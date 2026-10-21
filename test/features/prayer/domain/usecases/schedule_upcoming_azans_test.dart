import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:saathi/core/notifications/notification_channels.dart';
import 'package:saathi/core/notifications/notification_scheduler.dart';
import 'package:saathi/features/prayer/domain/entities/end_reminder.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_name.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_settings.dart';
import 'package:saathi/features/prayer/domain/usecases/schedule_upcoming_azans.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import '../../../../support/fakes.dart';

class MockScheduler extends Mock implements NotificationScheduler {}

void main() {
  setUpAll(() {
    tzdata.initializeTimeZones();
    registerFallbackValue(<ScheduledAlarm>[]);
  });

  late MockScheduler scheduler;
  late List<ScheduledAlarm> captured;

  setUp(() {
    scheduler = MockScheduler();
    captured = [];
    when(() => scheduler.cancelAll()).thenAnswer((_) async {});
    when(() => scheduler.canScheduleExact()).thenAnswer((_) async => true);
    when(() => scheduler.scheduleAll(any())).thenAnswer((invocation) async {
      captured = List.of(invocation.positionalArguments.first as List<ScheduledAlarm>);
    });
  });

  // 2026-10-12 12:00 in Karachi (PKT = UTC+5) == 07:00 UTC.
  final noonKarachi = DateTime.utc(2026, 10, 12, 7);

  // Azan-only defaults: no ending reminders, so these tests measure only azans.
  final azanDefaults = PrayerSettings.defaults().copyWith(
    endReminder: const EndReminderSettings(enabled: false),
  );

  ScheduleUpcomingAzans build(PrayerSettings settings, DateTime now) => ScheduleUpcomingAzans(
        FakeSettingsRepository(settings),
        FakePrayerRepository(),
        scheduler,
        () => now,
      );

  test('stableId is unique across every prayer, day of the year and pre flag', () {
    final ids = <int>{};
    var count = 0;
    for (var d = 0; d < 366; d++) {
      // 2024 is a leap year, so this covers day-of-year 1..366.
      final date = DateTime(2024, 1, 1 + d);
      for (final prayer in PrayerName.values) {
        for (final pre in [false, true]) {
          ids.add(stableId(date, prayer, pre: pre));
          count++;
        }
      }
    }
    expect(ids.length, count);
    expect(ids.every((id) => id > 0 && id < 0x7fffffff), isTrue);
  });

  test('cancels first, then schedules, and skips past prayers', () async {
    final report = (await build(PrayerSettings.defaults(), noonKarachi)()).valueOrNull!;

    verifyInOrder([() => scheduler.cancelAll(), () => scheduler.scheduleAll(any())]);
    expect(report.scheduledCount, captured.length);
    expect(captured.every((a) => a.at.isAfter(noonKarachi)), isTrue);

    // Fajr (about 05:13 PKT) has already passed on the first day.
    final todayFajrId = stableId(DateTime(2026, 10, 12), PrayerName.fajr);
    expect(captured.any((a) => a.id == todayFajrId), isFalse);
    // Dhuhr (about 12:19 PKT) is still ahead.
    final todayDhuhrId = stableId(DateTime(2026, 10, 12), PrayerName.dhuhr);
    expect(captured.any((a) => a.id == todayDhuhrId), isTrue);
  });

  test('never exceeds 60 pending with 5 azans a day', () async {
    final report = (await build(azanDefaults, noonKarachi)()).valueOrNull!;
    expect(captured.length, lessThanOrEqualTo(kMaxPendingNotifications));
    expect(report.days, kMaxScheduleDays);
  });

  test('never exceeds 60 even with every azan and pre-reminder on', () async {
    final all = PrayerSettings.defaults().copyWith(
      azanEnabled: {for (final p in PrayerName.values) p: true},
      preReminderMin: {for (final p in PrayerName.values) p: 15},
    );
    await build(all, noonKarachi)();
    expect(captured.length, lessThanOrEqualTo(kMaxPendingNotifications));
    expect(captured.map((a) => a.id).toSet().length, captured.length, reason: 'ids are unique');
  });

  test('pre-reminders fire before the azan on the dedicated channel', () async {
    final withReminder = PrayerSettings.defaults().copyWith(
      preReminderMin: {
        for (final p in PrayerName.values) p: p == PrayerName.maghrib ? 10 : 0,
      },
    );
    await build(withReminder, noonKarachi)();
    final pre = captured.where((a) => a.isPreReminder).toList();
    expect(pre, isNotEmpty);
    expect(pre.every((a) => a.channelId == 'pre_reminder'), isTrue);
    final azan = captured.firstWhere(
      (a) => a.id == stableId(DateTime(2026, 10, 12), PrayerName.maghrib),
    );
    final reminder = captured.firstWhere(
      (a) => a.id == stableId(DateTime(2026, 10, 12), PrayerName.maghrib, pre: true),
    );
    expect(azan.at.difference(reminder.at), const Duration(minutes: 10));
  });

  test('disabled prayers are not scheduled', () async {
    final noAsr = azanDefaults.copyWith(
      azanEnabled: {
        for (final p in PrayerName.values) p: p.hasAzan && p != PrayerName.asr,
      },
    );
    await build(noAsr, noonKarachi)();
    // Only check ids in the azan range (< 20000) to avoid collision with ending reminders.
    expect(captured.where((a) => a.id < 20000).any((a) => a.id % 20 ~/ 2 == PrayerName.asr.index), isFalse);
  });

  test('uses the selected sound channel', () async {
    await build(azanDefaults, noonKarachi)();
    expect(captured.every((a) => a.channelId == 'azan_beep'), isTrue);
  });

  test('schedules nothing when every azan is off, but still cancels', () async {
    final off = azanDefaults.copyWith(
      azanEnabled: {for (final p in PrayerName.values) p: false},
    );
    final report = (await build(off, noonKarachi)()).valueOrNull!;
    expect(report.scheduledCount, 0);
    verify(() => scheduler.cancelAll()).called(1);
    verifyNever(() => scheduler.scheduleAll(any()));
  });

  test('a scheduler failure becomes a Failure result, not an exception', () async {
    when(() => scheduler.scheduleAll(any())).thenThrow(StateError('boom'));
    final result = await build(PrayerSettings.defaults(), noonKarachi)();
    expect(result.isSuccess, isFalse);
    expect(result.failureOrNull!.message, contains('schedule'));
  });

  test('uses DST-safe local dates: London summer schedules on the right day', () async {
    final london = PrayerSettings.defaults().copyWith(
      lat: 51.5074,
      lng: -0.1278,
      timezoneId: 'Europe/London',
      countryCode: 'GB',
    );
    // 23:30 UTC on 30 Jun is already 00:30 BST on 1 Jul in London.
    await build(london, DateTime.utc(2026, 6, 30, 23, 30))();
    expect(captured, isNotEmpty);
    final firstDate = captured.first.payload;
    expect(firstDate, contains('2026-07-01'));
  });
}
