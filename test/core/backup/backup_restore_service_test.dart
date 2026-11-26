import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
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

  group('private vault', () {
    Future<File> dbWithVault() async {
      final file = File('${dir.path}/vault.sqlite');
      final db = AppDatabase(NativeDatabase(file));
      final now = DateTime.utc(2026, 11, 1);
      await db.expensesDao.add(
        ExpensesCompanion.insert(
          amount: 100,
          category: 'food',
          date: '2026-11-01',
          note: const Value('lunch'),
          createdAt: now,
        ),
      );
      await db.expensesDao.add(
        ExpensesCompanion.insert(
          amount: 999,
          category: 'other',
          date: '2026-11-01',
          note: const Value('SECRETGIFT'),
          source: const Value('vault'),
          createdAt: now,
        ),
      );
      final open = await db.udhaarDao.addContact(
        UdhaarContactsCompanion.insert(name: 'Ali', createdAt: now),
      );
      final hidden = await db.udhaarDao.addContact(
        UdhaarContactsCompanion.insert(
          name: 'SECRETFRIEND',
          createdAt: now,
          source: const Value('vault'),
        ),
      );
      for (final id in [open, hidden]) {
        await db.udhaarDao.addEntry(
          UdhaarEntriesCompanion.insert(
            contactId: id,
            amount: 50,
            type: 'gave',
            date: '2026-11-01',
            createdAt: now,
          ),
        );
      }
      await db.close();
      return file;
    }

    int count(String path, String sqlText) {
      final db = sql.sqlite3.open(path);
      try {
        return db.select(sqlText).first.values.first as int;
      } finally {
        db.dispose();
      }
    }

    test('stripping removes vault rows and leaves the rest', () async {
      final file = await dbWithVault();
      expect(BackupRestoreService.hasVault(file.path), isTrue);
      BackupRestoreService.stripVault(file.path);

      expect(BackupRestoreService.hasVault(file.path), isFalse);
      expect(count(file.path, 'SELECT COUNT(*) FROM expenses'), 1);
      expect(count(file.path, 'SELECT COUNT(*) FROM udhaar_contacts'), 1);
      expect(count(file.path, 'SELECT COUNT(*) FROM udhaar_entries'), 1);
      final text = String.fromCharCodes(file.readAsBytesSync());
      expect(text.contains('SECRETGIFT'), isFalse);
      expect(text.contains('SECRETFRIEND'), isFalse);
      expect(text.contains('lunch'), isTrue);
    });

    test('a restore keeps the vault that is on the phone', () async {
      final live = await dbWithVault();
      final backup = File('${dir.path}/backup.sqlite');
      live.copySync(backup.path);
      BackupRestoreService.stripVault(backup.path);

      BackupRestoreService.carryVault(from: live.path, into: backup.path);

      expect(count(backup.path, 'SELECT COUNT(*) FROM expenses'), 2);
      expect(
        count(
          backup.path,
          "SELECT COUNT(*) FROM expenses WHERE source = 'vault'",
        ),
        1,
      );
      expect(count(backup.path, 'SELECT COUNT(*) FROM udhaar_contacts'), 2);
      // Every ledger entry still points at a contact that exists.
      expect(
        count(
          backup.path,
          'SELECT COUNT(*) FROM udhaar_entries e JOIN udhaar_contacts c '
          'ON c.id = e.contact_id',
        ),
        2,
      );
      expect(
        count(
          backup.path,
          'SELECT COUNT(*) FROM udhaar_entries e JOIN udhaar_contacts c '
          "ON c.id = e.contact_id WHERE c.name = 'SECRETFRIEND'",
        ),
        1,
      );
    });

    test('a database without a vault reports none', () async {
      expect(BackupRestoreService.hasVault((await saathiDb()).path), isFalse);
    });
  });
}
