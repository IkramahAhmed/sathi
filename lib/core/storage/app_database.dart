import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [PrayerLogs, SettingsHistory],
  daos: [PrayerLogsDao, SettingsHistoryDao],
)
class AppDatabase extends _$AppDatabase {
  /// Opens the on-device SQLite file, or [executor] when given (tests).
  AppDatabase([QueryExecutor? executor]) : super(executor ?? driftDatabase(name: 'saathi'));

  @override
  int get schemaVersion => 1;
}
