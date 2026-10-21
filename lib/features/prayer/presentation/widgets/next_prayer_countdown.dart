import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/prayer_name.dart';
import '../../domain/entities/prayer_times_day.dart';
import '../l10n_helpers.dart';
import '../providers/prayer_providers.dart';

/// "Next: Asr — 3:43 PM" with a ticking countdown and a gold progress bar.
class NextPrayerCountdown extends ConsumerWidget {
  const NextPrayerCountdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final settings = ref.watch(currentSettingsProvider);
    final now = ref.watch(nowTickProvider);
    final next = ref.watch(nextPrayerProvider);
    final today = ref.watch(todayTimesProvider);
    final tomorrow = ref.watch(tomorrowTimesProvider);

    if (next == null) return const SizedBox.shrink();

    final remaining = next.at.difference(now);
    final jumma = next.prayer.name == 'dhuhr' && next.date.weekday == DateTime.friday;
    final name = prayerLabel(l10n, next.prayer, jumma: jumma);
    final prayerTime = formatClock(next.at, settings.timezoneId, locale);
    final progress = _gapProgress(next.prayer, next.at, today, tomorrow, now);

    return Card(
      color: scheme.primary,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  name,
                  key: const ValueKey('next-prayer-text'),
                  style: text.titleMedium?.copyWith(
                    color: scheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  prayerTime,
                  style: text.titleMedium?.copyWith(
                    color: AppTheme.gold,
                    fontWeight: FontWeight.w700,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              l10n.nextPrayer(name, humanDuration(l10n, remaining)),
              style: text.bodySmall?.copyWith(
                color: scheme.onPrimary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              clockDuration(remaining),
              key: const ValueKey('next-prayer-clock'),
              textDirection: TextDirection.ltr,
              style: text.displayMedium?.copyWith(
                color: scheme.onPrimary,
                fontWeight: FontWeight.w300,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            if (progress != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 3,
                  backgroundColor: scheme.onPrimary.withValues(alpha: 0.15),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.gold),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Returns how far we are through the gap [prev prayer → next prayer], 0.0–1.0.
  /// Returns null when the gap cannot be determined or hasn't started yet.
  double? _gapProgress(
    PrayerName nextPrayer,
    DateTime nextAt,
    PrayerTimesDay today,
    PrayerTimesDay tomorrow,
    DateTime now,
  ) {
    final prayers = PrayerName.obligatory;
    final idx = prayers.indexOf(nextPrayer);

    DateTime? gapStart;
    if (idx > 0) {
      // The next prayer is dhuhr..isha — prev prayer is on the same day.
      gapStart = today.times[prayers[idx - 1]];
    } else {
      // Fajr is next — the gap started at today's Isha (after midnight case).
      gapStart = today.times[PrayerName.isha];
    }

    if (gapStart == null) return null;
    final elapsed = now.difference(gapStart);
    // If gap hasn't started yet (e.g. Fajr is next but Isha is still in the future)
    if (elapsed.isNegative) return null;
    final total = nextAt.difference(gapStart);
    if (total.inSeconds <= 0) return null;
    return (elapsed.inSeconds / total.inSeconds).clamp(0.0, 1.0);
  }
}
