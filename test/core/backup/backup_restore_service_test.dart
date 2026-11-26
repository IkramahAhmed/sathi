import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/core/backup/backup_restore_service.dart';
import 'package:saathi/core/storage/app_database.dart';
import 'package:sqlite3/sqlite3.dart' as sql;

void main() {
  late Directory dir;
  setUp(() => dir = Directory.systemTemp.createTempSync('saathi_backup_test'));
  tearDown(() => dir.deleteSync(recursive: true));

  Future<File> saathiDb() async {
    final file = File('${dir.path}/real.sqlite');
    final db = AppDatabase(NativeDatabase(file));
    await db.prayerLogsDao.markDone(
      '2026-11-01',
      'fajr',
      DateTime.utc(2026, 11, 1),
    );
    await db.close();
    return file;
  }

  Uint8List container(List<int> db, {int extra = 0, int? declaredDbLen}) {
    final header = utf8.encode(
      jsonEncode({
        'format': 1,
        'schema': 14,
        'created': '2026-11-26T10:00:00',
        'prefs': {'khata_budget_food': 5000.0},
        'dbLen': declaredDbLen ?? db.length,
        'files': [],
      }),
    );
    final len = ByteData(4)..setUint32(0, header.length);
    return Uint8List.fromList([
      ...utf8.encode('SAATHIB1'),
      ...len.buffer.asUint8List(),
      ...header,
      ...db,
      ...List.filled(extra, 0),
    ]);
  }

  test('a real Saathi database passes validation', () async {
    final file = await saathiDb();
    expect(BackupRestoreService.validateDatabase(file, 17), isNull);
  });

  test('a backup from a newer app version is rejected', () async {
    final file = await saathiDb();
    expect(
      BackupRestoreService.validateDatabase(file, 16),
      BackupProblem.newer,
    );
  });

  test("another app's SQLite file is rejected", () {
    final file = File('${dir.path}/other.sqlite');
    final other = sql.sqlite3.open(file.path);
    other.execute('CREATE TABLE notes (id INTEGER PRIMARY KEY, body TEXT)');
    other.execute('PRAGMA user_version = 3');
    other.close();
    expect(
      BackupRestoreService.validateDatabase(file, 17),
      BackupProblem.notSaathi,
    );
  });

  test('an empty SQLite file (version 0) is rejected', () {
    final file = File('${dir.path}/empty.sqlite');
    sql.sqlite3.open(file.path).close();
    expect(BackupRestoreService.validateDatabase(file, 17), isNotNull);
  });

  test('random bytes are rejected', () async {
    final file = File('${dir.path}/junk.sqlite')
      ..writeAsBytesSync(List.filled(4096, 7));
    expect(BackupRestoreService.validateDatabase(file, 17), isNotNull);
  });

  test(
    'a complete container is read, and a truncated one is refused',
    () async {
      final dbBytes = (await saathiDb()).readAsBytesSync();
      final good = File('${dir.path}/good.saathi')
        ..writeAsBytesSync(container(dbBytes));
      expect(await BackupRestoreService.readBackup(good), isNotNull);

      final bytes = container(dbBytes);
      final cut = File('${dir.path}/cut.saathi')
        ..writeAsBytesSync(bytes.sublist(0, bytes.length - 100));
      expect(await BackupRestoreService.readBackup(cut), isNull);

      final padded = File('${dir.path}/padded.saathi')
        ..writeAsBytesSync(container(dbBytes, extra: 10));
      expect(await BackupRestoreService.readBackup(padded), isNull);
    },
  );

  test('an older bare SQLite backup is still accepted', () async {
    final legacy = await saathiDb();
    expect(await BackupRestoreService.readBackup(legacy), isNotNull);
  });

  test('unrelated files are refused', () async {
    final text = File('${dir.path}/notes.txt')
      ..writeAsStringSync('hello world, not a backup');
    expect(await BackupRestoreService.readBackup(text), isNull);
  });
}
