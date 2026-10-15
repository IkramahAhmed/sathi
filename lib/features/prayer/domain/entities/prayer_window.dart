import 'prayer_name.dart';
import 'prayer_times_day.dart';

/// The span during which a prayer may be offered, from its start until the next
/// event ends it.
class PrayerWindow {
  const PrayerWindow(this.prayer, this.start, this.end);

  final PrayerName prayer;

  /// Absolute instants (UTC).
  final DateTime start;
  final DateTime end;

  Duration get length => end.difference(start);

  /// Whether [instant] falls inside the window (start inclusive, end exclusive).
  bool contains(DateTime instant) => !instant.isBefore(start) && instant.isBefore(end);
}

/// The midpoint between sunset and the next Fajr. Isha's best time ends here.
DateTime islamicMidnight({required DateTime maghrib, required DateTime nextFajr}) =>
    maghrib.add(nextFajr.difference(maghrib) ~/ 2);

/// The five prayer windows of [day]. [next] is the following calendar day, which
/// Isha needs for the night's midpoint.
///
/// - Fajr ends at sunrise.
/// - Dhuhr ends when Asr starts.
/// - Asr ends at sunset, when Maghrib starts.
/// - Maghrib ends when Isha starts.
/// - Isha ends at Islamic midnight (or at the next Fajr, if midnight would fall
///   before Isha starts, as can happen at high latitudes).
List<PrayerWindow> prayerWindows(PrayerTimesDay day, PrayerTimesDay next) {
  final t = day.times;
  final fajr = t[PrayerName.fajr]!;
  final sunrise = t[PrayerName.sunrise]!;
  final dhuhr = t[PrayerName.dhuhr]!;
  final asr = t[PrayerName.asr]!;
  final maghrib = t[PrayerName.maghrib]!;
  final isha = t[PrayerName.isha]!;
  final nextFajr = next.times[PrayerName.fajr]!;

  var ishaEnd = islamicMidnight(maghrib: maghrib, nextFajr: nextFajr);
  if (!ishaEnd.isAfter(isha)) ishaEnd = nextFajr;

  return [
    PrayerWindow(PrayerName.fajr, fajr, sunrise),
    PrayerWindow(PrayerName.dhuhr, dhuhr, asr),
    PrayerWindow(PrayerName.asr, asr, maghrib),
    PrayerWindow(PrayerName.maghrib, maghrib, isha),
    PrayerWindow(PrayerName.isha, isha, ishaEnd),
  ];
}
