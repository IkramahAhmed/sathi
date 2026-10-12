import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers.dart';
import '../../../../app/router.dart';
import '../../../../core/notifications/notification_channels.dart';
import '../../../../core/utils/logger.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/calc_method.dart';
import '../../domain/entities/prayer_name.dart';
import '../l10n_helpers.dart';
import '../providers/prayer_providers.dart';
import '../providers/reschedule_controller.dart';
import '../providers/settings_controller.dart';
import '../widgets/city_picker.dart';

const List<int> _reminderChoices = [0, 5, 10, 15, 20, 30];

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(currentSettingsProvider);
    final controller = ref.read(settingsControllerProvider.notifier);
    final pending = ref.watch(rescheduleControllerProvider).report?.scheduledCount;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          _Section(l10n.secLocation),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: Text(l10n.currentLocation(settings.cityName, settings.countryCode)),
            subtitle: Text(
              '${settings.lat.toStringAsFixed(3)}, ${settings.lng.toStringAsFixed(3)} · ${settings.timezoneId}',
            ),
          ),
          ListTile(
            key: const ValueKey('use-my-location'),
            leading: const Icon(Icons.my_location),
            title: Text(l10n.useMyLocation),
            onTap: () => _useLocation(context, ref),
          ),
          ListTile(
            key: const ValueKey('choose-city'),
            leading: const Icon(Icons.location_city_outlined),
            title: Text(l10n.chooseCity),
            onTap: () async {
              final city = await showCityPicker(context);
              if (city != null) await controller.pickCity(city);
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.explore_outlined),
            title: Text(l10n.followMe),
            subtitle: Text(l10n.followMeHint),
            value: settings.followMeLocation,
            onChanged: (v) => controller.setFollowMe(follow: v),
          ),
          _Section(l10n.secCalculation),
          ListTile(
            key: const ValueKey('method-tile'),
            leading: const Icon(Icons.calculate_outlined),
            title: Text(l10n.method),
            subtitle: Text(
              settings.methodIsManual ? settings.method.displayName : l10n.autoMethod(settings.method.displayName),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final picked = await _choose<CalcMethod>(
                context,
                title: l10n.method,
                values: CalcMethod.values,
                selected: settings.method,
                label: (m) => m.displayName,
              );
              if (picked != null) await controller.setMethod(picked);
            },
          ),
          ListTile(
            key: const ValueKey('madhab-tile'),
            leading: const Icon(Icons.rule),
            title: Text(l10n.madhab),
            subtitle: Text(madhabLabel(l10n, settings.madhab)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final picked = await _choose<Madhab>(
                context,
                title: l10n.madhab,
                values: Madhab.values,
                selected: settings.madhab,
                label: (m) => madhabLabel(l10n, m),
              );
              if (picked != null) await controller.setMadhab(picked);
            },
          ),
          ListTile(
            leading: const Icon(Icons.nightlight_outlined),
            title: Text(l10n.highLatRule),
            subtitle: Text(highLatLabel(l10n, settings.highLat)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final picked = await _choose<HighLatitudeRule>(
                context,
                title: l10n.highLatRule,
                values: HighLatitudeRule.values,
                selected: settings.highLat,
                label: (m) => highLatLabel(l10n, m),
              );
              if (picked != null) await controller.setHighLat(picked);
            },
          ),
          if (settings.methodIsManual || settings.madhabIsManual)
            ListTile(
              leading: const Icon(Icons.restart_alt),
              title: Text(l10n.useCountryDefaults),
              onTap: controller.resetToCountryDefaults,
            ),
          _Section(l10n.secPrayers),
          for (final prayer in PrayerName.values)
            _PrayerSettingsCard(prayer: prayer, key: ValueKey('prayer-settings-${prayer.name}')),
          _Section(l10n.azanSound),
          for (final sound in AzanSound.values)
            ListTile(
              key: ValueKey('sound-${sound.name}'),
              leading: Icon(
                settings.sound == sound ? Icons.radio_button_checked : Icons.radio_button_off,
                color: settings.sound == sound ? scheme.primary : null,
              ),
              title: Text(soundLabel(l10n, sound)),
              trailing: sound.isSilent
                  ? null
                  : IconButton(
                      tooltip: l10n.previewSound,
                      icon: const Icon(Icons.play_circle_outline),
                      onPressed: () => _preview(ref, sound),
                    ),
              onTap: () => controller.setSound(sound),
            ),
          _Section(l10n.secHijri),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.hijriAdjust, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 8),
                SegmentedButton<int>(
                  segments: [
                    ButtonSegment(value: -1, label: Text(l10n.hijriMinusOne)),
                    ButtonSegment(value: 0, label: Text(l10n.hijriNoChange)),
                    ButtonSegment(value: 1, label: Text(l10n.hijriPlusOne)),
                  ],
                  selected: {settings.hijriAdjustDays},
                  onSelectionChanged: (s) => controller.setHijriAdjust(s.first),
                ),
              ],
            ),
          ),
          _Section(l10n.secLanguage),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'en', label: Text(l10n.langEnglish)),
                ButtonSegment(value: 'ur', label: Text(l10n.langUrdu)),
                ButtonSegment(value: 'en_PK', label: Text(l10n.langRomanUrdu)),
              ],
              selected: {settings.localeTag},
              onSelectionChanged: (s) => controller.setLocale(s.first),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          ListTile(
            key: const ValueKey('test-notification'),
            leading: const Icon(Icons.notifications_active_outlined),
            title: Text(l10n.testNotification),
            subtitle: pending == null ? null : Text(l10n.pendingCount(pending)),
            onTap: () => _scheduleTest(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.battery_alert_outlined),
            title: Text(l10n.batteryHelp),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(Routes.oemGuide),
          ),
        ],
      ),
    );
  }

  Future<void> _useLocation(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final result = await ref.read(settingsControllerProvider.notifier).useCurrentLocation();
    messenger.showSnackBar(SnackBar(
      content: Text(result.when(
        success: (fix) => l10n.locationUpdated(fix.cityName),
        failure: (_) => l10n.locationFailed,
      )),
    ));
  }

  Future<void> _preview(WidgetRef ref, AzanSound sound) async {
    try {
      await ref.read(localNotificationsProvider).showNow(
            id: 9001,
            title: NotificationChannels.nameFor(sound),
            body: 'Saathi',
            channelId: sound.channelId,
          );
    } catch (error, stackTrace) {
      appLog.warning('Sound preview failed', error, stackTrace);
    }
  }

  Future<void> _scheduleTest(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final sound = ref.read(currentSettingsProvider).sound;
    await ref.read(localNotificationsProvider).scheduleTest(
          id: 9002,
          title: l10n.testTitle,
          body: l10n.testBody,
          channelId: sound.channelId,
        );
    messenger.showSnackBar(SnackBar(content: Text(l10n.testScheduled)));
  }
}

Future<T?> _choose<T>(
  BuildContext context, {
  required String title,
  required List<T> values,
  required T selected,
  required String Function(T) label,
}) =>
    showDialog<T>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(title),
        children: [
          for (final v in values)
            ListTile(
              leading: Icon(v == selected ? Icons.radio_button_checked : Icons.radio_button_off),
              title: Text(label(v)),
              onTap: () => Navigator.of(context).pop(v),
            ),
        ],
      ),
    );

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 8),
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700),
        ),
      );
}

/// Azan switch, "masjid time" stepper and pre-reminder for one prayer.
class _PrayerSettingsCard extends ConsumerWidget {
  const _PrayerSettingsCard({required this.prayer, super.key});

  final PrayerName prayer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(currentSettingsProvider);
    final controller = ref.read(settingsControllerProvider.notifier);
    final adjust = settings.adjustmentFor(prayer);
    final reminder = settings.preReminderFor(prayer);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(prayerLabel(l10n, prayer), style: Theme.of(context).textTheme.titleMedium),
                  ),
                  if (prayer.hasAzan)
                    Switch(
                      key: ValueKey('azan-switch-${prayer.name}'),
                      value: settings.azanFor(prayer),
                      onChanged: (v) => controller.setAzanEnabled(prayer, enabled: v),
                    ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Text(l10n.masjidAdjust)),
                  IconButton(
                    key: ValueKey('adjust-minus-${prayer.name}'),
                    tooltip: '-1',
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: adjust <= -30 ? null : () => controller.setAdjustment(prayer, adjust - 1),
                  ),
                  SizedBox(
                    width: 64,
                    child: Text(
                      adjust > 0 ? '+$adjust' : '$adjust',
                      key: ValueKey('adjust-value-${prayer.name}'),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                  IconButton(
                    key: ValueKey('adjust-plus-${prayer.name}'),
                    tooltip: '+1',
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: adjust >= 30 ? null : () => controller.setAdjustment(prayer, adjust + 1),
                  ),
                ],
              ),
              if (prayer.hasAzan)
                Row(
                  children: [
                    Expanded(child: Text(l10n.preReminder)),
                    DropdownButton<int>(
                      key: ValueKey('reminder-${prayer.name}'),
                      value: _reminderChoices.contains(reminder) ? reminder : 0,
                      underline: const SizedBox.shrink(),
                      items: [
                        for (final m in _reminderChoices)
                          DropdownMenuItem(
                            value: m,
                            child: Text(m == 0 ? l10n.off : l10n.minutesValue(m)),
                          ),
                      ],
                      onChanged: (m) {
                        if (m != null) controller.setPreReminder(prayer, m);
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
