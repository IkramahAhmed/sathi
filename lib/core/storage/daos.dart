import 'package:drift/drift.dart';

import 'app_database.dart';
import 'tables.dart';

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
