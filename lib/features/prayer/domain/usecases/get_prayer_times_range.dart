import '../../../../core/utils/clock.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/utils/tz_utils.dart';
import '../entities/prayer_times_day.dart';
import '../repositories/prayer_repository.dart';
import '../repositories/settings_repository.dart';

/// Prayer times for [days] consecutive calendar days.
class GetPrayerTimesRange {
  const GetPrayerTimesRange(this._prayers, this._settings, this._clock);

  final PrayerRepository _prayers;
  final SettingsRepository _settings;
  final Clock _clock;

  /// Starts at [start] (a calendar date), or today when omitted.
  Future<Result<List<PrayerTimesDay>>> call({DateTime? start, required int days}) =>
      guard(() async {
        final settings = await _settings.load();
        final first = start == null
            ? localDateAt(_clock(), settings.timezoneId)
            : dateOnly(start);
        return [
          for (var i = 0; i < days; i++)
            _prayers.timesFor(
              DateTime(first.year, first.month, first.day + i),
              settings,
            ),
        ];
      });
}
