import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../khata/presentation/providers/khata_providers.dart';
import '../../prayer/presentation/providers/prayer_providers.dart';
import '../../prayer/presentation/providers/tracker_providers.dart';
import '../../tasks/data/task_reminders.dart' show dateKey;
import '../domain/weekly_review.dart';

/// The review for the last seven completed days. Reloaded each time the screen opens.
final weeklyReviewProvider = FutureProvider.autoDispose<WeeklyReview>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final today = ref.watch(todayDateProvider);
  final includeBank = ref.watch(countBankProvider);

  final done = await ref.watch(doneByDateProvider.future);
  final pauses = await ref.watch(pausesProvider.future);
  final start = await ref.watch(trackingStartProvider.future);

  final expenses = await db.expensesDao.getRange(
    dateKey(DateTime(today.year, today.month, today.day - 14)),
    dateKey(DateTime(today.year, today.month, today.day - 1)),
    includeBank ? ['manual', 'bank'] : ['manual'],
  );

  return buildWeeklyReview(
    today: today,
    expenses: expenses,
    doneByDate: done,
    pauses: pauses,
    trackingStart: start,
    tasks: await db.select(db.tasks).get(),
    fasts: await db.select(db.fastLogs).get(),
    contacts: await db.udhaarDao.watchContacts().first,
    udhaarEntries: await db.udhaarDao.getAllEntries(),
  );
});
