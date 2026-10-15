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

/// Days on which prayers are not required (illness, a woman's period). Kept on
/// the phone only: this is private health information and is never synced.
@DataClassName('PauseRow')
class PauseRanges extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// First paused date, `yyyy-MM-dd`.
  TextColumn get startDate => text()();

  /// Last paused date, `yyyy-MM-dd`. Null while the pause is ongoing.
  TextColumn get endDate => text().nullable()();
}

/// How many prayers of each kind the user still owes (qaza). Never below zero.
class QazaBalance extends Table {
  TextColumn get prayer => text()();
  IntColumn get owed => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {prayer};
}

/// Every change to the qaza balance, newest last. Lets the user see and undo what happened.
class QazaHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get prayer => text()();

  /// +n when prayers were added, -n when qaza prayers were made up.
  IntColumn get delta => integer()();
  DateTimeColumn get at => dateTime()();

  /// `initial`, `added`, `madeUp` or `auto`.
  TextColumn get source => text()();

  /// For `auto` rows: `yyyy-MM-dd|prayer`, so the same missed prayer is never counted twice.
  TextColumn get autoKey => text().nullable().unique()();
}
