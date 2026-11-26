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

/// A person in the Udhaar ledger (customer, friend, family, shopkeeper).
class UdhaarContacts extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Display name of the person.
  TextColumn get name => text()();

  /// Optional phone number (used for WhatsApp reminders later).
  TextColumn get phone => text().withDefault(const Constant(''))();

  DateTimeColumn get createdAt => dateTime()();

  /// `normal` (default) or `vault` — vault contacts are hidden from the
  /// normal Udhaar list and excluded from overdue checks.
  TextColumn get source => text().withDefault(const Constant('normal'))();
}

/// One credit/debit entry in an [UdhaarContacts] ledger.
class UdhaarEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get contactId => integer().references(UdhaarContacts, #id)();

  /// Amount in local currency (always positive).
  RealColumn get amount => real()();

  /// `gave`     → you gave money / they owe you  (adds to balance).
  /// `received` → you received / they paid back   (subtracts from balance).
  TextColumn get type => text()();

  /// Optional note.
  TextColumn get note => text().withDefault(const Constant(''))();

  /// Calendar date as `yyyy-MM-dd`.
  TextColumn get date => text()();

  /// When a `gave` entry should be paid back (`yyyy-MM-dd`). Null when no due date was set.
  TextColumn get dueDate => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
}

/// A named task list (e.g. Personal, Work, Shopping).
class TaskLists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get color => text().withDefault(const Constant('#6750A4'))();
  TextColumn get emoji => text().withDefault(const Constant('📋'))();
  DateTimeColumn get createdAt => dateTime()();
}

/// A task / to-do item. Due date and time are optional.
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();

  /// `yyyy-MM-dd` or null for tasks with no specific date.
  TextColumn get dueDate => text().nullable()();

  /// `HH:mm` or null — notification fires at this time on [dueDate].
  TextColumn get dueTime => text().nullable()();

  /// `high` or `normal`.
  TextColumn get priority => text().withDefault(const Constant('normal'))();

  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();

  /// `none` | `daily` | `weekly` | `monthly`.
  TextColumn get recurrence => text().withDefault(const Constant('none'))();

  /// Optional description / sub-tasks note.
  TextColumn get note => text().withDefault(const Constant(''))();

  /// Optional list this task belongs to.
  IntColumn get listId => integer().nullable()();

  /// Minutes before the due time to remind as well (0 = only at the due time).
  IntColumn get remindBefore => integer().withDefault(const Constant(0))();

  /// A prayer (`fajr`, `dhuhr`, `asr`, `maghrib`, `isha`) the due time follows, or null.
  TextColumn get prayerAnchor => text().nullable()();

  /// Minutes after the anchored prayer (negative = before it).
  IntColumn get prayerOffset => integer().withDefault(const Constant(0))();

  /// Bill amount: finishing the task offers to add it to the Khata.
  RealColumn get amount => real().nullable()();

  /// Khata category for [amount] (an `ExpenseCategory` name).
  TextColumn get billCategory => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
}

/// A rule that auto-creates an [Expenses] row on a fixed schedule.
class RecurringExpenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  TextColumn get category => text()();
  TextColumn get type => text().withDefault(const Constant('expense'))();
  TextColumn get note => text().withDefault(const Constant(''))();
  // 'daily' | 'weekly' | 'monthly' | 'yearly'
  TextColumn get frequency => text()();
  // YYYY-MM-DD — when this rule will next fire
  TextColumn get nextDue => text()();
  /// Day of the month the rule was created on (0 = unknown). Lets a rule created on
  /// the 31st fire on the 28th in February and go back to the 31st afterwards.
  IntColumn get anchorDay => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
}

/// Daily expense / income entries for the Khata (ledger) feature.
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Amount in local currency (always positive).
  RealColumn get amount => real()();

  /// For expenses: matches [ExpenseCategory.name].
  /// For income: matches [IncomeSource.name].
  TextColumn get category => text()();

  /// `expense` (default) or `income`.
  TextColumn get type => text().withDefault(const Constant('expense'))();

  /// Optional description.
  TextColumn get note => text().withDefault(const Constant(''))();

  /// Calendar date as `yyyy-MM-dd`.
  TextColumn get date => text()();

  /// Absolute path to an attached receipt photo. Null when no photo.
  TextColumn get receiptPath => text().nullable()();

  /// `manual` (user-entered) or `bank` (auto-captured from notification).
  TextColumn get source => text().withDefault(const Constant('manual'))();

  /// The [Accounts] row this entry belongs to, or null when none was chosen.
  IntColumn get accountId => integer().nullable()();

  /// When this row was created (UTC), used for ordering within a day.
  DateTimeColumn get createdAt => dateTime()();
}

/// A place money is kept: cash in hand, a bank account or a mobile wallet.
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();

  /// `cash` | `bank` | `wallet`.
  TextColumn get kind => text().withDefault(const Constant('cash'))();
  RealColumn get openingBalance => real().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
}

/// Something being saved for (Hajj, wedding, a car).
class SavingsGoals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get target => real()();
  RealColumn get saved => real().withDefault(const Constant(0))();

  /// `yyyy-MM-dd` or null.
  TextColumn get deadline => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

/// One row per date a fast was kept, missed, or made up.
class FastLogs extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Calendar date as `yyyy-MM-dd`.
  TextColumn get date => text()();

  /// `kept` | `missed` | `made_up` (a missed fast kept on another day).
  TextColumn get status => text()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {date},
      ];
}
