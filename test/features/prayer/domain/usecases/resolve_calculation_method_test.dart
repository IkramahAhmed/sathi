import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/features/prayer/domain/entities/calc_method.dart';
import 'package:saathi/features/prayer/domain/usecases/apply_location.dart';
import 'package:saathi/features/prayer/domain/usecases/resolve_calculation_method_for_country.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_settings.dart';

void main() {
  const resolve = ResolveCalculationMethodForCountry();

  const expectations = <String, (CalcMethod, Madhab)>{
    'PK': (CalcMethod.karachi, Madhab.hanafi),
    'IN': (CalcMethod.karachi, Madhab.hanafi),
    'BD': (CalcMethod.karachi, Madhab.hanafi),
    'AF': (CalcMethod.karachi, Madhab.hanafi),
    'SA': (CalcMethod.ummAlQura, Madhab.shafi),
    'YE': (CalcMethod.ummAlQura, Madhab.shafi),
    'AE': (CalcMethod.dubai, Madhab.shafi),
    'QA': (CalcMethod.qatar, Madhab.shafi),
    'KW': (CalcMethod.kuwait, Madhab.shafi),
    'EG': (CalcMethod.egyptian, Madhab.shafi),
    'SD': (CalcMethod.egyptian, Madhab.shafi),
    'LY': (CalcMethod.egyptian, Madhab.shafi),
    'TR': (CalcMethod.turkiye, Madhab.hanafi),
    'SG': (CalcMethod.singapore, Madhab.shafi),
    'MY': (CalcMethod.singapore, Madhab.shafi),
    'ID': (CalcMethod.indonesian, Madhab.shafi),
    'US': (CalcMethod.northAmerica, Madhab.shafi),
    'CA': (CalcMethod.northAmerica, Madhab.shafi),
    'GB': (CalcMethod.muslimWorldLeague, Madhab.shafi),
    'FR': (CalcMethod.muslimWorldLeague, Madhab.shafi),
    'DE': (CalcMethod.muslimWorldLeague, Madhab.shafi),
    'NL': (CalcMethod.muslimWorldLeague, Madhab.shafi),
    'JP': (CalcMethod.muslimWorldLeague, Madhab.shafi),
  };

  for (final entry in expectations.entries) {
    test('${entry.key} -> ${entry.value.$1.name} / ${entry.value.$2.name}', () {
      final result = resolve(entry.key);
      expect(result.method, entry.value.$1);
      expect(result.madhab, entry.value.$2);
    });
  }

  test('is case-insensitive and trims', () {
    expect(resolve(' pk ').method, CalcMethod.karachi);
  });

  test('unknown or empty country falls back to Muslim World League / Shafi', () {
    expect(resolve('').method, CalcMethod.muslimWorldLeague);
    expect(resolve('ZZ').madhab, Madhab.shafi);
  });

  group('applyLocation', () {
    test('moving to the US switches to ISNA/Shafi when not overridden', () {
      final moved = applyLocation(
        PrayerSettings.defaults(),
        lat: 40.7,
        lng: -74.0,
        countryCode: 'us',
        cityName: 'New York',
      );
      expect(moved.method, CalcMethod.northAmerica);
      expect(moved.madhab, Madhab.shafi);
      expect(moved.countryCode, 'US');
      expect(moved.cityName, 'New York');
    });

    test('a manual override wins over the auto default', () {
      final manual = PrayerSettings.defaults().copyWith(
        method: CalcMethod.egyptian,
        methodIsManual: true,
        madhab: Madhab.hanafi,
        madhabIsManual: true,
      );
      final moved = applyLocation(
        manual,
        lat: 40.7,
        lng: -74.0,
        countryCode: 'US',
        cityName: 'New York',
      );
      expect(moved.method, CalcMethod.egyptian);
      expect(moved.madhab, Madhab.hanafi);
    });
  });
}
