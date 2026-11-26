import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [PrayerLogs, SettingsHistory, PauseRanges, QazaBalance, QazaHistory, Expenses, UdhaarContacts, UdhaarEntries, TaskLists, Tasks, RecurringExpenses, Accounts, SavingsGoals, FastLogs, CustomCategories],
  daos: [PrayerLogsDao, SettingsHistoryDao, PauseRangesDao, QazaDao, ExpensesDao, UdhaarDao, TaskListsDao, TasksDao, RecurringExpensesDao, AccountsDao, SavingsGoalsDao, FastLogsDao, CustomCategoriesDao],
)
class AppDatabase extends _$AppDatabase {
  /// Opens the on-device SQLite file, or [executor] when given (tests).
  AppDatabase([QueryExecutor? executor]) : super(executor ?? driftDatabase(name: 'saathi'));

  @override
  int get schemaVersion => 17;

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
          // Guard addColumn calls: when a table is created by an earlier step in
          // the same migration run, createTable uses the CURRENT schema (all
          // columns), so a subsequent addColumn would duplicate an existing
          // column. The lower-bound checks skip the ALTER when the table was
          // just created moments ago.
          if (from < 6 && from >= 5) {
            await m.addColumn(udhaarEntries, udhaarEntries.dueDate);
          }
          if (from < 7 && from >= 4) {
            await m.addColumn(expenses, expenses.type);
            await m.addColumn(expenses, expenses.receiptPath);
          }
          if (from < 8 && from >= 4) {
            await m.addColumn(expenses, expenses.source);
          }
          if (from < 9) {
            await m.createTable(tasks);
          }
          if (from < 10 && from >= 9) {
            await m.addColumn(tasks, tasks.note);
          }
          if (from < 11) {
            await m.createTable(taskLists);
            if (from >= 9) await m.addColumn(tasks, tasks.listId);
          }
          if (from < 12) {
            // Fix SMS/Gmail-imported rows that defaulted to source='manual'.
            // Bank entries always have a note starting with '['.
            await customStatement(
              "UPDATE expenses SET source = 'bank' WHERE source = 'manual' AND note LIKE '[%'",
            );
          }
          if (from < 13) {
            await m.createTable(recurringExpenses);
          }
          if (from < 14 && from >= 5) {
            await m.addColumn(udhaarContacts, udhaarContacts.source);
          }
          if (from < 15 && from >= 13) {
            await m.addColumn(recurringExpenses, recurringExpenses.anchorDay);
          }
          if (from < 16) {
            await m.createTable(accounts);
            await m.createTable(savingsGoals);
            await m.createTable(fastLogs);
            if (from >= 9) {
              await m.addColumn(tasks, tasks.remindBefore);
              await m.addColumn(tasks, tasks.prayerAnchor);
              await m.addColumn(tasks, tasks.prayerOffset);
              await m.addColumn(tasks, tasks.amount);
              await m.addColumn(tasks, tasks.billCategory);
            }
            if (from >= 4) {
              await m.addColumn(expenses, expenses.accountId);
            }
          }
          if (from < 17) {
            await m.createTable(customCategories);
          }
        },
      );
}
