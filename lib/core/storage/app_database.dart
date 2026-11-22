import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [PrayerLogs, SettingsHistory, PauseRanges, QazaBalance, QazaHistory, Expenses, UdhaarContacts, UdhaarEntries, TaskLists, Tasks],
  daos: [PrayerLogsDao, SettingsHistoryDao, PauseRangesDao, QazaDao, ExpensesDao, UdhaarDao, TaskListsDao, TasksDao],
)
class AppDatabase extends _$AppDatabase {
  /// Opens the on-device SQLite file, or [executor] when given (tests).
  AppDatabase([QueryExecutor? executor]) : super(executor ?? driftDatabase(name: 'saathi'));

  @override
  int get schemaVersion => 11;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(prayerLogs, prayerLogs.done);
            await m.addColumn(prayerLogs, prayerLogs.updatedAt);
            await m.addColumn(prayerLogs, prayerLogs.dirty);
            await customStatement('UPDATE prayer_logs SET updated_at = done_at');
          }
          if (from < 3) {
            await m.createTable(pauseRanges);
            await m.createTable(qazaBalance);
            await m.createTable(qazaHistory);
          }
          if (from < 4) {
            await m.createTable(expenses);
          }
          if (from < 5) {
            await m.createTable(udhaarContacts);
            await m.createTable(udhaarEntries);
          }
          if (from < 6) {
            await m.addColumn(udhaarEntries, udhaarEntries.dueDate);
          }
          if (from < 7) {
            await m.addColumn(expenses, expenses.type);
            await m.addColumn(expenses, expenses.receiptPath);
          }
          if (from < 8) {
            await m.addColumn(expenses, expenses.source);
          }
          if (from < 9) {
            await m.createTable(tasks);
          }
          if (from < 10) {
            await m.addColumn(tasks, tasks.note);
          }
          if (from < 11) {
            await m.createTable(taskLists);
            await m.addColumn(tasks, tasks.listId);
          }
        },
      );
}
