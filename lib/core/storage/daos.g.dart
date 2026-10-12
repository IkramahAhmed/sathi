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
