import 'dart:convert';
import 'dart:math' as math;

import 'package:intl/intl.dart';

import '../../../../core/notifications/notification_channels.dart';
import '../../../../core/notifications/notification_scheduler.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/utils/tz_utils.dart';
import '../entities/end_reminder.dart';
import '../entities/jamaat.dart';
import '../entities/notification_texts.dart';
import '../entities/prayer_name.dart';
import '../entities/prayer_window.dart';
import '../repositories/prayer_repository.dart';
import '../repositories/reminder_state.dart';
import '../repositories/settings_repository.dart';
import 'sync_native_state.dart';

/// iOS keeps only 64 pending local notifications; stay safely below that.
const int kMaxPendingNotifications = 60;

/// Maximum days of azans scheduled ahead.
const int kMaxScheduleDays = 10;

/// Ending reminders are only scheduled for today and tomorrow. They are the
/// most numerous, and the app re-plans them on every start and resume.
const int kEndReminderDays = 2;

/// Id for the azan (or its pre-reminder) of [prayer] on [date].
///
/// `(dayOfYear * 10 + prayerIndex) * 2 + (pre ? 1 : 0)`. Deterministic, unique
/// within a year and well inside the int32 range. Ids below 10000.
int stableId(DateTime date, PrayerName prayer, {bool pre = false}) =>
    (dayOfYear(date) * 10 + prayer.index) * 2 + (pre ? 1 : 0);

/// Id for the "time to leave for jama'at" reminder. In the range 10000-19999.
int leaveId(DateTime date, PrayerName prayer) => 10000 + dayOfYear(date) * 10 + prayer.index;

/// Id for the [index]th (0-9) "prayer ending" reminder. In the range 20000-59999.
int endReminderId(DateTime date, PrayerName prayer, int index) {
  assert(index >= 0 && index < 10, 'index must be 0-9');
  return 20000 + (dayOfYear(date) * 10 + prayer.index) * 10 + index;
}

/// Every possible id of the ending reminders for [prayer] on [date]. Used to
/// cancel the rest once the prayer is done.
List<int> endReminderIds(DateTime date, PrayerName prayer) =>
    [for (var i = 0; i < 10; i++) endReminderId(date, prayer, i)];

/// Notification action ids (see the tap handler).
abstract final class ReminderActions {
  static const takePhoto = 'take_photo';
  static const stop = 'stop_reminders';
  static const prayed = 'mark_prayed';
}

/// Outcome of a scheduling run.
class ScheduleReport {
  const ScheduleReport({
    required this.scheduledCount,
    required this.days,
    required this.exactAlarms,
    required this.scheduledAt,
    this.endReminders = 0,
    this.leaveReminders = 0,
  });

  final int scheduledCount;
  final int days;

  /// False when the OS refused exact alarms and inexact ones were used.
  final bool exactAlarms;
  final DateTime scheduledAt;

  /// How many of [scheduledCount] are "prayer ending" reminders.
  final int endReminders;

  /// How many are "time to leave for jama'at" reminders.
  final int leaveReminders;
}

/// Cancels everything and schedules the upcoming azans, pre-reminders, jama'at
/// reminders and "prayer ending" reminders.
class ScheduleUpcomingAzans {
  const ScheduleUpcomingAzans(
    this._settings,
    this._prayers,
    this._scheduler,
    this._clock, {
    this._reminderState = const NoReminderState(),
    this._maxPending = kMaxPendingNotifications,
    this._nativeSync,
  });

  final SettingsRepository _settings;
  final PrayerTimesProvider _prayers;
  final NotificationScheduler _scheduler;
  final Clock _clock;
  final ReminderState _reminderState;
  final int _maxPending;

  /// Also refreshes the silent windows and the widget after scheduling.
  final SyncNativeState? _nativeSync;

  static String _isoDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<Result<ScheduleReport>> call() async {
    final result = await _schedule();
    await _nativeSync?.call();
    return result;
  }

  Future<Result<ScheduleReport>> _schedule() => guard(() async {
        final settings = await _settings.load();
        final now = _clock();
        await _scheduler.cancelAll();

        final texts = NotificationTexts.forLocale(settings.localeTag);
        final today = localDateAt(now, settings.timezoneId);
        DateTime dayAt(int i) => DateTime(today.year, today.month, today.day + i);

        final azanChannel = NotificationChannels.azanChannelFor(settings.sound, alarm: settings.azanOnAlarm);

        // --- Ending reminders (today and tomorrow only) ------------------------
        final ending = <ScheduledAlarm>[];
        if (settings.endReminder.enabled) {
          for (var i = 0; i < kEndReminderDays; i++) {
            final date = dayAt(i);
            if (await _reminderState.isPaused(date)) continue;
            final day = _prayers.timesFor(date, settings);
            final next = _prayers.timesFor(dayAt(i + 1), settings);
            for (final window in prayerWindows(day, next)) {
              if (!settings.endReminder.appliesTo(window.prayer)) continue;
              if (!window.end.isAfter(now)) continue;
              if (await _reminderState.isDone(date, window.prayer)) continue;
              if (await _reminderState.isMuted(date, window.prayer)) continue;
              for (final slot in endReminderPlan(window, settings.endReminder)) {
                if (!slot.at.isAfter(now)) continue;
                final last = slot.minutesLeft <= 5;
                ending.add(ScheduledAlarm(
                  id: endReminderId(date, window.prayer, slot.index),
                  at: slot.at,
                  timezoneId: settings.timezoneId,
                  title: texts.endingTitle(window.prayer, slot.minutesLeft, last: last, isFriday: day.isFriday),
                  body: texts.endingBody(requirePhoto: settings.endReminder.requirePhoto),
                  channelId: NotificationChannels.prayerEnding,
                  payload: jsonEncode({
                    'kind': 'ending',
                    'prayer': window.prayer.name,
                    'date': _isoDate(date),
                    'photo': settings.endReminder.requirePhoto,
                  }),
                  actions: settings.endReminder.requirePhoto
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
            }
          }
        }

        // --- Azans, pre-reminders and jama'at reminders ------------------------
        final enabled = [
          for (final p in PrayerName.values)
            if (p.hasAzan && settings.azanFor(p)) p,
        ];
        final jamaat = settings.jamaat;
        final leaveOn = jamaat.leaveReminderMin > 0 && jamaat.isConfigured;
        final exact = await _scheduler.canScheduleExact();

        // Per-day cost, to decide how many days fit in the budget.
        var perDay = 0;
        for (final p in enabled) {
          perDay += settings.preReminderFor(p) > 0 ? 2 : 1;
        }
        if (leaveOn) perDay += PrayerName.obligatory.length;

        final alarms = <ScheduledAlarm>[...ending];
        var days = 0;
        if (perDay > 0) {
          final budget = math.max(perDay, _maxPending - ending.length);
          days = math.max(1, math.min(kMaxScheduleDays, budget ~/ perDay));
          for (var i = 0; i < days; i++) {
            final date = dayAt(i);
            final day = _prayers.timesFor(date, settings);
            final dateText = _isoDate(date);
            for (final prayer in enabled) {
              final at = day.times[prayer];
              if (at == null) continue;
              final payload = jsonEncode({'prayer': prayer.name, 'date': dateText});
              if (at.isAfter(now)) {
                alarms.add(ScheduledAlarm(
                  id: stableId(date, prayer),
                  at: at,
                  timezoneId: settings.timezoneId,
                  title: texts.azanTitle(prayer, isFriday: day.isFriday),
                  body: texts.azanBody(prayer, settings.cityName, isFriday: day.isFriday),
                  channelId: azanChannel,
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
                    channelId: NotificationChannels.preReminder,
                    payload: payload,
                    isPreReminder: true,
                  ));
                }
              }
            }
            if (leaveOn) {
              for (final prayer in PrayerName.obligatory) {
                final j = jamaatTime(
                  prayer: prayer,
                  day: day,
                  settings: jamaat,
                  timezoneId: settings.timezoneId,
                );
                if (j == null) continue;
                final leaveAt = j.subtract(Duration(minutes: jamaat.leaveReminderMin));
                if (!leaveAt.isAfter(now)) continue;
                alarms.add(ScheduledAlarm(
                  id: leaveId(date, prayer),
                  at: leaveAt,
                  timezoneId: settings.timezoneId,
                  title: texts.leaveTitle(prayer, isFriday: day.isFriday),
                  body: texts.leaveBody(DateFormat('h:mm a').format(toZoned(j, settings.timezoneId))),
                  channelId: NotificationChannels.jamaatReminder,
                  payload: jsonEncode({'kind': 'leave', 'prayer': prayer.name, 'date': dateText}),
                ));
              }
            }
          }
        }

        if (alarms.isEmpty) {
          await _settings.setLastScheduledAt(now);
          return ScheduleReport(scheduledCount: 0, days: 0, exactAlarms: exact, scheduledAt: now);
        }

        alarms.sort((a, b) => a.at.compareTo(b.at));
        final capped = alarms.length > _maxPending ? alarms.sublist(0, _maxPending) : alarms;

        await _scheduler.scheduleAll(capped);
        await _settings.setLastScheduledAt(now);
        return ScheduleReport(
          scheduledCount: capped.length,
          days: days,
          exactAlarms: exact,
          scheduledAt: now,
          endReminders: capped.where((a) => a.channelId == NotificationChannels.prayerEnding).length,
          leaveReminders: capped.where((a) => a.channelId == NotificationChannels.jamaatReminder).length,
        );
      }, message: 'Could not schedule azan notifications');
}
