import '../entities/prayer_settings.dart';
import 'resolve_calculation_method_for_country.dart';

/// Returns [settings] moved to a new location. Method and madhab follow the
/// country defaults unless the user has overridden them manually.
PrayerSettings applyLocation(
  PrayerSettings settings, {
  required double lat,
  required double lng,
  required String countryCode,
  required String cityName,
  String? timezoneId,
  ResolveCalculationMethodForCountry resolver = const ResolveCalculationMethodForCountry(),
}) {
  final defaults = resolver(countryCode);
  return settings.copyWith(
    lat: lat,
    lng: lng,
    countryCode: countryCode.toUpperCase(),
    cityName: cityName,
    timezoneId: timezoneId ?? settings.timezoneId,
    method: settings.methodIsManual ? settings.method : defaults.method,
    madhab: settings.madhabIsManual ? settings.madhab : defaults.madhab,
  );
}
