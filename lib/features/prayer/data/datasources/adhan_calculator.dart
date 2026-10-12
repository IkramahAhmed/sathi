import 'package:adhan_dart/adhan_dart.dart' as adhan;

import '../../domain/entities/calc_method.dart';
import '../../domain/entities/prayer_name.dart';
import '../../domain/entities/prayer_settings.dart';
import '../../domain/entities/prayer_times_day.dart';
import '../../domain/repositories/prayer_repository.dart';

/// Wraps `adhan_dart`. Fully offline and deterministic.
class AdhanCalculator implements PrayerTimesProvider {
  const AdhanCalculator();

  @override
  PrayerTimesDay timesFor(DateTime date, PrayerSettings settings) => compute(date, settings);

  /// Computes the times for the calendar [date] at the settings' location.
  ///
  /// `adhan_dart` returns UTC instants, which are kept as-is; the per-prayer
  /// "masjid time" adjustment is applied by the library before rounding.
  PrayerTimesDay compute(DateTime date, PrayerSettings settings) {
    final params = _parameters(settings);
    final times = adhan.PrayerTimes(
      date: DateTime(date.year, date.month, date.day),
      coordinates: adhan.Coordinates(settings.lat, settings.lng),
      calculationParameters: params,
    );
    return PrayerTimesDay(
      date: DateTime(date.year, date.month, date.day),
      times: {
        PrayerName.fajr: times.fajr.toUtc(),
        PrayerName.sunrise: times.sunrise.toUtc(),
        PrayerName.dhuhr: times.dhuhr.toUtc(),
        PrayerName.asr: times.asr.toUtc(),
        PrayerName.maghrib: times.maghrib.toUtc(),
        PrayerName.isha: times.isha.toUtc(),
      },
    );
  }

  /// Bearing to the Kaaba in degrees clockwise from true north.
  double qiblaBearing(double lat, double lng) =>
      adhan.Qibla.qibla(adhan.Coordinates(lat, lng));

  adhan.CalculationParameters _parameters(PrayerSettings s) {
    final params = switch (s.method) {
      CalcMethod.karachi => adhan.CalculationMethodParameters.karachi(),
      CalcMethod.muslimWorldLeague => adhan.CalculationMethodParameters.muslimWorldLeague(),
      CalcMethod.ummAlQura => adhan.CalculationMethodParameters.ummAlQura(),
      CalcMethod.dubai => adhan.CalculationMethodParameters.dubai(),
      CalcMethod.qatar => adhan.CalculationMethodParameters.qatar(),
      CalcMethod.kuwait => adhan.CalculationMethodParameters.kuwait(),
      CalcMethod.egyptian => adhan.CalculationMethodParameters.egyptian(),
      CalcMethod.turkiye => adhan.CalculationMethodParameters.turkiye(),
      CalcMethod.singapore => adhan.CalculationMethodParameters.singapore(),
      CalcMethod.indonesian => adhan.CalculationMethodParameters.indonesian(),
      CalcMethod.northAmerica => adhan.CalculationMethodParameters.northAmerica(),
      CalcMethod.moonsightingCommittee => adhan.CalculationMethodParameters.moonsightingCommittee(),
    };
    params.madhab = switch (s.madhab) {
      Madhab.hanafi => adhan.Madhab.hanafi,
      Madhab.shafi => adhan.Madhab.shafi,
    };
    params.highLatitudeRule = switch (s.highLat) {
      HighLatitudeRule.middleOfTheNight => adhan.HighLatitudeRule.middleOfTheNight,
      HighLatitudeRule.seventhOfTheNight => adhan.HighLatitudeRule.seventhOfTheNight,
      HighLatitudeRule.twilightAngle => adhan.HighLatitudeRule.twilightAngle,
    };
    params.adjustments = {
      adhan.Prayer.fajr: s.adjustmentFor(PrayerName.fajr),
      adhan.Prayer.sunrise: s.adjustmentFor(PrayerName.sunrise),
      adhan.Prayer.dhuhr: s.adjustmentFor(PrayerName.dhuhr),
      adhan.Prayer.asr: s.adjustmentFor(PrayerName.asr),
      adhan.Prayer.maghrib: s.adjustmentFor(PrayerName.maghrib),
      adhan.Prayer.isha: s.adjustmentFor(PrayerName.isha),
    };
    return params;
  }
}
