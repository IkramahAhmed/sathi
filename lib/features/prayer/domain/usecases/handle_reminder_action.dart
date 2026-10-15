import 'dart:convert';

import '../../../../core/notifications/notification_scheduler.dart';
import '../../../../core/utils/logger.dart';
import '../entities/prayer_name.dart';
import 'schedule_upcoming_azans.dart';

/// What the user chose on a reminder.
enum ReminderOutcome {
  /// Reminders stopped for this prayer; nothing was recorded.
  stopped,

  /// The prayer was ticked and its reminders cancelled.
  prayed,

  /// The tap should open the camera screen, which is the UI's job.
  needsPhoto,

  /// Not one of ours, or malformed. Ignored.
  ignored,
}

/// Handles taps on "prayer ending" notification buttons. The same code runs in
/// the app and in the background (when the app is closed), with different
/// [markPrayed] and [mute] functions.
class HandleReminderAction {
  const HandleReminderAction({
    required this.scheduler,
    required this.mute,
    required this.markPrayed,
  });

  final NotificationScheduler scheduler;

  /// Records "stop reminders" for a prayer on a date.
  final Future<void> Function(DateTime date, PrayerName prayer) mute;

  /// Ticks the prayer as prayed.
  final Future<void> Function(DateTime date, PrayerName prayer) markPrayed;

  /// Decodes a reminder payload. Null if it is not a prayer-ending payload.
  static ({PrayerName prayer, DateTime date, bool photo})? parse(String? payload) {
    if (payload == null || payload.isEmpty) return null;
    try {
      final json = jsonDecode(payload) as Map<String, dynamic>;
      if (json['kind'] != 'ending') return null;
      final prayer = PrayerName.values.where((p) => p.name == json['prayer']).firstOrNull;
      final date = DateTime.tryParse(json['date'] as String? ?? '');
      if (prayer == null || date == null || !prayer.hasAzan) return null;
      return (prayer: prayer, date: DateTime(date.year, date.month, date.day), photo: json['photo'] == true);
    } catch (_) {
      return null;
    }
  }

  Future<ReminderOutcome> call({required String? actionId, required String? payload}) async {
    final info = parse(payload);
    if (info == null) return ReminderOutcome.ignored;

    switch (actionId) {
      case ReminderActions.stop:
        await mute(info.date, info.prayer);
        await scheduler.cancel(endReminderIds(info.date, info.prayer));
        return ReminderOutcome.stopped;
      case ReminderActions.prayed:
        // Photo proof was asked for: a button must not bypass it.
        if (info.photo) return ReminderOutcome.needsPhoto;
        await markPrayed(info.date, info.prayer);
        await scheduler.cancel(endReminderIds(info.date, info.prayer));
        return ReminderOutcome.prayed;
      case ReminderActions.takePhoto:
        return ReminderOutcome.needsPhoto;
      case null:
        // A plain tap on the notification.
        return info.photo ? ReminderOutcome.needsPhoto : ReminderOutcome.ignored;
      default:
        appLog.info('Unknown reminder action: $actionId');
        return ReminderOutcome.ignored;
    }
  }
}
