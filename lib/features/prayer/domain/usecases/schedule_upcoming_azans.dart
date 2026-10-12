import 'dart:convert';
import 'dart:math' as math;

import '../../../../core/notifications/notification_scheduler.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/utils/tz_utils.dart';
import '../entities/notification_texts.dart';
import '../entities/prayer_name.dart';
import '../repositories/prayer_repository.dart';
import '../repositories/settings_repository.dart';

/// iOS keeps only 64 pending local notifications; stay safely below that.
const int kMaxPendingNotifications = 60;

/// Maximum days scheduled ahead.
const int kMaxScheduleDays = 10;

/// Id for the notification of [prayer] on [date].
///
/// `(dayOfYear * 10 + prayerIndex) * 2 + (pre ? 1 : 0)`. Deterministic, unique
/// within a year and well inside the int32 range.
int stableId(DateTime date, PrayerName prayer, {bool pre = false}) =>
    (dayOfYear(date) * 10 + prayer.index) * 2 + (pre ? 1 : 0);

/// Outcome of a scheduling run.
class ScheduleReport {
  const ScheduleReport({
    required this.scheduledCount,
    required this.days,
    required this.exactAlarms,
    required this.scheduledAt,
  });

  final int scheduledCount;
  final int days;

  /// False when the OS refused exact alarms and inexact ones were used.
  final bool exactAlarms;
  final DateTime scheduledAt;
}

/// Cancels everything and schedules the upcoming azans (and optional
/// pre-reminders) for the next few days.
class ScheduleUpcomingAzans {
  const ScheduleUpcomingAzans(
    this._settings,
    this._prayers,
    this._scheduler,
    this._clock,
  );

  final SettingsRepository _settings;
  final PrayerTimesProvider _prayers;
  final NotificationScheduler _scheduler;
  final Clock _clock;

  Future<Result<ScheduleReport>> call() => guard(() async {
        final settings = await _settings.load();
        final now = _clock();
        await _scheduler.cancelAll();

        final enabled = [
          for (final p in PrayerName.values)
            if (p.hasAzan && settings.azanFor(p)) p,
        ];
        final perDay = enabled.fold<int>(
          0,
          (sum, p) => sum + (settings.preReminderFor(p) > 0 ? 2 : 1),
        );
        final exact = await _scheduler.canScheduleExact();

        if (perDay == 0) {
          await _settings.setLastScheduledAt(now);
          return ScheduleReport(
            scheduledCount: 0,
            days: 0,
            exactAlarms: exact,
            scheduledAt: now,
          );
        }

        final days = math.max(1, math.min(kMaxScheduleDays, kMaxPendingNotifications ~/ perDay));
        final texts = NotificationTexts.forLocale(settings.localeTag);
        final today = localDateAt(now, settings.timezoneId);
        final alarms = <ScheduledAlarm>[];

        for (var i = 0; i < days; i++) {
          final date = DateTime(today.year, today.month, today.day + i);
          final day = _prayers.timesFor(date, settings);
          for (final prayer in enabled) {
            final at = day.times[prayer];
            if (at == null) continue;
            final payload = jsonEncode({
              'prayer': prayer.name,
              'date': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
            });
            if (at.isAfter(now)) {
              alarms.add(ScheduledAlarm(
                id: stableId(date, prayer),
                at: at,
                timezoneId: settings.timezoneId,
                title: texts.azanTitle(prayer, isFriday: day.isFriday),
                body: texts.azanBody(prayer, settings.cityName, isFriday: day.isFriday),
                channelId: settings.sound.channelId,
                payload: payload,
              ));
            }
            final reminder = settings.preReminderFor(prayer);
            if (reminder > 0) {
              final preAt = at.subtract(Duration(minutes: reminder));
              if (preAt.isAfter(now)) {
                alarms.add(ScheduledAlarm(
                  id: stableId(date, prayer, pre: true),
                  at: preAt,
                  timezoneId: settings.timezoneId,
                  title: texts.preReminderTitle(prayer, reminder, isFriday: day.isFriday),
                  body: texts.preReminderBody(settings.cityName),
                  channelId: 'pre_reminder',
                  payload: payload,
                  isPreReminder: true,
                ));
              }
            }
          }
        }

        alarms.sort((a, b) => a.at.compareTo(b.at));
        final capped = alarms.length > kMaxPendingNotifications
            ? alarms.sublist(0, kMaxPendingNotifications)
            : alarms;

        await _scheduler.scheduleAll(capped);
        await _settings.setLastScheduledAt(now);
        return ScheduleReport(
          scheduledCount: capped.length,
          days: days,
          exactAlarms: exact,
          scheduledAt: now,
        );
      }, message: 'Could not schedule azan notifications');
}
