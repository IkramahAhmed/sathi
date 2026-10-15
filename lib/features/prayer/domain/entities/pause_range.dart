/// A stretch of days on which prayers are not required of the user (for example
/// illness or a woman's period). Paused days do not break the streak and do not
/// count as missed prayers.
///
/// Dates are calendar dates at the user's location, stored as `yyyy-MM-dd`.
class PauseRange {
  const PauseRange({required this.start, this.end, this.id});

  final int? id;

  /// First paused date (inclusive).
  final DateTime start;

  /// Last paused date (inclusive). Null while the pause is still ongoing.
  final DateTime? end;

  bool get isOngoing => end == null;

  bool contains(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    final s = DateTime(start.year, start.month, start.day);
    if (d.isBefore(s)) return false;
    final e = end;
    return e == null || !d.isAfter(DateTime(e.year, e.month, e.day));
  }
}
