import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/core/storage/app_database.dart';
import 'package:saathi/core/sync/cloud_api.dart';
import 'package:saathi/core/sync/sync_models.dart';
import 'package:saathi/core/sync/sync_config.dart';
import 'package:saathi/features/prayer/data/sync/prayer_sync_service.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;

import '../../../support/fakes.dart';

/// One simulated phone: its own database, settings and clock.
class Phone {
  Phone._(this.db, this.store, this.service);

  final AppDatabase db;
  final SyncConfigStore store;
  final PrayerSyncService service;

  static Future<Phone> create(
    FakeCloudServer server, {
    required String key,
    bool enabled = true,
    String url = 'https://api.test',
  }) async {
    final store = SyncConfigStore(FakeKeyValueStore(), FakeSecretStore());
    await store.setEnabled(enabled);
    await store.setBaseUrl(url);
    await store.setKey(key);
    final db = AppDatabase(NativeDatabase.memory());
    return Phone._(db, store, PrayerSyncService(logs: db.prayerLogsDao, api: server, config: store));
  }

  Future<Set<String>> done(String date) => db.prayerLogsDao.doneFor(date);
  Future<void> tick(String date, String prayer, DateTime at) => db.prayerLogsDao.markDone(date, prayer, at);
  Future<void> untick(String date, String prayer, DateTime at) => db.prayerLogsDao.unmark(date, prayer, at);
  Future<int> pending() => service.pendingCount();
}

void main() {
  // Several in-memory databases are open at once on purpose (one per simulated phone).
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  final key = 'S' * 43;
  const day = '2026-10-15';
  DateTime at(int h, [int m = 0]) => DateTime.utc(2026, 10, 15, h, m);

  late FakeCloudServer server;
  late Phone a;
  late Phone b;

  setUp(() async {
    server = FakeCloudServer();
    a = await Phone.create(server, key: key);
    b = await Phone.create(server, key: key);
  });

  tearDown(() async {
    await a.db.close();
    await b.db.close();
  });

  group('two phones, one key', () {
    test('a tick on one phone appears on the other', () async {
      await a.tick(day, 'fajr', at(1));
      final first = (await a.service.syncNow()).valueOrNull!;
      expect(first.pushed, 1);
      expect(await a.pending(), 0);

      final second = (await b.service.syncNow()).valueOrNull!;
      expect(second.pulled, 1);
      expect(second.applied, 1);
      expect(await b.done(day), {'fajr'});
      expect(await b.pending(), 0, reason: 'received changes are not re-uploaded');
    });

    test('an un-tick on one phone removes it on the other', () async {
      await a.tick(day, 'asr', at(1));
      await a.service.syncNow();
      await b.service.syncNow();
      expect(await b.done(day), {'asr'});

      await b.untick(day, 'asr', at(2));
      await b.service.syncNow();
      await a.service.syncNow();
      expect(await a.done(day), isEmpty);
    });

    test('the newest edit wins when both phones changed the same prayer', () async {
      await a.tick(day, 'maghrib', at(5)); // ticked at 05:00
      await b.tick(day, 'maghrib', at(6)); // ticked, then...
      await b.untick(day, 'maghrib', at(7)); // ...un-ticked at 07:00, the newest
      await a.service.syncNow();
      await b.service.syncNow();
      await a.service.syncNow();
      expect(await a.done(day), isEmpty);
      expect(await b.done(day), isEmpty);
    });

    test('different prayers on different phones both survive', () async {
      await a.tick(day, 'fajr', at(1));
      await b.tick(day, 'dhuhr', at(2));
      await a.service.syncNow();
      await b.service.syncNow();
      await a.service.syncNow();
      expect(await a.done(day), {'fajr', 'dhuhr'});
      expect(await b.done(day), {'fajr', 'dhuhr'});
    });

    test('a brand new phone with the key gets the whole history', () async {
      for (var d = 1; d <= 5; d++) {
        await a.tick('2026-10-0$d', 'fajr', DateTime.utc(2026, 10, d, 5));
        await a.tick('2026-10-0$d', 'isha', DateTime.utc(2026, 10, d, 20));
      }
      await a.service.syncNow();
      final c = await Phone.create(server, key: key);
      addTearDown(c.db.close);
      final report = (await c.service.syncNow()).valueOrNull!;
      expect(report.applied, 10);
      expect(await c.done('2026-10-03'), {'fajr', 'isha'});
    });

    test('a different key sees nothing', () async {
      await a.tick(day, 'fajr', at(1));
      await a.service.syncNow();
      final stranger = await Phone.create(server, key: 'X' * 43);
      addTearDown(stranger.db.close);
      final report = (await stranger.service.syncNow()).valueOrNull!;
      expect(report.pulled, 0);
      expect(await stranger.done(day), isEmpty);
    });
  });

  group('reliability', () {
    test('while offline, changes stay queued and nothing is lost; the next sync sends them', () async {
      await a.tick(day, 'fajr', at(1));
      server.failWith = const CloudApiException(CloudErrorKind.network, 'No connection');
      final failed = await a.service.syncNow();
      expect(failed.isSuccess, isFalse);
      expect(failed.failureOrNull!.message, 'No connection');
      expect(await a.pending(), 1);
      expect(await a.done(day), {'fajr'}, reason: 'the app keeps working offline');

      server.failWith = null;
      expect((await a.service.syncNow()).isSuccess, isTrue);
      expect(await a.pending(), 0);
      expect(server.rowsFor(key), 1);
    });

    test('a failed sync does not move the saved position or the last-synced time', () async {
      await a.tick(day, 'fajr', at(1));
      await a.service.syncNow();
      final cursor = a.store.cursor;
      final last = a.store.lastSyncAt;
      server.failWith = const CloudApiException(CloudErrorKind.server, 'down', statusCode: 503);
      await a.service.syncNow();
      expect(a.store.cursor, cursor);
      expect(a.store.lastSyncAt, last);
    });

    test('a rejected key is reported and keeps the data queued', () async {
      await a.tick(day, 'fajr', at(1));
      server.failWith = const CloudApiException(CloudErrorKind.unauthorized, 'bad key', statusCode: 401);
      final r = await a.service.syncNow();
      expect((r.failureOrNull!.cause! as CloudApiException).kind, CloudErrorKind.unauthorized);
      expect(await a.pending(), 1);
    });

    test('an edit made while the upload was in flight is not lost', () async {
      await a.tick(day, 'fajr', at(1));
      // The server answers, but meanwhile the user un-ticks. Simulate by
      // editing during the call through a wrapper API.
      final racing = _RacingApi(server, () => a.untick(day, 'fajr', at(2)));
      final service = PrayerSyncService(logs: a.db.prayerLogsDao, api: racing, config: a.store);
      await service.syncNow();
      expect(await a.pending(), 1, reason: 'the un-tick is newer than what was uploaded');
      await a.service.syncNow();
      expect(await a.pending(), 0);
      await b.service.syncNow();
      expect(await b.done(day), isEmpty, reason: 'the un-tick reached the cloud');
    });

    test('two sync calls at once share one run', () async {
      await a.tick(day, 'fajr', at(1));
      final results = await Future.wait([a.service.syncNow(), a.service.syncNow(), a.service.syncNow()]);
      expect(results.every((r) => r.isSuccess), isTrue);
      expect(server.syncCalls, 1);
    });

    test('syncing again with nothing new still works and sends nothing', () async {
      await a.tick(day, 'fajr', at(1));
      await a.service.syncNow();
      server.received.clear();
      final r = (await a.service.syncNow()).valueOrNull!;
      expect(r.pushed, 0);
      expect(server.received.single, isEmpty);
    });

    test('each pull starts a little before the saved position (overlap), never below zero', () async {
      await a.service.syncNow();
      expect(server.cursorsReceived.last, 0);
      for (var i = 0; i < 30; i++) {
        await a.tick('2026-09-${(i + 1).toString().padLeft(2, '0')}', 'fajr', at(1, i));
      }
      await a.service.syncNow();
      final saved = a.store.cursor;
      expect(saved, 30);
      await a.service.syncNow();
      expect(server.cursorsReceived.last, saved - PrayerSyncService.overlap);
    });

    test('the saved position never goes backwards', () async {
      await a.tick(day, 'fajr', at(1));
      await a.service.syncNow();
      final first = a.store.cursor;
      await a.service.syncNow();
      expect(a.store.cursor, greaterThanOrEqualTo(first));
    });
  });

  group('large histories', () {
    test('pages through more changes than one response holds', () async {
      final small = FakeCloudServer(pageSize: 4);
      final writer = await Phone.create(small, key: key);
      final reader = await Phone.create(small, key: key);
      addTearDown(writer.db.close);
      addTearDown(reader.db.close);
      for (var d = 1; d <= 6; d++) {
        for (final p in ['fajr', 'asr']) {
          await writer.tick('2026-10-${d.toString().padLeft(2, '0')}', p, DateTime.utc(2026, 10, d, 5));
        }
      }
      await writer.service.syncNow();
      final report = (await reader.service.syncNow()).valueOrNull!;
      expect(report.applied, 12);
      expect(await reader.done('2026-10-06'), {'fajr', 'asr'});
      expect(small.syncCalls, greaterThan(2), reason: 'it had to ask more than once');
    });

    test('pages smaller than the overlap still move forward (no repeated first page)', () async {
      final tiny = FakeCloudServer(pageSize: 3); // 3 is far below the overlap of 20
      final writer = await Phone.create(tiny, key: key);
      final reader = await Phone.create(tiny, key: key);
      addTearDown(writer.db.close);
      addTearDown(reader.db.close);
      for (var d = 1; d <= 9; d++) {
        await writer.tick('2026-10-${d.toString().padLeft(2, '0')}', 'fajr', DateTime.utc(2026, 10, d, 5));
      }
      await writer.service.syncNow();
      tiny.cursorsReceived.clear();
      await reader.service.syncNow();
      expect(await reader.done('2026-10-09'), {'fajr'});
      // Strictly increasing within the run, one request per page of 3: 0, 3, 6.
      expect(tiny.cursorsReceived, [0, 3, 6]);
    });

    test('uploads more than 500 queued changes in several requests', () async {
      for (var i = 0; i < 520; i++) {
        final date = DateTime.utc(2025).add(Duration(days: i ~/ 5)).toIso8601String().substring(0, 10);
        await a.tick(date, ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'][i % 5], DateTime.utc(2026, 1, 1, 0, 0, i % 60, i));
      }
      expect(await a.pending(), 520);
      final r = (await a.service.syncNow()).valueOrNull!;
      expect(r.pushed, 520);
      expect(await a.pending(), 0);
      expect(server.received.map((c) => c.length).reduce((x, y) => x > y ? x : y), lessThanOrEqualTo(500));
      expect(server.rowsFor(key), 520);
    });
  });

  group('configuration', () {
    test('does nothing when sync is off', () async {
      final off = await Phone.create(server, key: key, enabled: false);
      addTearDown(off.db.close);
      await off.tick(day, 'fajr', at(1));
      final r = await off.service.syncNow();
      expect(r.isSuccess, isFalse);
      expect(server.syncCalls, 0);
      expect(await off.pending(), 1);
    });

    test('does nothing without a usable server address or key', () async {
      final noUrl = await Phone.create(server, key: key, url: '');
      final badKey = await Phone.create(server, key: 'short');
      addTearDown(noUrl.db.close);
      addTearDown(badKey.db.close);
      expect((await noUrl.service.syncNow()).isSuccess, isFalse);
      expect((await badKey.service.syncNow()).isSuccess, isFalse);
      expect(server.syncCalls, 0);
    });

    test('switching to another key merges this phone\'s history into that account', () async {
      await a.tick(day, 'fajr', at(1));
      await a.service.syncNow(); // synced under the first key
      expect(await a.pending(), 0);

      final other = FakeCloudServer();
      await other.sync(
        baseUrl: Uri.parse('https://api.test'),
        key: 'Z' * 43,
        cursor: 0,
        changes: [], // the other account already exists
      );
      // Switch: new key, reset position, queue everything for upload.
      await a.store.setKey('Z' * 43);
      await a.store.setCursor(0);
      await a.db.prayerLogsDao.markAllDirty();
      final svc = PrayerSyncService(logs: a.db.prayerLogsDao, api: other, config: a.store);
      await svc.syncNow();
      expect(other.rowsFor('Z' * 43), 1, reason: 'the existing history moved to the new account');
    });
  });
}

/// Runs [onSend] after the server has received the request but before the
/// phone processes the reply, like an edit made during a slow upload.
class _RacingApi implements CloudApi {
  _RacingApi(this._inner, this._onSend);

  final CloudApi _inner;
  final Future<void> Function() _onSend;
  var _fired = false;

  @override
  Future<SyncResponse> sync({
    required Uri baseUrl,
    required String key,
    required int cursor,
    required List<SyncChange> changes,
  }) async {
    final response = await _inner.sync(baseUrl: baseUrl, key: key, cursor: cursor, changes: changes);
    if (!_fired) {
      _fired = true;
      await _onSend();
    }
    return response;
  }

  @override
  Future<void> deleteAccount({required Uri baseUrl, required String key}) =>
      _inner.deleteAccount(baseUrl: baseUrl, key: key);
}
