import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../core/notifications/local_notification_scheduler.dart';
import '../../../core/notifications/notification_channels.dart';
import '../../../core/notifications/notification_ids.dart';
import '../../../core/notifications/notification_scheduler.dart';
import '../../../core/storage/app_database.dart';

const String kTaskPayloadType = 'task';
const String kTaskActionDone = 'task_done';
const String kTaskActionSnooze = 'task_snooze';
const Duration kTaskSnooze = Duration(minutes: 10);

/// Four ids per task: slot 0 is the reminder at the due time, the others are
/// kept free for extra reminders.
const int _slots = 4;

int taskNotifId(int taskId, {int slot = 0}) =>
    kFeatureNotificationIdStart + taskId * _slots + slot;

/// Where task reminders used to live. Cleared whenever a task is rescheduled.
int _legacyTaskNotifId(int taskId) => 8000 + taskId;

String taskPayload(int taskId) =>
    jsonEncode({'type': kTaskPayloadType, 'id': taskId});

/// The task a notification payload points at, or null if it is not a task payload.
int? taskIdFromPayload(String? payload) {
  if (payload == null || payload.isEmpty) return null;
  try {
    final json = jsonDecode(payload);
    if (json is Map && json['type'] == kTaskPayloadType && json['id'] is int) {
      return json['id'] as int;
    }
  } catch (_) {}
  return null;
}

String dateKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Finds when [prayer] (`fajr`, `dhuhr`, `asr`, `maghrib`, `isha`) starts on a date.
typedef PrayerTimeResolver = DateTime? Function(DateTime date, String prayer);

/// The moment a task's reminder is due, or null when it has no date and time. A
/// task tied to a prayer needs [prayerTime] to say when that prayer is.
DateTime? taskDueAt(Task task, {PrayerTimeResolver? prayerTime}) {
  if (task.dueDate == null) return null;
  final date = DateTime.tryParse(task.dueDate!);
  if (date == null) return null;

  if (task.prayerAnchor != null) {
    final start = prayerTime?.call(date, task.prayerAnchor!);
    return start?.toLocal().add(Duration(minutes: task.prayerOffset));
  }
  if (task.dueTime == null) return null;
  final parts = task.dueTime!.split(':');
  if (parts.length < 2) return null;
  return DateTime(
    date.year,
    date.month,
    date.day,
    int.tryParse(parts[0]) ?? 0,
    int.tryParse(parts[1]) ?? 0,
  );
}

/// Adds one repeat period to [from]. Monthly repeats stay in the month: the
/// 31st becomes the 28th in February instead of spilling into March.
DateTime addRecurrence(DateTime from, String recurrence) {
  switch (recurrence) {
    case 'daily':
      return DateTime(from.year, from.month, from.day + 1);
    case 'weekly':
      return DateTime(from.year, from.month, from.day + 7);
    case 'monthly':
      final lastDay = DateTime(from.year, from.month + 2, 0).day;
      return DateTime(
        from.year,
        from.month + 1,
        from.day > lastDay ? lastDay : from.day,
      );
    default:
      return from;
  }
}

/// When the next copy of a repeating task is due. It follows the old schedule,
/// but never lands on or before [today], so finishing a task late does not
/// create one that is already overdue.
DateTime nextOccurrence(Task task, DateTime today) {
  final base = DateTime.tryParse(task.dueDate ?? '') ?? today;
  var next = addRecurrence(base, task.recurrence);
  var guard = 0;
  while (!next.isAfter(today) && guard++ < 4000) {
    next = addRecurrence(next, task.recurrence);
  }
  return next;
}

Future<FlutterLocalNotificationsPlugin> _plugin() async {
  final plugin = FlutterLocalNotificationsPlugin();
  await LocalNotificationScheduler.initialize(plugin);
  return plugin;
}

Future<void> _cancel(FlutterLocalNotificationsPlugin plugin, int taskId) async {
  for (var slot = 0; slot < _slots; slot++) {
    await plugin.cancel(id: taskNotifId(taskId, slot: slot));
  }
  await plugin.cancel(id: _legacyTaskNotifId(taskId));
}

String _leadLabel(int minutes) {
  if (minutes >= 1440 && minutes % 1440 == 0) {
    final days = minutes ~/ 1440;
    return days == 1 ? 'tomorrow' : 'in $days days';
  }
  if (minutes >= 60 && minutes % 60 == 0) {
    final hours = minutes ~/ 60;
    return hours == 1 ? 'in 1 hour' : 'in $hours hours';
  }
  return 'in $minutes min';
}

/// Schedules the reminder at the due time, and the early one when asked for.
Future<void> _scheduleFor(
  FlutterLocalNotificationsPlugin plugin,
  Task task,
  DateTime? at,
) async {
  if (at == null) return;
  final now = DateTime.now();
  if (at.isAfter(now)) await _show(plugin, task, at);
  if (task.remindBefore > 0) {
    final early = at.subtract(Duration(minutes: task.remindBefore));
    if (early.isAfter(now)) {
      await _show(
        plugin,
        task,
        early,
        slot: 1,
        body: 'Due ${_leadLabel(task.remindBefore)}',
      );
    }
  }
}

Future<void> _show(
  FlutterLocalNotificationsPlugin plugin,
  Task task,
  DateTime at, {
  int slot = 0,
  String body = 'Task due now',
}) => LocalNotificationScheduler(plugin).scheduleAll([
  ScheduledAlarm(
    id: taskNotifId(task.id, slot: slot),
    title: task.priority == 'high' ? '🔴 ${task.title}' : task.title,
    body: body,
    at: at,
    timezoneId: tz.local.name,
    channelId: NotificationChannels.taskReminder,
    payload: taskPayload(task.id),
    actions: const [
      AlarmAction(id: kTaskActionDone, label: 'Done'),
      AlarmAction(id: kTaskActionSnooze, label: 'Snooze 10 min'),
    ],
  ),
]);

Future<void> cancelTaskReminder(int taskId) async =>
    _cancel(await _plugin(), taskId);

/// Replaces the task's reminders with ones for its current due date and time.
Future<void> scheduleTaskReminder(
  Task task, {
  PrayerTimeResolver? prayerTime,
}) async {
  final plugin = await _plugin();
  await _cancel(plugin, task.id);
  if (task.isCompleted) return;
  await _scheduleFor(plugin, task, taskDueAt(task, prayerTime: prayerTime));
}

/// Puts back every future reminder, so they survive anything that cleared the
/// system's alarm list, and moves prayer-linked ones to the new day's times.
/// A snoozed reminder (already past its due time) is left alone.
Future<void> rescheduleAllTaskReminders(
  AppDatabase db, {
  PrayerTimeResolver? prayerTime,
}) async {
  final open =
      await (db.select(db.tasks)..where(
            (t) => t.isCompleted.equals(false) & t.dueDate.isNotNull(),
          ))
          .get();
  if (open.isEmpty) return;
  final plugin = await _plugin();
  for (final task in open) {
    if (task.dueTime == null && task.prayerAnchor == null) continue;
    await plugin.cancel(id: _legacyTaskNotifId(task.id));
    await plugin.cancel(id: taskNotifId(task.id, slot: 1));
    await _scheduleFor(plugin, task, taskDueAt(task, prayerTime: prayerTime));
  }
}

/// Marks [task] done, stops its reminder, and creates the next copy if it repeats.
Future<void> completeTask(
  AppDatabase db,
  Task task, {
  DateTime? now,
  PrayerTimeResolver? prayerTime,
}) async {
  final dao = db.tasksDao;
  await dao.completeTask(task.id);
  await cancelTaskReminder(task.id);
  if (task.recurrence == 'none') return;

  final today = DateTime(
    (now ?? DateTime.now()).year,
    (now ?? DateTime.now()).month,
    (now ?? DateTime.now()).day,
  );
  final newId = await dao.addTask(
    TasksCompanion.insert(
      title: task.title,
      dueDate: Value(dateKey(nextOccurrence(task, today))),
      dueTime: Value(task.dueTime),
      priority: Value(task.priority),
      recurrence: Value(task.recurrence),
      note: Value(task.note),
      listId: Value(task.listId),
      remindBefore: Value(task.remindBefore),
      prayerAnchor: Value(task.prayerAnchor),
      prayerOffset: Value(task.prayerOffset),
      amount: Value(task.amount),
      billCategory: Value(task.billCategory),
      createdAt: DateTime.now().toUtc(),
    ),
  );
  final saved = await dao.getTask(newId);
  if (saved != null) await scheduleTaskReminder(saved, prayerTime: prayerTime);
}

/// Reopens [task]. For a repeating task, the copy that finishing it created is
/// removed again so the list does not end up with two.
Future<void> reopenTask(
  AppDatabase db,
  Task task, {
  DateTime? now,
  PrayerTimeResolver? prayerTime,
}) async {
  final dao = db.tasksDao;
  if (task.recurrence != 'none' && task.completedAt != null) {
    final completed = task.completedAt!.toLocal();
    final today = DateTime(completed.year, completed.month, completed.day);
    final nextKey = dateKey(nextOccurrence(task, today));
    final copies =
        await (db.select(db.tasks)..where(
              (t) =>
                  t.isCompleted.equals(false) &
                  t.id.isBiggerThanValue(task.id) &
                  t.title.equals(task.title) &
                  t.recurrence.equals(task.recurrence) &
                  t.dueDate.equals(nextKey),
            ))
            .get();
    for (final copy in copies.take(1)) {
      await dao.deleteTask(copy.id);
      await cancelTaskReminder(copy.id);
    }
  }
  await dao.reopenTask(task.id);
  final saved = await dao.getTask(task.id);
  if (saved != null) await scheduleTaskReminder(saved, prayerTime: prayerTime);
}

/// Handles a tap on a task notification's button. Returns true when it was one.
/// Runs both in the app and in the background (app closed).
Future<bool> handleTaskNotificationAction(
  AppDatabase db, {
  required String? actionId,
  required String? payload,
  PrayerTimeResolver? prayerTime,
}) async {
  final id = taskIdFromPayload(payload);
  if (id == null) return false;
  final task = await db.tasksDao.getTask(id);
  if (task == null) return true;

  switch (actionId) {
    case kTaskActionDone:
      if (!task.isCompleted) await completeTask(db, task, prayerTime: prayerTime);
    case kTaskActionSnooze:
      if (!task.isCompleted)
        await _show(await _plugin(), task, DateTime.now().add(kTaskSnooze));
  }
  return true;
}
