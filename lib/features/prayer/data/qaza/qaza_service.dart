import '../../../../core/storage/app_database.dart';
import '../../../../core/storage/daos.dart';
import '../../../../core/utils/tz_utils.dart';
import '../../domain/entities/pause_range.dart';
import '../../domain/entities/prayer_name.dart';
import '../../domain/entities/prayer_settings.dart';
import '../../domain/entities/prayer_window.dart';
import '../../domain/entities/streaks.dart';
import '../../domain/repositories/prayer_repository.dart';

/// Converts stored pause rows to domain objects.
List<PauseRange> pauseRangesFrom(List<PauseRow> rows) => [
      for (final r in rows)
        PauseRange(
          id: r.id,
          start: DateTime.parse(r.startDate),
          end: r.endDate == null ? null : DateTime.parse(r.endDate!),
        ),
    ];

/// Keeps the qaza (missed prayers) balance in step with what the user ticked.
///
/// A prayer counts as missed only once its window has ended without a tick, and
/// never on a paused day. If the user later ticks it, or pauses that day, the
/// miss is taken back. Running it again changes nothing, so it is safe to call
/// on every app start.
class QazaService {
  QazaService({
    required this._qaza,
    required this._logs,
    required this._pauses,
    required this._times,
  });

  final QazaDao _qaza;
  final PrayerLogsDao _logs;
  final PauseRangesDao _pauses;
  final PrayerTimesProvider _times;

  static String keyFor(String date, PrayerName prayer) => '$date|${prayer.name}';

  /// Reconciles missed prayers from [from] (a calendar date) up to [now].
  /// Returns how many prayers were added minus how many were taken back.
  Future<int> reconcile({
    required PrayerSettings settings,
    required DateTime now,
    required DateTime from,
  }) async {
    final today = localDateAt(now, settings.timezoneId);
    final start = dateOnly(from);
    if (start.isAfter(today)) return 0;

    final done = await _logs.doneInRange(dateKey(start), dateKey(today));
    final pauses = pauseRangesFrom(await _pauses.all());

    // What should be counted as missed right now.
    final expected = <String>{};
    for (var d = start; !d.isAfter(today); d = DateTime(d.year, d.month, d.day + 1)) {
      if (pauses.any((p) => p.contains(d))) continue;
      final windows = prayerWindows(
        _times.timesFor(d, settings),
        _times.timesFor(DateTime(d.year, d.month, d.day + 1), settings),
      );
      final ticked = done[dateKey(d)] ?? const <String>{};
      for (final w in windows) {
        final ended = !w.end.isAfter(now.toUtc());
        if (ended && !ticked.contains(w.prayer.name)) expected.add(keyFor(dateKey(d), w.prayer));
      }
    }

    final existing = await _qaza.autoKeys();
    final startKey = dateKey(start);
    var net = 0;
    final at = now.toUtc();

    for (final key in expected.difference(existing)) {
      final prayer = key.split('|').last;
      net += await _qaza.change(prayer, 1, at, 'auto', autoKey: key);
    }
    // Take back misses that no longer hold (ticked later, or the day was paused).
    // Only touch dates in range, so older history is never disturbed.
    for (final key in existing.difference(expected)) {
      final date = key.split('|').first;
      if (date.compareTo(startKey) < 0) continue;
      final prayer = key.split('|').last;
      await _qaza.removeAuto(key, prayer);
      net -= 1;
    }
    return net;
  }
}
