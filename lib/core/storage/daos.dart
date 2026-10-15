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
