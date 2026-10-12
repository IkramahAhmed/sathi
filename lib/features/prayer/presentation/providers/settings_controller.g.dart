// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the persisted [PrayerSettings]. Every change is saved and then the
/// azan notifications are re-scheduled.

@ProviderFor(SettingsController)
final settingsControllerProvider = SettingsControllerProvider._();

/// Owns the persisted [PrayerSettings]. Every change is saved and then the
/// azan notifications are re-scheduled.
final class SettingsControllerProvider
    extends $AsyncNotifierProvider<SettingsController, PrayerSettings> {
  /// Owns the persisted [PrayerSettings]. Every change is saved and then the
  /// azan notifications are re-scheduled.
  SettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsControllerHash();

  @$internal
  @override
  SettingsController create() => SettingsController();
}

String _$settingsControllerHash() =>
    r'2f6604f4c232fc8d37ed3f2b4b760f94f151d738';

/// Owns the persisted [PrayerSettings]. Every change is saved and then the
/// azan notifications are re-scheduled.

abstract class _$SettingsController extends $AsyncNotifier<PrayerSettings> {
  FutureOr<PrayerSettings> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PrayerSettings>, PrayerSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PrayerSettings>, PrayerSettings>,
              AsyncValue<PrayerSettings>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
