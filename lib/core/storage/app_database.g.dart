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
    note,
    date,
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
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
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

  /// Matches [ExpenseCategory.name] — food, transport, rent, health, bills, shopping, other.
  final String category;

  /// Optional description.
  final String note;

  /// Calendar date as `yyyy-MM-dd`.
  final String date;

  /// When this row was created (UTC), used for ordering within a day.
  final DateTime createdAt;
  const Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.note,
    required this.date,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount'] = Variable<double>(amount);
    map['category'] = Variable<String>(category);
    map['note'] = Variable<String>(note);
    map['date'] = Variable<String>(date);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      amount: Value(amount),
      category: Value(category),
      note: Value(note),
      date: Value(date),
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
      note: serializer.fromJson<String>(json['note']),
      date: serializer.fromJson<String>(json['date']),
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
      'note': serializer.toJson<String>(note),
      'date': serializer.toJson<String>(date),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Expense copyWith({
    int? id,
    double? amount,
    String? category,
    String? note,
    String? date,
    DateTime? createdAt,
  }) => Expense(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    category: category ?? this.category,
    note: note ?? this.note,
    date: date ?? this.date,
    createdAt: createdAt ?? this.createdAt,
  );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      category: data.category.present ? data.category.value : this.category,
      note: data.note.present ? data.note.value : this.note,
      date: data.date.present ? data.date.value : this.date,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('note: $note, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, amount, category, note, date, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.category == this.category &&
          other.note == this.note &&
          other.date == this.date &&
          other.createdAt == this.createdAt);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<double> amount;
  final Value<String> category;
  final Value<String> note;
  final Value<String> date;
  final Value<DateTime> createdAt;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.category = const Value.absent(),
    this.note = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required double amount,
    required String category,
    this.note = const Value.absent(),
    required String date,
    required DateTime createdAt,
  }) : amount = Value(amount),
       category = Value(category),
       date = Value(date),
       createdAt = Value(createdAt);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<double>? amount,
    Expression<String>? category,
    Expression<String>? note,
    Expression<String>? date,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (category != null) 'category': category,
      if (note != null) 'note': note,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ExpensesCompanion copyWith({
    Value<int>? id,
    Value<double>? amount,
    Value<String>? category,
    Value<String>? note,
    Value<String>? date,
    Value<DateTime>? createdAt,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      note: note ?? this.note,
      date: date ?? this.date,
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
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
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
          ..write('note: $note, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
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
  late final PrayerLogsDao prayerLogsDao = PrayerLogsDao(this as AppDatabase);
  late final SettingsHistoryDao settingsHistoryDao = SettingsHistoryDao(
    this as AppDatabase,
  );
  late final PauseRangesDao pauseRangesDao = PauseRangesDao(
    this as AppDatabase,
  );
  late final QazaDao qazaDao = QazaDao(this as AppDatabase);
  late final ExpensesDao expensesDao = ExpensesDao(this as AppDatabase);
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
  Value<String> note,
  required String date,
  required DateTime createdAt,
});
typedef $$ExpensesTableUpdateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  Value<double> amount,
  Value<String> category,
  Value<String> note,
  Value<String> date,
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

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
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

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
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

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

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
                Value<String> note = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                amount: amount,
                category: category,
                note: note,
                date: date,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double amount,
                required String category,
                Value<String> note = const Value.absent(),
                required String date,
                required DateTime createdAt,
              }) => ExpensesCompanion.insert(
                id: id,
                amount: amount,
                category: category,
                note: note,
                date: date,
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
}
