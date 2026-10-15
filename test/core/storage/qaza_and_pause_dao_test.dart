import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/core/storage/app_database.dart';

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  final t0 = DateTime.utc(2026, 10, 15, 8);

  group('qaza balance', () {
    test('starts empty', () async {
      expect(await db.qazaDao.owed(), isEmpty);
      expect(await db.qazaDao.owedFor('fajr'), 0);
    });

    test('adding and making up change the count and are recorded', () async {
      expect(await db.qazaDao.change('fajr', 3, t0, 'added'), 3);
      expect(await db.qazaDao.change('fajr', -1, t0, 'madeUp'), -1);
      expect(await db.qazaDao.owedFor('fajr'), 2);
      final history = await db.qazaDao.history();
      expect(history.map((h) => h.delta), [-1, 3], reason: 'newest first');
      expect(history.map((h) => h.source), ['madeUp', 'added']);
    });

    test('the balance never goes below zero and the recorded change is what really happened', () async {
      await db.qazaDao.change('asr', 2, t0, 'added');
      expect(await db.qazaDao.change('asr', -5, t0, 'madeUp'), -2);
      expect(await db.qazaDao.owedFor('asr'), 0);
      expect(await db.qazaDao.change('asr', -1, t0, 'madeUp'), 0, reason: 'nothing left to make up');
      final rows = await db.qazaDao.history();
      expect(rows.first.delta, -2, reason: 'not -5');
    });

    test('prayers are independent', () async {
      await db.qazaDao.change('fajr', 4, t0, 'added');
      await db.qazaDao.change('isha', 1, t0, 'added');
      expect(await db.qazaDao.owed(), {'fajr': 4, 'isha': 1});
    });

    test('setInitial records the difference once and is idempotent', () async {
      await db.qazaDao.setInitial('dhuhr', 300, t0);
      expect(await db.qazaDao.owedFor('dhuhr'), 300);
      await db.qazaDao.setInitial('dhuhr', 300, t0);
      expect((await db.qazaDao.history()), hasLength(1));
      await db.qazaDao.setInitial('dhuhr', 250, t0);
      expect(await db.qazaDao.owedFor('dhuhr'), 250);
      expect((await db.qazaDao.history()).first.delta, -50);
      await db.qazaDao.setInitial('dhuhr', -4, t0);
      expect(await db.qazaDao.owedFor('dhuhr'), 0, reason: 'negative is treated as zero');
    });

    test('an auto key can only be counted once', () async {
      await db.qazaDao.change('fajr', 1, t0, 'auto', autoKey: '2026-10-14|fajr');
      await expectLater(
        db.qazaDao.change('fajr', 1, t0, 'auto', autoKey: '2026-10-14|fajr'),
        throwsA(anything),
      );
      expect(await db.qazaDao.owedFor('fajr'), 1, reason: 'the failed insert rolled back');
    });

    test('removeAuto takes the miss back and leaves other history alone', () async {
      await db.qazaDao.change('fajr', 5, t0, 'added');
      await db.qazaDao.change('fajr', 1, t0, 'auto', autoKey: '2026-10-14|fajr');
      expect(await db.qazaDao.owedFor('fajr'), 6);
      await db.qazaDao.removeAuto('2026-10-14|fajr', 'fajr');
      expect(await db.qazaDao.owedFor('fajr'), 5);
      expect(await db.qazaDao.autoKeys(), isEmpty);
      expect(await db.qazaDao.history(), hasLength(1));
      await db.qazaDao.removeAuto('2026-10-14|fajr', 'fajr'); // already gone
      expect(await db.qazaDao.owedFor('fajr'), 5);
    });

    test('watchOwed emits as the balance changes', () async {
      final expectation = expectLater(
        db.qazaDao.watchOwed(),
        emitsInOrder([isEmpty, {'fajr': 2}]),
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));
      await db.qazaDao.change('fajr', 2, t0, 'added');
      await expectation;
    });

    test('clearAll wipes balance and history', () async {
      await db.qazaDao.change('fajr', 2, t0, 'added');
      await db.qazaDao.clearAll();
      expect(await db.qazaDao.owed(), isEmpty);
      expect(await db.qazaDao.history(), isEmpty);
    });
  });

  group('pause ranges', () {
    test('start, then end an ongoing pause', () async {
      final id = await db.pauseRangesDao.startPause('2026-10-10');
      expect(id, isNotNull);
      var rows = await db.pauseRangesDao.all();
      expect(rows.single.endDate, isNull);

      expect(await db.pauseRangesDao.endOngoing('2026-10-14'), isTrue);
      rows = await db.pauseRangesDao.all();
      expect(rows.single.startDate, '2026-10-10');
      expect(rows.single.endDate, '2026-10-14');
    });

    test('only one pause can be ongoing at a time', () async {
      await db.pauseRangesDao.startPause('2026-10-10');
      expect(await db.pauseRangesDao.startPause('2026-10-12'), isNull);
      expect(await db.pauseRangesDao.all(), hasLength(1));
    });

    test('ending when nothing is ongoing reports false', () async {
      expect(await db.pauseRangesDao.endOngoing('2026-10-14'), isFalse);
    });

    test('a pause cannot end before it began', () async {
      await db.pauseRangesDao.startPause('2026-10-10');
      await db.pauseRangesDao.endOngoing('2026-10-01');
      expect((await db.pauseRangesDao.all()).single.endDate, '2026-10-10');
    });

    test('add a finished range, list newest first, and remove one', () async {
      final a = await db.pauseRangesDao.addRange('2026-09-01', '2026-09-05');
      await db.pauseRangesDao.addRange('2026-10-01', '2026-10-04');
      expect((await db.pauseRangesDao.all()).map((r) => r.startDate), ['2026-10-01', '2026-09-01']);
      await db.pauseRangesDao.remove(a);
      expect((await db.pauseRangesDao.all()).map((r) => r.startDate), ['2026-10-01']);
    });
  });

  group('log helpers', () {
    test('doneInRange returns only ticked prayers inside the range', () async {
      await db.prayerLogsDao.markDone('2026-10-12', 'fajr', t0);
      await db.prayerLogsDao.markDone('2026-10-13', 'asr', t0);
      await db.prayerLogsDao.markDone('2026-10-13', 'isha', t0);
      await db.prayerLogsDao.markDone('2026-10-20', 'fajr', t0);
      await db.prayerLogsDao.unmark('2026-10-13', 'isha', t0.add(const Duration(minutes: 1)));
      final r = await db.prayerLogsDao.doneInRange('2026-10-12', '2026-10-14');
      expect(r, {'2026-10-12': {'fajr'}, '2026-10-13': {'asr'}});
    });

    test('earliestDate finds the first log, or null', () async {
      expect(await db.prayerLogsDao.earliestDate(), isNull);
      await db.prayerLogsDao.markDone('2026-10-13', 'asr', t0);
      await db.prayerLogsDao.markDone('2026-09-30', 'fajr', t0);
      expect(await db.prayerLogsDao.earliestDate(), '2026-09-30');
    });
  });
}
