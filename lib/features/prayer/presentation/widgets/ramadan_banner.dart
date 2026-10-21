import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../domain/entities/prayer_times_day.dart';
import '../../domain/entities/prayer_name.dart';

/// Shown on the home screen during Ramadan.
/// Displays Sehri/Iftar countdown and a link to the Imsakiya table.
class RamadanBanner extends StatelessWidget {
  const RamadanBanner({
    required this.today,
    required this.tomorrow,
    required this.now,
    required this.timezoneId,
    super.key,
  });

  final PrayerTimesDay today;
  final PrayerTimesDay tomorrow;
  final DateTime now;
  final String timezoneId;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final fajr = today.times[PrayerName.fajr];
    final maghrib = today.times[PrayerName.maghrib];
    final tomorrowFajr = tomorrow.times[PrayerName.fajr];

    final (label, countdown, sub) = _compute(fajr, maghrib, tomorrowFajr);

    return Card(
      color: scheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
        child: Row(
          children: [
            Text('🌙', style: text.headlineMedium),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ramadan Mubarak',
                    style: text.labelMedium?.copyWith(
                        color: scheme.onPrimaryContainer.withAlpha(180)),
                  ),
                  if (countdown != null) ...[
                    Text(
                      countdown,
                      style: text.titleLarge?.copyWith(
                          color: scheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold),
                    ),
                    if (sub != null)
                      Text(sub,
                          style: text.bodySmall
                              ?.copyWith(color: scheme.onPrimaryContainer.withAlpha(180))),
                  ] else
                    Text(
                      label,
                      style: text.titleMedium
                          ?.copyWith(color: scheme.onPrimaryContainer),
                    ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Ramadan timetable',
              icon: Icon(Icons.calendar_month_outlined,
                  color: scheme.onPrimaryContainer),
              onPressed: () => context.push(Routes.imsakiya),
            ),
          ],
        ),
      ),
    );
  }

  (String label, String? countdown, String? sub) _compute(
      DateTime? fajr, DateTime? maghrib, DateTime? tomorrowFajr) {
    if (fajr == null || maghrib == null) {
      return ('Ramadan', null, null);
    }

    // Before Fajr: countdown to Sehri end.
    if (now.isBefore(fajr)) {
      final diff = fajr.difference(now);
      if (diff.inMinutes <= 0) return ('Sehri has ended', null, null);
      return ('Sehri ends in ${_fmt(diff)}', null, 'Stop eating before Fajr');
    }

    // Between Fajr and Maghrib: countdown to Iftar.
    if (now.isBefore(maghrib)) {
      final diff = maghrib.difference(now);
      return ('Iftar in ${_fmt(diff)}', null, 'Keep going! 💪');
    }

    // After Maghrib: Iftar time! Count to tomorrow's Sehri.
    if (tomorrowFajr != null) {
      final sehriEnd = tomorrowFajr.subtract(const Duration(minutes: 15));
      if (now.isBefore(sehriEnd)) {
        final diff = sehriEnd.difference(now);
        return ('Iftar time! 🎉', 'Sehri in ${_fmt(diff)}', 'Enjoy your meal');
      }
    }

    return ('Iftar time! 🎉', null, 'Alhamdulillah');
  }

  static String _fmt(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }
}
