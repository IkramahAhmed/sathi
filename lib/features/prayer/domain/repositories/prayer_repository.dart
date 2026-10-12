import '../entities/prayer_name.dart';
import '../entities/prayer_settings.dart';
import '../entities/prayer_times_day.dart';

/// Computes prayer times. Pure and synchronous, so it works with no network
/// and can run in a background isolate without a database.
abstract interface class PrayerTimesProvider {
  /// The times for the calendar [date] using [settings].
  PrayerTimesDay timesFor(DateTime date, PrayerSettings settings);
}

/// Prayer time calculation plus the user's "prayed" log.
abstract interface class PrayerRepository implements PrayerTimesProvider {
  Future<Set<PrayerName>> donePrayers(DateTime date);
  Stream<Set<PrayerName>> watchDonePrayers(DateTime date);
  Future<void> setDone(DateTime date, PrayerName prayer, {required bool done});
}
