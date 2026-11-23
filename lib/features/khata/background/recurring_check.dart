import 'package:drift/drift.dart' show Value;
import 'package:flutter/widgets.dart';

import '../../../core/storage/app_database.dart';
import '../../../core/storage/daos.dart';

String _ymd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

/// Returns the date one period after [d] for [frequency].
DateTime advanceDate(DateTime d, String frequency) {
  switch (frequency) {
    case 'daily':
      return d.add(const Duration(days: 1));
    case 'weekly':
      return d.add(const Duration(days: 7));
    case 'yearly':
      return DateTime(d.year + 1, d.month, d.day);
    default: // monthly
      return DateTime(d.year, d.month + 1, d.day);
  }
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
  for (final r in due) {
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
      nextDue = advanceDate(nextDue, r.frequency);
    }
    await recurringDao.advanceDue(r.id, _ymd(nextDue));
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
