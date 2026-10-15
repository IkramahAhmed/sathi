import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The default server address, set at build time with
/// `--dart-define=SAATHI_API_URL=https://...`. Empty when not set.
const String kDefaultApiUrl = String.fromEnvironment('SAATHI_API_URL');

final RegExp _keyPattern = RegExp(r'^[A-Za-z0-9_-]{43,128}$');

/// A fresh sync key: 32 random bytes as 43 base64url characters (256 bits).
String generateSyncKey([Random? random]) {
  final rng = random ?? Random.secure();
  final bytes = List<int>.generate(32, (_) => rng.nextInt(256));
  return base64Url.encode(bytes).replaceAll('=', '');
}

bool isValidSyncKey(String key) => _keyPattern.hasMatch(key);

/// Checks and normalises a server address. Returns null when it is not usable.
///
/// Release builds accept `https` only. Debug builds also accept `http`, so the
/// app can reach a local dev server.
Uri? parseServerUrl(String input, {bool allowCleartext = kDebugMode}) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) return null;
  final uri = Uri.tryParse(trimmed);
  if (uri == null || !uri.hasAuthority || uri.host.isEmpty) return null;
  final secure = uri.scheme == 'https';
  if (!secure && !(allowCleartext && uri.scheme == 'http')) return null;
  // Rebuilt from parts, which drops any query, fragment or credentials.
  // (`Uri.replace(query: null)` would keep them.)
  return Uri(scheme: uri.scheme, host: uri.host, port: uri.hasPort ? uri.port : null, path: uri.path);
}

/// The few plain settings sync needs. An interface over `SharedPreferences` so
/// each simulated phone in the tests can have its own storage.
abstract interface class KeyValueStore {
  int? getInt(String key);
  String? getString(String key);
  bool? getBool(String key);
  Future<void> setInt(String key, int value);
  Future<void> setString(String key, String value);
  Future<void> setBool(String key, bool value);
  Future<void> remove(String key);
}

/// [KeyValueStore] backed by `SharedPreferences`.
class PrefsKeyValueStore implements KeyValueStore {
  const PrefsKeyValueStore(this._prefs);

  final SharedPreferences _prefs;

  @override
  int? getInt(String key) => _prefs.getInt(key);

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  bool? getBool(String key) => _prefs.getBool(key);

  @override
  Future<void> setInt(String key, int value) => _prefs.setInt(key, value);

  @override
  Future<void> setString(String key, String value) => _prefs.setString(key, value);

  @override
  Future<void> setBool(String key, bool value) => _prefs.setBool(key, value);

  @override
  Future<void> remove(String key) => _prefs.remove(key);
}

/// Where the sync key is kept. Secure storage in the app, in memory in tests.
abstract interface class SecretStore {
  Future<String?> read(String name);
  Future<void> write(String name, String value);
  Future<void> delete(String name);
}

/// Android Keystore / iOS Keychain.
class SecureSecretStore implements SecretStore {
  const SecureSecretStore([this._storage = const FlutterSecureStorage()]);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String name) => _storage.read(key: name);

  @override
  Future<void> write(String name, String value) => _storage.write(key: name, value: value);

  @override
  Future<void> delete(String name) => _storage.delete(key: name);
}

class SyncConfig {
  const SyncConfig({this.enabled = false, this.baseUrl = '', this.key});

  final bool enabled;
  final String baseUrl;
  final String? key;

  Uri? get uri => parseServerUrl(baseUrl);

  /// Everything needed to talk to the server is present.
  bool get isConfigured => uri != null && key != null && isValidSyncKey(key!);

  SyncConfig copyWith({bool? enabled, String? baseUrl, String? key}) =>
      SyncConfig(enabled: enabled ?? this.enabled, baseUrl: baseUrl ?? this.baseUrl, key: key ?? this.key);
}

/// Persists sync settings. The key lives in secure storage; everything else
/// is plain preferences.
class SyncConfigStore {
  const SyncConfigStore(this._prefs, this._secrets);

  final KeyValueStore _prefs;
  final SecretStore _secrets;

  static const _enabledKey = 'sync_enabled';
  static const _urlKey = 'sync_base_url';
  static const _cursorKey = 'sync_cursor';
  static const _lastSyncKey = 'sync_last_at';
  static const _secretName = 'sync_key';

  Future<SyncConfig> load() async => SyncConfig(
        enabled: _prefs.getBool(_enabledKey) ?? false,
        baseUrl: _prefs.getString(_urlKey) ?? kDefaultApiUrl,
        key: await _secrets.read(_secretName),
      );

  Future<void> setEnabled(bool value) => _prefs.setBool(_enabledKey, value);
  Future<void> setBaseUrl(String value) => _prefs.setString(_urlKey, value);
  Future<void> setKey(String value) => _secrets.write(_secretName, value);

  int get cursor => _prefs.getInt(_cursorKey) ?? 0;
  Future<void> setCursor(int value) => _prefs.setInt(_cursorKey, value);

  DateTime? get lastSyncAt {
    final ms = _prefs.getInt(_lastSyncKey);
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
  }

  Future<void> setLastSyncAt(DateTime at) => _prefs.setInt(_lastSyncKey, at.toUtc().millisecondsSinceEpoch);

  /// Forgets the key and the sync position. Local prayer data is untouched.
  Future<void> clearAccount() async {
    await _secrets.delete(_secretName);
    await _prefs.remove(_cursorKey);
    await _prefs.remove(_lastSyncKey);
    await _prefs.setBool(_enabledKey, false);
  }
}
