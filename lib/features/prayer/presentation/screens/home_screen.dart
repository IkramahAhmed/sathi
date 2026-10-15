import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../domain/entities/prayer_name.dart';
import '../../domain/entities/streaks.dart';
import '../../../../l10n/app_localizations.dart';
import '../l10n_helpers.dart';
import '../providers/prayer_providers.dart';
import '../providers/settings_controller.dart';
import '../providers/tracker_providers.dart';
import '../widgets/next_prayer_countdown.dart';
import '../widgets/prayer_row.dart';
import '../widgets/status_banners.dart';
import '../widgets/tasbeeh_counter.dart';

/// Home: dates, the next-prayer countdown and the five prayer rows.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({this.highlight, super.key});

  /// A prayer to emphasise, set when the screen is opened from a notification.
  final PrayerName? highlight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final settings = ref.watch(currentSettingsProvider);
    final today = ref.watch(todayTimesProvider);
    final now = ref.watch(nowTickProvider);
    final next = ref.watch(nextPrayerProvider);
    final prayed = ref.watch(prayedTodayProvider).value ?? const <PrayerName>{};
    final hijri = ref.watch(hijriTodayProvider);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final isFriday = today.isFriday;
    final sunrise = today.times[PrayerName.sunrise];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(settings.cityName, key: const ValueKey('city-title')),
            Text(
              l10n.prayerTimesTitle,
              style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: l10n.locationRefresh,
            icon: const Icon(Icons.my_location),
            onPressed: () => _refreshLocation(context, ref),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        key: const ValueKey('tasbeeh-fab'),
        tooltip: l10n.tasbeehTitle,
        onPressed: () => TasbeehCounter.show(context),
        child: const Icon(Icons.fingerprint),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          const StatusBanners(),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.hijriDate(hijri.hDay, hijri.longMonthName, hijri.hYear),
                    key: const ValueKey('hijri-date'),
                    style: text.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat.yMMMMEEEEd(dateLocale(locale)).format(today.date),
                    key: const ValueKey('gregorian-date'),
                    style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  if (sunrise != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.wb_twilight, size: 18, color: scheme.primary),
                        const SizedBox(width: 6),
                        Text(
                          l10n.sunriseAt(formatClock(sunrise, settings.timezoneId, locale)),
                          key: const ValueKey('sunrise-text'),
                          style: text.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const NextPrayerCountdown(),
          const SizedBox(height: 12),
          for (final prayer in PrayerName.obligatory) ...[
            PrayerRow(
              key: ValueKey('prayer-row-${prayer.name}'),
              prayer: prayer,
              name: prayerLabel(l10n, prayer, jumma: isFriday),
              time: formatClock(today.times[prayer]!, settings.timezoneId, locale),
              azanEnabled: settings.azanFor(prayer),
              prayed: prayed.contains(prayer),
              isNext: next != null && next.prayer == prayer && next.date == today.date,
              isHighlighted: highlight == prayer,
              isPast: today.times[prayer]!.isBefore(now),
              onToggleAzan: (enabled) =>
                  ref.read(settingsControllerProvider.notifier).setAzanEnabled(prayer, enabled: enabled),
              onTogglePrayed: (done) async {
                final router = GoRouter.of(context);
                final result = await ref.read(prayerActionsProvider).setDone(today.date, prayer, done: done);
                if (result == TickResult.needsProof) {
                  router.push('${Routes.verify}?prayer=${prayer.name}&date=${dateKey(today.date)}');
                }
              },
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  Future<void> _refreshLocation(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final result = await ref.read(settingsControllerProvider.notifier).useCurrentLocation();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          result.when(
            success: (fix) => l10n.locationUpdated(fix.cityName),
            failure: (_) => l10n.locationFailed,
          ),
        ),
      ),
    );
  }
}
