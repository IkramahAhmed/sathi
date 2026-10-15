import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:saathi/core/sync/cloud_api.dart';
import 'package:saathi/core/sync/sync_models.dart';

void main() {
  final base = Uri.parse('https://api.example.dev');
  final key = 'K' * 43;
  final change = SyncChange(
    date: '2026-10-15',
    prayer: 'fajr',
    done: true,
    updatedAt: DateTime.utc(2026, 10, 15, 0, 30),
  );

  String okBody({int cursor = 3, bool hasMore = false}) => jsonEncode({
        'serverTime': '2026-10-15T10:00:00.000Z',
        'cursor': cursor,
        'hasMore': hasMore,
        'changes': [
          {'date': '2026-10-14', 'prayer': 'asr', 'done': false, 'updatedAt': '2026-10-14T11:00:00.000Z'},
        ],
      });

  HttpCloudApi api(MockClientHandler h, {Duration? timeout}) =>
      HttpCloudApi(client: MockClient(h), timeout: timeout ?? const Duration(seconds: 5));

  Future<Object?> failure(Future<void> Function() call) async {
    try {
      await call();
    } catch (e) {
      return e;
    }
    return null;
  }

  group('sync request', () {
    test('posts JSON to /v1/sync with the bearer key', () async {
      late http.Request seen;
      final client = api((r) async {
        seen = r;
        return http.Response(okBody(), 200);
      });
      await client.sync(baseUrl: base, key: key, cursor: 7, changes: [change]);

      expect(seen.method, 'POST');
      expect(seen.url.toString(), 'https://api.example.dev/v1/sync');
      expect(seen.headers['authorization'], 'Bearer $key');
      expect(seen.headers['content-type'], contains('application/json'));
      final body = jsonDecode(seen.body) as Map<String, dynamic>;
      expect(body['cursor'], 7);
      expect(body['changes'], [
        {'date': '2026-10-15', 'prayer': 'fajr', 'done': true, 'updatedAt': '2026-10-15T00:30:00.000Z'},
      ]);
    });

    test('keeps a path prefix on the server address and ignores a trailing slash', () async {
      final urls = <String>[];
      final client = api((r) async {
        urls.add(r.url.toString());
        return http.Response(okBody(), 200);
      });
      await client.sync(baseUrl: Uri.parse('https://x.dev/saathi/'), key: key, cursor: 0, changes: []);
      await client.sync(baseUrl: Uri.parse('https://x.dev'), key: key, cursor: 0, changes: []);
      expect(urls, ['https://x.dev/saathi/v1/sync', 'https://x.dev/v1/sync']);
    });

    test('parses the response', () async {
      final r = await api((_) async => http.Response(okBody(cursor: 9, hasMore: true), 200))
          .sync(baseUrl: base, key: key, cursor: 0, changes: []);
      expect(r.cursor, 9);
      expect(r.hasMore, isTrue);
      expect(r.serverTime, DateTime.utc(2026, 10, 15, 10));
      expect(r.changes.single.prayer, 'asr');
      expect(r.changes.single.done, isFalse);
      expect(r.changes.single.updatedAt, DateTime.utc(2026, 10, 14, 11));
    });
  });

  group('errors', () {
    Future<CloudApiException> run(MockClientHandler h, {Duration? timeout}) async {
      final e = await failure(() => api(h, timeout: timeout).sync(baseUrl: base, key: key, cursor: 0, changes: []));
      expect(e, isA<CloudApiException>());
      return e! as CloudApiException;
    }

    test('401 means the key was not accepted and is not retryable', () async {
      final e = await run((_) async => http.Response(
          jsonEncode({'error': {'code': 'unauthorized', 'message': 'A valid sync key is required.'}}), 401));
      expect(e.kind, CloudErrorKind.unauthorized);
      expect(e.retryable, isFalse);
      expect(e.message, 'A valid sync key is required.');
      expect(e.statusCode, 401);
    });

    test('5xx is a retryable server error, even with an HTML body', () async {
      final e = await run((_) async => http.Response('<html>Bad gateway</html>', 502));
      expect(e.kind, CloudErrorKind.server);
      expect(e.retryable, isTrue);
      expect(e.message, 'Request failed (502).');
    });

    test('400 and 413 are rejections, not retryable', () async {
      for (final code in [400, 413]) {
        final e = await run((_) async => http.Response('{}', code));
        expect(e.kind, CloudErrorKind.rejected, reason: '$code');
        expect(e.retryable, isFalse);
      }
    });

    test('a dropped connection is a retryable network error', () async {
      final e = await run((_) async => throw const SocketException('Network is unreachable'));
      expect(e.kind, CloudErrorKind.network);
      expect(e.retryable, isTrue);
    });

    test('an http client error is a network error', () async {
      final e = await run((_) async => throw http.ClientException('connection closed'));
      expect(e.kind, CloudErrorKind.network);
    });

    test('a TLS failure is a network error with a clear message', () async {
      final e = await run((_) async => throw const HandshakeException('bad certificate'));
      expect(e.kind, CloudErrorKind.network);
      expect(e.message, contains('secure'));
    });

    test('a slow server times out as a network error', () async {
      final e = await run(
        (_) => Completer<http.Response>().future,
        timeout: const Duration(milliseconds: 50),
      );
      expect(e.kind, CloudErrorKind.network);
      expect(e.message, contains('too long'));
    });

    test('a 200 that is not our JSON is rejected, not crashed on', () async {
      final e = await run((_) async => http.Response('<html>captive portal</html>', 200));
      expect(e.kind, CloudErrorKind.rejected);
    });

    test('a 200 with the wrong shape is rejected', () async {
      final e = await run((_) async => http.Response(jsonEncode({'hello': 1}), 200));
      expect(e.kind, CloudErrorKind.rejected);
    });
  });

  group('deleteAccount', () {
    test('sends DELETE /v1/account and accepts 204', () async {
      late http.Request seen;
      await api((r) async {
        seen = r;
        return http.Response('', 204);
      }).deleteAccount(baseUrl: base, key: key);
      expect(seen.method, 'DELETE');
      expect(seen.url.path, '/v1/account');
      expect(seen.headers['authorization'], 'Bearer $key');
    });

    test('throws on failure', () async {
      final e = await failure(
          () => api((_) async => http.Response('{}', 401)).deleteAccount(baseUrl: base, key: key));
      expect(e, isA<CloudApiException>());
      expect((e! as CloudApiException).kind, CloudErrorKind.unauthorized);
    });
  });
}
