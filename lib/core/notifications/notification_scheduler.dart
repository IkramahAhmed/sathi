/// One local notification to be shown at a future instant.
class ScheduledAlarm {
  const ScheduledAlarm({
    required this.id,
    required this.at,
    required this.timezoneId,
    required this.title,
    required this.body,
    required this.channelId,
    required this.payload,
    this.isPreReminder = false,
  });

  /// Deterministic id; see `stableId`.
  final int id;

  /// Absolute instant (UTC) the notification should fire.
  final DateTime at;

  /// IANA zone used to build the zoned schedule date (handles DST).
  final String timezoneId;
  final String title;
  final String body;
  final String channelId;

  /// JSON payload delivered when the notification is tapped.
  final String payload;
  final bool isPreReminder;
}

/// Pure-Dart contract for scheduling local notifications. Shared later by the
/// todo and khata features.
abstract interface class NotificationScheduler {
  /// Cancels every pending notification.
  Future<void> cancelAll();

  /// Schedules all [alarms]. Falls back to inexact alarms when exact alarms
  /// are not permitted.
  Future<void> scheduleAll(List<ScheduledAlarm> alarms);

  /// Whether exact alarms are currently permitted (always true off Android 12+).
  Future<bool> canScheduleExact();

  /// Number of notifications currently pending with the OS.
  Future<int> pendingCount();
}
