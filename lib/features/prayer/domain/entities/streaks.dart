import 'pause_range.dart';
import 'prayer_name.dart';

enum DayStatus {
  /// All five prayers done.
  complete,

  /// Some, but not all, done.
  partial,

  /// None done.
  none,

  /// A paused day (illness, period): neither counted nor broken.
  paused,

  /// After today.
  future,
}

class StreakSummary {
  const StreakSummary({required this.current, required this.best});

  /// Consecutive complete days up to today.
  final int current;

  /// The longest run ever recorded.
  final int best;
}

String dateKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

/// Status of one [date] given what was done and which days are paused.
DayStatus dayStatus({
  required DateTime date,
  required DateTime today,
  required Map<String, Set<PrayerName>> doneByDate,
  required List<PauseRange> pauses,
}) {
  final d = _day(date);
  if (d.isAfter(_day(today))) return DayStatus.future;
  if (pauses.any((p) => p.contains(d))) return DayStatus.paused;
  final done = doneByDate[dateKey(d)] ?? const <PrayerName>{};
  final count = PrayerName.obligatory.where(done.contains).length;
  if (count == PrayerName.obligatory.length) return DayStatus.complete;
  return count == 0 ? DayStatus.none : DayStatus.partial;
}

/// Current and best streaks.
///
/// A day counts when all five prayers are done. Paused days are skipped: they
/// neither add to nor break a streak. Today never breaks a streak while it is
/// still in progress. Days before [trackingStart] are ignored, so a new user does
/// not start with a "missed" history.
StreakSummary computeStreaks({
  required Map<String, Set<PrayerName>> doneByDate,
  required List<PauseRange> pauses,
  required DateTime today,
  required DateTime trackingStart,
}) {
  final t = _day(today);
  final start = _day(trackingStart);
  if (start.isAfter(t)) return const StreakSummary(current: 0, best: 0);

  DayStatus status(DateTime d) =>
      dayStatus(date: d, today: t, doneByDate: doneByDate, pauses: pauses);

  // Current: walk back from today.
  var current = 0;
  for (var d = t; !d.isBefore(start); d = DateTime(d.year, d.month, d.day - 1)) {
    final s = status(d);
    if (s == DayStatus.complete) {
      current++;
    } else if (s == DayStatus.paused) {
      continue;
    } else if (d == t) {
      continue; // today is still in progress
    } else {
      break;
    }
  }

  // Best: walk forward from the start.
  var best = 0;
  var run = 0;
  for (var d = start; !d.isAfter(t); d = DateTime(d.year, d.month, d.day + 1)) {
    final s = status(d);
    if (s == DayStatus.complete) {
      run++;
      if (run > best) best = run;
    } else if (s == DayStatus.paused) {
      continue;
    } else if (d == t) {
      continue;
    } else {
      run = 0;
    }
  }
  return StreakSummary(current: current, best: best > current ? best : current);
}
