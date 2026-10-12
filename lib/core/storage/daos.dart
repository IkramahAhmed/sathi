import 'package:drift/drift.dart';

import 'app_database.dart';
import 'tables.dart';

part 'daos.g.dart';

@DriftAccessor(tables: [PrayerLogs])
class PrayerLogsDao extends DatabaseAccessor<AppDatabase> with _$PrayerLogsDaoMixin {
  PrayerLogsDao(super.db);

  Stream<Set<String>> watchDone(String date) => (select(prayerLogs)..where((t) => t.date.equals(date)))
      .watch()
      .map((rows) => rows.map((r) => r.prayer).toSet());

  Future<Set<String>> doneFor(String date) async {
    final rows = await (select(prayerLogs)..where((t) => t.date.equals(date))).get();
    return rows.map((r) => r.prayer).toSet();
  }

  Future<void> markDone(String date, String prayer, DateTime at) => into(prayerLogs).insert(
        PrayerLogsCompanion.insert(date: date, prayer: prayer, doneAt: at),
        mode: InsertMode.insertOrReplace,
      );

  Future<void> unmark(String date, String prayer) =>
      (delete(prayerLogs)..where((t) => t.date.equals(date) & t.prayer.equals(prayer))).go();
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
