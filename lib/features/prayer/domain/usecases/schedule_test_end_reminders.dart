import 'dart:convert';

import '../../../../core/notifications/notification_channels.dart';
import '../../../../core/notifications/notification_scheduler.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/tz_utils.dart';
import '../entities/notification_texts.dart';
import '../entities/prayer_name.dart';
import '../entities/prayer_window.dart';
import '../repositories/prayer_repository.dart';
import '../repositories/settings_repository.dart';
import 'schedule_upcoming_azans.dart';

/// Sends a few "prayer ending" reminders a minute apart so the user can see exactly
/// how the real ones behave, without touching their prayer log. The last-call
/// wording is used on the final one.
class ScheduleTestEndReminders {
  const ScheduleTestEndReminders(this._settings, this._prayers, this._scheduler, this._clock);

  final SettingsRepository _settings;
  final PrayerTimesProvider _prayers;
  final NotificationScheduler _scheduler;
  final Clock _clock;

  static const Duration firstDelay = Duration(seconds: 10);
  static const Duration gap = Duration(minutes: 1);

  /// Returns the times the reminders will arrive.
  Future<List<DateTime>> call() async {
    final settings = await _settings.load();
    final now = _clock();
    final today = localDateAt(now, settings.timezoneId);
    final day = _prayers.timesFor(today, settings);
    final next = _prayers.timesFor(DateTime(today.year, today.month, today.day + 1), settings);
    final windows = prayerWindows(day, next);
    final current = windows.where((w) => w.contains(now)).firstOrNull;
    final prayer = current?.prayer ?? PrayerName.dhuhr;
    final texts = NotificationTexts.forLocale(settings.localeTag);
    final photo = settings.endReminder.requirePhoto;
    final dateText =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final times = <DateTime>[];
    final alarms = <ScheduledAlarm>[];
    for (var i = 0; i < testEndReminderIds.length; i++) {
      final at = now.add(firstDelay + gap * i);
      final last = i == testEndReminderIds.length - 1;
      times.add(at);
      alarms.add(ScheduledAlarm(
        id: testEndReminderIds[i],
        at: at,
        timezoneId: settings.timezoneId,
        title: '${texts.testPrefix}${texts.endingTitle(prayer, last ? 5 : 30 - i * 10, last: last, isFriday: day.isFriday)}',
        body: texts.endingBody(requirePhoto: photo),
        channelId: NotificationChannels.prayerEnding,
        payload: jsonEncode({'kind': 'ending', 'prayer': prayer.name, 'date': dateText, 'photo': photo, 'test': true}),
        actions: photo
            ? [
                AlarmAction(id: ReminderActions.takePhoto, label: texts.actionTakePhoto, opensApp: true),
                AlarmAction(id: ReminderActions.stop, label: texts.actionStop),
              ]
            : [
                AlarmAction(id: ReminderActions.prayed, label: texts.actionPrayed),
                AlarmAction(id: ReminderActions.stop, label: texts.actionStop),
              ],
      ));
    }
    await _scheduler.cancel(testEndReminderIds);
    await _scheduler.scheduleAll(alarms);
    return times;
  }
}
