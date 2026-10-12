import 'package:timezone/timezone.dart' as tz;

/// A calendar date with no time or zone, using a plain local [DateTime].
DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Returns the calendar date at [timezoneId] for the absolute instant [instant].
///
/// Requires the timezone database to be initialised (`initializeTimeZones`).
DateTime localDateAt(DateTime instant, String timezoneId) {
  final location = tz.getLocation(timezoneId);
  final local = tz.TZDateTime.from(instant.toUtc(), location);
  return DateTime(local.year, local.month, local.day);
}

/// Converts an absolute instant into a wall-clock [tz.TZDateTime] at [timezoneId].
tz.TZDateTime toZoned(DateTime instant, String timezoneId) =>
    tz.TZDateTime.from(instant.toUtc(), tz.getLocation(timezoneId));

/// Returns the 1-based day of the year for [d].
int dayOfYear(DateTime d) =>
    DateTime.utc(d.year, d.month, d.day).difference(DateTime.utc(d.year, 1, 1)).inDays + 1;
