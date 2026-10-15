import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/features/prayer/data/reminders/reminder_mute_store.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_name.dart';
import 'package:saathi/features/prayer/domain/usecases/handle_reminder_action.dart';
import 'package:saathi/features/prayer/domain/usecases/schedule_upcoming_azans.dart';

import '../../../../support/fakes.dart';

void main() {
  late RecordingScheduler scheduler;
  late List<(DateTime, PrayerName)> muted;
  late List<(DateTime, PrayerName)> prayed;
  late HandleReminderAction handler;

  setUp(() {
    scheduler = RecordingScheduler();
    muted = [];
    prayed = [];
    handler = HandleReminderAction(
      scheduler: scheduler,
      mute: (d, p) async => muted.add((d, p)),
      markPrayed: (d, p) async => prayed.add((d, p)),
    );
  });

  String payload({String prayer = 'asr', String date = '2026-10-15', bool photo = false, String kind = 'ending'}) =>
      jsonEncode({'kind': kind, 'prayer': prayer, 'date': date, 'photo': photo});

  final date = DateTime(2026, 10, 15);

  group('parse', () {
    test('reads a valid ending payload', () {
      final r = HandleReminderAction.parse(payload(photo: true))!;
      expect(r.prayer, PrayerName.asr);
      expect(r.date, date);
      expect(r.photo, isTrue);
    });

    test('rejects other kinds, unknown prayers, sunrise, bad dates and junk', () {
      expect(HandleReminderAction.parse(payload(kind: 'azan')), isNull);
      expect(HandleReminderAction.parse(payload(prayer: 'zuhr')), isNull);
      expect(HandleReminderAction.parse(payload(prayer: 'sunrise')), isNull);
      expect(HandleReminderAction.parse(payload(date: 'not-a-date')), isNull);
      expect(HandleReminderAction.parse('{not json'), isNull);
      expect(HandleReminderAction.parse(''), isNull);
      expect(HandleReminderAction.parse(null), isNull);
      expect(HandleReminderAction.parse('[1,2]'), isNull);
    });
  });

  group('stop reminders', () {
    test('mutes the prayer, cancels all its reminder ids and records nothing as prayed', () async {
      final r = await handler(actionId: ReminderActions.stop, payload: payload());
      expect(r, ReminderOutcome.stopped);
      expect(muted, [(date, PrayerName.asr)]);
      expect(prayed, isEmpty);
      expect(scheduler.cancelled, endReminderIds(date, PrayerName.asr));
    });

    test('works even when photo proof was required (stopping is always allowed)', () async {
      final r = await handler(actionId: ReminderActions.stop, payload: payload(photo: true));
      expect(r, ReminderOutcome.stopped);
    });
  });

  group('prayed button', () {
    test('without photo proof it ticks the prayer and cancels the rest', () async {
      final r = await handler(actionId: ReminderActions.prayed, payload: payload());
      expect(r, ReminderOutcome.prayed);
      expect(prayed, [(date, PrayerName.asr)]);
      expect(scheduler.cancelled, endReminderIds(date, PrayerName.asr));
      expect(muted, isEmpty);
    });

    test('with photo proof the button cannot bypass the photo', () async {
      final r = await handler(actionId: ReminderActions.prayed, payload: payload(photo: true));
      expect(r, ReminderOutcome.needsPhoto);
      expect(prayed, isEmpty);
      expect(scheduler.cancelled, isEmpty);
    });
  });

  group('take photo and plain taps', () {
    test('the Take photo button asks the UI to open the camera and changes nothing yet', () async {
      final r = await handler(actionId: ReminderActions.takePhoto, payload: payload(photo: true));
      expect(r, ReminderOutcome.needsPhoto);
      expect(prayed, isEmpty);
      expect(muted, isEmpty);
      expect(scheduler.cancelled, isEmpty);
    });

    test('tapping the notification itself opens the camera only when photo proof is on', () async {
      expect(await handler(actionId: null, payload: payload(photo: true)), ReminderOutcome.needsPhoto);
      expect(await handler(actionId: null, payload: payload()), ReminderOutcome.ignored);
    });

    test('other notifications and unknown buttons are ignored', () async {
      expect(await handler(actionId: null, payload: jsonEncode({'prayer': 'asr', 'date': '2026-10-15'})),
          ReminderOutcome.ignored);
      expect(await handler(actionId: 'who_knows', payload: payload()), ReminderOutcome.ignored);
      expect(await handler(actionId: ReminderActions.stop, payload: 'garbage'), ReminderOutcome.ignored);
      expect(muted, isEmpty);
      expect(scheduler.cancelled, isEmpty);
    });
  });

  group('ReminderMuteStore', () {
    late ReminderMuteStore store;
    setUp(() => store = ReminderMuteStore(FakeKeyValueStore()));
    final today = DateTime(2026, 10, 15);

    test('remembers a muted prayer for that date only', () async {
      expect(store.isMuted(date, PrayerName.asr), isFalse);
      await store.mute(date, PrayerName.asr, today: today);
      expect(store.isMuted(date, PrayerName.asr), isTrue);
      expect(store.isMuted(date, PrayerName.isha), isFalse);
      expect(store.isMuted(DateTime(2026, 10, 16), PrayerName.asr), isFalse);
    });

    test('can be undone', () async {
      await store.mute(date, PrayerName.asr, today: today);
      await store.unmute(date, PrayerName.asr);
      expect(store.isMuted(date, PrayerName.asr), isFalse);
    });

    test('forgets entries older than a week', () async {
      await store.mute(DateTime(2026, 10, 1), PrayerName.fajr, today: DateTime(2026, 10, 1));
      await store.mute(date, PrayerName.asr, today: today);
      expect(store.isMuted(DateTime(2026, 10, 1), PrayerName.fajr), isFalse);
      expect(store.isMuted(date, PrayerName.asr), isTrue);
    });

    test('survives corrupted stored data', () async {
      final kv = FakeKeyValueStore();
      await kv.setString('reminders_muted', '{broken');
      final broken = ReminderMuteStore(kv);
      expect(broken.isMuted(date, PrayerName.asr), isFalse);
      await broken.mute(date, PrayerName.asr, today: today);
      expect(broken.isMuted(date, PrayerName.asr), isTrue);
    });
  });
}
