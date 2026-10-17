// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qibla_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(compassSource)
final compassSourceProvider = CompassSourceProvider._();

final class CompassSourceProvider
    extends $FunctionalProvider<CompassSource, CompassSource, CompassSource>
    with $Provider<CompassSource> {
  CompassSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'compassSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$compassSourceHash();

  @$internal
  @override
  $ProviderElement<CompassSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CompassSource create(Ref ref) {
    return compassSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CompassSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CompassSource>(value),
    );
  }
}

String _$compassSourceHash() => r'30098cffe7433330bb6395e887032886ff39cf6c';

/// Magnetic declination at the saved location, so the compass can be turned into a
/// true-north heading. Zero when the phone cannot tell (then the error is only the
/// local declination).

@ProviderFor(magneticDeclination)
final magneticDeclinationProvider = MagneticDeclinationProvider._();

/// Magnetic declination at the saved location, so the compass can be turned into a
/// true-north heading. Zero when the phone cannot tell (then the error is only the
/// local declination).

final class MagneticDeclinationProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  /// Magnetic declination at the saved location, so the compass can be turned into a
  /// true-north heading. Zero when the phone cannot tell (then the error is only the
  /// local declination).
  MagneticDeclinationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'magneticDeclinationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$magneticDeclinationHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return magneticDeclination(ref);
  }
}

String _$magneticDeclinationHash() =>
    r'3b7d8d815e224eb1d0aef8c459309fa206d1831b';

/// Kilometres from the saved location to the Kaaba.

@ProviderFor(kaabaDistanceKm)
final kaabaDistanceKmProvider = KaabaDistanceKmProvider._();

/// Kilometres from the saved location to the Kaaba.

final class KaabaDistanceKmProvider
    extends $FunctionalProvider<double, double, double>
    with $Provider<double> {
  /// Kilometres from the saved location to the Kaaba.
  KaabaDistanceKmProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'kaabaDistanceKmProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$kaabaDistanceKmHash();

  @$internal
  @override
  $ProviderElement<double> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  double create(Ref ref) {
    return kaabaDistanceKm(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$kaabaDistanceKmHash() => r'fb6fdf9d20318bb82a458af281ec5617cfd7fa6d';
