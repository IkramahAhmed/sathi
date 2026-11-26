import 'package:drift/drift.dart' show Value;
import 'package:flutter/widgets.dart';

import '../../../core/storage/app_database.dart';
import '../../../core/storage/daos.dart';

String _ymd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

/// Returns the date one period after [d] for [frequency].
///
/// A monthly or yearly rule created on the 29th–31st stays on that day where the
/// month has it, and uses the month's last day where it does not. [anchorDay] is
/// the day it was created on (0 = use [d]'s own day).
DateTime advanceDate(DateTime d, String frequency, {int anchorDay = 0}) {
  final day = anchorDay > 0 ? anchorDay : d.day;
  switch (frequency) {
    case 'daily':
      return DateTime(d.year, d.month, d.day + 1);
    case 'weekly':
      return DateTime(d.year, d.month, d.day + 7);
    case 'yearly':
      return _clampedDate(d.year + 1, d.month, day);
    default: // monthly
      return _clampedDate(d.year, d.month + 1, day);
  }
}

DateTime _clampedDate(int year, int month, int day) {
  final lastDay = DateTime(year, month + 1, 0).day;
  return DateTime(year, month, day > lastDay ? lastDay : day);
}

/// Creates expense entries for any recurring rules whose nextDue has passed.
/// Advances nextDue atomically, so calling this twice on the same day is safe.
Future<void> runRecurringCheckWithDb(
  ExpensesDao expensesDao,
  RecurringExpensesDao recurringDao,
) async {
  final today = DateTime.now();
  final todayStr = _ymd(today);
  final due = await recurringDao.getDue(todayStr);
  if (due.isEmpty) return;
  // Each rule's entries and its new due date are written together, so a crash
  // cannot leave entries created but the rule still due (which would duplicate them).
  for (final r in due) {
    await recurringDao.attachedDatabase.transaction(() async {
      var nextDue = DateTime.parse(r.nextDue);
      while (!nextDue.isAfter(today)) {
        await expensesDao.add(ExpensesCompanion.insert(
          amount: r.amount,
          category: r.category,
          type: Value(r.type),
          note: Value(r.note),
          date: _ymd(nextDue),
          createdAt: nextDue.toUtc(),
        ));
        nextDue = advanceDate(nextDue, r.frequency, anchorDay: r.anchorDay);
      }
      await recurringDao.advanceDue(r.id, _ymd(nextDue));
    });
  }
}

/// Headless version for WorkManager background tasks — opens its own DB connection.
Future<void> runHeadlessRecurringCheck() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  try {
    await runRecurringCheckWithDb(db.expensesDao, db.recurringExpensesDao);
  } catch (_) {
    // Best-effort: never crash the background task.
  } finally {
    await db.close();
  }
}
