// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permissions_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PermissionsController)
final permissionsControllerProvider = PermissionsControllerProvider._();

final class PermissionsControllerProvider
    extends $NotifierProvider<PermissionsController, PermissionsState> {
  PermissionsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'permissionsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$permissionsControllerHash();

  @$internal
  @override
  PermissionsController create() => PermissionsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PermissionsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PermissionsState>(value),
    );
  }
}

String _$permissionsControllerHash() =>
    r'b497715b7bad6f69a64f180d45162020b725a40c';

abstract class _$PermissionsController extends $Notifier<PermissionsState> {
  PermissionsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PermissionsState, PermissionsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PermissionsState, PermissionsState>,
              PermissionsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
