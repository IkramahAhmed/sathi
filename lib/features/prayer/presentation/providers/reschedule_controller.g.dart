// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reschedule_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Runs [ScheduleUpcomingAzans] and exposes the outcome (for the banner).

@ProviderFor(RescheduleController)
final rescheduleControllerProvider = RescheduleControllerProvider._();

/// Runs [ScheduleUpcomingAzans] and exposes the outcome (for the banner).
final class RescheduleControllerProvider
    extends $NotifierProvider<RescheduleController, RescheduleState> {
  /// Runs [ScheduleUpcomingAzans] and exposes the outcome (for the banner).
  RescheduleControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rescheduleControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rescheduleControllerHash();

  @$internal
  @override
  RescheduleController create() => RescheduleController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RescheduleState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RescheduleState>(value),
    );
  }
}

String _$rescheduleControllerHash() =>
    r'ca403180e44175b92e2a717795d65c8021b3adb8';

/// Runs [ScheduleUpcomingAzans] and exposes the outcome (for the banner).

abstract class _$RescheduleController extends $Notifier<RescheduleState> {
  RescheduleState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RescheduleState, RescheduleState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RescheduleState, RescheduleState>,
              RescheduleState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
