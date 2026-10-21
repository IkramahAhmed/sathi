import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:saathi/core/notifications/notification_channels.dart';
import 'package:saathi/core/notifications/notification_scheduler.dart';
import 'package:saathi/features/prayer/domain/entities/calc_method.dart';
import 'package:saathi/features/prayer/domain/entities/end_reminder.dart';
import 'package:saathi/features/prayer/domain/entities/jamaat.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_name.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_settings.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_window.dart';
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
  late List<ScheduledAlarm> scheduled;
  late FakeReminderState state;

  setUp(() {
    scheduler = MockScheduler();
    scheduled = [];
    state = FakeReminderState();
    when(() => scheduler.cancelAll()).thenAnswer((_) async {});
    when(() => scheduler.canScheduleExact()).thenAnswer((_) async => true);
    when(() => scheduler.scheduleAll(any())).thenAnswer((i) async {
      scheduled = List.of(i.positionalArguments.first as List<ScheduledAlarm>);
    });
  });

  // Thursday 2026-10-15 12:00 in Karachi (UTC+5).
  final now = DateTime.utc(2026, 10, 15, 7);

  Future<ScheduleReport> run(PrayerSettings s, {DateTime? at, int maxPending = kMaxPendingNotifications}) async {
    final useCase = ScheduleUpcomingAzans(
      FakeSettingsRepository(s),
      FakePrayerRepository(),
      scheduler,
      () => at ?? now,
      reminderState: state,
      maxPending: maxPending,
    );
    return (await useCase()).valueOrNull!;
  }

  Iterable<ScheduledAlarm> ending() => scheduled.where((a) => a.channelId == NotificationChannels.prayerEndingAlarm);
  Iterable<ScheduledAlarm> leave() => scheduled.where((a) => a.channelId == NotificationChannels.jamaatReminder);

  final base = PrayerSettings.defaults();
  final endOn = base.copyWith(endReminder: const EndReminderSettings(enabled: true));

  // Settings with ending reminders disabled so azan-channel tests only see azan notifications.
  final azanOnly = base.copyWith(endReminder: const EndReminderSettings(enabled: false));

  group('azan channel', () {
    test('uses the normal channel by default and the alarm-volume channel when chosen', () async {
      await run(azanOnly.copyWith(sound: AzanSound.full));
      expect(scheduled.where((a) => !a.isPreReminder).every((a) => a.channelId == 'azan_full'), isTrue);

      await run(azanOnly.copyWith(sound: AzanSound.full, azanOnAlarm: true));
      expect(scheduled.every((a) => a.channelId == 'azan_full_alarm'), isTrue);
    });

    test('the silent sound has no alarm variant', () async {
      await run(azanOnly.copyWith(sound: AzanSound.silent, azanOnAlarm: true));
      expect(scheduled.every((a) => a.channelId == 'azan_silent'), isTrue);
    });
  });

  group('ending reminders', () {
    test('are on by default (new installs get persistent reminders with photo proof)', () async {
      final r = await run(base);
      expect(ending(), isNotEmpty);
      expect(r.endReminders, greaterThan(0));
    });

    test('can be switched off', () async {
      final r = await run(base.copyWith(endReminder: const EndReminderSettings(enabled: false)));
      expect(ending(), isEmpty);
      expect(r.endReminders, 0);
    });

    test('are planned for the prayers whose window has not ended, with rising times', () async {
      final r = await run(endOn);
      final list = ending().toList();
      expect(list, isNotEmpty);
      expect(r.endReminders, list.length);
      // At 12:00 PKT Fajr's window is over, so Fajr gets none today.
      expect(list.where((a) => jsonDecode(a.payload)['prayer'] == 'fajr' && jsonDecode(a.payload)['date'] == '2026-10-15'),
          isEmpty);
      expect(list.every((a) => a.at.isAfter(now)), isTrue);
    });

    test('only today and tomorrow are planned', () async {
      await run(endOn);
      final dates = ending().map((a) => jsonDecode(a.payload)['date']).toSet();
      expect(dates.difference({'2026-10-15', '2026-10-16'}), isEmpty);
    });

    test('each reminder sits inside its prayer window and the last is at most 8 minutes before the end', () async {
      await run(endOn);
      final calc = FakePrayerRepository();
      for (final a in ending()) {
        final p = jsonDecode(a.payload);
        final date = DateTime.parse(p['date'] as String);
        final day = calc.timesFor(date, endOn);
        final next = calc.timesFor(DateTime(date.year, date.month, date.day + 1), endOn);
        final w = prayerWindows(day, next).firstWhere((w) => w.prayer.name == p['prayer']);
        expect(w.contains(a.at), isTrue, reason: '${p['prayer']} ${p['date']}');
      }
    });

    test('ids are unique, in the ending range and never collide with azan ids', () async {
      await run(endOn.copyWith(azanOnAlarm: true));
      final ids = scheduled.map((a) => a.id).toList();
      expect(ids.toSet().length, ids.length);
      for (final a in ending()) {
        expect(a.id, inInclusiveRange(20000, 59999));
      }
      for (final a in scheduled.where((a) => a.channelId != NotificationChannels.prayerEndingAlarm)) {
        expect(a.id, lessThan(20000));
      }
    });

    test('a prayer that is already done gets no reminders', () async {
      final today = DateTime(2026, 10, 15);
      state.done.add(FakeReminderState.key(today, PrayerName.asr));
      await run(endOn);
      final asrToday = ending().where((a) {
        final p = jsonDecode(a.payload);
        return p['prayer'] == 'asr' && p['date'] == '2026-10-15';
      });
      expect(asrToday, isEmpty);
      // The others today still get them.
      expect(
        ending().where((a) => jsonDecode(a.payload)['prayer'] == 'dhuhr' || jsonDecode(a.payload)['prayer'] == 'maghrib'),
        isNotEmpty,
      );
    });

    test('a muted prayer gets no reminders but others do', () async {
      state.muted.add(FakeReminderState.key(DateTime(2026, 10, 15), PrayerName.maghrib));
      await run(endOn);
      expect(
        ending().where((a) {
          final p = jsonDecode(a.payload);
          return p['prayer'] == 'maghrib' && p['date'] == '2026-10-15';
        }),
        isEmpty,
      );
      expect(ending().where((a) => jsonDecode(a.payload)['prayer'] == 'isha'), isNotEmpty);
    });

    test('a paused day gets no reminders at all, the next day still does', () async {
      state.paused.add('2026-10-15');
      await run(endOn);
      final dates = ending().map((a) => jsonDecode(a.payload)['date']).toSet();
      expect(dates, {'2026-10-16'});
    });

    test('a prayer turned off in the list is skipped', () async {
      final s = endOn.copyWith(
        endReminder: EndReminderSettings(
          enabled: true,
          prayers: {for (final p in PrayerName.obligatory) p: p != PrayerName.isha},
        ),
      );
      await run(s);
      expect(ending().where((a) => jsonDecode(a.payload)['prayer'] == 'isha'), isEmpty);
    });

    test('with photo proof the notification offers Take photo and Stop; without, Prayed and Stop', () async {
      await run(endOn.copyWith(endReminder: const EndReminderSettings(enabled: true, requirePhoto: true)));
      final photo = ending().first;
      expect(photo.actions.map((a) => a.id), [ReminderActions.takePhoto, ReminderActions.stop]);
      expect(photo.actions.first.opensApp, isTrue);
      expect(photo.actions.last.opensApp, isFalse);
      expect(jsonDecode(photo.payload)['photo'], isTrue);
      expect(jsonDecode(photo.payload)['kind'], 'ending');

      // Without photo: explicitly opt out.
      final noPhoto = endOn.copyWith(endReminder: const EndReminderSettings(enabled: true, requirePhoto: false));
      await run(noPhoto);
      final plain = ending().first;
      expect(plain.actions.map((a) => a.id), [ReminderActions.prayed, ReminderActions.stop]);
      expect(jsonDecode(plain.payload)['photo'], isFalse);
    });

    test('the last reminder is worded as a last call', () async {
      await run(endOn);
      final byPrayer = <String, List<ScheduledAlarm>>{};
      for (final a in ending()) {
        final p = jsonDecode(a.payload);
        byPrayer.putIfAbsent('${p['date']}${p['prayer']}', () => []).add(a);
      }
      for (final list in byPrayer.values) {
        list.sort((a, b) => a.at.compareTo(b.at));
        expect(list.last.title, contains('ending'));
        expect(list.first.title, contains('min'));
      }
    });

    test('words follow the chosen language', () async {
      await run(endOn.copyWith(localeTag: 'en_PK'));
      expect(ending().first.title, contains('waqt'));
      await run(endOn.copyWith(localeTag: 'ur'));
      expect(ending().first.title, contains('وقت'));
    });

    test('nothing is planned for windows that have already ended', () async {
      // 23:00 PKT: every window of the 15th except Isha is over.
      await run(endOn, at: DateTime.utc(2026, 10, 15, 18));
      final today = ending().where((a) => jsonDecode(a.payload)['date'] == '2026-10-15');
      expect(today.every((a) => jsonDecode(a.payload)['prayer'] == 'isha'), isTrue);
    });
  });

  group('budget', () {
    test('azans plus reminders never exceed the limit, and reminders are kept first', () async {
      final heavy = endOn.copyWith(
        endReminder: const EndReminderSettings(enabled: true, leadMin: 60, repeatMin: 5),
        preReminderMin: {for (final p in PrayerName.values) p: 10},
        jamaat: const JamaatSettings(
          offsetMin: {PrayerName.fajr: 20, PrayerName.dhuhr: 15, PrayerName.asr: 10, PrayerName.maghrib: 5, PrayerName.isha: 15},
          leaveReminderMin: 10,
        ),
      );
      final r = await run(heavy);
      expect(scheduled.length, lessThanOrEqualTo(kMaxPendingNotifications));
      expect(r.scheduledCount, scheduled.length);
      expect(ending(), isNotEmpty, reason: 'the urgent reminders are not the ones dropped');
      expect(scheduled.map((a) => a.id).toSet().length, scheduled.length);
    });

    test('a bigger limit schedules more days of azans', () async {
      final small = await run(endOn, maxPending: 60);
      final big = await run(endOn, maxPending: 150);
      expect(big.days, greaterThanOrEqualTo(small.days));
      expect(big.scheduledCount, greaterThan(small.scheduledCount));
    });

    test('still schedules at least one day of azans when reminders use the whole budget', () async {
      final r = await run(
        endOn.copyWith(endReminder: const EndReminderSettings(enabled: true, leadMin: 180, repeatMin: 1)),
        maxPending: 20,
      );
      expect(r.days, greaterThanOrEqualTo(1));
      expect(scheduled.length, lessThanOrEqualTo(20));
    });
  });

  group('jama\'at reminders', () {
    final withJamaat = base.copyWith(
      jamaat: const JamaatSettings(
        offsetMin: {PrayerName.asr: 10},
        fixedMin: {PrayerName.isha: 20 * 60 + 15},
        leaveReminderMin: 12,
      ),
    );

    test('are off unless a leave time and a jama\'at time are both set', () async {
      await run(base);
      expect(leave(), isEmpty);
      await run(base.copyWith(jamaat: const JamaatSettings(offsetMin: {PrayerName.asr: 10})));
      expect(leave(), isEmpty, reason: 'leave reminder is 0');
      await run(base.copyWith(jamaat: const JamaatSettings(leaveReminderMin: 10)));
      expect(leave(), isEmpty, reason: 'no jama\'at times set');
    });

    test('fire the chosen minutes before jama\'at', () async {
      await run(withJamaat);
      final asr = leave().firstWhere((a) => jsonDecode(a.payload)['prayer'] == 'asr' && jsonDecode(a.payload)['date'] == '2026-10-15');
      final azan = FakePrayerRepository().timesFor(DateTime(2026, 10, 15), withJamaat).times[PrayerName.asr]!;
      expect(asr.at, azan.add(const Duration(minutes: 10 - 12)));
      expect(asr.title, contains('leave'));
      expect(asr.body, contains('Jama\'at is at'));
    });

    test('a fixed time is honoured in the local timezone', () async {
      await run(withJamaat);
      final isha = leave().firstWhere((a) => jsonDecode(a.payload)['prayer'] == 'isha' && jsonDecode(a.payload)['date'] == '2026-10-15');
      // 20:15 PKT minus 12 minutes = 20:03 PKT = 15:03 UTC.
      expect(isha.at, DateTime.utc(2026, 10, 15, 15, 3));
      expect(isha.body, contains('8:15 PM'));
    });

    test('past reminders are skipped', () async {
      await run(withJamaat, at: DateTime.utc(2026, 10, 15, 16)); // 21:00 PKT, after Isha jama'at
      expect(leave().where((a) => jsonDecode(a.payload)['date'] == '2026-10-15'), isEmpty);
    });

    test('use the jama\'at channel and unique ids in the leave range', () async {
      final r = await run(withJamaat);
      expect(r.leaveReminders, leave().length);
      for (final a in leave()) {
        expect(a.id, inInclusiveRange(10000, 19999));
      }
    });
  });

  group('ids', () {
    test('azan, leave and ending ids never overlap across a whole leap year', () {
      final seen = <int>{};
      var count = 0;
      for (var d = 0; d < 366; d++) {
        final date = DateTime(2024, 1, 1 + d);
        for (final p in PrayerName.values) {
          for (final id in [
            stableId(date, p),
            stableId(date, p, pre: true),
            leaveId(date, p),
            ...endReminderIds(date, p),
          ]) {
            seen.add(id);
            count++;
          }
        }
      }
      expect(seen.length, count);
      expect(seen.every((id) => id > 0 && id < 0x7fffffff), isTrue);
    });

    test('endReminderIds lists exactly the ten ids for a prayer on a date', () {
      final ids = endReminderIds(DateTime(2026, 10, 15), PrayerName.asr);
      expect(ids, hasLength(10));
      expect(ids.first, endReminderId(DateTime(2026, 10, 15), PrayerName.asr, 0));
      expect(ids.last, endReminderId(DateTime(2026, 10, 15), PrayerName.asr, 9));
    });
  });
}
