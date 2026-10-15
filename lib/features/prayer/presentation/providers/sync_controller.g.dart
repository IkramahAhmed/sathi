// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Cloud sync settings: on/off, server address and key.

@ProviderFor(SyncSettings)
final syncSettingsProvider = SyncSettingsProvider._();

/// Cloud sync settings: on/off, server address and key.
final class SyncSettingsProvider
    extends $AsyncNotifierProvider<SyncSettings, SyncConfig> {
  /// Cloud sync settings: on/off, server address and key.
  SyncSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncSettingsHash();

  @$internal
  @override
  SyncSettings create() => SyncSettings();
}

String _$syncSettingsHash() => r'140c4cbf9f00efaaf23e7bc4cc59f58bec15a883';

/// Cloud sync settings: on/off, server address and key.

abstract class _$SyncSettings extends $AsyncNotifier<SyncConfig> {
  FutureOr<SyncConfig> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SyncConfig>, SyncConfig>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SyncConfig>, SyncConfig>,
              AsyncValue<SyncConfig>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Runs syncs and exposes how the last one went.

@ProviderFor(SyncStatusController)
final syncStatusControllerProvider = SyncStatusControllerProvider._();

/// Runs syncs and exposes how the last one went.
final class SyncStatusControllerProvider
    extends $NotifierProvider<SyncStatusController, SyncStatus> {
  /// Runs syncs and exposes how the last one went.
  SyncStatusControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncStatusControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncStatusControllerHash();

  @$internal
  @override
  SyncStatusController create() => SyncStatusController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncStatus>(value),
    );
  }
}

String _$syncStatusControllerHash() =>
    r'e51ebf04e46e1446e7dfcb4ffe15ce414bcb31b2';

/// Runs syncs and exposes how the last one went.

abstract class _$SyncStatusController extends $Notifier<SyncStatus> {
  SyncStatus build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SyncStatus, SyncStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncStatus, SyncStatus>,
              SyncStatus,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
