import 'package:drift/drift.dart';

/// One row per prayer per date that has ever been ticked.
///
/// Un-ticking keeps the row with `done = false` (a tombstone) so the change can
/// be synced to other devices. The columns [updatedAt] and [dirty] drive cloud
/// sync: the newest [updatedAt] wins, and [dirty] rows are waiting to be uploaded.
class PrayerLogs extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Calendar date as `yyyy-MM-dd`.
  TextColumn get date => text()();
  TextColumn get prayer => text()();
  DateTimeColumn get doneAt => dateTime()();

  /// False means the prayer was un-ticked.
  BoolColumn get done => boolean().withDefault(const Constant(true))();

  /// When this row last changed (UTC). Used for last-write-wins.
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(Constant(DateTime.fromMillisecondsSinceEpoch(0, isUtc: true)))();

  /// True while the change has not been uploaded yet.
  BoolColumn get dirty => boolean().withDefault(const Constant(true))();

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
