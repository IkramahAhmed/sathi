// End-to-end check of the app's sync code against a REAL running server.
//
// Skipped unless SAATHI_E2E_URL is set, so `flutter test` stays offline. Run:
//
//   (in saathi-api)  npm run dev
//   (in saathi)      SAATHI_E2E_URL=http://localhost:8787 flutter test test/e2e
import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/core/storage/app_database.dart';
import 'package:saathi/core/sync/cloud_api.dart';
import 'package:saathi/core/sync/sync_config.dart';
import 'package:saathi/features/prayer/data/sync/prayer_sync_service.dart';

import '../support/fakes.dart';

void main() {
  final url = Platform.environment['SAATHI_E2E_URL'];
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  Future<({AppDatabase db, PrayerSyncService service, SyncConfigStore store})> phone(String key) async {
    final store = SyncConfigStore(FakeKeyValueStore(), FakeSecretStore());
    await store.setEnabled(true);
    await store.setBaseUrl(url!);
    await store.setKey(key);
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final service = PrayerSyncService(logs: db.prayerLogsDao, api: HttpCloudApi(), config: store);
    return (db: db, service: service, store: store);
  }

  setUpAll(() => HttpOverrides.global = null); // allow real network in tests

  test(
    'two phones sync a tick and an un-tick through the real server',
    () async {
      final key = generateSyncKey();
      final a = await phone(key);
      final b = await phone(key);

      await a.db.prayerLogsDao.markDone('2026-10-15', 'fajr', DateTime.utc(2026, 10, 15, 1));
      await a.db.prayerLogsDao.markDone('2026-10-15', 'asr', DateTime.utc(2026, 10, 15, 11));
      final up = (await a.service.syncNow()).valueOrNull!;
      expect(up.pushed, 2);

      final down = (await b.service.syncNow()).valueOrNull!;
      expect(down.applied, 2);
      expect(await b.db.prayerLogsDao.doneFor('2026-10-15'), {'fajr', 'asr'});

      await b.db.prayerLogsDao.unmark('2026-10-15', 'asr', DateTime.utc(2026, 10, 15, 12));
      await b.service.syncNow();
      await a.service.syncNow();
      expect(await a.db.prayerLogsDao.doneFor('2026-10-15'), {'fajr'});
      expect(await a.service.pendingCount(), 0);

      // Clean up what this test created on the server.
      await HttpCloudApi().deleteAccount(baseUrl: Uri.parse(url!), key: key);
    },
    skip: url == null ? 'set SAATHI_E2E_URL to run' : false,
  );

  test(
    'a wrong key shape is rejected by the real server as "unauthorized"',
    () async {
      final api = HttpCloudApi();
      await expectLater(
        api.sync(baseUrl: Uri.parse(url!), key: 'short', cursor: 0, changes: const []),
        throwsA(isA<CloudApiException>().having((e) => e.kind, 'kind', CloudErrorKind.unauthorized)),
      );
    },
    skip: url == null ? 'set SAATHI_E2E_URL to run' : false,
  );

  test(
    'an unreachable server is a retryable network error, not a crash',
    () async {
      final api = HttpCloudApi(timeout: const Duration(seconds: 3));
      await expectLater(
        api.sync(baseUrl: Uri.parse('http://127.0.0.1:9'), key: generateSyncKey(), cursor: 0, changes: const []),
        throwsA(isA<CloudApiException>().having((e) => e.retryable, 'retryable', isTrue)),
      );
    },
    skip: url == null ? 'set SAATHI_E2E_URL to run' : false,
  );
}
