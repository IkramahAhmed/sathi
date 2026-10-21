import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/features/prayer/domain/entities/end_reminder.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_name.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_window.dart';

void main() {
  final start = DateTime.utc(2026, 10, 15, 10);
  PrayerWindow window(int minutes, {PrayerName prayer = PrayerName.asr}) =>
      PrayerWindow(prayer, start, start.add(Duration(minutes: minutes)));

  const on = EndReminderSettings(enabled: true);

  test('does nothing when switched off or for a prayer that is turned off', () {
    expect(endReminderPlan(window(180), const EndReminderSettings(enabled: false)), isEmpty);
    final noAsr = on.copyWith(prayers: {...on.prayers, PrayerName.asr: false});
    expect(endReminderPlan(window(180), noAsr), isEmpty);
    expect(endReminderPlan(window(180, prayer: PrayerName.fajr), noAsr), isNotEmpty);
  });

  test('starts lead minutes before the end and repeats at the gap', () {
    final w = window(180); // ends 13:00
    // Explicit lead=30, repeat=10 so the test is not sensitive to default changes.
    final plan = endReminderPlan(w, on.copyWith(leadMin: 30, repeatMin: 10));
    expect(plan.map((s) => s.minutesLeft), [30, 20, 10, 5]);
    expect(plan.first.at, DateTime.utc(2026, 10, 15, 12, 30));
    expect(plan.map((s) => s.index), [0, 1, 2, 3]);
  });

  test('the last reminder is always five minutes before the end, never later', () {
    for (final lead in [15, 20, 30, 45, 60]) {
      for (final repeat in [3, 5, 7, 10, 15]) {
        final plan = endReminderPlan(window(240), on.copyWith(leadMin: lead, repeatMin: repeat));
        expect(plan, isNotEmpty, reason: '$lead/$repeat');
        expect(plan.last.minutesLeft, greaterThanOrEqualTo(5), reason: '$lead/$repeat');
        expect(plan.last.minutesLeft, lessThanOrEqualTo(8), reason: '$lead/$repeat: a last call close to the end');
      }
    }
  });

  test('reminders are in strictly increasing time order and inside the window', () {
    final w = window(120);
    final plan = endReminderPlan(w, on.copyWith(leadMin: 60, repeatMin: 7));
    for (var i = 1; i < plan.length; i++) {
      expect(plan[i].at.isAfter(plan[i - 1].at), isTrue);
    }
    for (final s in plan) {
      expect(w.contains(s.at), isTrue);
    }
  });

  test('a window shorter than the lead does not nag in its first five minutes', () {
    final w = window(20); // lead 30 > 20
    final plan = endReminderPlan(w, on);
    expect(plan.first.at.isBefore(w.start.add(const Duration(minutes: 5))), isFalse);
    expect(plan.last.minutesLeft, greaterThanOrEqualTo(5));
  });

  test('a very short window gets at most a single last call, or nothing', () {
    expect(endReminderPlan(window(8), on).length, lessThanOrEqualTo(1));
    expect(endReminderPlan(window(4), on), isEmpty);
  });

  test('never more than the hard cap, even with a long lead and a tiny gap', () {
    final plan = endReminderPlan(window(600), on.copyWith(leadMin: 180, repeatMin: 1));
    expect(plan.length, lessThanOrEqualTo(kMaxEndReminders));
  });

  test('out-of-range settings are clamped, not trusted', () {
    final plan = endReminderPlan(window(300), on.copyWith(leadMin: 9999, repeatMin: 0));
    expect(plan.length, lessThanOrEqualTo(kMaxEndReminders));
    // leadMin 9999 → clamped to 999 → earliest-guard clamps to window.start+5;
    // minutesLeft can be at most window duration minus the 5-min guard.
    expect(plan.first.minutesLeft, lessThanOrEqualTo(300));
  });

  test('appliesTo respects both the master switch and the per-prayer switch', () {
    expect(const EndReminderSettings(enabled: false).appliesTo(PrayerName.asr), isFalse);
    expect(on.appliesTo(PrayerName.asr), isTrue);
    expect(on.appliesTo(PrayerName.sunrise), isFalse, reason: 'sunrise is not a prayer');
  });
}
