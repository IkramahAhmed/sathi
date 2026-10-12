import 'prayer_name.dart';

/// The computed prayer times for one calendar day.
///
/// [date] is the calendar date at the user's location. Every value in [times]
/// is an absolute instant in UTC; convert it with the settings timezone for
/// display.
class PrayerTimesDay {
  const PrayerTimesDay({required this.date, required this.times});

  final DateTime date;
  final Map<PrayerName, DateTime> times;

  DateTime? operator [](PrayerName prayer) => times[prayer];

  /// Whether this date is a Friday (Dhuhr is shown as Jumma).
  bool get isFriday => date.weekday == DateTime.friday;
}

/// A prayer together with the instant it starts.
class UpcomingPrayer {
  const UpcomingPrayer(this.prayer, this.at, this.date);

  final PrayerName prayer;
  final DateTime at;

  /// The calendar date of the day the prayer belongs to.
  final DateTime date;
}

/// Finds the next obligatory prayer strictly after [now] across [days].
UpcomingPrayer? nextPrayerAfter(List<PrayerTimesDay> days, DateTime now) {
  UpcomingPrayer? best;
  for (final day in days) {
    for (final prayer in PrayerName.obligatory) {
      final at = day.times[prayer];
      if (at == null || !at.isAfter(now)) continue;
      if (best == null || at.isBefore(best.at)) {
        best = UpcomingPrayer(prayer, at, day.date);
      }
    }
  }
  return best;
}
