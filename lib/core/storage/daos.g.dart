// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daos.dart';

// ignore_for_file: type=lint
mixin _$PrayerLogsDaoMixin on DatabaseAccessor<AppDatabase> {
  $PrayerLogsTable get prayerLogs => attachedDatabase.prayerLogs;
  PrayerLogsDaoManager get managers => PrayerLogsDaoManager(this);
}

class PrayerLogsDaoManager {
  final _$PrayerLogsDaoMixin _db;
  PrayerLogsDaoManager(this._db);
  $$PrayerLogsTableTableManager get prayerLogs =>
      $$PrayerLogsTableTableManager(_db.attachedDatabase, _db.prayerLogs);
}

mixin _$SettingsHistoryDaoMixin on DatabaseAccessor<AppDatabase> {
  $SettingsHistoryTable get settingsHistory => attachedDatabase.settingsHistory;
  SettingsHistoryDaoManager get managers => SettingsHistoryDaoManager(this);
}

class SettingsHistoryDaoManager {
  final _$SettingsHistoryDaoMixin _db;
  SettingsHistoryDaoManager(this._db);
  $$SettingsHistoryTableTableManager get settingsHistory =>
      $$SettingsHistoryTableTableManager(
        _db.attachedDatabase,
        _db.settingsHistory,
      );
}

mixin _$PauseRangesDaoMixin on DatabaseAccessor<AppDatabase> {
  $PauseRangesTable get pauseRanges => attachedDatabase.pauseRanges;
  PauseRangesDaoManager get managers => PauseRangesDaoManager(this);
}

class PauseRangesDaoManager {
  final _$PauseRangesDaoMixin _db;
  PauseRangesDaoManager(this._db);
  $$PauseRangesTableTableManager get pauseRanges =>
      $$PauseRangesTableTableManager(_db.attachedDatabase, _db.pauseRanges);
}

mixin _$QazaDaoMixin on DatabaseAccessor<AppDatabase> {
  $QazaBalanceTable get qazaBalance => attachedDatabase.qazaBalance;
  $QazaHistoryTable get qazaHistory => attachedDatabase.qazaHistory;
  QazaDaoManager get managers => QazaDaoManager(this);
}

class QazaDaoManager {
  final _$QazaDaoMixin _db;
  QazaDaoManager(this._db);
  $$QazaBalanceTableTableManager get qazaBalance =>
      $$QazaBalanceTableTableManager(_db.attachedDatabase, _db.qazaBalance);
  $$QazaHistoryTableTableManager get qazaHistory =>
      $$QazaHistoryTableTableManager(_db.attachedDatabase, _db.qazaHistory);
}
