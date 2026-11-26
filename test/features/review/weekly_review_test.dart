import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/core/storage/app_database.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_name.dart';
import 'package:saathi/features/review/domain/weekly_review.dart';

String key(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

Expense expense(double amount, String category, DateTime day, {String type = 'expense', String source = 'manual'}) =>
    Expense(
      id: 1,
      amount: amount,
      category: category,
      type: type,
      note: '',
      date: key(day),
      source: source,
      createdAt: day.toUtc(),
    );

Task task({bool done = false, DateTime? completedAt, String? due}) => Task(
      id: 1,
      title: 't',
      dueDate: due,
      priority: 'normal',
      isCompleted: done,
      completedAt: completedAt,
      recurrence: 'none',
      note: '',
      remindBefore: 0,
      prayerOffset: 0,
      createdAt: DateTime.utc(2026),
    );

WeeklyReview build({
  List<Expense> expenses = const [],
  Map<String, Set<PrayerName>> done = const {},
  List<Task> tasks = const [],
  List<FastLog> fasts = const [],
  List<UdhaarContact> contacts = const [],
  List<UdhaarEntry> entries = const [],
  DateTime? start,
}) =>
    buildWeeklyReview(
      today: DateTime(2026, 11, 30),
      expenses: expenses,
      doneByDate: done,
      pauses: const [],
      trackingStart: start ?? DateTime(2026, 11, 1),
      tasks: tasks,
      fasts: fasts,
      contacts: contacts,
      udhaarEntries: entries,
    );

void main() {
  // Today is Monday 30 Nov, so the week is 23-29 Nov and the one before is 16-22 Nov.
  final d = DateTime(2026, 11, 30);
  DateTime ago(int n) => DateTime(d.year, d.month, d.day - n);

  test('covers the seven completed days and leaves today out', () {
    final r = build();
    expect(key(r.from), '2026-11-23');
    expect(key(r.to), '2026-11-29');
  });

  test('compares spending with the week before and finds the biggest rise', () {
    final r = build(expenses: [
      expense(9000, 'food', ago(2)),
      expense(3000, 'transport', ago(3)),
      expense(5000, 'food', ago(9)),
      expense(3000, 'transport', ago(10)),
      expense(70000, 'salary', ago(2), type: 'income'),
      expense(999, 'food', ago(1), source: 'vault'),
      expense(500, 'food', d), // today: not part of the week
    ]);
    expect(r.spent, 12000);
    expect(r.previousSpent, 8000);
    expect(r.percent, closeTo(50, 0.001));
    expect(r.biggestRiseKey, 'food');
    expect(r.biggestRise, 4000);
  });

  test('counts prayers and names the one missed most', () {
    final done = <String, Set<PrayerName>>{};
    for (var i = 1; i <= 7; i++) {
      done[key(ago(i))] = {PrayerName.dhuhr, PrayerName.asr, PrayerName.maghrib, PrayerName.isha};
    }
    final r = build(done: done);
    expect(r.countedDays, 7);
    expect(r.possible, 35);
    expect(r.prayed, 28);
    expect(r.weakest, PrayerName.fajr);
    expect(r.weakestDone, 0);
  });

  test('days before tracking began are not counted', () {
    final r = build(start: ago(3));
    expect(r.countedDays, 3);
    expect(r.possible, 15);
  });

  test('counts tasks finished in the week and tasks still overdue', () {
    final r = build(tasks: [
      task(done: true, completedAt: ago(2).toUtc()),
      task(done: true, completedAt: ago(10).toUtc()),
      task(due: key(ago(1))),
      task(due: key(d)),
      task(due: key(ago(20)), done: true, completedAt: ago(20).toUtc()),
    ]);
    expect(r.tasksDone, 1);
    expect(r.tasksOverdue, 1, reason: 'due today is not overdue yet');
  });

  test('counts fasts in the week only', () {
    final r = build(fasts: [
      FastLog(id: 1, date: key(ago(2)), status: 'kept'),
      FastLog(id: 2, date: key(ago(3)), status: 'missed'),
      FastLog(id: 3, date: key(ago(12)), status: 'kept'),
    ]);
    expect((r.fastsKept, r.fastsMissed), (1, 1));
  });

  test('totals what is owed both ways and lists dues coming up', () {
    final contacts = [
      UdhaarContact(id: 1, name: 'Ali', phone: '', createdAt: DateTime.utc(2026), source: 'normal'),
      UdhaarContact(id: 2, name: 'Bilal', phone: '', createdAt: DateTime.utc(2026), source: 'normal'),
    ];
    UdhaarEntry entry(int c, String type, double a, {String? due}) => UdhaarEntry(
          id: c * 10 + a.toInt(),
          contactId: c,
          type: type,
          amount: a,
          note: '',
          date: '2026-11-01',
          dueDate: due,
          createdAt: DateTime.utc(2026),
        );
    final r = build(contacts: contacts, entries: [
      entry(1, 'gave', 5000, due: key(DateTime(2026, 12, 2))),
      entry(2, 'received', 2000),
    ]);
    expect(r.owedToMe, 5000);
    expect(r.iOwe, 2000);
    expect(r.dues.single.contact.name, 'Ali');
  });

  test('a week with nothing recorded is empty', () {
    expect(build(start: d).isEmpty, isTrue);
  });
}
