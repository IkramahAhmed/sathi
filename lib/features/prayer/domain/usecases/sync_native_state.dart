import 'package:intl/intl.dart';

import '../../../../core/utils/clock.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/utils/tz_utils.dart';
import '../entities/native_state.dart';
import '../entities/notification_texts.dart';
import '../repositories/native_bridge.dart';
import '../repositories/prayer_repository.dart';
import '../repositories/settings_repository.dart';

/// Gives the phone what it needs to go silent during jama'at and to draw the
/// home-screen widget. Never throws: these are extras, and must not break the
/// azan scheduling that calls them.
class SyncNativeState {
  const SyncNativeState(this._settings, this._prayers, this._bridge, this._clock);

  final SettingsRepository _settings;
  final PrayerTimesProvider _prayers;
  final NativeBridge _bridge;
  final Clock _clock;

  Future<void> call() async {
    try {
      final settings = await _settings.load();
      final now = _clock();
      final today = localDateAt(now, settings.timezoneId);
      final days = [
        for (var i = 0; i < 4; i++) _prayers.timesFor(DateTime(today.year, today.month, today.day + i), settings),
      ];

      await _bridge.setSilentWindows(silentWindows(
        days: days,
        jamaat: settings.jamaat,
        timezoneId: settings.timezoneId,
        now: now,
      ));

      final texts = NotificationTexts.forLocale(settings.localeTag);
      final format = DateFormat('h:mm a');
      await _bridge.setWidgetData(WidgetSnapshot(
        city: settings.cityName,
        nextLabel: texts.widgetNext,
        entries: [
          for (final u in upcomingPrayers(days, now))
            WidgetEntry(
              label: texts.prayerName(u.prayer, isFriday: u.friday),
              at: u.at,
              timeText: widgetTime(u.at, settings.timezoneId, format.format),
            ),
        ],
      ));
    } catch (error, stackTrace) {
      appLog.warning('Could not update the phone-side features', error, stackTrace);
    }
  }
}
