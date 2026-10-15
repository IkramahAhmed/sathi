import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/features/prayer/domain/entities/pause_range.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_name.dart';
import 'package:saathi/features/prayer/domain/entities/streaks.dart';

void main() {
  final all = PrayerName.obligatory.toSet();
  final today = DateTime(2026, 10, 15);

  Map<String, Set<PrayerName>> full(List<int> days, {int month = 10}) => {
        for (final d in days) dateKey(DateTime(2026, month, d)): all,
      };

  StreakSummary streaks(
    Map<String, Set<PrayerName>> done, {
    List<PauseRange> pauses = const [],
    DateTime? start,
    DateTime? now,
  }) =>
      computeStreaks(
        doneByDate: done,
        pauses: pauses,
        today: now ?? today,
        trackingStart: start ?? DateTime(2026, 10, 1),
      );

  group('dayStatus', () {
    DayStatus s(DateTime d, Map<String, Set<PrayerName>> done, [List<PauseRange> p = const []]) =>
        dayStatus(date: d, today: today, doneByDate: done, pauses: p);

    test('complete, partial, none and future', () {
      expect(s(DateTime(2026, 10, 14), full([14])), DayStatus.complete);
      expect(s(DateTime(2026, 10, 14), {'2026-10-14': {PrayerName.fajr, PrayerName.asr}}), DayStatus.partial);
      expect(s(DateTime(2026, 10, 14), {}), DayStatus.none);
      expect(s(DateTime(2026, 10, 16), full([16])), DayStatus.future);
    });

    test('four of five is partial, and sunrise does not count as a prayer', () {
      expect(s(DateTime(2026, 10, 14), {'2026-10-14': {PrayerName.fajr, PrayerName.dhuhr, PrayerName.asr, PrayerName.maghrib}}),
          DayStatus.partial);
      expect(s(DateTime(2026, 10, 14), {'2026-10-14': {...all.difference({PrayerName.isha}), PrayerName.sunrise}}),
          DayStatus.partial);
    });

    test('a paused day wins over everything else', () {
      final pause = PauseRange(start: DateTime(2026, 10, 14), end: DateTime(2026, 10, 14));
      expect(s(DateTime(2026, 10, 14), {}, [pause]), DayStatus.paused);
      expect(s(DateTime(2026, 10, 14), full([14]), [pause]), DayStatus.paused);
    });
  });

  group('current streak', () {
    test('counts consecutive complete days ending today', () {
      expect(streaks(full([12, 13, 14, 15])).current, 4);
    });

    test('today still in progress does not break the streak', () {
      expect(streaks(full([12, 13, 14])).current, 3, reason: 'today not finished yet');
      expect(streaks({...full([12, 13, 14]), '2026-10-15': {PrayerName.fajr}}).current, 3);
    });

    test('a missed day breaks it', () {
      expect(streaks(full([10, 11, 13, 14, 15])).current, 3);
      expect(streaks(full([13, 14])).current, 2);
    });

    test('a day with four of five prayers breaks it', () {
      final done = {...full([12, 14, 15]), '2026-10-13': all.difference({PrayerName.isha})};
      expect(streaks(done).current, 2);
    });

    test('no data at all is zero', () {
      expect(streaks({}).current, 0);
      expect(streaks({}).best, 0);
    });

    test('days before tracking started do not count as misses', () {
      // Tracking began on the 13th; the 12th is ignored, not a break.
      expect(streaks(full([13, 14, 15]), start: DateTime(2026, 10, 13)).current, 3);
      expect(streaks(full([14, 15]), start: DateTime(2026, 10, 14)).current, 2);
    });

    test('tracking that starts in the future gives zero', () {
      expect(streaks(full([14]), start: DateTime(2026, 10, 20)).current, 0);
    });
  });

  group('pauses', () {
    test('a paused day between complete days keeps the streak alive and adds nothing', () {
      final pause = PauseRange(start: DateTime(2026, 10, 13), end: DateTime(2026, 10, 13));
      final r = streaks(full([11, 12, 14, 15]), pauses: [pause]);
      expect(r.current, 4, reason: '11, 12, 14, 15 are done; the 13th neither counts nor breaks');
    });

    test('a long pause does not break the streak', () {
      final pause = PauseRange(start: DateTime(2026, 10, 8), end: DateTime(2026, 10, 12));
      final r = streaks(full([5, 6, 7, 13, 14, 15]), pauses: [pause]);
      expect(r.current, 6);
    });

    test('an ongoing pause (no end) covers every day up to today', () {
      final pause = PauseRange(start: DateTime(2026, 10, 12));
      final r = streaks(full([9, 10, 11]), pauses: [pause]);
      expect(r.current, 3, reason: 'the streak is frozen while paused');
      expect(pause.isOngoing, isTrue);
    });

    test('the pause range is inclusive at both ends', () {
      final p = PauseRange(start: DateTime(2026, 10, 10), end: DateTime(2026, 10, 12));
      expect(p.contains(DateTime(2026, 10, 9)), isFalse);
      expect(p.contains(DateTime(2026, 10, 10)), isTrue);
      expect(p.contains(DateTime(2026, 10, 12, 23, 59)), isTrue);
      expect(p.contains(DateTime(2026, 10, 13)), isFalse);
    });
  });

  group('best streak', () {
    test('is the longest run, even if it is not the current one', () {
      final done = full([1, 2, 3, 4, 5, 8, 9, 15]);
      final r = streaks(done);
      expect(r.best, 5);
      expect(r.current, 1);
    });

    test('is never smaller than the current streak', () {
      final r = streaks(full([13, 14, 15]));
      expect(r.best, 3);
      expect(r.current, 3);
    });

    test('a pause inside a run does not split it', () {
      final pause = PauseRange(start: DateTime(2026, 10, 3), end: DateTime(2026, 10, 3));
      final r = streaks(full([1, 2, 4, 5]), pauses: [pause]);
      expect(r.best, 4);
    });

    test('crossing a month boundary works', () {
      final done = {...full([29, 30, 31], month: 8), ...full([1, 2], month: 9)};
      final r = computeStreaks(
        doneByDate: done,
        pauses: const [],
        today: DateTime(2026, 9, 2),
        trackingStart: DateTime(2026, 8, 25),
      );
      expect(r.current, 5);
    });
  });

  test('dateKey zero-pads', () {
    expect(dateKey(DateTime(2026, 1, 5)), '2026-01-05');
  });
}
