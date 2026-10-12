import 'package:drift/drift.dart';

/// One row per prayer the user marked as prayed on a given date.
class PrayerLogs extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Calendar date as `yyyy-MM-dd`.
  TextColumn get date => text()();
  TextColumn get prayer => text()();
  DateTimeColumn get doneAt => dateTime()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {date, prayer},
      ];
}

/// Append-only history of settings changes.
class SettingsHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get changedAt => dateTime()();
  TextColumn get settingKey => text()();
  TextColumn get oldValue => text().nullable()();
  TextColumn get newValue => text()();
}
