import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers.dart';
import '../../../../core/sync/cloud_api.dart';
import '../../../../core/sync/sync_config.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/utils/result.dart';

part 'sync_controller.g.dart';

/// Why a sync could not finish. Shown to the user in plain words.
enum SyncProblem { notConfigured, offline, serverError, keyRejected, other }

/// A value the user typed that was not acceptable.
enum SyncInputError { invalidAddress, invalidKey }

/// Cloud sync settings: on/off, server address and key.
@Riverpod(keepAlive: true)
class SyncSettings extends _$SyncSettings {
  @override
  Future<SyncConfig> build() => ref.watch(syncConfigStoreProvider).load();

  SyncConfigStore get _store => ref.read(syncConfigStoreProvider);

  Future<void> _reload() async => state = AsyncData(await _store.load());

  /// Turns sync on. The key is created the first time.
  Future<void> enable() async {
    final config = await _store.load();
    if (config.key == null) await _store.setKey(generateSyncKey());
    await _store.setEnabled(true);
    await _reload();
    unawaited(ref.read(syncStatusControllerProvider.notifier).syncNow());
  }

  /// Turns sync off. The key is kept so it can be turned on again.
  Future<void> disable() async {
    await _store.setEnabled(false);
    await _reload();
  }

  Future<SyncInputError?> setServerAddress(String input) async {
    final uri = parseServerUrl(input);
    if (uri == null) return SyncInputError.invalidAddress;
    await _store.setBaseUrl(uri.toString());
    await _reload();
    unawaited(ref.read(syncStatusControllerProvider.notifier).syncNow());
    return null;
  }

  /// Uses the key from another phone. This phone's history is queued so it
  /// merges into that account, and the saved position starts again.
  Future<SyncInputError?> useExistingKey(String input) async {
    final key = input.trim();
    if (!isValidSyncKey(key)) return SyncInputError.invalidKey;
    final current = await _store.load();
    if (current.key != key) {
      await _store.setKey(key);
      await _store.setCursor(0);
      await ref.read(appDatabaseProvider).prayerLogsDao.markAllDirty();
    }
    await _store.setEnabled(true);
    await _reload();
    unawaited(ref.read(syncStatusControllerProvider.notifier).syncNow());
    return null;
  }

  /// Erases the cloud copy, then forgets the key. The log on this phone stays.
  Future<Result<void>> deleteCloudData() async {
    final config = await _store.load();
    final uri = config.uri;
    final key = config.key;
    if (uri != null && key != null) {
      final result = await guard(() => ref.read(cloudApiProvider).deleteAccount(baseUrl: uri, key: key));
      if (!result.isSuccess) return result;
    }
    await _store.clearAccount();
    await _reload();
    await ref.read(syncStatusControllerProvider.notifier).reset();
    return const Result.success(null);
  }
}

class SyncStatus {
  const SyncStatus({this.running = false, this.lastSyncAt, this.problem, this.pending = 0});

  final bool running;
  final DateTime? lastSyncAt;
  final SyncProblem? problem;

  /// Local changes waiting to upload.
  final int pending;

  SyncStatus copyWith({bool? running, DateTime? lastSyncAt, SyncProblem? problem, bool clearProblem = false, int? pending}) =>
      SyncStatus(
        running: running ?? this.running,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
        problem: clearProblem ? null : (problem ?? this.problem),
        pending: pending ?? this.pending,
      );
}

/// Runs syncs and exposes how the last one went.
@Riverpod(keepAlive: true)
class SyncStatusController extends _$SyncStatusController {
  Timer? _debounce;

  /// A tick is uploaded this long after the last one, so a burst of ticks
  /// becomes a single request.
  static const Duration debounce = Duration(seconds: 3);

  @override
  SyncStatus build() {
    ref.onDispose(() => _debounce?.cancel());
    final store = ref.watch(syncConfigStoreProvider);
    unawaited(refreshPending());
    return SyncStatus(lastSyncAt: store.lastSyncAt);
  }

  Future<void> refreshPending() async {
    final pending = await ref.read(prayerSyncServiceProvider).pendingCount();
    state = state.copyWith(pending: pending);
  }

  /// Syncs now. Does nothing when cloud backup is off.
  Future<void> syncNow() async {
    _debounce?.cancel();
    final config = await ref.read(syncConfigStoreProvider).load();
    if (!config.enabled) return;
    if (state.running) return;

    if (!config.isConfigured) {
      state = state.copyWith(problem: SyncProblem.notConfigured);
      return;
    }
    state = state.copyWith(running: true, clearProblem: true);
    final service = ref.read(prayerSyncServiceProvider);
    final result = await service.syncNow();
    final pending = await service.pendingCount();
    state = result.when(
      success: (report) => SyncStatus(lastSyncAt: report.at, pending: pending),
      failure: (failure) {
        appLog.info('Sync problem: ${failure.message}');
        return SyncStatus(lastSyncAt: state.lastSyncAt, problem: _problemFor(failure.cause), pending: pending);
      },
    );
  }

  /// Asks for a sync shortly. Used after the user ticks a prayer.
  void scheduleSoon() {
    final enabled = ref.read(syncSettingsProvider).value?.enabled ?? false;
    if (!enabled) {
      unawaited(refreshPending());
      return;
    }
    _debounce?.cancel();
    _debounce = Timer(debounce, () => unawaited(syncNow()));
    unawaited(refreshPending());
  }

  Future<void> reset() async {
    _debounce?.cancel();
    state = SyncStatus(pending: await ref.read(prayerSyncServiceProvider).pendingCount());
  }

  static SyncProblem _problemFor(Object? cause) {
    if (cause is CloudApiException) {
      return switch (cause.kind) {
        CloudErrorKind.network => SyncProblem.offline,
        CloudErrorKind.server => SyncProblem.serverError,
        CloudErrorKind.unauthorized => SyncProblem.keyRejected,
        CloudErrorKind.rejected => SyncProblem.other,
      };
    }
    return SyncProblem.other;
  }
}
