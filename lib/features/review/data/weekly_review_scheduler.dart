import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../core/notifications/local_notification_scheduler.dart';
import '../../../core/notifications/notification_channels.dart';
import '../../../l10n/app_localizations.dart';

/// Above the prayer range, so rescheduling prayers never cancels it.
const int kWeeklyReviewNotifId = 150000;
const String kWeeklyReviewType = 'weekly_review';

const _onKey = 'weekly_review_on';
const _dayKey = 'weekly_review_day';
const _minutesKey = 'weekly_review_minutes';

/// When the weekly review reminder fires: on by default, Monday at 9:00.
class ReviewReminder {
  const ReviewReminder({this.enabled = true, this.weekday = DateTime.monday, this.minutes = 9 * 60});

  final bool enabled;

  /// `DateTime.monday` to `DateTime.sunday`.
  final int weekday;

  /// Minutes after midnight.
  final int minutes;

  static ReviewReminder load(SharedPreferences prefs) => ReviewReminder(
        enabled: prefs.getBool(_onKey) ?? true,
        weekday: (prefs.getInt(_dayKey) ?? DateTime.monday).clamp(1, 7),
        minutes: (prefs.getInt(_minutesKey) ?? 9 * 60).clamp(0, 24 * 60 - 1),
      );

  Future<void> save(SharedPreferences prefs) async {
    await prefs.setBool(_onKey, enabled);
    await prefs.setInt(_dayKey, weekday);
    await prefs.setInt(_minutesKey, minutes);
  }

  ReviewReminder copyWith({bool? enabled, int? weekday, int? minutes}) => ReviewReminder(
        enabled: enabled ?? this.enabled,
        weekday: weekday ?? this.weekday,
        minutes: minutes ?? this.minutes,
      );
}

/// The next time after [now] that falls on [weekday] at [minutes] after midnight.
DateTime nextWeeklyOccurrence(DateTime now, int weekday, int minutes) {
  final base = DateTime(now.year, now.month, now.day, minutes ~/ 60, minutes % 60);
  final ahead = (weekday - base.weekday) % 7;
  var next = DateTime(base.year, base.month, base.day + ahead, base.hour, base.minute);
  if (!next.isAfter(now)) next = DateTime(next.year, next.month, next.day + 7, next.hour, next.minute);
  return next;
}

bool isWeeklyReviewPayload(String? payload) {
  if (payload == null || payload.isEmpty) return false;
  try {
    final json = jsonDecode(payload);
    return json is Map && json['type'] == kWeeklyReviewType;
  } catch (_) {
    return false;
  }
}

/// Schedules the weekly reminder from the saved settings, or cancels it when it is
/// off. It repeats every week by itself, and calling this again just replaces it.
///
/// The text is fixed ("your review is ready"); the numbers are worked out live when
/// the review opens, so they are never out of date.
Future<void> applyWeeklyReview(SharedPreferences prefs, AppLocalizations l10n) async {
  final plugin = FlutterLocalNotificationsPlugin();
  await LocalNotificationScheduler.initialize(plugin);
  await plugin.cancel(id: kWeeklyReviewNotifId);

  final reminder = ReviewReminder.load(prefs);
  if (!reminder.enabled) return;

  final at = nextWeeklyOccurrence(DateTime.now(), reminder.weekday, reminder.minutes);
  await plugin.zonedSchedule(
    id: kWeeklyReviewNotifId,
    scheduledDate: tz.TZDateTime.from(at, tz.local),
    notificationDetails: NotificationChannels.detailsFor(NotificationChannels.weeklyReview),
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    title: l10n.reviewNotifTitle,
    body: l10n.reviewNotifBody,
    payload: jsonEncode({'type': kWeeklyReviewType}),
    matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
  );
}
