import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/core/storage/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  final t0 = DateTime.utc(2026, 10, 15, 8);
  final t1 = DateTime.utc(2026, 10, 15, 9);
  final t2 = DateTime.utc(2026, 10, 15, 10);
  const day = '2026-10-15';

  group('ticking and un-ticking', () {
    test('a tick is done and waiting to upload', () async {
      await db.prayerLogsDao.markDone(day, 'fajr', t0);
      expect(await db.prayerLogsDao.doneFor(day), {'fajr'});
      final dirty = await db.prayerLogsDao.dirtyRows();
      expect(dirty, hasLength(1));
      expect(dirty.single.done, isTrue);
      expect(dirty.single.updatedAt.toUtc(), t0);
    });

    test('un-ticking keeps a tombstone so the change can sync, but hides it from the UI', () async {
      await db.prayerLogsDao.markDone(day, 'fajr', t0);
      await db.prayerLogsDao.unmark(day, 'fajr', t1);
      expect(await db.prayerLogsDao.doneFor(day), isEmpty);
      final rows = await db.select(db.prayerLogs).get();
      expect(rows, hasLength(1));
      expect(rows.single.done, isFalse);
      expect(rows.single.updatedAt.toUtc(), t1);
      expect(rows.single.dirty, isTrue);
    });

    test('un-ticking something never ticked changes nothing', () async {
      await db.prayerLogsDao.unmark(day, 'asr', t0);
      expect(await db.select(db.prayerLogs).get(), isEmpty);
    });

    test('ticking again after an un-tick revives the row without duplicating it', () async {
      await db.prayerLogsDao.markDone(day, 'isha', t0);
      await db.prayerLogsDao.unmark(day, 'isha', t1);
      await db.prayerLogsDao.markDone(day, 'isha', t2);
      expect(await db.select(db.prayerLogs).get(), hasLength(1));
      expect(await db.prayerLogsDao.doneFor(day), {'isha'});
    });

    test('watchDone follows ticks and un-ticks', () async {
      final expectation = expectLater(
        db.prayerLogsDao.watchDone(day),
        emitsInOrder([isEmpty, {'dhuhr'}, isEmpty]),
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));
      await db.prayerLogsDao.markDone(day, 'dhuhr', t0);
      await Future<void>.delayed(const Duration(milliseconds: 20));
      await db.prayerLogsDao.unmark(day, 'dhuhr', t1);
      await expectation;
    });
  });

  group('dirty tracking', () {
    test('counts and lists only rows waiting to upload, oldest first', () async {
      await db.prayerLogsDao.markDone(day, 'asr', t2);
      await db.prayerLogsDao.markDone(day, 'fajr', t0);
      expect(await db.prayerLogsDao.dirtyCount(), 2);
      expect((await db.prayerLogsDao.dirtyRows()).map((r) => r.prayer), ['fajr', 'asr']);
    });

    test('markClean clears a row that was not edited since it was read', () async {
      await db.prayerLogsDao.markDone(day, 'fajr', t0);
      await db.prayerLogsDao.markClean(day, 'fajr', t0);
      expect(await db.prayerLogsDao.dirtyCount(), 0);
    });

    test('markClean leaves a row dirty when it was edited again meanwhile', () async {
      await db.prayerLogsDao.markDone(day, 'fajr', t0);
      await db.prayerLogsDao.unmark(day, 'fajr', t1); // edited after the upload was read
      await db.prayerLogsDao.markClean(day, 'fajr', t0); // confirms the OLD version
      expect(await db.prayerLogsDao.dirtyCount(), 1, reason: 'the newer edit still has to upload');
    });

    test('dirtyRows honours its limit', () async {
      for (final p in ['fajr', 'dhuhr', 'asr']) {
        await db.prayerLogsDao.markDone(day, p, t0);
      }
      expect(await db.prayerLogsDao.dirtyRows(limit: 2), hasLength(2));
    });

    test('markAllDirty flags everything, including already-synced rows', () async {
      await db.prayerLogsDao.markDone(day, 'fajr', t0);
      await db.prayerLogsDao.markClean(day, 'fajr', t0);
      await db.prayerLogsDao.markAllDirty();
      expect(await db.prayerLogsDao.dirtyCount(), 1);
    });
  });

  group('applying remote changes (last write wins)', () {
    Future<bool> remote(String prayer, bool done, DateTime at) =>
        db.prayerLogsDao.applyRemote(date: day, prayer: prayer, done: done, updatedAt: at);

    test('a new remote tick is stored as already synced', () async {
      expect(await remote('fajr', true, t1), isTrue);
      expect(await db.prayerLogsDao.doneFor(day), {'fajr'});
      expect(await db.prayerLogsDao.dirtyCount(), 0, reason: 'it came from the server');
    });

    test('a newer remote change replaces an older local one', () async {
      await db.prayerLogsDao.markDone(day, 'fajr', t0);
      expect(await remote('fajr', false, t1), isTrue);
      expect(await db.prayerLogsDao.doneFor(day), isEmpty);
      expect(await db.prayerLogsDao.dirtyCount(), 0);
    });

    test('an older remote change is ignored', () async {
      await db.prayerLogsDao.markDone(day, 'fajr', t1);
      expect(await remote('fajr', false, t0), isFalse);
      expect(await db.prayerLogsDao.doneFor(day), {'fajr'});
    });

    test('an equal timestamp is ignored (this is how our own echo comes back)', () async {
      await db.prayerLogsDao.markDone(day, 'fajr', t1);
      expect(await remote('fajr', true, t1), isFalse);
    });

    test('an un-uploaded local edit is never overwritten by an older remote change', () async {
      await db.prayerLogsDao.markDone(day, 'maghrib', t2); // dirty, newest
      expect(await remote('maghrib', false, t1), isFalse);
      expect(await db.prayerLogsDao.dirtyCount(), 1, reason: 'still has to upload');
      expect(await db.prayerLogsDao.doneFor(day), {'maghrib'});
    });

    test('applying the same change twice is harmless', () async {
      expect(await remote('asr', true, t1), isTrue);
      expect(await remote('asr', true, t1), isFalse);
      expect(await db.select(db.prayerLogs).get(), hasLength(1));
    });

    test('works across dates', () async {
      await db.prayerLogsDao.applyRemote(date: '2026-10-14', prayer: 'fajr', done: true, updatedAt: t0);
      await db.prayerLogsDao.applyRemote(date: '2026-10-15', prayer: 'fajr', done: true, updatedAt: t0);
      expect(await db.prayerLogsDao.doneFor('2026-10-14'), {'fajr'});
      expect(await db.prayerLogsDao.doneFor('2026-10-15'), {'fajr'});
    });
  });

  test('clearAll empties the log', () async {
    await db.prayerLogsDao.markDone(day, 'fajr', t0);
    await db.prayerLogsDao.clearAll();
    expect(await db.select(db.prayerLogs).get(), isEmpty);
  });

  group('upgrading a version 1 database', () {
    test('keeps old ticks, marks them done, stamps them with when they were ticked and queues them', () async {
      final upgraded = AppDatabase(
        NativeDatabase.memory(setup: (raw) {
          // The exact shape the app shipped with before cloud sync.
          raw.execute('''
            CREATE TABLE prayer_logs (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              date TEXT NOT NULL,
              prayer TEXT NOT NULL,
              done_at INTEGER NOT NULL,
              UNIQUE (date, prayer)
            )''');
          raw.execute('''
            CREATE TABLE settings_history (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              changed_at INTEGER NOT NULL,
              setting_key TEXT NOT NULL,
              old_value TEXT,
              new_value TEXT NOT NULL
            )''');
          raw.execute("INSERT INTO prayer_logs (date, prayer, done_at) VALUES ('2026-10-12', 'fajr', 1791795600)");
          raw.execute("INSERT INTO prayer_logs (date, prayer, done_at) VALUES ('2026-10-12', 'asr', 1791820800)");
          raw.execute('PRAGMA user_version = 1');
        }),
      );
      addTearDown(upgraded.close);

      final rows = await (upgraded.select(upgraded.prayerLogs)..orderBy([(t) => OrderingTerm.asc(t.prayer)])).get();
      expect(rows.map((r) => r.prayer), ['asr', 'fajr']);
      expect(rows.every((r) => r.done), isTrue);
      expect(rows.every((r) => r.dirty), isTrue, reason: 'old ticks must upload on first sync');
      expect(rows.first.updatedAt.toUtc(), rows.first.doneAt.toUtc());
      expect(rows.last.updatedAt.toUtc().millisecondsSinceEpoch, 1791795600 * 1000);
      expect(await upgraded.prayerLogsDao.doneFor('2026-10-12'), {'fajr', 'asr'});
    });

    test('a version 2 database (cloud sync) upgrades to 3 and keeps its data', () async {
      final upgraded = AppDatabase(
        NativeDatabase.memory(setup: (raw) {
          raw.execute('''
            CREATE TABLE prayer_logs (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              date TEXT NOT NULL,
              prayer TEXT NOT NULL,
              done_at INTEGER NOT NULL,
              done INTEGER NOT NULL DEFAULT 1,
              updated_at INTEGER NOT NULL DEFAULT 0,
              dirty INTEGER NOT NULL DEFAULT 1,
              UNIQUE (date, prayer)
            )''');
          raw.execute('''
            CREATE TABLE settings_history (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              changed_at INTEGER NOT NULL,
              setting_key TEXT NOT NULL,
              old_value TEXT,
              new_value TEXT NOT NULL
            )''');
          raw.execute("INSERT INTO prayer_logs (date, prayer, done_at, updated_at, dirty) VALUES ('2026-10-12', 'fajr', 1791795600, 1791795600, 0)");
          raw.execute('PRAGMA user_version = 2');
        }),
      );
      addTearDown(upgraded.close);

      expect(await upgraded.prayerLogsDao.doneFor('2026-10-12'), {'fajr'});
      expect(await upgraded.prayerLogsDao.dirtyCount(), 0, reason: 'sync state is untouched');
      // The new tables exist and work.
      await upgraded.qazaDao.change('fajr', 2, DateTime.utc(2026, 10, 15), 'added');
      expect(await upgraded.qazaDao.owedFor('fajr'), 2);
      expect(await upgraded.pauseRangesDao.startPause('2026-10-15'), isNotNull);
    });

    test('a fresh database is created at version 3 with every table', () async {
      expect(db.schemaVersion, 3);
      await db.prayerLogsDao.markDone(day, 'fajr', t0);
      final row = (await db.select(db.prayerLogs).get()).single;
      expect(row.done, isTrue);
      expect(row.dirty, isTrue);
    });
  });
}
