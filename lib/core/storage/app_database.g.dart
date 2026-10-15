// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PrayerLogsTable extends PrayerLogs
    with TableInfo<$PrayerLogsTable, PrayerLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrayerLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prayerMeta = const VerificationMeta('prayer');
  @override
  late final GeneratedColumn<String> prayer = GeneratedColumn<String>(
    'prayer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doneAtMeta = const VerificationMeta('doneAt');
  @override
  late final GeneratedColumn<DateTime> doneAt = GeneratedColumn<DateTime>(
    'done_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: Constant(DateTime.fromMillisecondsSinceEpoch(0, isUtc: true)),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    prayer,
    doneAt,
    done,
    updatedAt,
    dirty,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prayer_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<PrayerLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('prayer')) {
      context.handle(
        _prayerMeta,
        prayer.isAcceptableOrUnknown(data['prayer']!, _prayerMeta),
      );
    } else if (isInserting) {
      context.missing(_prayerMeta);
    }
    if (data.containsKey('done_at')) {
      context.handle(
        _doneAtMeta,
        doneAt.isAcceptableOrUnknown(data['done_at']!, _doneAtMeta),
      );
    } else if (isInserting) {
      context.missing(_doneAtMeta);
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {date, prayer},
  ];
  @override
  PrayerLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrayerLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      prayer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prayer'],
      )!,
      doneAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}done_at'],
      )!,
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
    );
  }

  @override
  $PrayerLogsTable createAlias(String alias) {
    return $PrayerLogsTable(attachedDatabase, alias);
  }
}

class PrayerLog extends DataClass implements Insertable<PrayerLog> {
  final int id;

  /// Calendar date as `yyyy-MM-dd`.
  final String date;
  final String prayer;
  final DateTime doneAt;

  /// False means the prayer was un-ticked.
  final bool done;

  /// When this row last changed (UTC). Used for last-write-wins.
  final DateTime updatedAt;

  /// True while the change has not been uploaded yet.
  final bool dirty;
  const PrayerLog({
    required this.id,
    required this.date,
    required this.prayer,
    required this.doneAt,
    required this.done,
    required this.updatedAt,
    required this.dirty,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['prayer'] = Variable<String>(prayer);
    map['done_at'] = Variable<DateTime>(doneAt);
    map['done'] = Variable<bool>(done);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['dirty'] = Variable<bool>(dirty);
    return map;
  }

  PrayerLogsCompanion toCompanion(bool nullToAbsent) {
    return PrayerLogsCompanion(
      id: Value(id),
      date: Value(date),
      prayer: Value(prayer),
      doneAt: Value(doneAt),
      done: Value(done),
      updatedAt: Value(updatedAt),
      dirty: Value(dirty),
    );
  }

  factory PrayerLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrayerLog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      prayer: serializer.fromJson<String>(json['prayer']),
      doneAt: serializer.fromJson<DateTime>(json['doneAt']),
      done: serializer.fromJson<bool>(json['done']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      dirty: serializer.fromJson<bool>(json['dirty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'prayer': serializer.toJson<String>(prayer),
      'doneAt': serializer.toJson<DateTime>(doneAt),
      'done': serializer.toJson<bool>(done),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'dirty': serializer.toJson<bool>(dirty),
    };
  }

  PrayerLog copyWith({
    int? id,
    String? date,
    String? prayer,
    DateTime? doneAt,
    bool? done,
    DateTime? updatedAt,
    bool? dirty,
  }) => PrayerLog(
    id: id ?? this.id,
    date: date ?? this.date,
    prayer: prayer ?? this.prayer,
    doneAt: doneAt ?? this.doneAt,
    done: done ?? this.done,
    updatedAt: updatedAt ?? this.updatedAt,
    dirty: dirty ?? this.dirty,
  );
  PrayerLog copyWithCompanion(PrayerLogsCompanion data) {
    return PrayerLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      prayer: data.prayer.present ? data.prayer.value : this.prayer,
      doneAt: data.doneAt.present ? data.doneAt.value : this.doneAt,
      done: data.done.present ? data.done.value : this.done,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrayerLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('prayer: $prayer, ')
          ..write('doneAt: $doneAt, ')
          ..write('done: $done, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dirty: $dirty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, prayer, doneAt, done, updatedAt, dirty);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrayerLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.prayer == this.prayer &&
          other.doneAt == this.doneAt &&
          other.done == this.done &&
          other.updatedAt == this.updatedAt &&
          other.dirty == this.dirty);
}

class PrayerLogsCompanion extends UpdateCompanion<PrayerLog> {
  final Value<int> id;
  final Value<String> date;
  final Value<String> prayer;
  final Value<DateTime> doneAt;
  final Value<bool> done;
  final Value<DateTime> updatedAt;
  final Value<bool> dirty;
  const PrayerLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.prayer = const Value.absent(),
    this.doneAt = const Value.absent(),
    this.done = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.dirty = const Value.absent(),
  });
  PrayerLogsCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required String prayer,
    required DateTime doneAt,
    this.done = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.dirty = const Value.absent(),
  }) : date = Value(date),
       prayer = Value(prayer),
       doneAt = Value(doneAt);
  static Insertable<PrayerLog> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<String>? prayer,
    Expression<DateTime>? doneAt,
    Expression<bool>? done,
    Expression<DateTime>? updatedAt,
    Expression<bool>? dirty,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (prayer != null) 'prayer': prayer,
      if (doneAt != null) 'done_at': doneAt,
      if (done != null) 'done': done,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (dirty != null) 'dirty': dirty,
    });
  }

  PrayerLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? date,
    Value<String>? prayer,
    Value<DateTime>? doneAt,
    Value<bool>? done,
    Value<DateTime>? updatedAt,
    Value<bool>? dirty,
  }) {
    return PrayerLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      prayer: prayer ?? this.prayer,
      doneAt: doneAt ?? this.doneAt,
      done: done ?? this.done,
      updatedAt: updatedAt ?? this.updatedAt,
      dirty: dirty ?? this.dirty,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (prayer.present) {
      map['prayer'] = Variable<String>(prayer.value);
    }
    if (doneAt.present) {
      map['done_at'] = Variable<DateTime>(doneAt.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrayerLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('prayer: $prayer, ')
          ..write('doneAt: $doneAt, ')
          ..write('done: $done, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dirty: $dirty')
          ..write(')'))
        .toString();
  }
}

class $SettingsHistoryTable extends SettingsHistory
    with TableInfo<$SettingsHistoryTable, SettingsHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _changedAtMeta = const VerificationMeta(
    'changedAt',
  );
  @override
  late final GeneratedColumn<DateTime> changedAt = GeneratedColumn<DateTime>(
    'changed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _settingKeyMeta = const VerificationMeta(
    'settingKey',
  );
  @override
  late final GeneratedColumn<String> settingKey = GeneratedColumn<String>(
    'setting_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _oldValueMeta = const VerificationMeta(
    'oldValue',
  );
  @override
  late final GeneratedColumn<String> oldValue = GeneratedColumn<String>(
    'old_value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _newValueMeta = const VerificationMeta(
    'newValue',
  );
  @override
  late final GeneratedColumn<String> newValue = GeneratedColumn<String>(
    'new_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    changedAt,
    settingKey,
    oldValue,
    newValue,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('changed_at')) {
      context.handle(
        _changedAtMeta,
        changedAt.isAcceptableOrUnknown(data['changed_at']!, _changedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_changedAtMeta);
    }
    if (data.containsKey('setting_key')) {
      context.handle(
        _settingKeyMeta,
        settingKey.isAcceptableOrUnknown(data['setting_key']!, _settingKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_settingKeyMeta);
    }
    if (data.containsKey('old_value')) {
      context.handle(
        _oldValueMeta,
        oldValue.isAcceptableOrUnknown(data['old_value']!, _oldValueMeta),
      );
    }
    if (data.containsKey('new_value')) {
      context.handle(
        _newValueMeta,
        newValue.isAcceptableOrUnknown(data['new_value']!, _newValueMeta),
      );
    } else if (isInserting) {
      context.missing(_newValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      changedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}changed_at'],
      )!,
      settingKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setting_key'],
      )!,
      oldValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}old_value'],
      ),
      newValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}new_value'],
      )!,
    );
  }

  @override
  $SettingsHistoryTable createAlias(String alias) {
    return $SettingsHistoryTable(attachedDatabase, alias);
  }
}

class SettingsHistoryData extends DataClass
    implements Insertable<SettingsHistoryData> {
  final int id;
  final DateTime changedAt;
  final String settingKey;
  final String? oldValue;
  final String newValue;
  const SettingsHistoryData({
    required this.id,
    required this.changedAt,
    required this.settingKey,
    this.oldValue,
    required this.newValue,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['changed_at'] = Variable<DateTime>(changedAt);
    map['setting_key'] = Variable<String>(settingKey);
    if (!nullToAbsent || oldValue != null) {
      map['old_value'] = Variable<String>(oldValue);
    }
    map['new_value'] = Variable<String>(newValue);
    return map;
  }

  SettingsHistoryCompanion toCompanion(bool nullToAbsent) {
    return SettingsHistoryCompanion(
      id: Value(id),
      changedAt: Value(changedAt),
      settingKey: Value(settingKey),
      oldValue: oldValue == null && nullToAbsent
          ? const Value.absent()
          : Value(oldValue),
      newValue: Value(newValue),
    );
  }

  factory SettingsHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsHistoryData(
      id: serializer.fromJson<int>(json['id']),
      changedAt: serializer.fromJson<DateTime>(json['changedAt']),
      settingKey: serializer.fromJson<String>(json['settingKey']),
      oldValue: serializer.fromJson<String?>(json['oldValue']),
      newValue: serializer.fromJson<String>(json['newValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'changedAt': serializer.toJson<DateTime>(changedAt),
      'settingKey': serializer.toJson<String>(settingKey),
      'oldValue': serializer.toJson<String?>(oldValue),
      'newValue': serializer.toJson<String>(newValue),
    };
  }

  SettingsHistoryData copyWith({
    int? id,
    DateTime? changedAt,
    String? settingKey,
    Value<String?> oldValue = const Value.absent(),
    String? newValue,
  }) => SettingsHistoryData(
    id: id ?? this.id,
    changedAt: changedAt ?? this.changedAt,
    settingKey: settingKey ?? this.settingKey,
    oldValue: oldValue.present ? oldValue.value : this.oldValue,
    newValue: newValue ?? this.newValue,
  );
  SettingsHistoryData copyWithCompanion(SettingsHistoryCompanion data) {
    return SettingsHistoryData(
      id: data.id.present ? data.id.value : this.id,
      changedAt: data.changedAt.present ? data.changedAt.value : this.changedAt,
      settingKey: data.settingKey.present
          ? data.settingKey.value
          : this.settingKey,
      oldValue: data.oldValue.present ? data.oldValue.value : this.oldValue,
      newValue: data.newValue.present ? data.newValue.value : this.newValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsHistoryData(')
          ..write('id: $id, ')
          ..write('changedAt: $changedAt, ')
          ..write('settingKey: $settingKey, ')
          ..write('oldValue: $oldValue, ')
          ..write('newValue: $newValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, changedAt, settingKey, oldValue, newValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsHistoryData &&
          other.id == this.id &&
          other.changedAt == this.changedAt &&
          other.settingKey == this.settingKey &&
          other.oldValue == this.oldValue &&
          other.newValue == this.newValue);
}

class SettingsHistoryCompanion extends UpdateCompanion<SettingsHistoryData> {
  final Value<int> id;
  final Value<DateTime> changedAt;
  final Value<String> settingKey;
  final Value<String?> oldValue;
  final Value<String> newValue;
  const SettingsHistoryCompanion({
    this.id = const Value.absent(),
    this.changedAt = const Value.absent(),
    this.settingKey = const Value.absent(),
    this.oldValue = const Value.absent(),
    this.newValue = const Value.absent(),
  });
  SettingsHistoryCompanion.insert({
    this.id = const Value.absent(),
    required DateTime changedAt,
    required String settingKey,
    this.oldValue = const Value.absent(),
    required String newValue,
  }) : changedAt = Value(changedAt),
       settingKey = Value(settingKey),
       newValue = Value(newValue);
  static Insertable<SettingsHistoryData> custom({
    Expression<int>? id,
    Expression<DateTime>? changedAt,
    Expression<String>? settingKey,
    Expression<String>? oldValue,
    Expression<String>? newValue,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (changedAt != null) 'changed_at': changedAt,
      if (settingKey != null) 'setting_key': settingKey,
      if (oldValue != null) 'old_value': oldValue,
      if (newValue != null) 'new_value': newValue,
    });
  }

  SettingsHistoryCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? changedAt,
    Value<String>? settingKey,
    Value<String?>? oldValue,
    Value<String>? newValue,
  }) {
    return SettingsHistoryCompanion(
      id: id ?? this.id,
      changedAt: changedAt ?? this.changedAt,
      settingKey: settingKey ?? this.settingKey,
      oldValue: oldValue ?? this.oldValue,
      newValue: newValue ?? this.newValue,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (changedAt.present) {
      map['changed_at'] = Variable<DateTime>(changedAt.value);
    }
    if (settingKey.present) {
      map['setting_key'] = Variable<String>(settingKey.value);
    }
    if (oldValue.present) {
      map['old_value'] = Variable<String>(oldValue.value);
    }
    if (newValue.present) {
      map['new_value'] = Variable<String>(newValue.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsHistoryCompanion(')
          ..write('id: $id, ')
          ..write('changedAt: $changedAt, ')
          ..write('settingKey: $settingKey, ')
          ..write('oldValue: $oldValue, ')
          ..write('newValue: $newValue')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PrayerLogsTable prayerLogs = $PrayerLogsTable(this);
  late final $SettingsHistoryTable settingsHistory = $SettingsHistoryTable(
    this,
  );
  late final PrayerLogsDao prayerLogsDao = PrayerLogsDao(this as AppDatabase);
  late final SettingsHistoryDao settingsHistoryDao = SettingsHistoryDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    prayerLogs,
    settingsHistory,
  ];
}

typedef $$PrayerLogsTableCreateCompanionBuilder = PrayerLogsCompanion Function({
  Value<int> id,
  required String date,
  required String prayer,
  required DateTime doneAt,
  Value<bool> done,
  Value<DateTime> updatedAt,
  Value<bool> dirty,
});
typedef $$PrayerLogsTableUpdateCompanionBuilder = PrayerLogsCompanion Function({
  Value<int> id,
  Value<String> date,
  Value<String> prayer,
  Value<DateTime> doneAt,
  Value<bool> done,
  Value<DateTime> updatedAt,
  Value<bool> dirty,
});

class $$PrayerLogsTableFilterComposer
    extends Composer<_$AppDatabase, $PrayerLogsTable> {
  $$PrayerLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prayer => $composableBuilder(
    column: $table.prayer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PrayerLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $PrayerLogsTable> {
  $$PrayerLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prayer => $composableBuilder(
    column: $table.prayer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PrayerLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrayerLogsTable> {
  $$PrayerLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get prayer =>
      $composableBuilder(column: $table.prayer, builder: (column) => column);

  GeneratedColumn<DateTime> get doneAt =>
      $composableBuilder(column: $table.doneAt, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);
}

class $$PrayerLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PrayerLogsTable,
          PrayerLog,
          $$PrayerLogsTableFilterComposer,
          $$PrayerLogsTableOrderingComposer,
          $$PrayerLogsTableAnnotationComposer,
          $$PrayerLogsTableCreateCompanionBuilder,
          $$PrayerLogsTableUpdateCompanionBuilder,
          (
            PrayerLog,
            BaseReferences<_$AppDatabase, $PrayerLogsTable, PrayerLog>,
          ),
          PrayerLog,
          PrefetchHooks Function()
        > {
  $$PrayerLogsTableTableManager(_$AppDatabase db, $PrayerLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrayerLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrayerLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrayerLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> prayer = const Value.absent(),
                Value<DateTime> doneAt = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
              }) => PrayerLogsCompanion(
                id: id,
                date: date,
                prayer: prayer,
                doneAt: doneAt,
                done: done,
                updatedAt: updatedAt,
                dirty: dirty,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String date,
                required String prayer,
                required DateTime doneAt,
                Value<bool> done = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
              }) => PrayerLogsCompanion.insert(
                id: id,
                date: date,
                prayer: prayer,
                doneAt: doneAt,
                done: done,
                updatedAt: updatedAt,
                dirty: dirty,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PrayerLogsTable, PrayerLog>(table),
                  BaseReferences<_$AppDatabase, $PrayerLogsTable, PrayerLog>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PrayerLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PrayerLogsTable,
      PrayerLog,
      $$PrayerLogsTableFilterComposer,
      $$PrayerLogsTableOrderingComposer,
      $$PrayerLogsTableAnnotationComposer,
      $$PrayerLogsTableCreateCompanionBuilder,
      $$PrayerLogsTableUpdateCompanionBuilder,
      (PrayerLog, BaseReferences<_$AppDatabase, $PrayerLogsTable, PrayerLog>),
      PrayerLog,
      PrefetchHooks Function()
    >;
typedef $$SettingsHistoryTableCreateCompanionBuilder =
    SettingsHistoryCompanion Function({
      Value<int> id,
      required DateTime changedAt,
      required String settingKey,
      Value<String?> oldValue,
      required String newValue,
    });
typedef $$SettingsHistoryTableUpdateCompanionBuilder =
    SettingsHistoryCompanion Function({
      Value<int> id,
      Value<DateTime> changedAt,
      Value<String> settingKey,
      Value<String?> oldValue,
      Value<String> newValue,
    });

class $$SettingsHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsHistoryTable> {
  $$SettingsHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get oldValue => $composableBuilder(
    column: $table.oldValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get newValue => $composableBuilder(
    column: $table.newValue,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsHistoryTable> {
  $$SettingsHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get oldValue => $composableBuilder(
    column: $table.oldValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get newValue => $composableBuilder(
    column: $table.newValue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsHistoryTable> {
  $$SettingsHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get changedAt =>
      $composableBuilder(column: $table.changedAt, builder: (column) => column);

  GeneratedColumn<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get oldValue =>
      $composableBuilder(column: $table.oldValue, builder: (column) => column);

  GeneratedColumn<String> get newValue =>
      $composableBuilder(column: $table.newValue, builder: (column) => column);
}

class $$SettingsHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsHistoryTable,
          SettingsHistoryData,
          $$SettingsHistoryTableFilterComposer,
          $$SettingsHistoryTableOrderingComposer,
          $$SettingsHistoryTableAnnotationComposer,
          $$SettingsHistoryTableCreateCompanionBuilder,
          $$SettingsHistoryTableUpdateCompanionBuilder,
          (
            SettingsHistoryData,
            BaseReferences<
              _$AppDatabase,
              $SettingsHistoryTable,
              SettingsHistoryData
            >,
          ),
          SettingsHistoryData,
          PrefetchHooks Function()
        > {
  $$SettingsHistoryTableTableManager(
    _$AppDatabase db,
    $SettingsHistoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> changedAt = const Value.absent(),
                Value<String> settingKey = const Value.absent(),
                Value<String?> oldValue = const Value.absent(),
                Value<String> newValue = const Value.absent(),
              }) => SettingsHistoryCompanion(
                id: id,
                changedAt: changedAt,
                settingKey: settingKey,
                oldValue: oldValue,
                newValue: newValue,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime changedAt,
                required String settingKey,
                Value<String?> oldValue = const Value.absent(),
                required String newValue,
              }) => SettingsHistoryCompanion.insert(
                id: id,
                changedAt: changedAt,
                settingKey: settingKey,
                oldValue: oldValue,
                newValue: newValue,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsHistoryTable, SettingsHistoryData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $SettingsHistoryTable,
                    SettingsHistoryData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsHistoryTable,
      SettingsHistoryData,
      $$SettingsHistoryTableFilterComposer,
      $$SettingsHistoryTableOrderingComposer,
      $$SettingsHistoryTableAnnotationComposer,
      $$SettingsHistoryTableCreateCompanionBuilder,
      $$SettingsHistoryTableUpdateCompanionBuilder,
      (
        SettingsHistoryData,
        BaseReferences<
          _$AppDatabase,
          $SettingsHistoryTable,
          SettingsHistoryData
        >,
      ),
      SettingsHistoryData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PrayerLogsTableTableManager get prayerLogs =>
      $$PrayerLogsTableTableManager(_db, _db.prayerLogs);
  $$SettingsHistoryTableTableManager get settingsHistory =>
      $$SettingsHistoryTableTableManager(_db, _db.settingsHistory);
}
