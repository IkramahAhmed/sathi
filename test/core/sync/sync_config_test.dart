import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/core/sync/sync_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/fakes.dart';

void main() {
  group('sync key', () {
    test('is 43 url-safe characters, valid, and different every time', () {
      final keys = {for (var i = 0; i < 50; i++) generateSyncKey()};
      expect(keys, hasLength(50));
      for (final k in keys) {
        expect(k, hasLength(43));
        expect(isValidSyncKey(k), isTrue);
        expect(k, isNot(contains('=')));
        expect(k, matches(RegExp(r'^[A-Za-z0-9_-]+$')));
      }
    });

    test('is deterministic for a given random source (so it is really built from it)', () {
      expect(generateSyncKey(Random(1)), generateSyncKey(Random(1)));
      expect(generateSyncKey(Random(1)), isNot(generateSyncKey(Random(2))));
    });

    test('validation rejects short, long, and non url-safe keys', () {
      expect(isValidSyncKey('short'), isFalse);
      expect(isValidSyncKey('A' * 42), isFalse);
      expect(isValidSyncKey('A' * 43), isTrue);
      expect(isValidSyncKey('A' * 128), isTrue);
      expect(isValidSyncKey('A' * 129), isFalse);
      expect(isValidSyncKey('${'A' * 42} '), isFalse);
      expect(isValidSyncKey('${'A' * 42}+'), isFalse);
      expect(isValidSyncKey(''), isFalse);
    });
  });

  group('server address', () {
    test('accepts https in every build', () {
      expect(parseServerUrl('https://saathi-api.me.workers.dev', allowCleartext: false)?.host, 'saathi-api.me.workers.dev');
      expect(parseServerUrl('  https://x.dev/api/  ', allowCleartext: false)?.path, '/api/');
    });

    test('accepts http only when cleartext is allowed (debug builds)', () {
      expect(parseServerUrl('http://10.0.2.2:8787', allowCleartext: false), isNull);
      final dev = parseServerUrl('http://10.0.2.2:8787', allowCleartext: true);
      expect(dev?.host, '10.0.2.2');
      expect(dev?.port, 8787);
    });

    test('rejects junk', () {
      for (final bad in ['', '   ', 'saathi-api', 'ftp://x.dev', 'https://', 'javascript:alert(1)', 'file:///etc/passwd']) {
        expect(parseServerUrl(bad, allowCleartext: true), isNull, reason: bad);
      }
    });

    test('drops query strings, fragments and embedded credentials', () {
      final u = parseServerUrl('https://user:pass@x.dev:8443/api?x=1#top', allowCleartext: false)!;
      expect(u.hasQuery, isFalse);
      expect(u.hasFragment, isFalse);
      expect(u.userInfo, isEmpty);
      expect(u.toString(), 'https://x.dev:8443/api');
    });
  });

  group('SyncConfigStore', () {
    late SharedPreferences prefs;
    late FakeSecretStore secrets;
    late SyncConfigStore store;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      secrets = FakeSecretStore();
      store = SyncConfigStore(PrefsKeyValueStore(prefs), secrets);
    });

    test('starts disabled with no key', () async {
      final c = await store.load();
      expect(c.enabled, isFalse);
      expect(c.key, isNull);
      expect(c.isConfigured, isFalse);
      expect(store.cursor, 0);
      expect(store.lastSyncAt, isNull);
    });

    test('the key goes to secure storage, never to preferences', () async {
      final key = generateSyncKey();
      await store.setKey(key);
      expect(secrets.values.values, contains(key));
      expect(prefs.getKeys().any((k) => (prefs.get(k) ?? '').toString().contains(key)), isFalse);
      expect((await store.load()).key, key);
    });

    test('is configured only with enabled data, a valid https address and a valid key', () async {
      await store.setBaseUrl('https://x.dev');
      expect((await store.load()).isConfigured, isFalse, reason: 'no key yet');
      await store.setKey(generateSyncKey());
      expect((await store.load()).isConfigured, isTrue);
      await store.setBaseUrl('not a url');
      expect((await store.load()).isConfigured, isFalse);
    });

    test('remembers cursor and last sync time', () async {
      await store.setCursor(42);
      final at = DateTime.utc(2026, 10, 15, 12, 30, 5);
      await store.setLastSyncAt(at);
      expect(store.cursor, 42);
      expect(store.lastSyncAt, at);
    });

    test('clearAccount forgets the key and position and turns sync off', () async {
      await store.setEnabled(true);
      await store.setKey(generateSyncKey());
      await store.setCursor(9);
      await store.setLastSyncAt(DateTime.utc(2026));
      await store.clearAccount();
      final c = await store.load();
      expect(c.enabled, isFalse);
      expect(c.key, isNull);
      expect(store.cursor, 0);
      expect(store.lastSyncAt, isNull);
    });
  });
}
