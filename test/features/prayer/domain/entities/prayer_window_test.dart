import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/features/prayer/data/datasources/adhan_calculator.dart';
import 'package:saathi/features/prayer/domain/entities/calc_method.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_name.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_settings.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_times_day.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_window.dart';

PrayerTimesDay _day(DateTime date, Map<PrayerName, DateTime> times) => PrayerTimesDay(date: date, times: times);

void main() {
  const calculator = AdhanCalculator();
  final karachi = PrayerSettings.defaults();

  test('windows chain together: each ends exactly when the next begins', () {
    final day = calculator.compute(DateTime(2026, 10, 15), karachi);
    final next = calculator.compute(DateTime(2026, 10, 16), karachi);
    final w = {for (final x in prayerWindows(day, next)) x.prayer: x};

    expect(w[PrayerName.fajr]!.end, day.times[PrayerName.sunrise]);
    expect(w[PrayerName.dhuhr]!.end, w[PrayerName.asr]!.start);
    expect(w[PrayerName.asr]!.end, w[PrayerName.maghrib]!.start);
    expect(w[PrayerName.maghrib]!.end, w[PrayerName.isha]!.start);
    for (final window in w.values) {
      expect(window.end.isAfter(window.start), isTrue, reason: window.prayer.name);
    }
  });

  test('Isha ends at Islamic midnight, between sunset and the next Fajr', () {
    final day = calculator.compute(DateTime(2026, 10, 15), karachi);
    final next = calculator.compute(DateTime(2026, 10, 16), karachi);
    final isha = prayerWindows(day, next).last;
    final maghrib = day.times[PrayerName.maghrib]!;
    final nextFajr = next.times[PrayerName.fajr]!;

    expect(isha.end.isAfter(maghrib), isTrue);
    expect(isha.end.isBefore(nextFajr), isTrue);
    // Exactly halfway.
    expect(isha.end.difference(maghrib), nextFajr.difference(isha.end));
  });

  test('windows are plausible in length for Karachi in October', () {
    final day = calculator.compute(DateTime(2026, 10, 15), karachi);
    final next = calculator.compute(DateTime(2026, 10, 16), karachi);
    final w = {for (final x in prayerWindows(day, next)) x.prayer: x.length};
    expect(w[PrayerName.fajr]!.inMinutes, inInclusiveRange(60, 90));
    expect(w[PrayerName.dhuhr]!.inHours, inInclusiveRange(3, 5));
    expect(w[PrayerName.asr]!.inHours, inInclusiveRange(1, 3));
    expect(w[PrayerName.maghrib]!.inMinutes, inInclusiveRange(60, 100));
    expect(w[PrayerName.isha]!.inHours, inInclusiveRange(4, 8));
  });

  test('if midnight would fall before Isha starts (high latitude) Isha runs to the next Fajr', () {
    final maghrib = DateTime.utc(2026, 6, 21, 20);
    final isha = DateTime.utc(2026, 6, 22, 1); // starts after the 00:30 midpoint
    final fajr = DateTime.utc(2026, 6, 22, 1, 30);
    final day = _day(DateTime(2026, 6, 21), {
      PrayerName.fajr: DateTime.utc(2026, 6, 21, 1),
      PrayerName.sunrise: DateTime.utc(2026, 6, 21, 3, 30),
      PrayerName.dhuhr: DateTime.utc(2026, 6, 21, 12),
      PrayerName.asr: DateTime.utc(2026, 6, 21, 16),
      PrayerName.maghrib: maghrib,
      PrayerName.isha: isha,
    });
    final next = _day(DateTime(2026, 6, 22), {PrayerName.fajr: fajr});
    expect(prayerWindows(day, next).last.end, fajr);
  });

  test('contains is start-inclusive and end-exclusive', () {
    final w = PrayerWindow(PrayerName.asr, DateTime.utc(2026, 1, 1, 10), DateTime.utc(2026, 1, 1, 12));
    expect(w.contains(DateTime.utc(2026, 1, 1, 10)), isTrue);
    expect(w.contains(DateTime.utc(2026, 1, 1, 11, 59)), isTrue);
    expect(w.contains(DateTime.utc(2026, 1, 1, 12)), isFalse);
    expect(w.contains(DateTime.utc(2026, 1, 1, 9, 59)), isFalse);
    expect(w.length, const Duration(hours: 2));
  });

  test('Makkah uses the calculation method it is given (sanity: windows exist)', () {
    final settings = karachi.copyWith(lat: 21.4225, lng: 39.8262, method: CalcMethod.ummAlQura, timezoneId: 'Asia/Riyadh');
    final day = calculator.compute(DateTime(2026, 10, 15), settings);
    final next = calculator.compute(DateTime(2026, 10, 16), settings);
    expect(prayerWindows(day, next), hasLength(5));
  });
}
