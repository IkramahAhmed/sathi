import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../l10n_helpers.dart';
import '../providers/prayer_providers.dart';

/// "Next: Asr in 23 min" with a ticking HH:MM:SS countdown.
///
/// The ticker pauses automatically while the app is not visible because
/// [nowTickProvider] only runs its timer in the resumed state.
class NextPrayerCountdown extends ConsumerWidget {
  const NextPrayerCountdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final now = ref.watch(nowTickProvider);
    final next = ref.watch(nextPrayerProvider);

    if (next == null) return const SizedBox.shrink();

    final remaining = next.at.difference(now);
    final jumma = next.prayer.name == 'dhuhr' && next.date.weekday == DateTime.friday;
    final name = prayerLabel(l10n, next.prayer, jumma: jumma);

    return Card(
      color: scheme.primary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Text(
              l10n.nextPrayer(name, humanDuration(l10n, remaining)),
              key: const ValueKey('next-prayer-text'),
              textAlign: TextAlign.center,
              style: text.titleMedium?.copyWith(color: scheme.onPrimary),
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
          ],
        ),
      ),
    );
  }
}
