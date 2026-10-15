import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers.dart';
import '../../../../core/location/cities.dart';
import '../../../../core/location/location_service.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/calc_method.dart';
import '../../domain/entities/prayer_name.dart';
import '../../domain/entities/prayer_settings.dart';
import '../../domain/usecases/apply_location.dart';
import '../../domain/usecases/resolve_calculation_method_for_country.dart';
import 'reschedule_controller.dart';

part 'settings_controller.g.dart';

/// Owns the persisted [PrayerSettings]. Every change is saved and then the
/// azan notifications are re-scheduled.
@Riverpod(keepAlive: true)
class SettingsController extends _$SettingsController {
  @override
  Future<PrayerSettings> build() => ref.watch(settingsRepositoryProvider).load();

  PrayerSettings get _current => state.value ?? PrayerSettings.defaults();

  Future<void> _apply(PrayerSettings next, {bool reschedule = true}) async {
    state = AsyncData(next);
    await ref.read(settingsRepositoryProvider).save(next);
    if (reschedule) {
      await ref.read(rescheduleControllerProvider.notifier).reschedule();
    }
  }

  /// Applies [edit] to the current settings, saves and re-schedules.
  Future<void> change(PrayerSettings Function(PrayerSettings current) edit) =>
      _apply(edit(_current));

  Future<void> setMethod(CalcMethod method) =>
      change((s) => s.copyWith(method: method, methodIsManual: true));

  Future<void> setMadhab(Madhab madhab) =>
      change((s) => s.copyWith(madhab: madhab, madhabIsManual: true));

  /// Goes back to the country default for method and madhab.
  Future<void> resetToCountryDefaults() => change((s) {
        final defaults = const ResolveCalculationMethodForCountry()(s.countryCode);
        return s.copyWith(
          method: defaults.method,
          madhab: defaults.madhab,
          methodIsManual: false,
          madhabIsManual: false,
        );
      });

  Future<void> setAzanEnabled(PrayerName prayer, {required bool enabled}) =>
      change((s) => s.copyWith(azanEnabled: {...s.azanEnabled, prayer: enabled}));

  Future<void> setAdjustment(PrayerName prayer, int minutes) =>
      change((s) => s.copyWith(adjustmentsMin: {...s.adjustmentsMin, prayer: minutes.clamp(-30, 30)}));

  Future<void> setPreReminder(PrayerName prayer, int minutes) =>
      change((s) => s.copyWith(preReminderMin: {...s.preReminderMin, prayer: minutes}));

  Future<void> setSound(AzanSound sound) => change((s) => s.copyWith(sound: sound));

  Future<void> setHijriAdjust(int days) =>
      change((s) => s.copyWith(hijriAdjustDays: days.clamp(-1, 1)));

  Future<void> setLocale(String tag) => change((s) => s.copyWith(localeTag: tag));

  Future<void> setFollowMe({required bool follow}) =>
      change((s) => s.copyWith(followMeLocation: follow));

  /// Sets a jama'at rule for [prayer]. Pass [offsetMin] (minutes after the
  /// azan) or [fixedMinuteOfDay] (for example 13:30 is 810), or neither to clear it.
  Future<void> setJamaat(PrayerName prayer, {int? offsetMin, int? fixedMinuteOfDay}) => change((s) {
        final offsets = {...s.jamaat.offsetMin}..remove(prayer);
        final fixed = {...s.jamaat.fixedMin}..remove(prayer);
        if (fixedMinuteOfDay != null) {
          fixed[prayer] = fixedMinuteOfDay.clamp(0, 1439);
        } else if (offsetMin != null && offsetMin > 0) {
          offsets[prayer] = offsetMin.clamp(1, 120);
        }
        return s.copyWith(jamaat: s.jamaat.copyWith(offsetMin: offsets, fixedMin: fixed));
      });

  /// Sets or clears (null) the Friday jama'at time.
  Future<void> setJummaTime(int? minuteOfDay) => change((s) => s.copyWith(
        jamaat: minuteOfDay == null
            ? s.jamaat.copyWith(clearJumma: true)
            : s.jamaat.copyWith(jummaFixedMin: minuteOfDay.clamp(0, 1439)),
      ));

  Future<void> setLeaveReminder(int minutes) =>
      change((s) => s.copyWith(jamaat: s.jamaat.copyWith(leaveReminderMin: minutes.clamp(0, 120))));

  Future<void> setHighLat(HighLatitudeRule rule) => change((s) => s.copyWith(highLat: rule));

  /// Moves to a manually chosen [city]; turns off "follow me".
  Future<void> pickCity(City city) => change(
        (s) => applyLocation(
          s,
          lat: city.lat,
          lng: city.lng,
          countryCode: city.countryCode,
          cityName: city.name,
          timezoneId: city.timezoneId,
        ).copyWith(followMeLocation: false),
      );

  /// Reads the device location and applies it. Returns the failure, if any.
  Future<Result<LocationFix>> useCurrentLocation() async {
    final service = ref.read(locationServiceProvider);
    var access = await service.access();
    if (access != LocationAccess.granted) access = await service.requestAccess();
    if (access != LocationAccess.granted) {
      return Result.failure(AppFailure('Location permission is needed ($access)'));
    }
    final result = await service.currentFix(fallbackCountryCode: _current.countryCode);
    if (result case Success(:final value)) {
      await change(
        (s) => applyLocation(
          s,
          lat: value.lat,
          lng: value.lng,
          countryCode: value.countryCode,
          cityName: value.cityName,
          timezoneId: value.timezoneId,
        ).copyWith(followMeLocation: true),
      );
    }
    return result;
  }

  DateTime? _lastFollowCheck;
  bool _followRunning = false;

  /// Minimum gap between follow-me checks, so returning to the app after a
  /// system dialog can never turn into a loop of location requests.
  static const Duration followCheckInterval = Duration(minutes: 10);

  /// When "follow me" is on and the device moved more than 50 km, recompute.
  ///
  /// Runs silently: it reads only the last known position, never prompts, is
  /// skipped during onboarding and is throttled.
  Future<void> followIfMoved() async {
    final settings = _current;
    if (!settings.followMeLocation || _followRunning) return;
    final now = ref.read(clockProvider)();
    final last = _lastFollowCheck;
    if (last != null && now.difference(last) < followCheckInterval) return;
    if (!await ref.read(settingsRepositoryProvider).isOnboardingDone()) return;

    _followRunning = true;
    _lastFollowCheck = now;
    try {
      await _followIfMoved(settings);
    } finally {
      _followRunning = false;
    }
  }

  Future<void> _followIfMoved(PrayerSettings settings) async {
    final service = ref.read(locationServiceProvider);
    if (await service.access() != LocationAccess.granted) return;
    final result = await service.currentFix(
      fallbackCountryCode: settings.countryCode,
      interactive: false,
    );
    final fix = result.valueOrNull;
    if (fix == null) return;
    final km = service.distanceKm(settings.lat, settings.lng, fix.lat, fix.lng);
    if (km > 50) {
      appLog.info('Moved ${km.round()} km; recomputing for ${fix.cityName}');
      await change(
        (s) => applyLocation(
          s,
          lat: fix.lat,
          lng: fix.lng,
          countryCode: fix.countryCode,
          cityName: fix.cityName,
          timezoneId: fix.timezoneId,
        ),
      );
    }
  }
}
