import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/features/prayer/data/datasources/adhan_calculator.dart';
import 'package:saathi/features/prayer/domain/entities/jamaat.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_name.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_settings.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

void main() {
  setUpAll(tzdata.initializeTimeZones);

  const calculator = AdhanCalculator();
  final settings = PrayerSettings.defaults(); // Karachi, UTC+5
  // 2026-10-15 is a Thursday; 2026-10-16 is a Friday.
  final thursday = calculator.compute(DateTime(2026, 10, 15), settings);
  final friday = calculator.compute(DateTime(2026, 10, 16), settings);

  DateTime? at(PrayerName p, JamaatSettings j, {bool fri = false}) => jamaatTime(
        prayer: p,
        day: fri ? friday : thursday,
        settings: j,
        timezoneId: 'Asia/Karachi',
      );

  test('nothing is set by default', () {
    const j = JamaatSettings();
    expect(j.isConfigured, isFalse);
    for (final p in PrayerName.obligatory) {
      expect(at(p, j), isNull);
      expect(j.hasRuleFor(p), isFalse);
    }
  });

  test('an offset adds minutes to the azan', () {
    const j = JamaatSettings(offsetMin: {PrayerName.asr: 10});
    expect(at(PrayerName.asr, j), thursday.times[PrayerName.asr]!.add(const Duration(minutes: 10)));
    expect(at(PrayerName.fajr, j), isNull, reason: 'only Asr is set');
    expect(j.isConfigured, isTrue);
  });

  test('an offset of zero or less means not set', () {
    const j = JamaatSettings(offsetMin: {PrayerName.asr: 0, PrayerName.isha: -5});
    expect(at(PrayerName.asr, j), isNull);
    expect(at(PrayerName.isha, j), isNull);
    expect(j.isConfigured, isFalse);
  });

  test('a fixed clock time is read in the location\'s timezone', () {
    // 13:30 in Karachi (UTC+5) is 08:30 UTC.
    const j = JamaatSettings(fixedMin: {PrayerName.dhuhr: 13 * 60 + 30});
    expect(at(PrayerName.dhuhr, j), DateTime.utc(2026, 10, 15, 8, 30));
  });

  test('a fixed time wins over an offset', () {
    const j = JamaatSettings(
      offsetMin: {PrayerName.asr: 10},
      fixedMin: {PrayerName.asr: 16 * 60},
    );
    expect(at(PrayerName.asr, j), DateTime.utc(2026, 10, 15, 11, 0));
  });

  test('Friday uses the Jumma time for Dhuhr, other days do not', () {
    const j = JamaatSettings(
      fixedMin: {PrayerName.dhuhr: 13 * 60},
      jummaFixedMin: 13 * 60 + 45,
    );
    expect(at(PrayerName.dhuhr, j, fri: true), DateTime.utc(2026, 10, 16, 8, 45));
    expect(at(PrayerName.dhuhr, j), DateTime.utc(2026, 10, 15, 8, 0), reason: 'Thursday uses the normal rule');
    expect(at(PrayerName.asr, j, fri: true), isNull, reason: 'Jumma only affects Dhuhr');
  });

  test('a Jumma time alone is enough on Fridays and counts as configured', () {
    const j = JamaatSettings(jummaFixedMin: 13 * 60 + 30);
    expect(j.isConfigured, isTrue);
    expect(at(PrayerName.dhuhr, j, fri: true), isNotNull);
    expect(at(PrayerName.dhuhr, j), isNull, reason: 'no ordinary Dhuhr rule');
  });

  test('daylight saving: a fixed time follows the local clock in London', () {
    final london = settings.copyWith(lat: 51.5, lng: -0.12, timezoneId: 'Europe/London');
    final summer = calculator.compute(DateTime(2026, 7, 1), london);
    final winter = calculator.compute(DateTime(2026, 12, 1), london);
    const j = JamaatSettings(fixedMin: {PrayerName.dhuhr: 13 * 60});
    final s = jamaatTime(prayer: PrayerName.dhuhr, day: summer, settings: j, timezoneId: 'Europe/London')!;
    final w = jamaatTime(prayer: PrayerName.dhuhr, day: winter, settings: j, timezoneId: 'Europe/London')!;
    // 13:00 BST is 12:00 UTC; 13:00 GMT is 13:00 UTC.
    expect(s, DateTime.utc(2026, 7, 1, 12));
    expect(w, DateTime.utc(2026, 12, 1, 13));
    expect(tz.TZDateTime.from(s, tz.getLocation('Europe/London')).hour, 13);
  });

  test('sunrise never has a jama\'at', () {
    const j = JamaatSettings(offsetMin: {PrayerName.sunrise: 10});
    expect(at(PrayerName.sunrise, j), isNull);
  });

  test('copyWith can clear the Jumma time', () {
    const j = JamaatSettings(jummaFixedMin: 800);
    expect(j.copyWith(clearJumma: true).jummaFixedMin, isNull);
    expect(j.copyWith(leaveReminderMin: 10).jummaFixedMin, 800);
  });
}
