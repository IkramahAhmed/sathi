import 'package:drift/drift.dart';

import 'app_database.dart';
import 'tables.dart';
// ignore_for_file: lines_longer_than_80_chars

part 'daos.g.dart';

@DriftAccessor(tables: [PrayerLogs])
class PrayerLogsDao extends DatabaseAccessor<AppDatabase> with _$PrayerLogsDaoMixin {
  PrayerLogsDao(super.db);

  /// Prayers that are currently ticked on [date] (tombstones are excluded).
  Stream<Set<String>> watchDone(String date) =>
      (select(prayerLogs)..where((t) => t.date.equals(date) & t.done.equals(true)))
          .watch()
          .map((rows) => rows.map((r) => r.prayer).toSet());

  Future<Set<String>> doneFor(String date) async {
    final rows =
        await (select(prayerLogs)..where((t) => t.date.equals(date) & t.done.equals(true))).get();
    return rows.map((r) => r.prayer).toSet();
  }

  /// Ticks a prayer. The change is marked as waiting to sync.
  Future<void> markDone(String date, String prayer, DateTime at) => _upsert(
        date: date,
        prayer: prayer,
        done: true,
        at: at.toUtc(),
        dirty: true,
      );

  /// Un-ticks a prayer by keeping a tombstone, so the change syncs too. Does
  /// nothing when the prayer was never ticked.
  Future<void> unmark(String date, String prayer, DateTime at) async {
    final existing = await _find(date, prayer);
    if (existing == null) return;
    await _upsert(date: date, prayer: prayer, done: false, at: at.toUtc(), dirty: true);
  }

  Future<PrayerLog?> _find(String date, String prayer) => (select(prayerLogs)
        ..where((t) => t.date.equals(date) & t.prayer.equals(prayer)))
      .getSingleOrNull();

  Future<void> _upsert({
    required String date,
    required String prayer,
    required bool done,
    required DateTime at,
    required bool dirty,
  }) =>
      into(prayerLogs).insert(
        PrayerLogsCompanion.insert(
          date: date,
          prayer: prayer,
          doneAt: at,
          done: Value(done),
          updatedAt: Value(at),
          dirty: Value(dirty),
        ),
        onConflict: DoUpdate(
          (old) => PrayerLogsCompanion(
            done: Value(done),
            doneAt: Value(at),
            updatedAt: Value(at),
            dirty: Value(dirty),
          ),
          target: [prayerLogs.date, prayerLogs.prayer],
        ),
      );

  /// Prayers ticked on each date from [from] to [to] inclusive (`yyyy-MM-dd`).
  /// Dates with nothing ticked are absent.
  Future<Map<String, Set<String>>> doneInRange(String from, String to) async {
    final rows = await (select(prayerLogs)
          ..where((t) => t.date.isBiggerOrEqualValue(from) & t.date.isSmallerOrEqualValue(to) & t.done.equals(true)))
        .get();
    final out = <String, Set<String>>{};
    for (final r in rows) {
      (out[r.date] ??= {}).add(r.prayer);
    }
    return out;
  }

  /// Every ticked prayer from [from] (`yyyy-MM-dd`) onwards, kept up to date.
  Stream<Map<String, Set<String>>> watchDoneSince(String from) =>
      (select(prayerLogs)..where((t) => t.date.isBiggerOrEqualValue(from) & t.done.equals(true))).watch().map((rows) {
        final out = <String, Set<String>>{};
        for (final r in rows) {
          (out[r.date] ??= {}).add(r.prayer);
        }
        return out;
      });

  /// The first date that has any log, or null. Used to guess when tracking began.
  Future<String?> earliestDate() async {
    final row = await (select(prayerLogs)
          ..orderBy([(t) => OrderingTerm.asc(t.date)])
          ..limit(1))
        .getSingleOrNull();
    return row?.date;
  }

  /// Changes waiting to be uploaded, oldest first.
  Future<List<PrayerLog>> dirtyRows({int limit = 500}) => (select(prayerLogs)
        ..where((t) => t.dirty.equals(true))
        ..orderBy([(t) => OrderingTerm.asc(t.updatedAt)])
        ..limit(limit))
      .get();

  Future<int> dirtyCount() async {
    final count = prayerLogs.id.count();
    final row = await (selectOnly(prayerLogs)
          ..addColumns([count])
          ..where(prayerLogs.dirty.equals(true)))
        .getSingle();
    return row.read(count) ?? 0;
  }

  /// Marks an uploaded row as synced, but only if it has not been edited again
  /// since it was read. A newer local edit stays dirty and uploads next time.
  Future<void> markClean(String date, String prayer, DateTime updatedAt) =>
      (update(prayerLogs)
            ..where((t) =>
                t.date.equals(date) & t.prayer.equals(prayer) & t.updatedAt.equals(updatedAt.toUtc())))
          .write(const PrayerLogsCompanion(dirty: Value(false)));

  /// Applies a change received from the cloud using last-write-wins.
  ///
  /// Returns true when it changed the local row. A local row that is as new or
  /// newer is kept, so an un-uploaded local edit is never overwritten.
  Future<bool> applyRemote({
    required String date,
    required String prayer,
    required bool done,
    required DateTime updatedAt,
  }) async {
    final at = updatedAt.toUtc();
    final existing = await _find(date, prayer);
    if (existing != null && !existing.updatedAt.toUtc().isBefore(at)) return false;
    await _upsert(date: date, prayer: prayer, done: done, at: at, dirty: false);
    return true;
  }

  /// Flags every row for upload. Used when the phone switches to another sync
  /// key, so its history merges into that account.
  Future<void> markAllDirty() =>
      update(prayerLogs).write(const PrayerLogsCompanion(dirty: Value(true)));

  /// Removes every log. Used when the user wipes their data.
  Future<void> clearAll() => delete(prayerLogs).go();
}


@DriftAccessor(tables: [SettingsHistory])
class SettingsHistoryDao extends DatabaseAccessor<AppDatabase> with _$SettingsHistoryDaoMixin {
  SettingsHistoryDao(super.db);

  Future<void> record(DateTime at, String key, String? oldValue, String newValue) =>
      into(settingsHistory).insert(
        SettingsHistoryCompanion.insert(
          changedAt: at,
          settingKey: key,
          oldValue: Value(oldValue),
          newValue: newValue,
        ),
      );

  Future<List<SettingsHistoryData>> recent({int limit = 50}) => (select(settingsHistory)
        ..orderBy([(t) => OrderingTerm.desc(t.id)])
        ..limit(limit))
      .get();
}

@DriftAccessor(tables: [PauseRanges])
class PauseRangesDao extends DatabaseAccessor<AppDatabase> with _$PauseRangesDaoMixin {
  PauseRangesDao(super.db);

  Stream<List<PauseRow>> watchAll() => (select(pauseRanges)..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
      .watch();

  Future<List<PauseRow>> all() =>
      (select(pauseRanges)..orderBy([(t) => OrderingTerm.desc(t.startDate)])).get();

  /// Starts an open-ended pause on [startDate]. Does nothing if one is already ongoing.
  Future<int?> startPause(String startDate) async {
    final ongoing = await (select(pauseRanges)..where((t) => t.endDate.isNull())).get();
    if (ongoing.isNotEmpty) return null;
    return into(pauseRanges).insert(PauseRangesCompanion.insert(startDate: startDate));
  }

  /// Ends the ongoing pause on [endDate] (inclusive). Returns false if none was ongoing.
  Future<bool> endOngoing(String endDate) async {
    final ongoing = await (select(pauseRanges)..where((t) => t.endDate.isNull())).get();
    if (ongoing.isEmpty) return false;
    final start = ongoing.first.startDate;
    // Never end before it began.
    final end = endDate.compareTo(start) < 0 ? start : endDate;
    await (update(pauseRanges)..where((t) => t.id.equals(ongoing.first.id)))
        .write(PauseRangesCompanion(endDate: Value(end)));
    return true;
  }

  Future<int> addRange(String startDate, String endDate) =>
      into(pauseRanges).insert(PauseRangesCompanion.insert(startDate: startDate, endDate: Value(endDate)));

  Future<void> remove(int id) => (delete(pauseRanges)..where((t) => t.id.equals(id))).go();

  Future<void> clearAll() => delete(pauseRanges).go();
}

@DriftAccessor(tables: [QazaBalance, QazaHistory])
class QazaDao extends DatabaseAccessor<AppDatabase> with _$QazaDaoMixin {
  QazaDao(super.db);

  /// Owed count per prayer name. Prayers never touched are absent.
  Stream<Map<String, int>> watchOwed() =>
      select(qazaBalance).watch().map((rows) => {for (final r in rows) r.prayer: r.owed});

  Future<Map<String, int>> owed() async =>
      {for (final r in await select(qazaBalance).get()) r.prayer: r.owed};

  Future<int> owedFor(String prayer) async {
    final row = await (select(qazaBalance)..where((t) => t.prayer.equals(prayer))).getSingleOrNull();
    return row?.owed ?? 0;
  }

  /// Changes the balance by [delta] and records it. The balance never goes below
  /// zero; the recorded delta is what really changed. Returns that real change.
  Future<int> change(String prayer, int delta, DateTime at, String source, {String? autoKey}) =>
      transaction(() async {
        final current = await owedFor(prayer);
        final next = (current + delta) < 0 ? 0 : current + delta;
        final applied = next - current;
        if (applied == 0 && autoKey == null) return 0;
        await into(qazaBalance).insert(
          QazaBalanceCompanion.insert(prayer: prayer, owed: Value(next)),
          mode: InsertMode.insertOrReplace,
        );
        await into(qazaHistory).insert(
          QazaHistoryCompanion.insert(
            prayer: prayer,
            delta: applied,
            at: at.toUtc(),
            source: source,
            autoKey: Value(autoKey),
          ),
        );
        return applied;
      });

  /// Sets the starting balance for [prayer] (for example "I owe 300 Fajr").
  /// Recorded as one `initial` entry so the history stays truthful.
  Future<void> setInitial(String prayer, int count, DateTime at) async {
    final current = await owedFor(prayer);
    final target = count < 0 ? 0 : count;
    if (target == current) return;
    await change(prayer, target - current, at, 'initial');
  }

  Future<List<QazaHistoryData>> history({int limit = 100}) => (select(qazaHistory)
        ..orderBy([(t) => OrderingTerm.desc(t.id)])
        ..limit(limit))
      .get();

  /// Keys of every auto-counted missed prayer, for reconciling.
  Future<Set<String>> autoKeys() async {
    final rows = await (select(qazaHistory)..where((t) => t.autoKey.isNotNull())).get();
    return {for (final r in rows) r.autoKey!};
  }

  /// Takes back an auto-counted miss (the user prayed it after all). Does nothing if it is not recorded.
  Future<void> removeAuto(String autoKey, String prayer) => transaction(() async {
        final row = await (select(qazaHistory)..where((t) => t.autoKey.equals(autoKey))).getSingleOrNull();
        if (row == null) return;
        await (delete(qazaHistory)..where((t) => t.id.equals(row.id))).go();
        final current = await owedFor(prayer);
        final next = current - row.delta < 0 ? 0 : current - row.delta;
        await into(qazaBalance).insert(
          QazaBalanceCompanion.insert(prayer: prayer, owed: Value(next)),
          mode: InsertMode.insertOrReplace,
        );
      });

  Future<void> clearAll() async {
    await delete(qazaBalance).go();
    await delete(qazaHistory).go();
  }
}

@DriftAccessor(tables: [Expenses])
class ExpensesDao extends DatabaseAccessor<AppDatabase> with _$ExpensesDaoMixin {
  ExpensesDao(super.db);

  Future<int> add(ExpensesCompanion entry) => into(expenses).insert(entry);

  /// The same transaction often arrives twice — bank-app push and SMS — a few
  /// seconds or minutes apart, with different sender names. So the key ignores
  /// the bank and uses amount + direction within a short time window.
  static const dedupWindow = Duration(minutes: 10);

  Future<bool> isDuplicateBankTx(double amount, String type, DateTime at) async {
    final row = await (select(expenses)
          ..where((t) =>
              t.source.equals('bank') &
              t.amount.equals(amount) &
              t.type.equals(type) &
              t.createdAt.isBetweenValues(at.subtract(dedupWindow), at.add(dedupWindow)))
          ..limit(1))
        .getSingleOrNull();
    return row != null;
  }

  /// Inserts a bank auto-capture unless the same transaction was already saved.
  Future<bool> addIfNew(ExpensesCompanion entry) async {
    final dup = await isDuplicateBankTx(
      entry.amount.value,
      entry.type.present ? entry.type.value : 'expense',
      entry.createdAt.value,
    );
    if (dup) return false;
    await add(entry);
    return true;
  }

  Future<void> updateExpense(int id, ExpensesCompanion entry) =>
      (update(expenses)..where((t) => t.id.equals(id))).write(entry);

  Future<void> remove(int id) => (delete(expenses)..where((t) => t.id.equals(id))).go();

  /// Move a manual entry into the vault (or back out).
  Future<void> setSource(int id, String source) =>
      (update(expenses)..where((t) => t.id.equals(id)))
          .write(ExpensesCompanion(source: Value(source)));

  /// All vault entries, newest first.
  Stream<List<Expense>> watchVault() =>
      (select(expenses)
            ..where((t) => t.source.equals('vault'))
            ..orderBy([
              (t) => OrderingTerm.desc(t.date),
              (t) => OrderingTerm.desc(t.createdAt),
            ]))
          .watch();

  /// All entries for the given month (format: `yyyy-MM`), newest first.
  Stream<List<Expense>> watchMonth(String yearMonth) =>
      (select(expenses)
            ..where((t) => t.date.like('$yearMonth%') & t.source.equals('manual'))
            ..orderBy([
              (t) => OrderingTerm.desc(t.date),
              (t) => OrderingTerm.desc(t.createdAt),
            ]))
          .watch();

  /// Bank-auto-captured entries for the given month, newest first.
  Stream<List<Expense>> watchBankMonth(String yearMonth) =>
      (select(expenses)
            ..where((t) => t.date.like('$yearMonth%') & t.source.equals('bank'))
            ..orderBy([
              (t) => OrderingTerm.desc(t.date),
              (t) => OrderingTerm.desc(t.createdAt),
            ]))
          .watch();

  /// Entries for a month from the given sources (`manual`, `bank`), for totals and budgets.
  Stream<List<Expense>> watchMonthFrom(String yearMonth, List<String> sources) =>
      (select(expenses)
            ..where((t) => t.date.like('$yearMonth%') & t.source.isIn(sources))
            ..orderBy([
              (t) => OrderingTerm.desc(t.date),
              (t) => OrderingTerm.desc(t.createdAt),
            ]))
          .watch();

  /// Entries dated from [from] to [to] (both `yyyy-MM-dd`, inclusive) from the given sources.
  Future<List<Expense>> getRange(String from, String to, List<String> sources) =>
      (select(expenses)
            ..where((t) =>
                t.date.isBiggerOrEqualValue(from) &
                t.date.isSmallerOrEqualValue(to) &
                t.source.isIn(sources)))
          .get();

  Future<List<Expense>> getMonthFrom(String yearMonth, List<String> sources) =>
      (select(expenses)..where((t) => t.date.like('$yearMonth%') & t.source.isIn(sources))).get();

  /// All entries for the given month as a one-shot Future (for PDF export).
  Future<List<Expense>> getMonth(String yearMonth) =>
      (select(expenses)
            ..where((t) => t.date.like('$yearMonth%') & t.source.equals('manual'))
            ..orderBy([
              (t) => OrderingTerm.asc(t.date),
              (t) => OrderingTerm.asc(t.createdAt),
            ]))
          .get();
}

@DriftAccessor(tables: [UdhaarContacts, UdhaarEntries])
class UdhaarDao extends DatabaseAccessor<AppDatabase> with _$UdhaarDaoMixin {
  UdhaarDao(super.db);

  // ── Contacts ──────────────────────────────────────────────────────────────

  /// Normal (non-vault) contacts only.
  Stream<List<UdhaarContact>> watchContacts() =>
      (select(udhaarContacts)
            ..where((t) => t.source.isNotValue('vault'))
            ..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .watch();

  /// Vault contacts only.
  Stream<List<UdhaarContact>> watchVaultContacts() =>
      (select(udhaarContacts)
            ..where((t) => t.source.equals('vault'))
            ..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .watch();

  Future<int> addContact(UdhaarContactsCompanion entry) =>
      into(udhaarContacts).insert(entry);

  Future<void> updateContact(int id, UdhaarContactsCompanion entry) =>
      (update(udhaarContacts)..where((t) => t.id.equals(id))).write(entry);

  Future<void> deleteContact(int id) => transaction(() async {
        await (delete(udhaarEntries)..where((t) => t.contactId.equals(id))).go();
        await (delete(udhaarContacts)..where((t) => t.id.equals(id))).go();
      });

  // ── Entries ───────────────────────────────────────────────────────────────

  /// All entries for a contact, newest first.
  Stream<List<UdhaarEntry>> watchEntries(int contactId) =>
      (select(udhaarEntries)
            ..where((t) => t.contactId.equals(contactId))
            ..orderBy([
              (t) => OrderingTerm.desc(t.date),
              (t) => OrderingTerm.desc(t.createdAt),
            ]))
          .watch();

  Future<void> addEntry(UdhaarEntriesCompanion entry) =>
      into(udhaarEntries).insert(entry);

  Future<void> updateEntry(int id, UdhaarEntriesCompanion entry) =>
      (update(udhaarEntries)..where((t) => t.id.equals(id))).write(entry);

  Future<void> deleteEntry(int id) =>
      (delete(udhaarEntries)..where((t) => t.id.equals(id))).go();

  /// Every entry across all contacts. Used to work out who is overdue.
  Stream<List<UdhaarEntry>> watchAllEntries() => select(udhaarEntries).watch();

  Future<List<UdhaarEntry>> getAllEntries() => select(udhaarEntries).get();

  /// All non-vault contacts (used for overdue notifications).
  Future<List<UdhaarContact>> getAllContacts() =>
      (select(udhaarContacts)..where((t) => t.source.isNotValue('vault'))).get();

  Future<void> setContactSource(int id, String source) =>
      (update(udhaarContacts)..where((t) => t.id.equals(id)))
          .write(UdhaarContactsCompanion(source: Value(source)));

  /// Net balance for each contact: positive = they owe you, negative = you owe them.
  Stream<Map<int, double>> watchBalances() {
    final gave = udhaarEntries.amount.sum();
    return (selectOnly(udhaarEntries)
          ..addColumns([udhaarEntries.contactId, gave])
          ..groupBy([udhaarEntries.contactId]))
        .watch()
        .asyncMap((_) async {
      // Manual calculation per contact for correctness with gave/received split.
      final all = await select(udhaarEntries).get();
      final map = <int, double>{};
      for (final e in all) {
        final delta = e.type == 'gave' ? e.amount : -e.amount;
        map[e.contactId] = (map[e.contactId] ?? 0) + delta;
      }
      return map;
    });
  }
}

@DriftAccessor(tables: [TaskLists])
class TaskListsDao extends DatabaseAccessor<AppDatabase> with _$TaskListsDaoMixin {
  TaskListsDao(super.db);

  Stream<List<TaskList>> watchLists() =>
      (select(taskLists)..orderBy([(t) => OrderingTerm.asc(t.createdAt)])).watch();

  Future<int> addList(TaskListsCompanion entry) => into(taskLists).insert(entry);

  Future<void> updateList(TaskListsCompanion entry) =>
      update(taskLists).replace(entry);

  Future<void> deleteList(int id) =>
      (delete(taskLists)..where((t) => t.id.equals(id))).go();
}

@DriftAccessor(tables: [Tasks])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  TasksDao(super.db);

  /// Today's tasks (pending), sorted by priority then creation time.
  Stream<List<Task>> watchToday(String todayStr, int? listId) {
    return (select(tasks)
          ..where((t) {
            final base = t.isCompleted.equals(false) &
                (t.dueDate.isNull() | t.dueDate.equals(todayStr));
            if (listId != null) return base & t.listId.equals(listId);
            return base;
          })
          ..orderBy([
            (t) => OrderingTerm(expression: t.priority, mode: OrderingMode.desc),
            (t) => OrderingTerm.asc(t.createdAt),
          ]))
        .watch();
  }

  /// Upcoming: due after today, not yet completed.
  Stream<List<Task>> watchUpcoming(String todayStr, int? listId) {
    return (select(tasks)
          ..where((t) {
            final base = t.isCompleted.equals(false) &
                t.dueDate.isNotNull() &
                t.dueDate.isBiggerThan(Variable(todayStr));
            if (listId != null) return base & t.listId.equals(listId);
            return base;
          })
          ..orderBy([
            (t) => OrderingTerm.asc(t.dueDate),
            (t) => OrderingTerm(expression: t.priority, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  /// Completed tasks, most recently completed first (up to 50).
  Stream<List<Task>> watchCompleted(int? listId) {
    return (select(tasks)
          ..where((t) {
            final base = t.isCompleted.equals(true);
            if (listId != null) return base & t.listId.equals(listId);
            return base;
          })
          ..orderBy([(t) => OrderingTerm.desc(t.completedAt)])
          ..limit(50))
        .watch();
  }

  /// Overdue: due before today, not completed.
  Stream<List<Task>> watchOverdue(String todayStr, int? listId) {
    return (select(tasks)
          ..where((t) {
            final base = t.isCompleted.equals(false) &
                t.dueDate.isNotNull() &
                t.dueDate.isSmallerThan(Variable(todayStr));
            if (listId != null) return base & t.listId.equals(listId);
            return base;
          })
          ..orderBy([
            (t) => OrderingTerm.asc(t.dueDate),
            (t) => OrderingTerm(expression: t.priority, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  /// Tomorrow's tasks (not yet completed).
  Stream<List<Task>> watchTomorrow(String tomorrowStr, int? listId) {
    return (select(tasks)
          ..where((t) {
            final base = t.isCompleted.equals(false) &
                t.dueDate.isNotNull() &
                t.dueDate.equals(tomorrowStr);
            if (listId != null) return base & t.listId.equals(listId);
            return base;
          })
          ..orderBy([
            (t) => OrderingTerm(expression: t.priority, mode: OrderingMode.desc),
            (t) => OrderingTerm.asc(t.createdAt),
          ]))
        .watch();
  }

  Future<int> addTask(TasksCompanion entry) => into(tasks).insert(entry);

  Future<bool> updateTask(TasksCompanion entry) =>
      update(tasks).replace(entry);

  Future<void> completeTask(int id) =>
      (update(tasks)..where((t) => t.id.equals(id))).write(TasksCompanion(
        isCompleted: const Value(true),
        completedAt: Value(DateTime.now().toUtc()),
      ));

  Future<void> reopenTask(int id) =>
      (update(tasks)..where((t) => t.id.equals(id))).write(const TasksCompanion(
        isCompleted: Value(false),
        completedAt: Value(null),
      ));

  Future<void> deleteTask(int id) =>
      (delete(tasks)..where((t) => t.id.equals(id))).go();

  /// Removes list assignment from all tasks in a list (before deleting the list).
  Future<void> unassignList(int listId) =>
      (update(tasks)..where((t) => t.listId.equals(listId)))
          .write(const TasksCompanion(listId: Value(null)));

  Future<Task?> getTask(int id) =>
      (select(tasks)..where((t) => t.id.equals(id))).getSingleOrNull();
}

@DriftAccessor(tables: [RecurringExpenses])
class RecurringExpensesDao extends DatabaseAccessor<AppDatabase>
    with _$RecurringExpensesDaoMixin {
  RecurringExpensesDao(super.db);

  Stream<List<RecurringExpense>> watchAll() =>
      (select(recurringExpenses)
            ..orderBy([(t) => OrderingTerm.asc(t.nextDue)]))
          .watch();

  /// Rows whose nextDue is on or before [todayYmd].
  Future<List<RecurringExpense>> getDue(String todayYmd) =>
      (select(recurringExpenses)
            ..where((t) => t.nextDue.isSmallerOrEqualValue(todayYmd)))
          .get();

  Future<void> add(RecurringExpensesCompanion entry) =>
      into(recurringExpenses).insert(entry);

  Future<void> advanceDue(int id, String nextDue) =>
      (update(recurringExpenses)..where((t) => t.id.equals(id)))
          .write(RecurringExpensesCompanion(nextDue: Value(nextDue)));

  Future<void> remove(int id) =>
      (delete(recurringExpenses)..where((t) => t.id.equals(id))).go();
}

@DriftAccessor(tables: [Accounts, Expenses])
class AccountsDao extends DatabaseAccessor<AppDatabase> with _$AccountsDaoMixin {
  AccountsDao(super.db);

  Stream<List<Account>> watchAll() =>
      (select(accounts)..orderBy([(t) => OrderingTerm.asc(t.id)])).watch();

  Future<int> add(AccountsCompanion entry) => into(accounts).insert(entry);

  Future<void> rename(int id, String name) =>
      (update(accounts)..where((t) => t.id.equals(id))).write(AccountsCompanion(name: Value(name)));

  /// Removes the account. Entries keep their amounts but lose the account link.
  Future<void> remove(int id) async {
    await (update(expenses)..where((t) => t.accountId.equals(id)))
        .write(const ExpensesCompanion(accountId: Value(null)));
    await (delete(accounts)..where((t) => t.id.equals(id))).go();
  }

  /// Opening balance plus income minus spending, for every account. Follows both
  /// the accounts and the entries, so editing an opening balance updates it too.
  Stream<Map<int, double>> watchBalances() => customSelect(
        'SELECT a.id AS id, a.opening_balance + COALESCE(SUM(CASE WHEN e.type = \'income\' '
        'THEN e.amount ELSE -e.amount END), 0) AS balance '
        'FROM accounts a LEFT JOIN expenses e ON e.account_id = a.id AND e.source != \'vault\' '
        'GROUP BY a.id',
        readsFrom: {accounts, expenses},
      ).watch().map((rows) => {
            for (final r in rows) r.read<int>('id'): r.read<double>('balance'),
          });
}

@DriftAccessor(tables: [SavingsGoals])
class SavingsGoalsDao extends DatabaseAccessor<AppDatabase> with _$SavingsGoalsDaoMixin {
  SavingsGoalsDao(super.db);

  Stream<List<SavingsGoal>> watchAll() =>
      (select(savingsGoals)..orderBy([(t) => OrderingTerm.asc(t.id)])).watch();

  Future<int> add(SavingsGoalsCompanion entry) => into(savingsGoals).insert(entry);

  Future<void> addMoney(int id, double amount) => customUpdate(
        'UPDATE savings_goals SET saved = MAX(0, saved + ?) WHERE id = ?',
        variables: [Variable<double>(amount), Variable<int>(id)],
        updates: {savingsGoals},
      );

  Future<void> updateGoal(int id, SavingsGoalsCompanion entry) =>
      (update(savingsGoals)..where((t) => t.id.equals(id))).write(entry);

  Future<void> remove(int id) => (delete(savingsGoals)..where((t) => t.id.equals(id))).go();
}

@DriftAccessor(tables: [FastLogs])
class FastLogsDao extends DatabaseAccessor<AppDatabase> with _$FastLogsDaoMixin {
  FastLogsDao(super.db);

  Stream<List<FastLog>> watchAll() =>
      (select(fastLogs)..orderBy([(t) => OrderingTerm.desc(t.date)])).watch();

  /// Sets the status for [date]; a null status clears it.
  Future<void> setStatus(String date, String? status) async {
    if (status == null) {
      await (delete(fastLogs)..where((t) => t.date.equals(date))).go();
      return;
    }
    final updated = await (update(fastLogs)..where((t) => t.date.equals(date)))
        .write(FastLogsCompanion(status: Value(status)));
    if (updated == 0) {
      await into(fastLogs).insert(FastLogsCompanion.insert(date: date, status: status));
    }
  }
}

@DriftAccessor(tables: [CustomCategories, Expenses, RecurringExpenses, Tasks])
class CustomCategoriesDao extends DatabaseAccessor<AppDatabase> with _$CustomCategoriesDaoMixin {
  CustomCategoriesDao(super.db);

  Stream<List<CustomCategory>> watchAll() =>
      (select(customCategories)..orderBy([(t) => OrderingTerm.asc(t.id)])).watch();

  Future<int> add(CustomCategoriesCompanion entry) => into(customCategories).insert(entry);

  Future<void> updateCategory(int id, {required String name, required String emoji}) =>
      (update(customCategories)..where((t) => t.id.equals(id)))
          .write(CustomCategoriesCompanion(name: Value(name), emoji: Value(emoji)));

  /// Deletes the category. Entries, recurring rules and bill tasks that used it
  /// move to Other, so no amount is ever lost.
  Future<void> remove(int id) => transaction(() async {
        final key = 'c$id';
        await (update(expenses)..where((t) => t.category.equals(key)))
            .write(const ExpensesCompanion(category: Value('other')));
        await (update(recurringExpenses)..where((t) => t.category.equals(key)))
            .write(const RecurringExpensesCompanion(category: Value('other')));
        await (update(tasks)..where((t) => t.billCategory.equals(key)))
            .write(const TasksCompanion(billCategory: Value('other')));
        await (delete(customCategories)..where((t) => t.id.equals(id))).go();
      });
}
