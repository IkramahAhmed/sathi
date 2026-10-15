import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'sync_models.dart';

enum CloudErrorKind {
  /// The key was not accepted.
  unauthorized,

  /// No connection or a timeout. Worth retrying later.
  network,

  /// The server failed (5xx). Worth retrying later.
  server,

  /// The request was rejected as invalid. A bug or a version mismatch.
  rejected,
}

class CloudApiException implements Exception {
  const CloudApiException(this.kind, this.message, {this.statusCode});

  final CloudErrorKind kind;
  final String message;
  final int? statusCode;

  bool get retryable => kind == CloudErrorKind.network || kind == CloudErrorKind.server;

  @override
  String toString() => 'CloudApiException($kind${statusCode == null ? '' : ' $statusCode'}: $message)';
}

/// The sync server. An interface so tests can use an in-memory server.
abstract interface class CloudApi {
  Future<SyncResponse> sync({
    required Uri baseUrl,
    required String key,
    required int cursor,
    required List<SyncChange> changes,
  });

  /// Deletes the user and all their cloud data.
  Future<void> deleteAccount({required Uri baseUrl, required String key});
}

class HttpCloudApi implements CloudApi {
  HttpCloudApi({http.Client? client, this.timeout = const Duration(seconds: 20)}) : _client = client ?? http.Client();

  final http.Client _client;
  final Duration timeout;

  Uri _endpoint(Uri base, String path) {
    final prefix = base.path.replaceAll(RegExp(r'/+$'), '');
    return Uri(scheme: base.scheme, host: base.host, port: base.hasPort ? base.port : null, path: '$prefix$path');
  }

  Map<String, String> _headers(String key) => {
        'authorization': 'Bearer $key',
        'content-type': 'application/json',
        'accept': 'application/json',
      };

  Future<http.Response> _send(Future<http.Response> Function() request) async {
    try {
      return await request().timeout(timeout);
    } on TimeoutException {
      throw const CloudApiException(CloudErrorKind.network, 'The server took too long to answer.');
    } on SocketException catch (e) {
      throw CloudApiException(CloudErrorKind.network, 'No connection: ${e.message}');
    } on http.ClientException catch (e) {
      throw CloudApiException(CloudErrorKind.network, 'No connection: ${e.message}');
    } on HandshakeException {
      throw const CloudApiException(CloudErrorKind.network, 'Could not make a secure connection.');
    }
  }

  CloudApiException _failure(http.Response r) {
    var message = 'Request failed (${r.statusCode}).';
    try {
      final body = jsonDecode(r.body) as Map<String, dynamic>;
      message = (body['error'] as Map<String, dynamic>)['message'] as String? ?? message;
    } catch (_) {
      // Not our JSON error shape (for example an HTML error page); keep the default.
    }
    final kind = switch (r.statusCode) {
      401 || 403 => CloudErrorKind.unauthorized,
      >= 500 => CloudErrorKind.server,
      _ => CloudErrorKind.rejected,
    };
    return CloudApiException(kind, message, statusCode: r.statusCode);
  }

  @override
  Future<SyncResponse> sync({
    required Uri baseUrl,
    required String key,
    required int cursor,
    required List<SyncChange> changes,
  }) async {
    final response = await _send(
      () => _client.post(
        _endpoint(baseUrl, '/v1/sync'),
        headers: _headers(key),
        body: jsonEncode({'cursor': cursor, 'changes': [for (final c in changes) c.toJson()]}),
      ),
    );
    if (response.statusCode != 200) throw _failure(response);
    try {
      return SyncResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } catch (_) {
      throw CloudApiException(
        CloudErrorKind.rejected,
        'The server sent a reply the app could not read.',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<void> deleteAccount({required Uri baseUrl, required String key}) async {
    final response = await _send(() => _client.delete(_endpoint(baseUrl, '/v1/account'), headers: _headers(key)));
    if (response.statusCode != 204 && response.statusCode != 200) throw _failure(response);
  }
}
