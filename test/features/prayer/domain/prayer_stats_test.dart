import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_name.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_stats.dart';

String key(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

void main() {
  final today = DateTime(2026, 11, 26);

  test('finds the prayer missed most often and the overall completion', () {
    final done = <String, Set<PrayerName>>{};
    for (var i = 1; i <= 10; i++) {
      final day = DateTime(2026, 11, 26 - i);
      // Everything except Fajr on every day.
      done[key(day)] = {PrayerName.dhuhr, PrayerName.asr, PrayerName.maghrib, PrayerName.isha};
    }
    final stats = computePrayerStats(
      doneByDate: done,
      pauses: const [],
      today: today,
      start: DateTime(2026, 11, 16),
    );
    expect(stats.days, 10);
    expect(stats.weakest, PrayerName.fajr);
    expect(stats.done[PrayerName.fajr], 0);
    expect(stats.done[PrayerName.asr], 10);
    expect(stats.completion, closeTo(0.8, 0.0001));
  });

  test('today and days before tracking began are not held against the user', () {
    final stats = computePrayerStats(
      doneByDate: const {},
      pauses: const [],
      today: today,
      start: DateTime(2026, 11, 24),
    );
    expect(stats.days, 2, reason: '24th and 25th only; today is still in progress');
    expect(stats.statuses.length, 30);
  });

  test('no data and perfect data have no weakest prayer', () {
    expect(
      computePrayerStats(doneByDate: const {}, pauses: const [], today: today, start: today).weakest,
      isNull,
    );
    final all = {for (var i = 1; i <= 5; i++) key(DateTime(2026, 11, 26 - i)): PrayerName.obligatory.toSet()};
    final stats = computePrayerStats(doneByDate: all, pauses: const [], today: today, start: DateTime(2026, 11, 21));
    expect(stats.weakest, isNull);
    expect(stats.completion, 1);
  });
}
