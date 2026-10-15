// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracker_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The first day the user has been tracking. Days before it are never counted
/// as missed. Set the first time it is needed.

@ProviderFor(trackingStart)
final trackingStartProvider = TrackingStartProvider._();

/// The first day the user has been tracking. Days before it are never counted
/// as missed. Set the first time it is needed.

final class TrackingStartProvider
    extends
        $FunctionalProvider<AsyncValue<DateTime>, DateTime, FutureOr<DateTime>>
    with $FutureModifier<DateTime>, $FutureProvider<DateTime> {
  /// The first day the user has been tracking. Days before it are never counted
  /// as missed. Set the first time it is needed.
  TrackingStartProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trackingStartProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trackingStartHash();

  @$internal
  @override
  $FutureProviderElement<DateTime> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<DateTime> create(Ref ref) {
    return trackingStart(ref);
  }
}

String _$trackingStartHash() => r'33d0e2e77b25234637e25bd71daeb8e0365693e0';

/// Everything ticked in the tracker window, by date.

@ProviderFor(doneByDate)
final doneByDateProvider = DoneByDateProvider._();

/// Everything ticked in the tracker window, by date.

final class DoneByDateProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, Set<PrayerName>>>,
          Map<String, Set<PrayerName>>,
          Stream<Map<String, Set<PrayerName>>>
        >
    with
        $FutureModifier<Map<String, Set<PrayerName>>>,
        $StreamProvider<Map<String, Set<PrayerName>>> {
  /// Everything ticked in the tracker window, by date.
  DoneByDateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'doneByDateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$doneByDateHash();

  @$internal
  @override
  $StreamProviderElement<Map<String, Set<PrayerName>>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, Set<PrayerName>>> create(Ref ref) {
    return doneByDate(ref);
  }
}

String _$doneByDateHash() => r'736465da0271bcde9805419b2bd94cce9662be1a';

@ProviderFor(pauses)
final pausesProvider = PausesProvider._();

final class PausesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PauseRange>>,
          List<PauseRange>,
          Stream<List<PauseRange>>
        >
    with $FutureModifier<List<PauseRange>>, $StreamProvider<List<PauseRange>> {
  PausesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pausesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pausesHash();

  @$internal
  @override
  $StreamProviderElement<List<PauseRange>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<PauseRange>> create(Ref ref) {
    return pauses(ref);
  }
}

String _$pausesHash() => r'a01f7fc9a89bf93fe92fdecacd4e709f6b4c9231';

@ProviderFor(streakSummary)
final streakSummaryProvider = StreakSummaryProvider._();

final class StreakSummaryProvider
    extends $FunctionalProvider<StreakSummary, StreakSummary, StreakSummary>
    with $Provider<StreakSummary> {
  StreakSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'streakSummaryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$streakSummaryHash();

  @$internal
  @override
  $ProviderElement<StreakSummary> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StreakSummary create(Ref ref) {
    return streakSummary(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StreakSummary value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StreakSummary>(value),
    );
  }
}

String _$streakSummaryHash() => r'd4740fa52f856233bb9de6bb82399b1b7a979f25';

/// Owed qaza prayers per prayer.

@ProviderFor(qazaOwed)
final qazaOwedProvider = QazaOwedProvider._();

/// Owed qaza prayers per prayer.

final class QazaOwedProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<PrayerName, int>>,
          Map<PrayerName, int>,
          Stream<Map<PrayerName, int>>
        >
    with
        $FutureModifier<Map<PrayerName, int>>,
        $StreamProvider<Map<PrayerName, int>> {
  /// Owed qaza prayers per prayer.
  QazaOwedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'qazaOwedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$qazaOwedHash();

  @$internal
  @override
  $StreamProviderElement<Map<PrayerName, int>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<PrayerName, int>> create(Ref ref) {
    return qazaOwed(ref);
  }
}

String _$qazaOwedHash() => r'1c15a1a08640a09ce8da8f04021a7962ae1865b0';

@ProviderFor(qazaTotal)
final qazaTotalProvider = QazaTotalProvider._();

final class QazaTotalProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  QazaTotalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'qazaTotalProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$qazaTotalHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return qazaTotal(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$qazaTotalHash() => r'7b6efddbff9eaa5cad06402ed48181ddfec0c330';

/// The one place that ticks and un-ticks prayers, so every screen behaves the same.

@ProviderFor(prayerActions)
final prayerActionsProvider = PrayerActionsProvider._();

/// The one place that ticks and un-ticks prayers, so every screen behaves the same.

final class PrayerActionsProvider
    extends $FunctionalProvider<PrayerActions, PrayerActions, PrayerActions>
    with $Provider<PrayerActions> {
  /// The one place that ticks and un-ticks prayers, so every screen behaves the same.
  PrayerActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'prayerActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$prayerActionsHash();

  @$internal
  @override
  $ProviderElement<PrayerActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PrayerActions create(Ref ref) {
    return prayerActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrayerActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrayerActions>(value),
    );
  }
}

String _$prayerActionsHash() => r'998eea666b3d64dc1cf05359c0884f03096d20f3';
