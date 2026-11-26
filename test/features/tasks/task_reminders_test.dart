import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/core/notifications/notification_ids.dart';
import 'package:saathi/core/storage/app_database.dart';
import 'package:saathi/features/tasks/data/task_reminders.dart';

Task task({String? due, String recurrence = 'daily', String? time}) => Task(
      id: 7,
      title: 'Pay rent',
      dueDate: due,
      dueTime: time,
      priority: 'normal',
      isCompleted: false,
      recurrence: recurrence,
      note: '',
      remindBefore: 0,
      prayerOffset: 0,
      createdAt: DateTime.utc(2026, 1, 1),
    );

void main() {
  final today = DateTime(2026, 11, 26);

  group('repeat dates', () {
    test('monthly repeat on the 31st stays in the month instead of spilling over', () {
      expect(addRecurrence(DateTime(2026, 1, 31), 'monthly'), DateTime(2026, 2, 28));
      expect(addRecurrence(DateTime(2028, 1, 31), 'monthly'), DateTime(2028, 2, 29));
      expect(addRecurrence(DateTime(2026, 3, 31), 'monthly'), DateTime(2026, 4, 30));
      expect(addRecurrence(DateTime(2026, 12, 15), 'monthly'), DateTime(2027, 1, 15));
    });

    test('a task finished on time repeats on the next day in its schedule', () {
      expect(nextOccurrence(task(due: '2026-11-26'), today), DateTime(2026, 11, 27));
      expect(nextOccurrence(task(due: '2026-11-26', recurrence: 'weekly'), today),
          DateTime(2026, 12, 3));
    });

    test('a task finished late never repeats into the past', () {
      expect(nextOccurrence(task(due: '2026-11-20'), today), DateTime(2026, 11, 27));
      final weekly = nextOccurrence(task(due: '2026-11-01', recurrence: 'weekly'), today);
      expect(weekly.isAfter(today), isTrue);
      expect(weekly, DateTime(2026, 11, 29));
    });

    test('a task finished early keeps its schedule', () {
      expect(nextOccurrence(task(due: '2026-12-10'), today), DateTime(2026, 12, 11));
    });

    test('a repeating task with no due date repeats from today', () {
      expect(nextOccurrence(task(due: null), today), DateTime(2026, 11, 27));
    });
  });

  group('reminder times and ids', () {
    test('a reminder needs both a date and a time', () {
      expect(taskDueAt(task(due: '2026-11-26')), isNull);
      expect(taskDueAt(task(time: '09:30')), isNull);
      expect(taskDueAt(task(due: '2026-11-26', time: '09:30')), DateTime(2026, 11, 26, 9, 30));
    });

    test('task ids never land in the prayer range or on each other', () {
      expect(taskNotifId(1), greaterThanOrEqualTo(kFeatureNotificationIdStart));
      final ids = {for (var i = 1; i <= 5000; i++) ...[taskNotifId(i), taskNotifId(i, slot: 1)]};
      expect(ids.length, 10000);
    });

    test('payloads round-trip and foreign payloads are ignored', () {
      expect(taskIdFromPayload(taskPayload(42)), 42);
      expect(taskIdFromPayload('{"prayer":"fajr"}'), isNull);
      expect(taskIdFromPayload('not json'), isNull);
      expect(taskIdFromPayload(null), isNull);
    });
  });
}
