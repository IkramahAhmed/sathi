import 'pause_range.dart';
import 'prayer_name.dart';
import 'streaks.dart';

class PrayerStats {
  const PrayerStats({required this.days, required this.done, required this.statuses});

  /// Days counted (paused days and today are left out).
  final int days;

  /// How many of those days each prayer was prayed.
  final Map<PrayerName, int> done;

  /// The status of each of the last days, oldest first, for drawing a heatmap.
  final List<({DateTime date, DayStatus status})> statuses;

  int get prayed => done.values.fold(0, (a, b) => a + b);

  /// Share of all possible prayers that were prayed, 0 to 1.
  double get completion => days == 0 ? 0 : prayed / (days * PrayerName.obligatory.length);

  /// The prayer prayed least often, or null when everything is equal or there is no data.
  PrayerName? get weakest {
    if (days == 0) return null;
    PrayerName? worst;
    var fewest = days + 1;
    for (final p in PrayerName.obligatory) {
      final n = done[p] ?? 0;
      if (n < fewest) {
        fewest = n;
        worst = p;
      }
    }
    final allEqual = PrayerName.obligatory.every((p) => (done[p] ?? 0) == fewest);
    return allEqual ? null : worst;
  }
}

/// Statistics for the last [window] days. Days before [start] (when tracking
/// began) and paused days do not count against the user, and neither does today,
/// which is still in progress.
PrayerStats computePrayerStats({
  required Map<String, Set<PrayerName>> doneByDate,
  required List<PauseRange> pauses,
  required DateTime today,
  required DateTime start,
  int window = 30,
}) {
  final todayOnly = DateTime(today.year, today.month, today.day);
  final startOnly = DateTime(start.year, start.month, start.day);
  final counts = {for (final p in PrayerName.obligatory) p: 0};
  final statuses = <({DateTime date, DayStatus status})>[];
  var days = 0;

  for (var i = window - 1; i >= 0; i--) {
    final day = DateTime(todayOnly.year, todayOnly.month, todayOnly.day - i);
    final status = dayStatus(date: day, today: todayOnly, doneByDate: doneByDate, pauses: pauses);
    statuses.add((date: day, status: status));
    final counted = !day.isBefore(startOnly) &&
        day.isBefore(todayOnly) &&
        status != DayStatus.paused &&
        status != DayStatus.future;
    if (!counted) continue;
    days++;
    final done = doneByDate[dateKey(day)] ?? const <PrayerName>{};
    for (final p in PrayerName.obligatory) {
      if (done.contains(p)) counts[p] = counts[p]! + 1;
    }
  }
  return PrayerStats(days: days, done: counts, statuses: statuses);
}
