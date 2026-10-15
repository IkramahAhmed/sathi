import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [PrayerLogs, SettingsHistory, PauseRanges, QazaBalance, QazaHistory],
  daos: [PrayerLogsDao, SettingsHistoryDao, PauseRangesDao, QazaDao],
)
class AppDatabase extends _$AppDatabase {
  /// Opens the on-device SQLite file, or [executor] when given (tests).
  AppDatabase([QueryExecutor? executor]) : super(executor ?? driftDatabase(name: 'saathi'));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // v2 adds cloud-sync bookkeeping. Existing ticks count as "done",
            // were last changed when they were ticked, and still need uploading.
            await m.addColumn(prayerLogs, prayerLogs.done);
            await m.addColumn(prayerLogs, prayerLogs.updatedAt);
            await m.addColumn(prayerLogs, prayerLogs.dirty);
            await customStatement('UPDATE prayer_logs SET updated_at = done_at');
          }
          if (from < 3) {
            // v3 adds pauses and the qaza tracker.
            await m.createTable(pauseRanges);
            await m.createTable(qazaBalance);
            await m.createTable(qazaHistory);
          }
        },
      );
}
