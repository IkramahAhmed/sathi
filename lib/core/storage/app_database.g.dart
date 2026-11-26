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

class $PauseRangesTable extends PauseRanges
    with TableInfo<$PauseRangesTable, PauseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PauseRangesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, startDate, endDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pause_ranges';
  @override
  VerificationContext validateIntegrity(
    Insertable<PauseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PauseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PauseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_date'],
      ),
    );
  }

  @override
  $PauseRangesTable createAlias(String alias) {
    return $PauseRangesTable(attachedDatabase, alias);
  }
}

class PauseRow extends DataClass implements Insertable<PauseRow> {
  final int id;

  /// First paused date, `yyyy-MM-dd`.
  final String startDate;

  /// Last paused date, `yyyy-MM-dd`. Null while the pause is ongoing.
  final String? endDate;
  const PauseRow({required this.id, required this.startDate, this.endDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start_date'] = Variable<String>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<String>(endDate);
    }
    return map;
  }

  PauseRangesCompanion toCompanion(bool nullToAbsent) {
    return PauseRangesCompanion(
      id: Value(id),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
    );
  }

  factory PauseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PauseRow(
      id: serializer.fromJson<int>(json['id']),
      startDate: serializer.fromJson<String>(json['startDate']),
      endDate: serializer.fromJson<String?>(json['endDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startDate': serializer.toJson<String>(startDate),
      'endDate': serializer.toJson<String?>(endDate),
    };
  }

  PauseRow copyWith({
    int? id,
    String? startDate,
    Value<String?> endDate = const Value.absent(),
  }) => PauseRow(
    id: id ?? this.id,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
  );
  PauseRow copyWithCompanion(PauseRangesCompanion data) {
    return PauseRow(
      id: data.id.present ? data.id.value : this.id,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PauseRow(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, startDate, endDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PauseRow &&
          other.id == this.id &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate);
}

class PauseRangesCompanion extends UpdateCompanion<PauseRow> {
  final Value<int> id;
  final Value<String> startDate;
  final Value<String?> endDate;
  const PauseRangesCompanion({
    this.id = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
  });
  PauseRangesCompanion.insert({
    this.id = const Value.absent(),
    required String startDate,
    this.endDate = const Value.absent(),
  }) : startDate = Value(startDate);
  static Insertable<PauseRow> custom({
    Expression<int>? id,
    Expression<String>? startDate,
    Expression<String>? endDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
    });
  }

  PauseRangesCompanion copyWith({
    Value<int>? id,
    Value<String>? startDate,
    Value<String?>? endDate,
  }) {
    return PauseRangesCompanion(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PauseRangesCompanion(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate')
          ..write(')'))
        .toString();
  }
}

class $QazaBalanceTable extends QazaBalance
    with TableInfo<$QazaBalanceTable, QazaBalanceData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QazaBalanceTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _prayerMeta = const VerificationMeta('prayer');
  @override
  late final GeneratedColumn<String> prayer = GeneratedColumn<String>(
    'prayer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _owedMeta = const VerificationMeta('owed');
  @override
  late final GeneratedColumn<int> owed = GeneratedColumn<int>(
    'owed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [prayer, owed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'qaza_balance';
  @override
  VerificationContext validateIntegrity(
    Insertable<QazaBalanceData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('prayer')) {
      context.handle(
        _prayerMeta,
        prayer.isAcceptableOrUnknown(data['prayer']!, _prayerMeta),
      );
    } else if (isInserting) {
      context.missing(_prayerMeta);
    }
    if (data.containsKey('owed')) {
      context.handle(
        _owedMeta,
        owed.isAcceptableOrUnknown(data['owed']!, _owedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {prayer};
  @override
  QazaBalanceData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QazaBalanceData(
      prayer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prayer'],
      )!,
      owed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owed'],
      )!,
    );
  }

  @override
  $QazaBalanceTable createAlias(String alias) {
    return $QazaBalanceTable(attachedDatabase, alias);
  }
}

class QazaBalanceData extends DataClass implements Insertable<QazaBalanceData> {
  final String prayer;
  final int owed;
  const QazaBalanceData({required this.prayer, required this.owed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['prayer'] = Variable<String>(prayer);
    map['owed'] = Variable<int>(owed);
    return map;
  }

  QazaBalanceCompanion toCompanion(bool nullToAbsent) {
    return QazaBalanceCompanion(prayer: Value(prayer), owed: Value(owed));
  }

  factory QazaBalanceData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QazaBalanceData(
      prayer: serializer.fromJson<String>(json['prayer']),
      owed: serializer.fromJson<int>(json['owed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'prayer': serializer.toJson<String>(prayer),
      'owed': serializer.toJson<int>(owed),
    };
  }

  QazaBalanceData copyWith({String? prayer, int? owed}) =>
      QazaBalanceData(prayer: prayer ?? this.prayer, owed: owed ?? this.owed);
  QazaBalanceData copyWithCompanion(QazaBalanceCompanion data) {
    return QazaBalanceData(
      prayer: data.prayer.present ? data.prayer.value : this.prayer,
      owed: data.owed.present ? data.owed.value : this.owed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QazaBalanceData(')
          ..write('prayer: $prayer, ')
          ..write('owed: $owed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(prayer, owed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QazaBalanceData &&
          other.prayer == this.prayer &&
          other.owed == this.owed);
}

class QazaBalanceCompanion extends UpdateCompanion<QazaBalanceData> {
  final Value<String> prayer;
  final Value<int> owed;
  final Value<int> rowid;
  const QazaBalanceCompanion({
    this.prayer = const Value.absent(),
    this.owed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QazaBalanceCompanion.insert({
    required String prayer,
    this.owed = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : prayer = Value(prayer);
  static Insertable<QazaBalanceData> custom({
    Expression<String>? prayer,
    Expression<int>? owed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (prayer != null) 'prayer': prayer,
      if (owed != null) 'owed': owed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QazaBalanceCompanion copyWith({
    Value<String>? prayer,
    Value<int>? owed,
    Value<int>? rowid,
  }) {
    return QazaBalanceCompanion(
      prayer: prayer ?? this.prayer,
      owed: owed ?? this.owed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (prayer.present) {
      map['prayer'] = Variable<String>(prayer.value);
    }
    if (owed.present) {
      map['owed'] = Variable<int>(owed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QazaBalanceCompanion(')
          ..write('prayer: $prayer, ')
          ..write('owed: $owed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QazaHistoryTable extends QazaHistory
    with TableInfo<$QazaHistoryTable, QazaHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QazaHistoryTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _prayerMeta = const VerificationMeta('prayer');
  @override
  late final GeneratedColumn<String> prayer = GeneratedColumn<String>(
    'prayer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deltaMeta = const VerificationMeta('delta');
  @override
  late final GeneratedColumn<int> delta = GeneratedColumn<int>(
    'delta',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _autoKeyMeta = const VerificationMeta(
    'autoKey',
  );
  @override
  late final GeneratedColumn<String> autoKey = GeneratedColumn<String>(
    'auto_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    prayer,
    delta,
    at,
    source,
    autoKey,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'qaza_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<QazaHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('prayer')) {
      context.handle(
        _prayerMeta,
        prayer.isAcceptableOrUnknown(data['prayer']!, _prayerMeta),
      );
    } else if (isInserting) {
      context.missing(_prayerMeta);
    }
    if (data.containsKey('delta')) {
      context.handle(
        _deltaMeta,
        delta.isAcceptableOrUnknown(data['delta']!, _deltaMeta),
      );
    } else if (isInserting) {
      context.missing(_deltaMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('auto_key')) {
      context.handle(
        _autoKeyMeta,
        autoKey.isAcceptableOrUnknown(data['auto_key']!, _autoKeyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QazaHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QazaHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      prayer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prayer'],
      )!,
      delta: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}delta'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      autoKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}auto_key'],
      ),
    );
  }

  @override
  $QazaHistoryTable createAlias(String alias) {
    return $QazaHistoryTable(attachedDatabase, alias);
  }
}

class QazaHistoryData extends DataClass implements Insertable<QazaHistoryData> {
  final int id;
  final String prayer;

  /// +n when prayers were added, -n when qaza prayers were made up.
  final int delta;
  final DateTime at;

  /// `initial`, `added`, `madeUp` or `auto`.
  final String source;

  /// For `auto` rows: `yyyy-MM-dd|prayer`, so the same missed prayer is never counted twice.
  final String? autoKey;
  const QazaHistoryData({
    required this.id,
    required this.prayer,
    required this.delta,
    required this.at,
    required this.source,
    this.autoKey,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['prayer'] = Variable<String>(prayer);
    map['delta'] = Variable<int>(delta);
    map['at'] = Variable<DateTime>(at);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || autoKey != null) {
      map['auto_key'] = Variable<String>(autoKey);
    }
    return map;
  }

  QazaHistoryCompanion toCompanion(bool nullToAbsent) {
    return QazaHistoryCompanion(
      id: Value(id),
      prayer: Value(prayer),
      delta: Value(delta),
      at: Value(at),
      source: Value(source),
      autoKey: autoKey == null && nullToAbsent
          ? const Value.absent()
          : Value(autoKey),
    );
  }

  factory QazaHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QazaHistoryData(
      id: serializer.fromJson<int>(json['id']),
      prayer: serializer.fromJson<String>(json['prayer']),
      delta: serializer.fromJson<int>(json['delta']),
      at: serializer.fromJson<DateTime>(json['at']),
      source: serializer.fromJson<String>(json['source']),
      autoKey: serializer.fromJson<String?>(json['autoKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'prayer': serializer.toJson<String>(prayer),
      'delta': serializer.toJson<int>(delta),
      'at': serializer.toJson<DateTime>(at),
      'source': serializer.toJson<String>(source),
      'autoKey': serializer.toJson<String?>(autoKey),
    };
  }

  QazaHistoryData copyWith({
    int? id,
    String? prayer,
    int? delta,
    DateTime? at,
    String? source,
    Value<String?> autoKey = const Value.absent(),
  }) => QazaHistoryData(
    id: id ?? this.id,
    prayer: prayer ?? this.prayer,
    delta: delta ?? this.delta,
    at: at ?? this.at,
    source: source ?? this.source,
    autoKey: autoKey.present ? autoKey.value : this.autoKey,
  );
  QazaHistoryData copyWithCompanion(QazaHistoryCompanion data) {
    return QazaHistoryData(
      id: data.id.present ? data.id.value : this.id,
      prayer: data.prayer.present ? data.prayer.value : this.prayer,
      delta: data.delta.present ? data.delta.value : this.delta,
      at: data.at.present ? data.at.value : this.at,
      source: data.source.present ? data.source.value : this.source,
      autoKey: data.autoKey.present ? data.autoKey.value : this.autoKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QazaHistoryData(')
          ..write('id: $id, ')
          ..write('prayer: $prayer, ')
          ..write('delta: $delta, ')
          ..write('at: $at, ')
          ..write('source: $source, ')
          ..write('autoKey: $autoKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, prayer, delta, at, source, autoKey);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QazaHistoryData &&
          other.id == this.id &&
          other.prayer == this.prayer &&
          other.delta == this.delta &&
          other.at == this.at &&
          other.source == this.source &&
          other.autoKey == this.autoKey);
}

class QazaHistoryCompanion extends UpdateCompanion<QazaHistoryData> {
  final Value<int> id;
  final Value<String> prayer;
  final Value<int> delta;
  final Value<DateTime> at;
  final Value<String> source;
  final Value<String?> autoKey;
  const QazaHistoryCompanion({
    this.id = const Value.absent(),
    this.prayer = const Value.absent(),
    this.delta = const Value.absent(),
    this.at = const Value.absent(),
    this.source = const Value.absent(),
    this.autoKey = const Value.absent(),
  });
  QazaHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String prayer,
    required int delta,
    required DateTime at,
    required String source,
    this.autoKey = const Value.absent(),
  }) : prayer = Value(prayer),
       delta = Value(delta),
       at = Value(at),
       source = Value(source);
  static Insertable<QazaHistoryData> custom({
    Expression<int>? id,
    Expression<String>? prayer,
    Expression<int>? delta,
    Expression<DateTime>? at,
    Expression<String>? source,
    Expression<String>? autoKey,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (prayer != null) 'prayer': prayer,
      if (delta != null) 'delta': delta,
      if (at != null) 'at': at,
      if (source != null) 'source': source,
      if (autoKey != null) 'auto_key': autoKey,
    });
  }

  QazaHistoryCompanion copyWith({
    Value<int>? id,
    Value<String>? prayer,
    Value<int>? delta,
    Value<DateTime>? at,
    Value<String>? source,
    Value<String?>? autoKey,
  }) {
    return QazaHistoryCompanion(
      id: id ?? this.id,
      prayer: prayer ?? this.prayer,
      delta: delta ?? this.delta,
      at: at ?? this.at,
      source: source ?? this.source,
      autoKey: autoKey ?? this.autoKey,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (prayer.present) {
      map['prayer'] = Variable<String>(prayer.value);
    }
    if (delta.present) {
      map['delta'] = Variable<int>(delta.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (autoKey.present) {
      map['auto_key'] = Variable<String>(autoKey.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QazaHistoryCompanion(')
          ..write('id: $id, ')
          ..write('prayer: $prayer, ')
          ..write('delta: $delta, ')
          ..write('at: $at, ')
          ..write('source: $source, ')
          ..write('autoKey: $autoKey')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('expense'),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
  static const VerificationMeta _receiptPathMeta = const VerificationMeta(
    'receiptPath',
  );
  @override
  late final GeneratedColumn<String> receiptPath = GeneratedColumn<String>(
    'receipt_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amount,
    category,
    type,
    note,
    date,
    receiptPath,
    source,
    accountId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Expense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('receipt_path')) {
      context.handle(
        _receiptPathMeta,
        receiptPath.isAcceptableOrUnknown(
          data['receipt_path']!,
          _receiptPathMeta,
        ),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      receiptPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_path'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;

  /// Amount in local currency (always positive).
  final double amount;

  /// For expenses: matches [ExpenseCategory.name].
  /// For income: matches [IncomeSource.name].
  final String category;

  /// `expense` (default) or `income`.
  final String type;

  /// Optional description.
  final String note;

  /// Calendar date as `yyyy-MM-dd`.
  final String date;

  /// Absolute path to an attached receipt photo. Null when no photo.
  final String? receiptPath;

  /// `manual` (user-entered) or `bank` (auto-captured from notification).
  final String source;

  /// The [Accounts] row this entry belongs to, or null when none was chosen.
  final int? accountId;

  /// When this row was created (UTC), used for ordering within a day.
  final DateTime createdAt;
  const Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.type,
    required this.note,
    required this.date,
    this.receiptPath,
    required this.source,
    this.accountId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount'] = Variable<double>(amount);
    map['category'] = Variable<String>(category);
    map['type'] = Variable<String>(type);
    map['note'] = Variable<String>(note);
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || receiptPath != null) {
      map['receipt_path'] = Variable<String>(receiptPath);
    }
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<int>(accountId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      amount: Value(amount),
      category: Value(category),
      type: Value(type),
      note: Value(note),
      date: Value(date),
      receiptPath: receiptPath == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptPath),
      source: Value(source),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      createdAt: Value(createdAt),
    );
  }

  factory Expense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      category: serializer.fromJson<String>(json['category']),
      type: serializer.fromJson<String>(json['type']),
      note: serializer.fromJson<String>(json['note']),
      date: serializer.fromJson<String>(json['date']),
      receiptPath: serializer.fromJson<String?>(json['receiptPath']),
      source: serializer.fromJson<String>(json['source']),
      accountId: serializer.fromJson<int?>(json['accountId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<double>(amount),
      'category': serializer.toJson<String>(category),
      'type': serializer.toJson<String>(type),
      'note': serializer.toJson<String>(note),
      'date': serializer.toJson<String>(date),
      'receiptPath': serializer.toJson<String?>(receiptPath),
      'source': serializer.toJson<String>(source),
      'accountId': serializer.toJson<int?>(accountId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Expense copyWith({
    int? id,
    double? amount,
    String? category,
    String? type,
    String? note,
    String? date,
    Value<String?> receiptPath = const Value.absent(),
    String? source,
    Value<int?> accountId = const Value.absent(),
    DateTime? createdAt,
  }) => Expense(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    category: category ?? this.category,
    type: type ?? this.type,
    note: note ?? this.note,
    date: date ?? this.date,
    receiptPath: receiptPath.present ? receiptPath.value : this.receiptPath,
    source: source ?? this.source,
    accountId: accountId.present ? accountId.value : this.accountId,
    createdAt: createdAt ?? this.createdAt,
  );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      category: data.category.present ? data.category.value : this.category,
      type: data.type.present ? data.type.value : this.type,
      note: data.note.present ? data.note.value : this.note,
      date: data.date.present ? data.date.value : this.date,
      receiptPath: data.receiptPath.present
          ? data.receiptPath.value
          : this.receiptPath,
      source: data.source.present ? data.source.value : this.source,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('type: $type, ')
          ..write('note: $note, ')
          ..write('date: $date, ')
          ..write('receiptPath: $receiptPath, ')
          ..write('source: $source, ')
          ..write('accountId: $accountId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    amount,
    category,
    type,
    note,
    date,
    receiptPath,
    source,
    accountId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.category == this.category &&
          other.type == this.type &&
          other.note == this.note &&
          other.date == this.date &&
          other.receiptPath == this.receiptPath &&
          other.source == this.source &&
          other.accountId == this.accountId &&
          other.createdAt == this.createdAt);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<double> amount;
  final Value<String> category;
  final Value<String> type;
  final Value<String> note;
  final Value<String> date;
  final Value<String?> receiptPath;
  final Value<String> source;
  final Value<int?> accountId;
  final Value<DateTime> createdAt;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.category = const Value.absent(),
    this.type = const Value.absent(),
    this.note = const Value.absent(),
    this.date = const Value.absent(),
    this.receiptPath = const Value.absent(),
    this.source = const Value.absent(),
    this.accountId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required double amount,
    required String category,
    this.type = const Value.absent(),
    this.note = const Value.absent(),
    required String date,
    this.receiptPath = const Value.absent(),
    this.source = const Value.absent(),
    this.accountId = const Value.absent(),
    required DateTime createdAt,
  }) : amount = Value(amount),
       category = Value(category),
       date = Value(date),
       createdAt = Value(createdAt);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<double>? amount,
    Expression<String>? category,
    Expression<String>? type,
    Expression<String>? note,
    Expression<String>? date,
    Expression<String>? receiptPath,
    Expression<String>? source,
    Expression<int>? accountId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (category != null) 'category': category,
      if (type != null) 'type': type,
      if (note != null) 'note': note,
      if (date != null) 'date': date,
      if (receiptPath != null) 'receipt_path': receiptPath,
      if (source != null) 'source': source,
      if (accountId != null) 'account_id': accountId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ExpensesCompanion copyWith({
    Value<int>? id,
    Value<double>? amount,
    Value<String>? category,
    Value<String>? type,
    Value<String>? note,
    Value<String>? date,
    Value<String?>? receiptPath,
    Value<String>? source,
    Value<int?>? accountId,
    Value<DateTime>? createdAt,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      type: type ?? this.type,
      note: note ?? this.note,
      date: date ?? this.date,
      receiptPath: receiptPath ?? this.receiptPath,
      source: source ?? this.source,
      accountId: accountId ?? this.accountId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (receiptPath.present) {
      map['receipt_path'] = Variable<String>(receiptPath.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('type: $type, ')
          ..write('note: $note, ')
          ..write('date: $date, ')
          ..write('receiptPath: $receiptPath, ')
          ..write('source: $source, ')
          ..write('accountId: $accountId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $UdhaarContactsTable extends UdhaarContacts
    with TableInfo<$UdhaarContactsTable, UdhaarContact> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UdhaarContactsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, phone, createdAt, source];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'udhaar_contacts';
  @override
  VerificationContext validateIntegrity(
    Insertable<UdhaarContact> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UdhaarContact map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UdhaarContact(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
    );
  }

  @override
  $UdhaarContactsTable createAlias(String alias) {
    return $UdhaarContactsTable(attachedDatabase, alias);
  }
}

class UdhaarContact extends DataClass implements Insertable<UdhaarContact> {
  final int id;

  /// Display name of the person.
  final String name;

  /// Optional phone number (used for WhatsApp reminders later).
  final String phone;
  final DateTime createdAt;

  /// `normal` (default) or `vault` — vault contacts are hidden from the
  /// normal Udhaar list and excluded from overdue checks.
  final String source;
  const UdhaarContact({
    required this.id,
    required this.name,
    required this.phone,
    required this.createdAt,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['source'] = Variable<String>(source);
    return map;
  }

  UdhaarContactsCompanion toCompanion(bool nullToAbsent) {
    return UdhaarContactsCompanion(
      id: Value(id),
      name: Value(name),
      phone: Value(phone),
      createdAt: Value(createdAt),
      source: Value(source),
    );
  }

  factory UdhaarContact.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UdhaarContact(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'source': serializer.toJson<String>(source),
    };
  }

  UdhaarContact copyWith({
    int? id,
    String? name,
    String? phone,
    DateTime? createdAt,
    String? source,
  }) => UdhaarContact(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    createdAt: createdAt ?? this.createdAt,
    source: source ?? this.source,
  );
  UdhaarContact copyWithCompanion(UdhaarContactsCompanion data) {
    return UdhaarContact(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UdhaarContact(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('createdAt: $createdAt, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, phone, createdAt, source);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UdhaarContact &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.createdAt == this.createdAt &&
          other.source == this.source);
}

class UdhaarContactsCompanion extends UpdateCompanion<UdhaarContact> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> phone;
  final Value<DateTime> createdAt;
  final Value<String> source;
  const UdhaarContactsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.source = const Value.absent(),
  });
  UdhaarContactsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    required DateTime createdAt,
    this.source = const Value.absent(),
  }) : name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<UdhaarContact> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<DateTime>? createdAt,
    Expression<String>? source,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (createdAt != null) 'created_at': createdAt,
      if (source != null) 'source': source,
    });
  }

  UdhaarContactsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? phone,
    Value<DateTime>? createdAt,
    Value<String>? source,
  }) {
    return UdhaarContactsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      source: source ?? this.source,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UdhaarContactsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('createdAt: $createdAt, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }
}

class $UdhaarEntriesTable extends UdhaarEntries
    with TableInfo<$UdhaarEntriesTable, UdhaarEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UdhaarEntriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _contactIdMeta = const VerificationMeta(
    'contactId',
  );
  @override
  late final GeneratedColumn<int> contactId = GeneratedColumn<int>(
    'contact_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES udhaar_contacts (id)',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    contactId,
    amount,
    type,
    note,
    date,
    dueDate,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'udhaar_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<UdhaarEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('contact_id')) {
      context.handle(
        _contactIdMeta,
        contactId.isAcceptableOrUnknown(data['contact_id']!, _contactIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contactIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UdhaarEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UdhaarEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      contactId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}contact_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UdhaarEntriesTable createAlias(String alias) {
    return $UdhaarEntriesTable(attachedDatabase, alias);
  }
}

class UdhaarEntry extends DataClass implements Insertable<UdhaarEntry> {
  final int id;
  final int contactId;

  /// Amount in local currency (always positive).
  final double amount;

  /// `gave`     → you gave money / they owe you  (adds to balance).
  /// `received` → you received / they paid back   (subtracts from balance).
  final String type;

  /// Optional note.
  final String note;

  /// Calendar date as `yyyy-MM-dd`.
  final String date;

  /// When a `gave` entry should be paid back (`yyyy-MM-dd`). Null when no due date was set.
  final String? dueDate;
  final DateTime createdAt;
  const UdhaarEntry({
    required this.id,
    required this.contactId,
    required this.amount,
    required this.type,
    required this.note,
    required this.date,
    this.dueDate,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['contact_id'] = Variable<int>(contactId);
    map['amount'] = Variable<double>(amount);
    map['type'] = Variable<String>(type);
    map['note'] = Variable<String>(note);
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<String>(dueDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UdhaarEntriesCompanion toCompanion(bool nullToAbsent) {
    return UdhaarEntriesCompanion(
      id: Value(id),
      contactId: Value(contactId),
      amount: Value(amount),
      type: Value(type),
      note: Value(note),
      date: Value(date),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      createdAt: Value(createdAt),
    );
  }

  factory UdhaarEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UdhaarEntry(
      id: serializer.fromJson<int>(json['id']),
      contactId: serializer.fromJson<int>(json['contactId']),
      amount: serializer.fromJson<double>(json['amount']),
      type: serializer.fromJson<String>(json['type']),
      note: serializer.fromJson<String>(json['note']),
      date: serializer.fromJson<String>(json['date']),
      dueDate: serializer.fromJson<String?>(json['dueDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'contactId': serializer.toJson<int>(contactId),
      'amount': serializer.toJson<double>(amount),
      'type': serializer.toJson<String>(type),
      'note': serializer.toJson<String>(note),
      'date': serializer.toJson<String>(date),
      'dueDate': serializer.toJson<String?>(dueDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UdhaarEntry copyWith({
    int? id,
    int? contactId,
    double? amount,
    String? type,
    String? note,
    String? date,
    Value<String?> dueDate = const Value.absent(),
    DateTime? createdAt,
  }) => UdhaarEntry(
    id: id ?? this.id,
    contactId: contactId ?? this.contactId,
    amount: amount ?? this.amount,
    type: type ?? this.type,
    note: note ?? this.note,
    date: date ?? this.date,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    createdAt: createdAt ?? this.createdAt,
  );
  UdhaarEntry copyWithCompanion(UdhaarEntriesCompanion data) {
    return UdhaarEntry(
      id: data.id.present ? data.id.value : this.id,
      contactId: data.contactId.present ? data.contactId.value : this.contactId,
      amount: data.amount.present ? data.amount.value : this.amount,
      type: data.type.present ? data.type.value : this.type,
      note: data.note.present ? data.note.value : this.note,
      date: data.date.present ? data.date.value : this.date,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UdhaarEntry(')
          ..write('id: $id, ')
          ..write('contactId: $contactId, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('note: $note, ')
          ..write('date: $date, ')
          ..write('dueDate: $dueDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, contactId, amount, type, note, date, dueDate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UdhaarEntry &&
          other.id == this.id &&
          other.contactId == this.contactId &&
          other.amount == this.amount &&
          other.type == this.type &&
          other.note == this.note &&
          other.date == this.date &&
          other.dueDate == this.dueDate &&
          other.createdAt == this.createdAt);
}

class UdhaarEntriesCompanion extends UpdateCompanion<UdhaarEntry> {
  final Value<int> id;
  final Value<int> contactId;
  final Value<double> amount;
  final Value<String> type;
  final Value<String> note;
  final Value<String> date;
  final Value<String?> dueDate;
  final Value<DateTime> createdAt;
  const UdhaarEntriesCompanion({
    this.id = const Value.absent(),
    this.contactId = const Value.absent(),
    this.amount = const Value.absent(),
    this.type = const Value.absent(),
    this.note = const Value.absent(),
    this.date = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UdhaarEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int contactId,
    required double amount,
    required String type,
    this.note = const Value.absent(),
    required String date,
    this.dueDate = const Value.absent(),
    required DateTime createdAt,
  }) : contactId = Value(contactId),
       amount = Value(amount),
       type = Value(type),
       date = Value(date),
       createdAt = Value(createdAt);
  static Insertable<UdhaarEntry> custom({
    Expression<int>? id,
    Expression<int>? contactId,
    Expression<double>? amount,
    Expression<String>? type,
    Expression<String>? note,
    Expression<String>? date,
    Expression<String>? dueDate,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (contactId != null) 'contact_id': contactId,
      if (amount != null) 'amount': amount,
      if (type != null) 'type': type,
      if (note != null) 'note': note,
      if (date != null) 'date': date,
      if (dueDate != null) 'due_date': dueDate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UdhaarEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? contactId,
    Value<double>? amount,
    Value<String>? type,
    Value<String>? note,
    Value<String>? date,
    Value<String?>? dueDate,
    Value<DateTime>? createdAt,
  }) {
    return UdhaarEntriesCompanion(
      id: id ?? this.id,
      contactId: contactId ?? this.contactId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      note: note ?? this.note,
      date: date ?? this.date,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (contactId.present) {
      map['contact_id'] = Variable<int>(contactId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(dueDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UdhaarEntriesCompanion(')
          ..write('id: $id, ')
          ..write('contactId: $contactId, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('note: $note, ')
          ..write('date: $date, ')
          ..write('dueDate: $dueDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TaskListsTable extends TaskLists
    with TableInfo<$TaskListsTable, TaskList> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskListsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#6750A4'),
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('📋'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, color, emoji, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_lists';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskList> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskList map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskList(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TaskListsTable createAlias(String alias) {
    return $TaskListsTable(attachedDatabase, alias);
  }
}

class TaskList extends DataClass implements Insertable<TaskList> {
  final int id;
  final String name;
  final String color;
  final String emoji;
  final DateTime createdAt;
  const TaskList({
    required this.id,
    required this.name,
    required this.color,
    required this.emoji,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<String>(color);
    map['emoji'] = Variable<String>(emoji);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TaskListsCompanion toCompanion(bool nullToAbsent) {
    return TaskListsCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
      emoji: Value(emoji),
      createdAt: Value(createdAt),
    );
  }

  factory TaskList.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskList(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<String>(json['color']),
      emoji: serializer.fromJson<String>(json['emoji']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<String>(color),
      'emoji': serializer.toJson<String>(emoji),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TaskList copyWith({
    int? id,
    String? name,
    String? color,
    String? emoji,
    DateTime? createdAt,
  }) => TaskList(
    id: id ?? this.id,
    name: name ?? this.name,
    color: color ?? this.color,
    emoji: emoji ?? this.emoji,
    createdAt: createdAt ?? this.createdAt,
  );
  TaskList copyWithCompanion(TaskListsCompanion data) {
    return TaskList(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskList(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('emoji: $emoji, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color, emoji, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskList &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.emoji == this.emoji &&
          other.createdAt == this.createdAt);
}

class TaskListsCompanion extends UpdateCompanion<TaskList> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> color;
  final Value<String> emoji;
  final Value<DateTime> createdAt;
  const TaskListsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.emoji = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TaskListsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.color = const Value.absent(),
    this.emoji = const Value.absent(),
    required DateTime createdAt,
  }) : name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<TaskList> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? color,
    Expression<String>? emoji,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (emoji != null) 'emoji': emoji,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TaskListsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? color,
    Value<String>? emoji,
    Value<DateTime>? createdAt,
  }) {
    return TaskListsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      emoji: emoji ?? this.emoji,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskListsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('emoji: $emoji, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueTimeMeta = const VerificationMeta(
    'dueTime',
  );
  @override
  late final GeneratedColumn<String> dueTime = GeneratedColumn<String>(
    'due_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recurrenceMeta = const VerificationMeta(
    'recurrence',
  );
  @override
  late final GeneratedColumn<String> recurrence = GeneratedColumn<String>(
    'recurrence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<int> listId = GeneratedColumn<int>(
    'list_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remindBeforeMeta = const VerificationMeta(
    'remindBefore',
  );
  @override
  late final GeneratedColumn<int> remindBefore = GeneratedColumn<int>(
    'remind_before',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _prayerAnchorMeta = const VerificationMeta(
    'prayerAnchor',
  );
  @override
  late final GeneratedColumn<String> prayerAnchor = GeneratedColumn<String>(
    'prayer_anchor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _prayerOffsetMeta = const VerificationMeta(
    'prayerOffset',
  );
  @override
  late final GeneratedColumn<int> prayerOffset = GeneratedColumn<int>(
    'prayer_offset',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _billCategoryMeta = const VerificationMeta(
    'billCategory',
  );
  @override
  late final GeneratedColumn<String> billCategory = GeneratedColumn<String>(
    'bill_category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    dueDate,
    dueTime,
    priority,
    isCompleted,
    completedAt,
    recurrence,
    note,
    listId,
    remindBefore,
    prayerAnchor,
    prayerOffset,
    amount,
    billCategory,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Task> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('due_time')) {
      context.handle(
        _dueTimeMeta,
        dueTime.isAcceptableOrUnknown(data['due_time']!, _dueTimeMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('recurrence')) {
      context.handle(
        _recurrenceMeta,
        recurrence.isAcceptableOrUnknown(data['recurrence']!, _recurrenceMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('list_id')) {
      context.handle(
        _listIdMeta,
        listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta),
      );
    }
    if (data.containsKey('remind_before')) {
      context.handle(
        _remindBeforeMeta,
        remindBefore.isAcceptableOrUnknown(
          data['remind_before']!,
          _remindBeforeMeta,
        ),
      );
    }
    if (data.containsKey('prayer_anchor')) {
      context.handle(
        _prayerAnchorMeta,
        prayerAnchor.isAcceptableOrUnknown(
          data['prayer_anchor']!,
          _prayerAnchorMeta,
        ),
      );
    }
    if (data.containsKey('prayer_offset')) {
      context.handle(
        _prayerOffsetMeta,
        prayerOffset.isAcceptableOrUnknown(
          data['prayer_offset']!,
          _prayerOffsetMeta,
        ),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('bill_category')) {
      context.handle(
        _billCategoryMeta,
        billCategory.isAcceptableOrUnknown(
          data['bill_category']!,
          _billCategoryMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_date'],
      ),
      dueTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_time'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      recurrence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurrence'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      listId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}list_id'],
      ),
      remindBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remind_before'],
      )!,
      prayerAnchor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prayer_anchor'],
      ),
      prayerOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prayer_offset'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      ),
      billCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bill_category'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class Task extends DataClass implements Insertable<Task> {
  final int id;
  final String title;

  /// `yyyy-MM-dd` or null for tasks with no specific date.
  final String? dueDate;

  /// `HH:mm` or null — notification fires at this time on [dueDate].
  final String? dueTime;

  /// `high` or `normal`.
  final String priority;
  final bool isCompleted;
  final DateTime? completedAt;

  /// `none` | `daily` | `weekly` | `monthly`.
  final String recurrence;

  /// Optional description / sub-tasks note.
  final String note;

  /// Optional list this task belongs to.
  final int? listId;

  /// Minutes before the due time to remind as well (0 = only at the due time).
  final int remindBefore;

  /// A prayer (`fajr`, `dhuhr`, `asr`, `maghrib`, `isha`) the due time follows, or null.
  final String? prayerAnchor;

  /// Minutes after the anchored prayer (negative = before it).
  final int prayerOffset;

  /// Bill amount: finishing the task offers to add it to the Khata.
  final double? amount;

  /// Khata category for [amount] (an `ExpenseCategory` name).
  final String? billCategory;
  final DateTime createdAt;
  const Task({
    required this.id,
    required this.title,
    this.dueDate,
    this.dueTime,
    required this.priority,
    required this.isCompleted,
    this.completedAt,
    required this.recurrence,
    required this.note,
    this.listId,
    required this.remindBefore,
    this.prayerAnchor,
    required this.prayerOffset,
    this.amount,
    this.billCategory,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<String>(dueDate);
    }
    if (!nullToAbsent || dueTime != null) {
      map['due_time'] = Variable<String>(dueTime);
    }
    map['priority'] = Variable<String>(priority);
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['recurrence'] = Variable<String>(recurrence);
    map['note'] = Variable<String>(note);
    if (!nullToAbsent || listId != null) {
      map['list_id'] = Variable<int>(listId);
    }
    map['remind_before'] = Variable<int>(remindBefore);
    if (!nullToAbsent || prayerAnchor != null) {
      map['prayer_anchor'] = Variable<String>(prayerAnchor);
    }
    map['prayer_offset'] = Variable<int>(prayerOffset);
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    if (!nullToAbsent || billCategory != null) {
      map['bill_category'] = Variable<String>(billCategory);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      title: Value(title),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      dueTime: dueTime == null && nullToAbsent
          ? const Value.absent()
          : Value(dueTime),
      priority: Value(priority),
      isCompleted: Value(isCompleted),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      recurrence: Value(recurrence),
      note: Value(note),
      listId: listId == null && nullToAbsent
          ? const Value.absent()
          : Value(listId),
      remindBefore: Value(remindBefore),
      prayerAnchor: prayerAnchor == null && nullToAbsent
          ? const Value.absent()
          : Value(prayerAnchor),
      prayerOffset: Value(prayerOffset),
      amount: amount == null && nullToAbsent
          ? const Value.absent()
          : Value(amount),
      billCategory: billCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(billCategory),
      createdAt: Value(createdAt),
    );
  }

  factory Task.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      dueDate: serializer.fromJson<String?>(json['dueDate']),
      dueTime: serializer.fromJson<String?>(json['dueTime']),
      priority: serializer.fromJson<String>(json['priority']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      recurrence: serializer.fromJson<String>(json['recurrence']),
      note: serializer.fromJson<String>(json['note']),
      listId: serializer.fromJson<int?>(json['listId']),
      remindBefore: serializer.fromJson<int>(json['remindBefore']),
      prayerAnchor: serializer.fromJson<String?>(json['prayerAnchor']),
      prayerOffset: serializer.fromJson<int>(json['prayerOffset']),
      amount: serializer.fromJson<double?>(json['amount']),
      billCategory: serializer.fromJson<String?>(json['billCategory']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'dueDate': serializer.toJson<String?>(dueDate),
      'dueTime': serializer.toJson<String?>(dueTime),
      'priority': serializer.toJson<String>(priority),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'recurrence': serializer.toJson<String>(recurrence),
      'note': serializer.toJson<String>(note),
      'listId': serializer.toJson<int?>(listId),
      'remindBefore': serializer.toJson<int>(remindBefore),
      'prayerAnchor': serializer.toJson<String?>(prayerAnchor),
      'prayerOffset': serializer.toJson<int>(prayerOffset),
      'amount': serializer.toJson<double?>(amount),
      'billCategory': serializer.toJson<String?>(billCategory),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Task copyWith({
    int? id,
    String? title,
    Value<String?> dueDate = const Value.absent(),
    Value<String?> dueTime = const Value.absent(),
    String? priority,
    bool? isCompleted,
    Value<DateTime?> completedAt = const Value.absent(),
    String? recurrence,
    String? note,
    Value<int?> listId = const Value.absent(),
    int? remindBefore,
    Value<String?> prayerAnchor = const Value.absent(),
    int? prayerOffset,
    Value<double?> amount = const Value.absent(),
    Value<String?> billCategory = const Value.absent(),
    DateTime? createdAt,
  }) => Task(
    id: id ?? this.id,
    title: title ?? this.title,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    dueTime: dueTime.present ? dueTime.value : this.dueTime,
    priority: priority ?? this.priority,
    isCompleted: isCompleted ?? this.isCompleted,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    recurrence: recurrence ?? this.recurrence,
    note: note ?? this.note,
    listId: listId.present ? listId.value : this.listId,
    remindBefore: remindBefore ?? this.remindBefore,
    prayerAnchor: prayerAnchor.present ? prayerAnchor.value : this.prayerAnchor,
    prayerOffset: prayerOffset ?? this.prayerOffset,
    amount: amount.present ? amount.value : this.amount,
    billCategory: billCategory.present ? billCategory.value : this.billCategory,
    createdAt: createdAt ?? this.createdAt,
  );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      dueTime: data.dueTime.present ? data.dueTime.value : this.dueTime,
      priority: data.priority.present ? data.priority.value : this.priority,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      recurrence: data.recurrence.present
          ? data.recurrence.value
          : this.recurrence,
      note: data.note.present ? data.note.value : this.note,
      listId: data.listId.present ? data.listId.value : this.listId,
      remindBefore: data.remindBefore.present
          ? data.remindBefore.value
          : this.remindBefore,
      prayerAnchor: data.prayerAnchor.present
          ? data.prayerAnchor.value
          : this.prayerAnchor,
      prayerOffset: data.prayerOffset.present
          ? data.prayerOffset.value
          : this.prayerOffset,
      amount: data.amount.present ? data.amount.value : this.amount,
      billCategory: data.billCategory.present
          ? data.billCategory.value
          : this.billCategory,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueTime: $dueTime, ')
          ..write('priority: $priority, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('recurrence: $recurrence, ')
          ..write('note: $note, ')
          ..write('listId: $listId, ')
          ..write('remindBefore: $remindBefore, ')
          ..write('prayerAnchor: $prayerAnchor, ')
          ..write('prayerOffset: $prayerOffset, ')
          ..write('amount: $amount, ')
          ..write('billCategory: $billCategory, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    dueDate,
    dueTime,
    priority,
    isCompleted,
    completedAt,
    recurrence,
    note,
    listId,
    remindBefore,
    prayerAnchor,
    prayerOffset,
    amount,
    billCategory,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.title == this.title &&
          other.dueDate == this.dueDate &&
          other.dueTime == this.dueTime &&
          other.priority == this.priority &&
          other.isCompleted == this.isCompleted &&
          other.completedAt == this.completedAt &&
          other.recurrence == this.recurrence &&
          other.note == this.note &&
          other.listId == this.listId &&
          other.remindBefore == this.remindBefore &&
          other.prayerAnchor == this.prayerAnchor &&
          other.prayerOffset == this.prayerOffset &&
          other.amount == this.amount &&
          other.billCategory == this.billCategory &&
          other.createdAt == this.createdAt);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> dueDate;
  final Value<String?> dueTime;
  final Value<String> priority;
  final Value<bool> isCompleted;
  final Value<DateTime?> completedAt;
  final Value<String> recurrence;
  final Value<String> note;
  final Value<int?> listId;
  final Value<int> remindBefore;
  final Value<String?> prayerAnchor;
  final Value<int> prayerOffset;
  final Value<double?> amount;
  final Value<String?> billCategory;
  final Value<DateTime> createdAt;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueTime = const Value.absent(),
    this.priority = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.note = const Value.absent(),
    this.listId = const Value.absent(),
    this.remindBefore = const Value.absent(),
    this.prayerAnchor = const Value.absent(),
    this.prayerOffset = const Value.absent(),
    this.amount = const Value.absent(),
    this.billCategory = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.dueDate = const Value.absent(),
    this.dueTime = const Value.absent(),
    this.priority = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.note = const Value.absent(),
    this.listId = const Value.absent(),
    this.remindBefore = const Value.absent(),
    this.prayerAnchor = const Value.absent(),
    this.prayerOffset = const Value.absent(),
    this.amount = const Value.absent(),
    this.billCategory = const Value.absent(),
    required DateTime createdAt,
  }) : title = Value(title),
       createdAt = Value(createdAt);
  static Insertable<Task> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? dueDate,
    Expression<String>? dueTime,
    Expression<String>? priority,
    Expression<bool>? isCompleted,
    Expression<DateTime>? completedAt,
    Expression<String>? recurrence,
    Expression<String>? note,
    Expression<int>? listId,
    Expression<int>? remindBefore,
    Expression<String>? prayerAnchor,
    Expression<int>? prayerOffset,
    Expression<double>? amount,
    Expression<String>? billCategory,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (dueDate != null) 'due_date': dueDate,
      if (dueTime != null) 'due_time': dueTime,
      if (priority != null) 'priority': priority,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (completedAt != null) 'completed_at': completedAt,
      if (recurrence != null) 'recurrence': recurrence,
      if (note != null) 'note': note,
      if (listId != null) 'list_id': listId,
      if (remindBefore != null) 'remind_before': remindBefore,
      if (prayerAnchor != null) 'prayer_anchor': prayerAnchor,
      if (prayerOffset != null) 'prayer_offset': prayerOffset,
      if (amount != null) 'amount': amount,
      if (billCategory != null) 'bill_category': billCategory,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TasksCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String?>? dueDate,
    Value<String?>? dueTime,
    Value<String>? priority,
    Value<bool>? isCompleted,
    Value<DateTime?>? completedAt,
    Value<String>? recurrence,
    Value<String>? note,
    Value<int?>? listId,
    Value<int>? remindBefore,
    Value<String?>? prayerAnchor,
    Value<int>? prayerOffset,
    Value<double?>? amount,
    Value<String?>? billCategory,
    Value<DateTime>? createdAt,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      recurrence: recurrence ?? this.recurrence,
      note: note ?? this.note,
      listId: listId ?? this.listId,
      remindBefore: remindBefore ?? this.remindBefore,
      prayerAnchor: prayerAnchor ?? this.prayerAnchor,
      prayerOffset: prayerOffset ?? this.prayerOffset,
      amount: amount ?? this.amount,
      billCategory: billCategory ?? this.billCategory,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(dueDate.value);
    }
    if (dueTime.present) {
      map['due_time'] = Variable<String>(dueTime.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (recurrence.present) {
      map['recurrence'] = Variable<String>(recurrence.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<int>(listId.value);
    }
    if (remindBefore.present) {
      map['remind_before'] = Variable<int>(remindBefore.value);
    }
    if (prayerAnchor.present) {
      map['prayer_anchor'] = Variable<String>(prayerAnchor.value);
    }
    if (prayerOffset.present) {
      map['prayer_offset'] = Variable<int>(prayerOffset.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (billCategory.present) {
      map['bill_category'] = Variable<String>(billCategory.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueTime: $dueTime, ')
          ..write('priority: $priority, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('recurrence: $recurrence, ')
          ..write('note: $note, ')
          ..write('listId: $listId, ')
          ..write('remindBefore: $remindBefore, ')
          ..write('prayerAnchor: $prayerAnchor, ')
          ..write('prayerOffset: $prayerOffset, ')
          ..write('amount: $amount, ')
          ..write('billCategory: $billCategory, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $RecurringExpensesTable extends RecurringExpenses
    with TableInfo<$RecurringExpensesTable, RecurringExpense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringExpensesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('expense'),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextDueMeta = const VerificationMeta(
    'nextDue',
  );
  @override
  late final GeneratedColumn<String> nextDue = GeneratedColumn<String>(
    'next_due',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anchorDayMeta = const VerificationMeta(
    'anchorDay',
  );
  @override
  late final GeneratedColumn<int> anchorDay = GeneratedColumn<int>(
    'anchor_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amount,
    category,
    type,
    note,
    frequency,
    nextDue,
    anchorDay,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecurringExpense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('next_due')) {
      context.handle(
        _nextDueMeta,
        nextDue.isAcceptableOrUnknown(data['next_due']!, _nextDueMeta),
      );
    } else if (isInserting) {
      context.missing(_nextDueMeta);
    }
    if (data.containsKey('anchor_day')) {
      context.handle(
        _anchorDayMeta,
        anchorDay.isAcceptableOrUnknown(data['anchor_day']!, _anchorDayMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringExpense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringExpense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      nextDue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}next_due'],
      )!,
      anchorDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}anchor_day'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RecurringExpensesTable createAlias(String alias) {
    return $RecurringExpensesTable(attachedDatabase, alias);
  }
}

class RecurringExpense extends DataClass
    implements Insertable<RecurringExpense> {
  final int id;
  final double amount;
  final String category;
  final String type;
  final String note;
  final String frequency;
  final String nextDue;

  /// Day of the month the rule was created on (0 = unknown). Lets a rule created on
  /// the 31st fire on the 28th in February and go back to the 31st afterwards.
  final int anchorDay;
  final DateTime createdAt;
  const RecurringExpense({
    required this.id,
    required this.amount,
    required this.category,
    required this.type,
    required this.note,
    required this.frequency,
    required this.nextDue,
    required this.anchorDay,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount'] = Variable<double>(amount);
    map['category'] = Variable<String>(category);
    map['type'] = Variable<String>(type);
    map['note'] = Variable<String>(note);
    map['frequency'] = Variable<String>(frequency);
    map['next_due'] = Variable<String>(nextDue);
    map['anchor_day'] = Variable<int>(anchorDay);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RecurringExpensesCompanion toCompanion(bool nullToAbsent) {
    return RecurringExpensesCompanion(
      id: Value(id),
      amount: Value(amount),
      category: Value(category),
      type: Value(type),
      note: Value(note),
      frequency: Value(frequency),
      nextDue: Value(nextDue),
      anchorDay: Value(anchorDay),
      createdAt: Value(createdAt),
    );
  }

  factory RecurringExpense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringExpense(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      category: serializer.fromJson<String>(json['category']),
      type: serializer.fromJson<String>(json['type']),
      note: serializer.fromJson<String>(json['note']),
      frequency: serializer.fromJson<String>(json['frequency']),
      nextDue: serializer.fromJson<String>(json['nextDue']),
      anchorDay: serializer.fromJson<int>(json['anchorDay']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<double>(amount),
      'category': serializer.toJson<String>(category),
      'type': serializer.toJson<String>(type),
      'note': serializer.toJson<String>(note),
      'frequency': serializer.toJson<String>(frequency),
      'nextDue': serializer.toJson<String>(nextDue),
      'anchorDay': serializer.toJson<int>(anchorDay),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RecurringExpense copyWith({
    int? id,
    double? amount,
    String? category,
    String? type,
    String? note,
    String? frequency,
    String? nextDue,
    int? anchorDay,
    DateTime? createdAt,
  }) => RecurringExpense(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    category: category ?? this.category,
    type: type ?? this.type,
    note: note ?? this.note,
    frequency: frequency ?? this.frequency,
    nextDue: nextDue ?? this.nextDue,
    anchorDay: anchorDay ?? this.anchorDay,
    createdAt: createdAt ?? this.createdAt,
  );
  RecurringExpense copyWithCompanion(RecurringExpensesCompanion data) {
    return RecurringExpense(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      category: data.category.present ? data.category.value : this.category,
      type: data.type.present ? data.type.value : this.type,
      note: data.note.present ? data.note.value : this.note,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      nextDue: data.nextDue.present ? data.nextDue.value : this.nextDue,
      anchorDay: data.anchorDay.present ? data.anchorDay.value : this.anchorDay,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringExpense(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('type: $type, ')
          ..write('note: $note, ')
          ..write('frequency: $frequency, ')
          ..write('nextDue: $nextDue, ')
          ..write('anchorDay: $anchorDay, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    amount,
    category,
    type,
    note,
    frequency,
    nextDue,
    anchorDay,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringExpense &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.category == this.category &&
          other.type == this.type &&
          other.note == this.note &&
          other.frequency == this.frequency &&
          other.nextDue == this.nextDue &&
          other.anchorDay == this.anchorDay &&
          other.createdAt == this.createdAt);
}

class RecurringExpensesCompanion extends UpdateCompanion<RecurringExpense> {
  final Value<int> id;
  final Value<double> amount;
  final Value<String> category;
  final Value<String> type;
  final Value<String> note;
  final Value<String> frequency;
  final Value<String> nextDue;
  final Value<int> anchorDay;
  final Value<DateTime> createdAt;
  const RecurringExpensesCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.category = const Value.absent(),
    this.type = const Value.absent(),
    this.note = const Value.absent(),
    this.frequency = const Value.absent(),
    this.nextDue = const Value.absent(),
    this.anchorDay = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RecurringExpensesCompanion.insert({
    this.id = const Value.absent(),
    required double amount,
    required String category,
    this.type = const Value.absent(),
    this.note = const Value.absent(),
    required String frequency,
    required String nextDue,
    this.anchorDay = const Value.absent(),
    required DateTime createdAt,
  }) : amount = Value(amount),
       category = Value(category),
       frequency = Value(frequency),
       nextDue = Value(nextDue),
       createdAt = Value(createdAt);
  static Insertable<RecurringExpense> custom({
    Expression<int>? id,
    Expression<double>? amount,
    Expression<String>? category,
    Expression<String>? type,
    Expression<String>? note,
    Expression<String>? frequency,
    Expression<String>? nextDue,
    Expression<int>? anchorDay,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (category != null) 'category': category,
      if (type != null) 'type': type,
      if (note != null) 'note': note,
      if (frequency != null) 'frequency': frequency,
      if (nextDue != null) 'next_due': nextDue,
      if (anchorDay != null) 'anchor_day': anchorDay,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RecurringExpensesCompanion copyWith({
    Value<int>? id,
    Value<double>? amount,
    Value<String>? category,
    Value<String>? type,
    Value<String>? note,
    Value<String>? frequency,
    Value<String>? nextDue,
    Value<int>? anchorDay,
    Value<DateTime>? createdAt,
  }) {
    return RecurringExpensesCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      type: type ?? this.type,
      note: note ?? this.note,
      frequency: frequency ?? this.frequency,
      nextDue: nextDue ?? this.nextDue,
      anchorDay: anchorDay ?? this.anchorDay,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (nextDue.present) {
      map['next_due'] = Variable<String>(nextDue.value);
    }
    if (anchorDay.present) {
      map['anchor_day'] = Variable<int>(anchorDay.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringExpensesCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('type: $type, ')
          ..write('note: $note, ')
          ..write('frequency: $frequency, ')
          ..write('nextDue: $nextDue, ')
          ..write('anchorDay: $anchorDay, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('cash'),
  );
  static const VerificationMeta _openingBalanceMeta = const VerificationMeta(
    'openingBalance',
  );
  @override
  late final GeneratedColumn<double> openingBalance = GeneratedColumn<double>(
    'opening_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    kind,
    openingBalance,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Account> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('opening_balance')) {
      context.handle(
        _openingBalanceMeta,
        openingBalance.isAcceptableOrUnknown(
          data['opening_balance']!,
          _openingBalanceMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      openingBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}opening_balance'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class Account extends DataClass implements Insertable<Account> {
  final int id;
  final String name;

  /// `cash` | `bank` | `wallet`.
  final String kind;
  final double openingBalance;
  final DateTime createdAt;
  const Account({
    required this.id,
    required this.name,
    required this.kind,
    required this.openingBalance,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['kind'] = Variable<String>(kind);
    map['opening_balance'] = Variable<double>(openingBalance);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      name: Value(name),
      kind: Value(kind),
      openingBalance: Value(openingBalance),
      createdAt: Value(createdAt),
    );
  }

  factory Account.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      kind: serializer.fromJson<String>(json['kind']),
      openingBalance: serializer.fromJson<double>(json['openingBalance']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>(kind),
      'openingBalance': serializer.toJson<double>(openingBalance),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Account copyWith({
    int? id,
    String? name,
    String? kind,
    double? openingBalance,
    DateTime? createdAt,
  }) => Account(
    id: id ?? this.id,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    openingBalance: openingBalance ?? this.openingBalance,
    createdAt: createdAt ?? this.createdAt,
  );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      openingBalance: data.openingBalance.present
          ? data.openingBalance.value
          : this.openingBalance,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, kind, openingBalance, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.openingBalance == this.openingBalance &&
          other.createdAt == this.createdAt);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> kind;
  final Value<double> openingBalance;
  final Value<DateTime> createdAt;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.openingBalance = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.kind = const Value.absent(),
    this.openingBalance = const Value.absent(),
    required DateTime createdAt,
  }) : name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<Account> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<double>? openingBalance,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (openingBalance != null) 'opening_balance': openingBalance,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AccountsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? kind,
    Value<double>? openingBalance,
    Value<DateTime>? createdAt,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      openingBalance: openingBalance ?? this.openingBalance,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (openingBalance.present) {
      map['opening_balance'] = Variable<double>(openingBalance.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SavingsGoalsTable extends SavingsGoals
    with TableInfo<$SavingsGoalsTable, SavingsGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsGoalsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<double> target = GeneratedColumn<double>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savedMeta = const VerificationMeta('saved');
  @override
  late final GeneratedColumn<double> saved = GeneratedColumn<double>(
    'saved',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _deadlineMeta = const VerificationMeta(
    'deadline',
  );
  @override
  late final GeneratedColumn<String> deadline = GeneratedColumn<String>(
    'deadline',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    target,
    saved,
    deadline,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingsGoal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target')) {
      context.handle(
        _targetMeta,
        target.isAcceptableOrUnknown(data['target']!, _targetMeta),
      );
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('saved')) {
      context.handle(
        _savedMeta,
        saved.isAcceptableOrUnknown(data['saved']!, _savedMeta),
      );
    }
    if (data.containsKey('deadline')) {
      context.handle(
        _deadlineMeta,
        deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsGoal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      target: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target'],
      )!,
      saved: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}saved'],
      )!,
      deadline: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deadline'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SavingsGoalsTable createAlias(String alias) {
    return $SavingsGoalsTable(attachedDatabase, alias);
  }
}

class SavingsGoal extends DataClass implements Insertable<SavingsGoal> {
  final int id;
  final String name;
  final double target;
  final double saved;

  /// `yyyy-MM-dd` or null.
  final String? deadline;
  final DateTime createdAt;
  const SavingsGoal({
    required this.id,
    required this.name,
    required this.target,
    required this.saved,
    this.deadline,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['target'] = Variable<double>(target);
    map['saved'] = Variable<double>(saved);
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<String>(deadline);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SavingsGoalsCompanion toCompanion(bool nullToAbsent) {
    return SavingsGoalsCompanion(
      id: Value(id),
      name: Value(name),
      target: Value(target),
      saved: Value(saved),
      deadline: deadline == null && nullToAbsent
          ? const Value.absent()
          : Value(deadline),
      createdAt: Value(createdAt),
    );
  }

  factory SavingsGoal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsGoal(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      target: serializer.fromJson<double>(json['target']),
      saved: serializer.fromJson<double>(json['saved']),
      deadline: serializer.fromJson<String?>(json['deadline']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'target': serializer.toJson<double>(target),
      'saved': serializer.toJson<double>(saved),
      'deadline': serializer.toJson<String?>(deadline),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SavingsGoal copyWith({
    int? id,
    String? name,
    double? target,
    double? saved,
    Value<String?> deadline = const Value.absent(),
    DateTime? createdAt,
  }) => SavingsGoal(
    id: id ?? this.id,
    name: name ?? this.name,
    target: target ?? this.target,
    saved: saved ?? this.saved,
    deadline: deadline.present ? deadline.value : this.deadline,
    createdAt: createdAt ?? this.createdAt,
  );
  SavingsGoal copyWithCompanion(SavingsGoalsCompanion data) {
    return SavingsGoal(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      target: data.target.present ? data.target.value : this.target,
      saved: data.saved.present ? data.saved.value : this.saved,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoal(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('target: $target, ')
          ..write('saved: $saved, ')
          ..write('deadline: $deadline, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, target, saved, deadline, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsGoal &&
          other.id == this.id &&
          other.name == this.name &&
          other.target == this.target &&
          other.saved == this.saved &&
          other.deadline == this.deadline &&
          other.createdAt == this.createdAt);
}

class SavingsGoalsCompanion extends UpdateCompanion<SavingsGoal> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> target;
  final Value<double> saved;
  final Value<String?> deadline;
  final Value<DateTime> createdAt;
  const SavingsGoalsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.target = const Value.absent(),
    this.saved = const Value.absent(),
    this.deadline = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SavingsGoalsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double target,
    this.saved = const Value.absent(),
    this.deadline = const Value.absent(),
    required DateTime createdAt,
  }) : name = Value(name),
       target = Value(target),
       createdAt = Value(createdAt);
  static Insertable<SavingsGoal> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? target,
    Expression<double>? saved,
    Expression<String>? deadline,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (target != null) 'target': target,
      if (saved != null) 'saved': saved,
      if (deadline != null) 'deadline': deadline,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SavingsGoalsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? target,
    Value<double>? saved,
    Value<String?>? deadline,
    Value<DateTime>? createdAt,
  }) {
    return SavingsGoalsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      target: target ?? this.target,
      saved: saved ?? this.saved,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (target.present) {
      map['target'] = Variable<double>(target.value);
    }
    if (saved.present) {
      map['saved'] = Variable<double>(saved.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<String>(deadline.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoalsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('target: $target, ')
          ..write('saved: $saved, ')
          ..write('deadline: $deadline, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FastLogsTable extends FastLogs with TableInfo<$FastLogsTable, FastLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FastLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fast_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<FastLog> instance, {
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
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {date},
  ];
  @override
  FastLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FastLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $FastLogsTable createAlias(String alias) {
    return $FastLogsTable(attachedDatabase, alias);
  }
}

class FastLog extends DataClass implements Insertable<FastLog> {
  final int id;

  /// Calendar date as `yyyy-MM-dd`.
  final String date;

  /// `kept` | `missed` | `made_up` (a missed fast kept on another day).
  final String status;
  const FastLog({required this.id, required this.date, required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['status'] = Variable<String>(status);
    return map;
  }

  FastLogsCompanion toCompanion(bool nullToAbsent) {
    return FastLogsCompanion(
      id: Value(id),
      date: Value(date),
      status: Value(status),
    );
  }

  factory FastLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FastLog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'status': serializer.toJson<String>(status),
    };
  }

  FastLog copyWith({int? id, String? date, String? status}) => FastLog(
    id: id ?? this.id,
    date: date ?? this.date,
    status: status ?? this.status,
  );
  FastLog copyWithCompanion(FastLogsCompanion data) {
    return FastLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FastLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FastLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.status == this.status);
}

class FastLogsCompanion extends UpdateCompanion<FastLog> {
  final Value<int> id;
  final Value<String> date;
  final Value<String> status;
  const FastLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.status = const Value.absent(),
  });
  FastLogsCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required String status,
  }) : date = Value(date),
       status = Value(status);
  static Insertable<FastLog> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (status != null) 'status': status,
    });
  }

  FastLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? date,
    Value<String>? status,
  }) {
    return FastLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      status: status ?? this.status,
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
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FastLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('status: $status')
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
  late final $PauseRangesTable pauseRanges = $PauseRangesTable(this);
  late final $QazaBalanceTable qazaBalance = $QazaBalanceTable(this);
  late final $QazaHistoryTable qazaHistory = $QazaHistoryTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $UdhaarContactsTable udhaarContacts = $UdhaarContactsTable(this);
  late final $UdhaarEntriesTable udhaarEntries = $UdhaarEntriesTable(this);
  late final $TaskListsTable taskLists = $TaskListsTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $RecurringExpensesTable recurringExpenses =
      $RecurringExpensesTable(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $SavingsGoalsTable savingsGoals = $SavingsGoalsTable(this);
  late final $FastLogsTable fastLogs = $FastLogsTable(this);
  late final PrayerLogsDao prayerLogsDao = PrayerLogsDao(this as AppDatabase);
  late final SettingsHistoryDao settingsHistoryDao = SettingsHistoryDao(
    this as AppDatabase,
  );
  late final PauseRangesDao pauseRangesDao = PauseRangesDao(
    this as AppDatabase,
  );
  late final QazaDao qazaDao = QazaDao(this as AppDatabase);
  late final ExpensesDao expensesDao = ExpensesDao(this as AppDatabase);
  late final UdhaarDao udhaarDao = UdhaarDao(this as AppDatabase);
  late final TaskListsDao taskListsDao = TaskListsDao(this as AppDatabase);
  late final TasksDao tasksDao = TasksDao(this as AppDatabase);
  late final RecurringExpensesDao recurringExpensesDao = RecurringExpensesDao(
    this as AppDatabase,
  );
  late final AccountsDao accountsDao = AccountsDao(this as AppDatabase);
  late final SavingsGoalsDao savingsGoalsDao = SavingsGoalsDao(
    this as AppDatabase,
  );
  late final FastLogsDao fastLogsDao = FastLogsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    prayerLogs,
    settingsHistory,
    pauseRanges,
    qazaBalance,
    qazaHistory,
    expenses,
    udhaarContacts,
    udhaarEntries,
    taskLists,
    tasks,
    recurringExpenses,
    accounts,
    savingsGoals,
    fastLogs,
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
typedef $$PauseRangesTableCreateCompanionBuilder =
    PauseRangesCompanion Function({
      Value<int> id,
      required String startDate,
      Value<String?> endDate,
    });
typedef $$PauseRangesTableUpdateCompanionBuilder =
    PauseRangesCompanion Function({
      Value<int> id,
      Value<String> startDate,
      Value<String?> endDate,
    });

class $$PauseRangesTableFilterComposer
    extends Composer<_$AppDatabase, $PauseRangesTable> {
  $$PauseRangesTableFilterComposer({
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

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PauseRangesTableOrderingComposer
    extends Composer<_$AppDatabase, $PauseRangesTable> {
  $$PauseRangesTableOrderingComposer({
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

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PauseRangesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PauseRangesTable> {
  $$PauseRangesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);
}

class $$PauseRangesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PauseRangesTable,
          PauseRow,
          $$PauseRangesTableFilterComposer,
          $$PauseRangesTableOrderingComposer,
          $$PauseRangesTableAnnotationComposer,
          $$PauseRangesTableCreateCompanionBuilder,
          $$PauseRangesTableUpdateCompanionBuilder,
          (
            PauseRow,
            BaseReferences<_$AppDatabase, $PauseRangesTable, PauseRow>,
          ),
          PauseRow,
          PrefetchHooks Function()
        > {
  $$PauseRangesTableTableManager(_$AppDatabase db, $PauseRangesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PauseRangesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PauseRangesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PauseRangesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> startDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
              }) => PauseRangesCompanion(
                id: id,
                startDate: startDate,
                endDate: endDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String startDate,
                Value<String?> endDate = const Value.absent(),
              }) => PauseRangesCompanion.insert(
                id: id,
                startDate: startDate,
                endDate: endDate,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PauseRangesTable, PauseRow>(table),
                  BaseReferences<_$AppDatabase, $PauseRangesTable, PauseRow>(
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

typedef $$PauseRangesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PauseRangesTable,
      PauseRow,
      $$PauseRangesTableFilterComposer,
      $$PauseRangesTableOrderingComposer,
      $$PauseRangesTableAnnotationComposer,
      $$PauseRangesTableCreateCompanionBuilder,
      $$PauseRangesTableUpdateCompanionBuilder,
      (PauseRow, BaseReferences<_$AppDatabase, $PauseRangesTable, PauseRow>),
      PauseRow,
      PrefetchHooks Function()
    >;
typedef $$QazaBalanceTableCreateCompanionBuilder =
    QazaBalanceCompanion Function({
      required String prayer,
      Value<int> owed,
      Value<int> rowid,
    });
typedef $$QazaBalanceTableUpdateCompanionBuilder =
    QazaBalanceCompanion Function({
      Value<String> prayer,
      Value<int> owed,
      Value<int> rowid,
    });

class $$QazaBalanceTableFilterComposer
    extends Composer<_$AppDatabase, $QazaBalanceTable> {
  $$QazaBalanceTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get prayer => $composableBuilder(
    column: $table.prayer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get owed => $composableBuilder(
    column: $table.owed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QazaBalanceTableOrderingComposer
    extends Composer<_$AppDatabase, $QazaBalanceTable> {
  $$QazaBalanceTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get prayer => $composableBuilder(
    column: $table.prayer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get owed => $composableBuilder(
    column: $table.owed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QazaBalanceTableAnnotationComposer
    extends Composer<_$AppDatabase, $QazaBalanceTable> {
  $$QazaBalanceTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get prayer =>
      $composableBuilder(column: $table.prayer, builder: (column) => column);

  GeneratedColumn<int> get owed =>
      $composableBuilder(column: $table.owed, builder: (column) => column);
}

class $$QazaBalanceTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QazaBalanceTable,
          QazaBalanceData,
          $$QazaBalanceTableFilterComposer,
          $$QazaBalanceTableOrderingComposer,
          $$QazaBalanceTableAnnotationComposer,
          $$QazaBalanceTableCreateCompanionBuilder,
          $$QazaBalanceTableUpdateCompanionBuilder,
          (
            QazaBalanceData,
            BaseReferences<_$AppDatabase, $QazaBalanceTable, QazaBalanceData>,
          ),
          QazaBalanceData,
          PrefetchHooks Function()
        > {
  $$QazaBalanceTableTableManager(_$AppDatabase db, $QazaBalanceTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QazaBalanceTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QazaBalanceTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QazaBalanceTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> prayer = const Value.absent(),
            Value<int> owed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => QazaBalanceCompanion(prayer: prayer, owed: owed, rowid: rowid),
          createCompanionCallback:
              ({
                required String prayer,
                Value<int> owed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QazaBalanceCompanion.insert(
                prayer: prayer,
                owed: owed,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$QazaBalanceTable, QazaBalanceData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $QazaBalanceTable,
                    QazaBalanceData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QazaBalanceTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QazaBalanceTable,
      QazaBalanceData,
      $$QazaBalanceTableFilterComposer,
      $$QazaBalanceTableOrderingComposer,
      $$QazaBalanceTableAnnotationComposer,
      $$QazaBalanceTableCreateCompanionBuilder,
      $$QazaBalanceTableUpdateCompanionBuilder,
      (
        QazaBalanceData,
        BaseReferences<_$AppDatabase, $QazaBalanceTable, QazaBalanceData>,
      ),
      QazaBalanceData,
      PrefetchHooks Function()
    >;
typedef $$QazaHistoryTableCreateCompanionBuilder =
    QazaHistoryCompanion Function({
      Value<int> id,
      required String prayer,
      required int delta,
      required DateTime at,
      required String source,
      Value<String?> autoKey,
    });
typedef $$QazaHistoryTableUpdateCompanionBuilder =
    QazaHistoryCompanion Function({
      Value<int> id,
      Value<String> prayer,
      Value<int> delta,
      Value<DateTime> at,
      Value<String> source,
      Value<String?> autoKey,
    });

class $$QazaHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $QazaHistoryTable> {
  $$QazaHistoryTableFilterComposer({
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

  ColumnFilters<String> get prayer => $composableBuilder(
    column: $table.prayer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get delta => $composableBuilder(
    column: $table.delta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get autoKey => $composableBuilder(
    column: $table.autoKey,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QazaHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $QazaHistoryTable> {
  $$QazaHistoryTableOrderingComposer({
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

  ColumnOrderings<String> get prayer => $composableBuilder(
    column: $table.prayer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get delta => $composableBuilder(
    column: $table.delta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get autoKey => $composableBuilder(
    column: $table.autoKey,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QazaHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $QazaHistoryTable> {
  $$QazaHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get prayer =>
      $composableBuilder(column: $table.prayer, builder: (column) => column);

  GeneratedColumn<int> get delta =>
      $composableBuilder(column: $table.delta, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get autoKey =>
      $composableBuilder(column: $table.autoKey, builder: (column) => column);
}

class $$QazaHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QazaHistoryTable,
          QazaHistoryData,
          $$QazaHistoryTableFilterComposer,
          $$QazaHistoryTableOrderingComposer,
          $$QazaHistoryTableAnnotationComposer,
          $$QazaHistoryTableCreateCompanionBuilder,
          $$QazaHistoryTableUpdateCompanionBuilder,
          (
            QazaHistoryData,
            BaseReferences<_$AppDatabase, $QazaHistoryTable, QazaHistoryData>,
          ),
          QazaHistoryData,
          PrefetchHooks Function()
        > {
  $$QazaHistoryTableTableManager(_$AppDatabase db, $QazaHistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QazaHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QazaHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QazaHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> prayer = const Value.absent(),
                Value<int> delta = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> autoKey = const Value.absent(),
              }) => QazaHistoryCompanion(
                id: id,
                prayer: prayer,
                delta: delta,
                at: at,
                source: source,
                autoKey: autoKey,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String prayer,
                required int delta,
                required DateTime at,
                required String source,
                Value<String?> autoKey = const Value.absent(),
              }) => QazaHistoryCompanion.insert(
                id: id,
                prayer: prayer,
                delta: delta,
                at: at,
                source: source,
                autoKey: autoKey,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$QazaHistoryTable, QazaHistoryData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $QazaHistoryTable,
                    QazaHistoryData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QazaHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QazaHistoryTable,
      QazaHistoryData,
      $$QazaHistoryTableFilterComposer,
      $$QazaHistoryTableOrderingComposer,
      $$QazaHistoryTableAnnotationComposer,
      $$QazaHistoryTableCreateCompanionBuilder,
      $$QazaHistoryTableUpdateCompanionBuilder,
      (
        QazaHistoryData,
        BaseReferences<_$AppDatabase, $QazaHistoryTable, QazaHistoryData>,
      ),
      QazaHistoryData,
      PrefetchHooks Function()
    >;
typedef $$ExpensesTableCreateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  required double amount,
  required String category,
  Value<String> type,
  Value<String> note,
  required String date,
  Value<String?> receiptPath,
  Value<String> source,
  Value<int?> accountId,
  required DateTime createdAt,
});
typedef $$ExpensesTableUpdateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  Value<double> amount,
  Value<String> category,
  Value<String> type,
  Value<String> note,
  Value<String> date,
  Value<String?> receiptPath,
  Value<String> source,
  Value<int?> accountId,
  Value<DateTime> createdAt,
});

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
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

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
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

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          Expense,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
          Expense,
          PrefetchHooks Function()
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String?> receiptPath = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int?> accountId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                amount: amount,
                category: category,
                type: type,
                note: note,
                date: date,
                receiptPath: receiptPath,
                source: source,
                accountId: accountId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double amount,
                required String category,
                Value<String> type = const Value.absent(),
                Value<String> note = const Value.absent(),
                required String date,
                Value<String?> receiptPath = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int?> accountId = const Value.absent(),
                required DateTime createdAt,
              }) => ExpensesCompanion.insert(
                id: id,
                amount: amount,
                category: category,
                type: type,
                note: note,
                date: date,
                receiptPath: receiptPath,
                source: source,
                accountId: accountId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExpensesTable, Expense>(table),
                  BaseReferences<_$AppDatabase, $ExpensesTable, Expense>(
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

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      Expense,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
      Expense,
      PrefetchHooks Function()
    >;
typedef $$UdhaarContactsTableCreateCompanionBuilder =
    UdhaarContactsCompanion Function({
      Value<int> id,
      required String name,
      Value<String> phone,
      required DateTime createdAt,
      Value<String> source,
    });
typedef $$UdhaarContactsTableUpdateCompanionBuilder =
    UdhaarContactsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> phone,
      Value<DateTime> createdAt,
      Value<String> source,
    });

final class $$UdhaarContactsTableReferences
    extends BaseReferences<_$AppDatabase, $UdhaarContactsTable, UdhaarContact> {
  $$UdhaarContactsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$UdhaarEntriesTable, List<UdhaarEntry>>
  _udhaarEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.udhaarEntries,
    aliasName: 'udhaar_contacts__id__udhaar_entries__contact_id',
  );

  $$UdhaarEntriesTableProcessedTableManager get udhaarEntriesRefs {
    final manager = $$UdhaarEntriesTableTableManager(
      $_db,
      $_db.udhaarEntries,
    ).filter((f) => f.contactId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_udhaarEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UdhaarContactsTableFilterComposer
    extends Composer<_$AppDatabase, $UdhaarContactsTable> {
  $$UdhaarContactsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> udhaarEntriesRefs(
    Expression<bool> Function($$UdhaarEntriesTableFilterComposer f) f,
  ) {
    final $$UdhaarEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.udhaarEntries,
      getReferencedColumn: (t) => t.contactId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UdhaarEntriesTableFilterComposer(
            $db: $db,
            $table: $db.udhaarEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UdhaarContactsTableOrderingComposer
    extends Composer<_$AppDatabase, $UdhaarContactsTable> {
  $$UdhaarContactsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UdhaarContactsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UdhaarContactsTable> {
  $$UdhaarContactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  Expression<T> udhaarEntriesRefs<T extends Object>(
    Expression<T> Function($$UdhaarEntriesTableAnnotationComposer a) f,
  ) {
    final $$UdhaarEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.udhaarEntries,
      getReferencedColumn: (t) => t.contactId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UdhaarEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.udhaarEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UdhaarContactsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UdhaarContactsTable,
          UdhaarContact,
          $$UdhaarContactsTableFilterComposer,
          $$UdhaarContactsTableOrderingComposer,
          $$UdhaarContactsTableAnnotationComposer,
          $$UdhaarContactsTableCreateCompanionBuilder,
          $$UdhaarContactsTableUpdateCompanionBuilder,
          (UdhaarContact, $$UdhaarContactsTableReferences),
          UdhaarContact,
          PrefetchHooks Function({bool udhaarEntriesRefs})
        > {
  $$UdhaarContactsTableTableManager(
    _$AppDatabase db,
    $UdhaarContactsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UdhaarContactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UdhaarContactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UdhaarContactsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> source = const Value.absent(),
              }) => UdhaarContactsCompanion(
                id: id,
                name: name,
                phone: phone,
                createdAt: createdAt,
                source: source,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> phone = const Value.absent(),
                required DateTime createdAt,
                Value<String> source = const Value.absent(),
              }) => UdhaarContactsCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                createdAt: createdAt,
                source: source,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UdhaarContactsTable, UdhaarContact>(table),
                  $$UdhaarContactsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({udhaarEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (udhaarEntriesRefs) db.udhaarEntries,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (udhaarEntriesRefs)
                    await $_getPrefetchedData<
                      UdhaarContact,
                      $UdhaarContactsTable,
                      UdhaarEntry
                    >(
                      currentTable: table,
                      referencedTable: $$UdhaarContactsTableReferences
                          ._udhaarEntriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$UdhaarContactsTableReferences(
                            db,
                            table,
                            p0,
                          ).udhaarEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.contactId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UdhaarContactsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UdhaarContactsTable,
      UdhaarContact,
      $$UdhaarContactsTableFilterComposer,
      $$UdhaarContactsTableOrderingComposer,
      $$UdhaarContactsTableAnnotationComposer,
      $$UdhaarContactsTableCreateCompanionBuilder,
      $$UdhaarContactsTableUpdateCompanionBuilder,
      (UdhaarContact, $$UdhaarContactsTableReferences),
      UdhaarContact,
      PrefetchHooks Function({bool udhaarEntriesRefs})
    >;
typedef $$UdhaarEntriesTableCreateCompanionBuilder =
    UdhaarEntriesCompanion Function({
      Value<int> id,
      required int contactId,
      required double amount,
      required String type,
      Value<String> note,
      required String date,
      Value<String?> dueDate,
      required DateTime createdAt,
    });
typedef $$UdhaarEntriesTableUpdateCompanionBuilder =
    UdhaarEntriesCompanion Function({
      Value<int> id,
      Value<int> contactId,
      Value<double> amount,
      Value<String> type,
      Value<String> note,
      Value<String> date,
      Value<String?> dueDate,
      Value<DateTime> createdAt,
    });

final class $$UdhaarEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $UdhaarEntriesTable, UdhaarEntry> {
  $$UdhaarEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UdhaarContactsTable _contactIdTable(_$AppDatabase db) => db
      .udhaarContacts
      .createAlias('udhaar_entries__contact_id__udhaar_contacts__id');

  $$UdhaarContactsTableProcessedTableManager get contactId {
    final $_column = $_itemColumn<int>('contact_id')!;

    final manager = $$UdhaarContactsTableTableManager(
      $_db,
      $_db.udhaarContacts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contactIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UdhaarEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $UdhaarEntriesTable> {
  $$UdhaarEntriesTableFilterComposer({
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

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UdhaarContactsTableFilterComposer get contactId {
    final $$UdhaarContactsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contactId,
      referencedTable: $db.udhaarContacts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UdhaarContactsTableFilterComposer(
            $db: $db,
            $table: $db.udhaarContacts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UdhaarEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $UdhaarEntriesTable> {
  $$UdhaarEntriesTableOrderingComposer({
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

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UdhaarContactsTableOrderingComposer get contactId {
    final $$UdhaarContactsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contactId,
      referencedTable: $db.udhaarContacts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UdhaarContactsTableOrderingComposer(
            $db: $db,
            $table: $db.udhaarContacts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UdhaarEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UdhaarEntriesTable> {
  $$UdhaarEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UdhaarContactsTableAnnotationComposer get contactId {
    final $$UdhaarContactsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contactId,
      referencedTable: $db.udhaarContacts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UdhaarContactsTableAnnotationComposer(
            $db: $db,
            $table: $db.udhaarContacts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UdhaarEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UdhaarEntriesTable,
          UdhaarEntry,
          $$UdhaarEntriesTableFilterComposer,
          $$UdhaarEntriesTableOrderingComposer,
          $$UdhaarEntriesTableAnnotationComposer,
          $$UdhaarEntriesTableCreateCompanionBuilder,
          $$UdhaarEntriesTableUpdateCompanionBuilder,
          (UdhaarEntry, $$UdhaarEntriesTableReferences),
          UdhaarEntry,
          PrefetchHooks Function({bool contactId})
        > {
  $$UdhaarEntriesTableTableManager(_$AppDatabase db, $UdhaarEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UdhaarEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UdhaarEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UdhaarEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> contactId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String?> dueDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UdhaarEntriesCompanion(
                id: id,
                contactId: contactId,
                amount: amount,
                type: type,
                note: note,
                date: date,
                dueDate: dueDate,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int contactId,
                required double amount,
                required String type,
                Value<String> note = const Value.absent(),
                required String date,
                Value<String?> dueDate = const Value.absent(),
                required DateTime createdAt,
              }) => UdhaarEntriesCompanion.insert(
                id: id,
                contactId: contactId,
                amount: amount,
                type: type,
                note: note,
                date: date,
                dueDate: dueDate,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UdhaarEntriesTable, UdhaarEntry>(table),
                  $$UdhaarEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({contactId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (contactId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.contactId,
                        referencedTable: $$UdhaarEntriesTableReferences
                            ._contactIdTable(db),
                        referencedColumn: $$UdhaarEntriesTableReferences
                            ._contactIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$UdhaarEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UdhaarEntriesTable,
      UdhaarEntry,
      $$UdhaarEntriesTableFilterComposer,
      $$UdhaarEntriesTableOrderingComposer,
      $$UdhaarEntriesTableAnnotationComposer,
      $$UdhaarEntriesTableCreateCompanionBuilder,
      $$UdhaarEntriesTableUpdateCompanionBuilder,
      (UdhaarEntry, $$UdhaarEntriesTableReferences),
      UdhaarEntry,
      PrefetchHooks Function({bool contactId})
    >;
typedef $$TaskListsTableCreateCompanionBuilder = TaskListsCompanion Function({
  Value<int> id,
  required String name,
  Value<String> color,
  Value<String> emoji,
  required DateTime createdAt,
});
typedef $$TaskListsTableUpdateCompanionBuilder = TaskListsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> color,
  Value<String> emoji,
  Value<DateTime> createdAt,
});

class $$TaskListsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskListsTable> {
  $$TaskListsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TaskListsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskListsTable> {
  $$TaskListsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskListsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskListsTable> {
  $$TaskListsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TaskListsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskListsTable,
          TaskList,
          $$TaskListsTableFilterComposer,
          $$TaskListsTableOrderingComposer,
          $$TaskListsTableAnnotationComposer,
          $$TaskListsTableCreateCompanionBuilder,
          $$TaskListsTableUpdateCompanionBuilder,
          (TaskList, BaseReferences<_$AppDatabase, $TaskListsTable, TaskList>),
          TaskList,
          PrefetchHooks Function()
        > {
  $$TaskListsTableTableManager(_$AppDatabase db, $TaskListsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskListsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskListsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskListsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TaskListsCompanion(
                id: id,
                name: name,
                color: color,
                emoji: emoji,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> color = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                required DateTime createdAt,
              }) => TaskListsCompanion.insert(
                id: id,
                name: name,
                color: color,
                emoji: emoji,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TaskListsTable, TaskList>(table),
                  BaseReferences<_$AppDatabase, $TaskListsTable, TaskList>(
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

typedef $$TaskListsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskListsTable,
      TaskList,
      $$TaskListsTableFilterComposer,
      $$TaskListsTableOrderingComposer,
      $$TaskListsTableAnnotationComposer,
      $$TaskListsTableCreateCompanionBuilder,
      $$TaskListsTableUpdateCompanionBuilder,
      (TaskList, BaseReferences<_$AppDatabase, $TaskListsTable, TaskList>),
      TaskList,
      PrefetchHooks Function()
    >;
typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  Value<int> id,
  required String title,
  Value<String?> dueDate,
  Value<String?> dueTime,
  Value<String> priority,
  Value<bool> isCompleted,
  Value<DateTime?> completedAt,
  Value<String> recurrence,
  Value<String> note,
  Value<int?> listId,
  Value<int> remindBefore,
  Value<String?> prayerAnchor,
  Value<int> prayerOffset,
  Value<double?> amount,
  Value<String?> billCategory,
  required DateTime createdAt,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String?> dueDate,
  Value<String?> dueTime,
  Value<String> priority,
  Value<bool> isCompleted,
  Value<DateTime?> completedAt,
  Value<String> recurrence,
  Value<String> note,
  Value<int?> listId,
  Value<int> remindBefore,
  Value<String?> prayerAnchor,
  Value<int> prayerOffset,
  Value<double?> amount,
  Value<String?> billCategory,
  Value<DateTime> createdAt,
});

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dueTime => $composableBuilder(
    column: $table.dueTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get listId => $composableBuilder(
    column: $table.listId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remindBefore => $composableBuilder(
    column: $table.remindBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prayerAnchor => $composableBuilder(
    column: $table.prayerAnchor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get prayerOffset => $composableBuilder(
    column: $table.prayerOffset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get billCategory => $composableBuilder(
    column: $table.billCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dueTime => $composableBuilder(
    column: $table.dueTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get listId => $composableBuilder(
    column: $table.listId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remindBefore => $composableBuilder(
    column: $table.remindBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prayerAnchor => $composableBuilder(
    column: $table.prayerAnchor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get prayerOffset => $composableBuilder(
    column: $table.prayerOffset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get billCategory => $composableBuilder(
    column: $table.billCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get dueTime =>
      $composableBuilder(column: $table.dueTime, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get listId =>
      $composableBuilder(column: $table.listId, builder: (column) => column);

  GeneratedColumn<int> get remindBefore => $composableBuilder(
    column: $table.remindBefore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get prayerAnchor => $composableBuilder(
    column: $table.prayerAnchor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get prayerOffset => $composableBuilder(
    column: $table.prayerOffset,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get billCategory => $composableBuilder(
    column: $table.billCategory,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          Task,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
          Task,
          PrefetchHooks Function()
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> dueDate = const Value.absent(),
                Value<String?> dueTime = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String> recurrence = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<int?> listId = const Value.absent(),
                Value<int> remindBefore = const Value.absent(),
                Value<String?> prayerAnchor = const Value.absent(),
                Value<int> prayerOffset = const Value.absent(),
                Value<double?> amount = const Value.absent(),
                Value<String?> billCategory = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                title: title,
                dueDate: dueDate,
                dueTime: dueTime,
                priority: priority,
                isCompleted: isCompleted,
                completedAt: completedAt,
                recurrence: recurrence,
                note: note,
                listId: listId,
                remindBefore: remindBefore,
                prayerAnchor: prayerAnchor,
                prayerOffset: prayerOffset,
                amount: amount,
                billCategory: billCategory,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String?> dueDate = const Value.absent(),
                Value<String?> dueTime = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String> recurrence = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<int?> listId = const Value.absent(),
                Value<int> remindBefore = const Value.absent(),
                Value<String?> prayerAnchor = const Value.absent(),
                Value<int> prayerOffset = const Value.absent(),
                Value<double?> amount = const Value.absent(),
                Value<String?> billCategory = const Value.absent(),
                required DateTime createdAt,
              }) => TasksCompanion.insert(
                id: id,
                title: title,
                dueDate: dueDate,
                dueTime: dueTime,
                priority: priority,
                isCompleted: isCompleted,
                completedAt: completedAt,
                recurrence: recurrence,
                note: note,
                listId: listId,
                remindBefore: remindBefore,
                prayerAnchor: prayerAnchor,
                prayerOffset: prayerOffset,
                amount: amount,
                billCategory: billCategory,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TasksTable, Task>(table),
                  BaseReferences<_$AppDatabase, $TasksTable, Task>(
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

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      Task,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
      Task,
      PrefetchHooks Function()
    >;
typedef $$RecurringExpensesTableCreateCompanionBuilder =
    RecurringExpensesCompanion Function({
      Value<int> id,
      required double amount,
      required String category,
      Value<String> type,
      Value<String> note,
      required String frequency,
      required String nextDue,
      Value<int> anchorDay,
      required DateTime createdAt,
    });
typedef $$RecurringExpensesTableUpdateCompanionBuilder =
    RecurringExpensesCompanion Function({
      Value<int> id,
      Value<double> amount,
      Value<String> category,
      Value<String> type,
      Value<String> note,
      Value<String> frequency,
      Value<String> nextDue,
      Value<int> anchorDay,
      Value<DateTime> createdAt,
    });

class $$RecurringExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringExpensesTable> {
  $$RecurringExpensesTableFilterComposer({
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

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nextDue => $composableBuilder(
    column: $table.nextDue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get anchorDay => $composableBuilder(
    column: $table.anchorDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecurringExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringExpensesTable> {
  $$RecurringExpensesTableOrderingComposer({
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

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nextDue => $composableBuilder(
    column: $table.nextDue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get anchorDay => $composableBuilder(
    column: $table.anchorDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecurringExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringExpensesTable> {
  $$RecurringExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<String> get nextDue =>
      $composableBuilder(column: $table.nextDue, builder: (column) => column);

  GeneratedColumn<int> get anchorDay =>
      $composableBuilder(column: $table.anchorDay, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RecurringExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecurringExpensesTable,
          RecurringExpense,
          $$RecurringExpensesTableFilterComposer,
          $$RecurringExpensesTableOrderingComposer,
          $$RecurringExpensesTableAnnotationComposer,
          $$RecurringExpensesTableCreateCompanionBuilder,
          $$RecurringExpensesTableUpdateCompanionBuilder,
          (
            RecurringExpense,
            BaseReferences<
              _$AppDatabase,
              $RecurringExpensesTable,
              RecurringExpense
            >,
          ),
          RecurringExpense,
          PrefetchHooks Function()
        > {
  $$RecurringExpensesTableTableManager(
    _$AppDatabase db,
    $RecurringExpensesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurringExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurringExpensesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<String> nextDue = const Value.absent(),
                Value<int> anchorDay = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RecurringExpensesCompanion(
                id: id,
                amount: amount,
                category: category,
                type: type,
                note: note,
                frequency: frequency,
                nextDue: nextDue,
                anchorDay: anchorDay,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double amount,
                required String category,
                Value<String> type = const Value.absent(),
                Value<String> note = const Value.absent(),
                required String frequency,
                required String nextDue,
                Value<int> anchorDay = const Value.absent(),
                required DateTime createdAt,
              }) => RecurringExpensesCompanion.insert(
                id: id,
                amount: amount,
                category: category,
                type: type,
                note: note,
                frequency: frequency,
                nextDue: nextDue,
                anchorDay: anchorDay,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecurringExpensesTable, RecurringExpense>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $RecurringExpensesTable,
                    RecurringExpense
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecurringExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecurringExpensesTable,
      RecurringExpense,
      $$RecurringExpensesTableFilterComposer,
      $$RecurringExpensesTableOrderingComposer,
      $$RecurringExpensesTableAnnotationComposer,
      $$RecurringExpensesTableCreateCompanionBuilder,
      $$RecurringExpensesTableUpdateCompanionBuilder,
      (
        RecurringExpense,
        BaseReferences<
          _$AppDatabase,
          $RecurringExpensesTable,
          RecurringExpense
        >,
      ),
      RecurringExpense,
      PrefetchHooks Function()
    >;
typedef $$AccountsTableCreateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  required String name,
  Value<String> kind,
  Value<double> openingBalance,
  required DateTime createdAt,
});
typedef $$AccountsTableUpdateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> kind,
  Value<double> openingBalance,
  Value<DateTime> createdAt,
});

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<double> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTable,
          Account,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (Account, BaseReferences<_$AppDatabase, $AccountsTable, Account>),
          Account,
          PrefetchHooks Function()
        > {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<double> openingBalance = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                name: name,
                kind: kind,
                openingBalance: openingBalance,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> kind = const Value.absent(),
                Value<double> openingBalance = const Value.absent(),
                required DateTime createdAt,
              }) => AccountsCompanion.insert(
                id: id,
                name: name,
                kind: kind,
                openingBalance: openingBalance,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AccountsTable, Account>(table),
                  BaseReferences<_$AppDatabase, $AccountsTable, Account>(
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

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTable,
      Account,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (Account, BaseReferences<_$AppDatabase, $AccountsTable, Account>),
      Account,
      PrefetchHooks Function()
    >;
typedef $$SavingsGoalsTableCreateCompanionBuilder =
    SavingsGoalsCompanion Function({
      Value<int> id,
      required String name,
      required double target,
      Value<double> saved,
      Value<String?> deadline,
      required DateTime createdAt,
    });
typedef $$SavingsGoalsTableUpdateCompanionBuilder =
    SavingsGoalsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double> target,
      Value<double> saved,
      Value<String?> deadline,
      Value<DateTime> createdAt,
    });

class $$SavingsGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get saved => $composableBuilder(
    column: $table.saved,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavingsGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get saved => $composableBuilder(
    column: $table.saved,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavingsGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<double> get saved =>
      $composableBuilder(column: $table.saved, builder: (column) => column);

  GeneratedColumn<String> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SavingsGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavingsGoalsTable,
          SavingsGoal,
          $$SavingsGoalsTableFilterComposer,
          $$SavingsGoalsTableOrderingComposer,
          $$SavingsGoalsTableAnnotationComposer,
          $$SavingsGoalsTableCreateCompanionBuilder,
          $$SavingsGoalsTableUpdateCompanionBuilder,
          (
            SavingsGoal,
            BaseReferences<_$AppDatabase, $SavingsGoalsTable, SavingsGoal>,
          ),
          SavingsGoal,
          PrefetchHooks Function()
        > {
  $$SavingsGoalsTableTableManager(_$AppDatabase db, $SavingsGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavingsGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> target = const Value.absent(),
                Value<double> saved = const Value.absent(),
                Value<String?> deadline = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SavingsGoalsCompanion(
                id: id,
                name: name,
                target: target,
                saved: saved,
                deadline: deadline,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required double target,
                Value<double> saved = const Value.absent(),
                Value<String?> deadline = const Value.absent(),
                required DateTime createdAt,
              }) => SavingsGoalsCompanion.insert(
                id: id,
                name: name,
                target: target,
                saved: saved,
                deadline: deadline,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SavingsGoalsTable, SavingsGoal>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SavingsGoalsTable,
                    SavingsGoal
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavingsGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavingsGoalsTable,
      SavingsGoal,
      $$SavingsGoalsTableFilterComposer,
      $$SavingsGoalsTableOrderingComposer,
      $$SavingsGoalsTableAnnotationComposer,
      $$SavingsGoalsTableCreateCompanionBuilder,
      $$SavingsGoalsTableUpdateCompanionBuilder,
      (
        SavingsGoal,
        BaseReferences<_$AppDatabase, $SavingsGoalsTable, SavingsGoal>,
      ),
      SavingsGoal,
      PrefetchHooks Function()
    >;
typedef $$FastLogsTableCreateCompanionBuilder = FastLogsCompanion Function({
  Value<int> id,
  required String date,
  required String status,
});
typedef $$FastLogsTableUpdateCompanionBuilder = FastLogsCompanion Function({
  Value<int> id,
  Value<String> date,
  Value<String> status,
});

class $$FastLogsTableFilterComposer
    extends Composer<_$AppDatabase, $FastLogsTable> {
  $$FastLogsTableFilterComposer({
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

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FastLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $FastLogsTable> {
  $$FastLogsTableOrderingComposer({
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

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FastLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FastLogsTable> {
  $$FastLogsTableAnnotationComposer({
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

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$FastLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FastLogsTable,
          FastLog,
          $$FastLogsTableFilterComposer,
          $$FastLogsTableOrderingComposer,
          $$FastLogsTableAnnotationComposer,
          $$FastLogsTableCreateCompanionBuilder,
          $$FastLogsTableUpdateCompanionBuilder,
          (FastLog, BaseReferences<_$AppDatabase, $FastLogsTable, FastLog>),
          FastLog,
          PrefetchHooks Function()
        > {
  $$FastLogsTableTableManager(_$AppDatabase db, $FastLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FastLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FastLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FastLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<String> status = const Value.absent(),
          }) => FastLogsCompanion(id: id, date: date, status: status),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String date,
            required String status,
          }) => FastLogsCompanion.insert(id: id, date: date, status: status),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FastLogsTable, FastLog>(table),
                  BaseReferences<_$AppDatabase, $FastLogsTable, FastLog>(
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

typedef $$FastLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FastLogsTable,
      FastLog,
      $$FastLogsTableFilterComposer,
      $$FastLogsTableOrderingComposer,
      $$FastLogsTableAnnotationComposer,
      $$FastLogsTableCreateCompanionBuilder,
      $$FastLogsTableUpdateCompanionBuilder,
      (FastLog, BaseReferences<_$AppDatabase, $FastLogsTable, FastLog>),
      FastLog,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PrayerLogsTableTableManager get prayerLogs =>
      $$PrayerLogsTableTableManager(_db, _db.prayerLogs);
  $$SettingsHistoryTableTableManager get settingsHistory =>
      $$SettingsHistoryTableTableManager(_db, _db.settingsHistory);
  $$PauseRangesTableTableManager get pauseRanges =>
      $$PauseRangesTableTableManager(_db, _db.pauseRanges);
  $$QazaBalanceTableTableManager get qazaBalance =>
      $$QazaBalanceTableTableManager(_db, _db.qazaBalance);
  $$QazaHistoryTableTableManager get qazaHistory =>
      $$QazaHistoryTableTableManager(_db, _db.qazaHistory);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$UdhaarContactsTableTableManager get udhaarContacts =>
      $$UdhaarContactsTableTableManager(_db, _db.udhaarContacts);
  $$UdhaarEntriesTableTableManager get udhaarEntries =>
      $$UdhaarEntriesTableTableManager(_db, _db.udhaarEntries);
  $$TaskListsTableTableManager get taskLists =>
      $$TaskListsTableTableManager(_db, _db.taskLists);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$RecurringExpensesTableTableManager get recurringExpenses =>
      $$RecurringExpensesTableTableManager(_db, _db.recurringExpenses);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$SavingsGoalsTableTableManager get savingsGoals =>
      $$SavingsGoalsTableTableManager(_db, _db.savingsGoals);
  $$FastLogsTableTableManager get fastLogs =>
      $$FastLogsTableTableManager(_db, _db.fastLogs);
}
