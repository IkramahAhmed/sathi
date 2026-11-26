import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../core/backup/backup_restore_service.dart';
import '../../../review/data/weekly_review_scheduler.dart';
import '../../../khata/presentation/providers/khata_providers.dart';

import '../../../../app/providers.dart';
import '../../../../app/router.dart';
import '../../../../core/notifications/notification_channels.dart';
import '../../../../core/services/notification_capture_service.dart';
import '../../../../core/utils/logger.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/calc_method.dart';
import '../../domain/entities/prayer_name.dart';
import '../l10n_helpers.dart';
import '../providers/prayer_providers.dart';
import '../providers/reschedule_controller.dart';
import '../providers/settings_controller.dart';
import '../widgets/city_picker.dart';
import '../widgets/cloud_sync_section.dart';
import '../widgets/end_reminder_section.dart';
import '../widgets/jamaat_section.dart';

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
          const JamaatSection(),
          const EndReminderSection(),
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
          SwitchListTile(
            key: const ValueKey('azan-alarm'),
            secondary: const Icon(Icons.alarm),
            title: Text(l10n.azanAlarmVolume),
            subtitle: Text(l10n.azanAlarmHelp),
            value: settings.azanOnAlarm,
            onChanged: (v) => controller.setAzanOnAlarm(alarm: v),
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
          const CloudSyncSection(),
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
            key: const ValueKey('check-setup'),
            leading: const Icon(Icons.fact_check_outlined),
            title: Text(l10n.checkSetupTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(Routes.setupCheck),
          ),
          ListTile(
            leading: const Icon(Icons.battery_alert_outlined),
            title: Text(l10n.batteryHelp),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(Routes.oemGuide),
          ),
          const _BankSyncSection(),
          const _WeeklyReviewSection(),
          const _DataBackupSection(),
          ListTile(
            key: const ValueKey('audio-credits'),
            leading: const Icon(Icons.copyright_outlined),
            title: Text(l10n.audioCredits),
            onTap: () => showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(l10n.audioCredits),
                content: SingleChildScrollView(child: Text(l10n.audioCreditsBody)),
                actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.close))],
              ),
            ),
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
    final settings = ref.read(currentSettingsProvider);
    await ref.read(localNotificationsProvider).scheduleTest(
          id: 9002,
          title: l10n.testTitle,
          body: l10n.testBody,
          channelId: NotificationChannels.azanChannelFor(settings.sound, alarm: settings.azanOnAlarm),
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

// ── Bank Sync ─────────────────────────────────────────────────────────────────

class _BankSyncSection extends ConsumerStatefulWidget {
  const _BankSyncSection();

  @override
  ConsumerState<_BankSyncSection> createState() => _BankSyncSectionState();
}

class _BankSyncSectionState extends ConsumerState<_BankSyncSection> {
  CaptureHealth? _health;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final h = await NotificationCaptureService.health();
    if (mounted) setState(() => _health = h);
  }

  Future<void> _enableNotifAccess() async {
    await NotificationCaptureService.openSettings();
    await Future.delayed(const Duration(seconds: 1));
    await _check();
  }

  /// Android sometimes drops the listener (often after an app update) while
  /// the permission still shows as granted.
  Future<void> _restart() async {
    await NotificationCaptureService.rebind();
    await Future.delayed(const Duration(seconds: 2));
    await _check();
    if (!mounted || (_health?.connected ?? false)) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(AppLocalizations.of(context).bankSyncRestartHint),
    ));
    await _enableNotifAccess();
  }

  static String _ago(AppLocalizations l10n, DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return l10n.agoJustNow;
    if (d.inHours < 1) return l10n.agoMinutes('${d.inMinutes}');
    if (d.inDays < 1) return l10n.agoHours('${d.inHours}');
    return l10n.agoDays('${d.inDays}');
  }

  @override
  Widget build(BuildContext context) {
    final h = _health;
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    final (Color? color, String subtitle, Widget? trailing, VoidCallback? onTap) = switch (h) {
      null => (null, l10n.bankSyncChecking, null, null),
      CaptureHealth(hasAccess: false) => (
          null,
          l10n.bankSyncEnableHint,
          FilledButton.tonal(onPressed: _enableNotifAccess, child: Text(l10n.bankSyncEnable)),
          _enableNotifAccess,
        ),
      CaptureHealth(connected: false) => (
          scheme.error,
          l10n.bankSyncPaused,
          FilledButton.tonal(onPressed: _restart, child: Text(l10n.bankSyncRestart)),
          _restart,
        ),
      _ => (
          Colors.green.shade700,
          [
            h.lastCandidateAt == null
                ? l10n.bankSyncWaiting
                : l10n.bankSyncLast(_ago(l10n, h.lastCandidateAt!)),
            if (h.pending > 0) l10n.bankSyncPending('${h.pending}'),
          ].join(' · '),
          Icon(Icons.check_circle, color: Colors.green.shade700, size: 20),
          _check,
        ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Section(l10n.bankSyncTitle),
        ListTile(
          key: const ValueKey('notif-capture'),
          leading: Icon(Icons.notifications_active_outlined, color: color),
          title: Text(l10n.bankSyncAuto),
          subtitle: Text(subtitle),
          trailing: trailing,
          onTap: onTap,
        ),
      ],
    );
  }
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

// ── Data & Backup ─────────────────────────────────────────────────────────────

class _DataBackupSection extends ConsumerWidget {
  const _DataBackupSection();

  Future<void> _pickAutoBackup(BuildContext context, WidgetRef ref) async {
    final files = await BackupRestoreService.autoBackups();
    if (!context.mounted || files.isEmpty) return;
    final l10n = AppLocalizations.of(context);
    final chosen = await showModalBottomSheet<File>(
      context: context,
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final f in files)
              ListTile(
                leading: const Icon(Icons.history),
                title: Text(_autoBackupLabel(f)),
                subtitle: Text(l10n.backupRestore),
                onTap: () => Navigator.pop(sheet, f),
              ),
          ],
        ),
      ),
    );
    if (chosen == null || !context.mounted) return;
    await BackupRestoreService.restoreFile(
      context,
      ref.read(appDatabaseProvider),
      ref.read(sharedPreferencesProvider),
      chosen,
    );
  }

  /// "saathi_auto_2026-11-26_1530.saathi" → "26 Nov 2026, 15:30".
  static String _autoBackupLabel(File f) {
    final m = RegExp(r'(\d{4}-\d{2}-\d{2})_(\d{2})(\d{2})').firstMatch(f.path);
    if (m == null) return f.path.split('/').last;
    final date = DateTime.tryParse(m.group(1)!);
    if (date == null) return f.path.split('/').last;
    return '${DateFormat('d MMM yyyy').format(date)}, ${m.group(2)}:${m.group(3)}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final prefs = ref.watch(sharedPreferencesProvider);
    final lastAuto = prefs.getInt('auto_backup_at');
    final countBank = ref.watch(countBankProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            l10n.settingsDataBackup,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.backup_outlined),
          title: Text(l10n.backupExport),
          subtitle: Text(l10n.backupExportSub),
          onTap: () => BackupRestoreService.backup(
            context,
            ref.read(appDatabaseProvider),
            ref.read(sharedPreferencesProvider),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.restore_outlined),
          title: Text(l10n.backupRestore),
          subtitle: Text(l10n.backupRestoreSub),
          onTap: () => BackupRestoreService.restore(
            context,
            ref.read(appDatabaseProvider),
            ref.read(sharedPreferencesProvider),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.history_outlined),
          title: Text(l10n.backupAuto),
          subtitle: Text(lastAuto == null
              ? l10n.backupAutoNone
              : l10n.backupAutoSub(DateFormat('d MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(lastAuto)))),
          onTap: () => _pickAutoBackup(context, ref),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.account_balance_outlined),
          title: Text(l10n.settingsCountBank),
          subtitle: Text(l10n.settingsCountBankSub),
          value: countBank,
          onChanged: (v) => ref.read(countBankProvider.notifier).set(v),
        ),
      ],
    );
  }
}

// ── Weekly review ─────────────────────────────────────────────────────────────

class _WeeklyReviewSection extends ConsumerStatefulWidget {
  const _WeeklyReviewSection();

  @override
  ConsumerState<_WeeklyReviewSection> createState() => _WeeklyReviewSectionState();
}

class _WeeklyReviewSectionState extends ConsumerState<_WeeklyReviewSection> {
  late ReviewReminder _reminder = ReviewReminder.load(ref.read(sharedPreferencesProvider));

  Future<void> _update(ReviewReminder next) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final l10n = AppLocalizations.of(context);
    setState(() => _reminder = next);
    await next.save(prefs);
    await applyWeeklyReview(prefs, l10n);
  }

  /// Monday is 1 ... Sunday is 7; 23 Nov 2026 is a Monday.
  String _dayName(int weekday, String locale) =>
      DateFormat.EEEE(locale).format(DateTime(2026, 11, 22 + weekday));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = dateLocale(Localizations.localeOf(context));
    final time = TimeOfDay(hour: _reminder.minutes ~/ 60, minute: _reminder.minutes % 60);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        SwitchListTile(
          secondary: const Icon(Icons.insights_outlined),
          title: Text(l10n.reviewTitle),
          subtitle: Text(_reminder.enabled
              ? l10n.reviewSettingOn(_dayName(_reminder.weekday, locale), time.format(context))
              : l10n.reviewSettingSub),
          value: _reminder.enabled,
          onChanged: (v) => _update(_reminder.copyWith(enabled: v)),
        ),
        if (_reminder.enabled) ...[
          ListTile(
            contentPadding: const EdgeInsets.only(left: 72, right: 16),
            title: Text(l10n.reviewDay),
            trailing: DropdownButton<int>(
              value: _reminder.weekday,
              underline: const SizedBox.shrink(),
              items: [
                for (var d = 1; d <= 7; d++) DropdownMenuItem(value: d, child: Text(_dayName(d, locale))),
              ],
              onChanged: (v) {
                if (v != null) _update(_reminder.copyWith(weekday: v));
              },
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 72, right: 16),
            title: Text(l10n.reviewTime),
            trailing: Text(time.format(context), style: Theme.of(context).textTheme.titleMedium),
            onTap: () async {
              final picked = await showTimePicker(context: context, initialTime: time);
              if (picked != null) _update(_reminder.copyWith(minutes: picked.hour * 60 + picked.minute));
            },
          ),
        ],
      ],
    );
  }
}
