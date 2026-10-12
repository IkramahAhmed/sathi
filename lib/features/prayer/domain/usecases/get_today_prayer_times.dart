import '../../../../core/utils/clock.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/utils/tz_utils.dart';
import '../entities/prayer_times_day.dart';
import '../repositories/prayer_repository.dart';
import '../repositories/settings_repository.dart';

/// Today's prayer times in the user's timezone.
class GetTodayPrayerTimes {
  const GetTodayPrayerTimes(this._prayers, this._settings, this._clock);

  final PrayerRepository _prayers;
  final SettingsRepository _settings;
  final Clock _clock;

  Future<Result<PrayerTimesDay>> call() => guard(() async {
        final settings = await _settings.load();
        final today = localDateAt(_clock(), settings.timezoneId);
        return _prayers.timesFor(today, settings);
      });
}
