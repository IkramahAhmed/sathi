// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oem_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Null on non-Android platforms or when the lookup fails.

@ProviderFor(oemInfo)
final oemInfoProvider = OemInfoProvider._();

/// Null on non-Android platforms or when the lookup fails.

final class OemInfoProvider
    extends
        $FunctionalProvider<AsyncValue<OemInfo?>, OemInfo?, FutureOr<OemInfo?>>
    with $FutureModifier<OemInfo?>, $FutureProvider<OemInfo?> {
  /// Null on non-Android platforms or when the lookup fails.
  OemInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'oemInfoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$oemInfoHash();

  @$internal
  @override
  $FutureProviderElement<OemInfo?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<OemInfo?> create(Ref ref) {
    return oemInfo(ref);
  }
}

String _$oemInfoHash() => r'18f193ab6f884c2ab5761b016aefc3c1046e6127';
