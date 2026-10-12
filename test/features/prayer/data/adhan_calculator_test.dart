import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/features/prayer/data/datasources/adhan_calculator.dart';
import 'package:saathi/features/prayer/domain/entities/calc_method.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_name.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_settings.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Snapshot tests. Expected values come from the public AlAdhan API
/// (api.aladhan.com), fetched on 2026-10-12 with matching method/school.
void main() {
  setUpAll(tzdata.initializeTimeZones);

  const calculator = AdhanCalculator();

  /// Formats [instant] as HH:mm at [zone].
  String hm(DateTime instant, String zone) {
    final t = tz.TZDateTime.from(instant, tz.getLocation(zone));
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  int minutes(String hhmm) {
    final parts = hhmm.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  void expectWithinOneMinute(
    Map<PrayerName, DateTime> actual,
    Map<PrayerName, String> expected,
    String zone,
  ) {
    for (final entry in expected.entries) {
      final got = minutes(hm(actual[entry.key]!, zone));
      final want = minutes(entry.value);
      // Compare on a 24h circle so 23:59 vs 00:00 counts as one minute apart.
      final diff = (got - want).abs();
      final circular = diff > 720 ? 1440 - diff : diff;
      expect(circular, lessThanOrEqualTo(1),
          reason: '${entry.key.name}: got ${hm(actual[entry.key]!, zone)}, want ${entry.value}');
    }
  }

  PrayerSettings settings({
    required double lat,
    required double lng,
    required String zone,
    required CalcMethod method,
    required Madhab madhab,
    HighLatitudeRule highLat = HighLatitudeRule.middleOfTheNight,
  }) =>
      PrayerSettings.defaults().copyWith(
        lat: lat,
        lng: lng,
        timezoneId: zone,
        method: method,
        madhab: madhab,
        highLat: highLat,
      );

  test('Karachi 2026-10-12, Karachi method, Hanafi matches AlAdhan', () {
    final day = calculator.compute(
      DateTime(2026, 10, 12),
      settings(
        lat: 24.8607,
        lng: 67.0011,
        zone: 'Asia/Karachi',
        method: CalcMethod.karachi,
        madhab: Madhab.hanafi,
      ),
    );
    expectWithinOneMinute(
      day.times,
      {
        PrayerName.fajr: '05:13',
        PrayerName.sunrise: '06:29',
        PrayerName.dhuhr: '12:19',
        PrayerName.asr: '16:30',
        PrayerName.maghrib: '18:08',
        PrayerName.isha: '19:24',
      },
      'Asia/Karachi',
    );
  });

  test('Makkah 2026-10-12, Umm al-Qura matches AlAdhan', () {
    final day = calculator.compute(
      DateTime(2026, 10, 12),
      settings(
        lat: 21.4225,
        lng: 39.8262,
        zone: 'Asia/Riyadh',
        method: CalcMethod.ummAlQura,
        madhab: Madhab.shafi,
      ),
    );
    expectWithinOneMinute(
      day.times,
      {
        PrayerName.fajr: '04:59',
        PrayerName.sunrise: '06:15',
        PrayerName.dhuhr: '12:07',
        PrayerName.asr: '15:29',
        PrayerName.maghrib: '17:59',
        PrayerName.isha: '19:29',
      },
      'Asia/Riyadh',
    );
  });

  test('London 2026-06-21 (high latitude, twilight angle) matches AlAdhan', () {
    final day = calculator.compute(
      DateTime(2026, 6, 21),
      settings(
        lat: 51.5074,
        lng: -0.1278,
        zone: 'Europe/London',
        method: CalcMethod.muslimWorldLeague,
        madhab: Madhab.shafi,
        highLat: HighLatitudeRule.twilightAngle,
      ),
    );
    expectWithinOneMinute(
      day.times,
      {
        PrayerName.fajr: '02:31',
        PrayerName.sunrise: '04:43',
        PrayerName.dhuhr: '13:02',
        PrayerName.asr: '17:25',
        PrayerName.maghrib: '21:22',
        PrayerName.isha: '23:27',
      },
      'Europe/London',
    );
  });

  test('per-prayer adjustment shifts only that prayer by the given minutes', () {
    final base = settings(
      lat: 24.8607,
      lng: 67.0011,
      zone: 'Asia/Karachi',
      method: CalcMethod.karachi,
      madhab: Madhab.hanafi,
    );
    final plain = calculator.compute(DateTime(2026, 10, 12), base);
    final shifted = calculator.compute(
      DateTime(2026, 10, 12),
      base.copyWith(adjustmentsMin: {
        for (final p in PrayerName.values) p: p == PrayerName.asr ? 5 : 0,
      }),
    );
    expect(shifted.times[PrayerName.asr]!.difference(plain.times[PrayerName.asr]!),
        const Duration(minutes: 5));
    expect(shifted.times[PrayerName.fajr], plain.times[PrayerName.fajr]);
    expect(shifted.times[PrayerName.isha], plain.times[PrayerName.isha]);
  });

  test('Qibla bearing from Karachi is roughly west-north-west', () {
    final bearing = calculator.qiblaBearing(24.8607, 67.0011);
    expect(bearing, inInclusiveRange(260, 275));
  });
}
