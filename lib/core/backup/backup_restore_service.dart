import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqlite3/sqlite3.dart' as sql;

import '../../l10n/app_localizations.dart';
import '../storage/app_database.dart';
import '../storage/receipt_store.dart';

/// A `.saathi` backup is one file:
///   8 bytes  magic "SAATHIB1"
///   4 bytes  header length (big endian)
///   header   JSON: schema version, date, settings, receipt list
///   database bytes, then each receipt photo's bytes, in header order.
/// Older backups (a bare SQLite file) can still be restored.
const _magic = [83, 65, 65, 84, 72, 73, 66, 49]; // SAATHIB1
const _sqliteMagic = [
  83,
  81,
  76,
  105,
  116,
  101,
  32,
  102,
  111,
  114,
  109,
  97,
  116,
  32,
  51,
  0,
];
const _maxHeaderBytes = 8 * 1024 * 1024;

/// Per-device state that must not travel between backups.
bool _skipPref(String key) =>
    key.startsWith('sync_') ||
    key == 'last_scheduled_at' ||
    key.startsWith('udhaar_overdue_since_') ||
    key.startsWith('udhaar_last_notif_day_');

class _Backup {
  _Backup(
    this.file,
    this.schema,
    this.created,
    this.prefs,
    this.receipts,
    this.dbStart,
    this.dbLen,
  );
  final File file;
  final int? schema;
  final String? created;
  final Map<String, Object?> prefs;
  final List<({String path, String name, int len})> receipts;
  final int dbStart;
  final int dbLen;
}

/// Why a file cannot be restored.
enum BackupProblem { notSaathi, newer, damaged }

class BackupRestoreService {
  static void _say(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static Future<String> _livePath(AppDatabase db) async {
    try {
      final rows = await db.customSelect('PRAGMA database_list').get();
      final file = rows.first.read<String>('file');
      if (file.isNotEmpty) return file;
    } catch (_) {}
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/saathi.sqlite';
  }

  /// Writes a consistent snapshot of the live database to [target].
  static Future<void> _snapshot(AppDatabase db, String target) async {
    final out = File(target);
    if (await out.exists()) await out.delete();
    try {
      await db.customStatement("VACUUM INTO '${target.replaceAll("'", "''")}'");
    } catch (_) {
      await File(await _livePath(db)).copy(target);
    }
  }

  // ── Private vault ───────────────────────────────────────────────────────
  // Backups never contain the vault, so a shared file can't show private items.
  // Restoring keeps the vault that is already on the phone.

  static Set<String> _columns(sql.Database db, String table) => {
    for (final r in db.select('PRAGMA table_info($table)')) r['name'] as String,
  };

  static bool _hasTable(sql.Database db, String table) => db.select(
    'SELECT 1 FROM sqlite_master WHERE type = ? AND name = ?',
    ['table', table],
  ).isNotEmpty;

  /// True when the database file has any vault entry or vault contact.
  @visibleForTesting
  static bool hasVault(String path) {
    final db = sql.sqlite3.open(path, mode: sql.OpenMode.readOnly);
    try {
      for (final table in ['expenses', 'udhaar_contacts']) {
        if (_hasTable(db, table) &&
            _columns(db, table).contains('source') &&
            db.select('SELECT 1 FROM $table WHERE source = ? LIMIT 1', [
              'vault',
            ]).isNotEmpty) {
          return true;
        }
      }
      return false;
    } finally {
      db.dispose();
    }
  }

  /// Deletes every vault entry and vault contact (with their ledger entries) from
  /// the database file, then compacts it so the deleted text is gone from the file.
  @visibleForTesting
  static void stripVault(String path) {
    final db = sql.sqlite3.open(path);
    try {
      if (_hasTable(db, 'udhaar_contacts') &&
          _columns(db, 'udhaar_contacts').contains('source')) {
        if (_hasTable(db, 'udhaar_entries')) {
          db.execute(
            "DELETE FROM udhaar_entries WHERE contact_id IN "
            "(SELECT id FROM udhaar_contacts WHERE source = 'vault')",
          );
        }
        db.execute("DELETE FROM udhaar_contacts WHERE source = 'vault'");
      }
      if (_hasTable(db, 'expenses') &&
          _columns(db, 'expenses').contains('source')) {
        db.execute("DELETE FROM expenses WHERE source = 'vault'");
      }
      db.execute('VACUUM');
    } finally {
      db.dispose();
    }
  }

  /// Copies the vault rows of the database at [from] into the one at [into].
  /// New ids are given, and each ledger entry follows its contact. Columns the
  /// older [into] file does not have yet are skipped.
  @visibleForTesting
  static void carryVault({required String from, required String into}) {
    final db = sql.sqlite3.open(into);
    try {
      db.execute('ATTACH DATABASE ? AS live', [from]);
      db.execute('BEGIN');

      List<String> common(String table, {List<String> without = const ['id']}) {
        final live = {
          for (final r in db.select('PRAGMA live.table_info($table)'))
            r['name'] as String,
        };
        return [
          for (final c in _columns(db, table))
            if (live.contains(c) && !without.contains(c)) c,
        ];
      }

      bool both(String table) =>
          _hasTable(db, table) &&
          db.select(
            "SELECT 1 FROM live.sqlite_master WHERE type = 'table' AND name = ?",
            [table],
          ).isNotEmpty;

      // Without a `source` column a copied vault contact would turn into a normal
      // one and show up in the Udhaar list, so such an old file is left alone.
      if (both('udhaar_contacts') &&
          both('udhaar_entries') &&
          _columns(db, 'udhaar_contacts').contains('source')) {
        final contactCols = common('udhaar_contacts');
        final entryCols = common(
          'udhaar_entries',
          without: ['id', 'contact_id'],
        );
        final names = contactCols.join(', ');
        final oldContacts = db.select(
          "SELECT id FROM live.udhaar_contacts WHERE source = 'vault'",
        );
        for (final row in oldContacts) {
          final oldId = row['id'] as int;
          db.execute(
            'INSERT INTO udhaar_contacts ($names) SELECT $names '
            'FROM live.udhaar_contacts WHERE id = ?',
            [oldId],
          );
          final newId = db.lastInsertRowId;
          if (entryCols.isEmpty) continue;
          final cols = entryCols.join(', ');
          db.execute(
            'INSERT INTO udhaar_entries (contact_id, $cols) '
            'SELECT ?, $cols FROM live.udhaar_entries WHERE contact_id = ?',
            [newId, oldId],
          );
        }
      }

      if (both('expenses') && _columns(db, 'expenses').contains('source')) {
        final cols = common('expenses').join(', ');
        db.execute(
          'INSERT INTO expenses ($cols) SELECT $cols '
          "FROM live.expenses WHERE source = 'vault'",
        );
      }

      db.execute('COMMIT');
      db.execute('DETACH DATABASE live');
    } catch (_) {
      try {
        db.execute('ROLLBACK');
      } catch (_) {}
      rethrow;
    } finally {
      db.dispose();
    }
  }

  // ── Backup ──────────────────────────────────────────────────────────────

  /// Writes a complete backup (database, settings, receipt photos) to [dest].
  static Future<void> _writeBackup(
    AppDatabase db,
    SharedPreferences prefs,
    File dest,
  ) async {
    await ReceiptStore.migrateExisting(db);

    final tmp = await getTemporaryDirectory();
    final snapshot = '${tmp.path}/saathi_snapshot.sqlite';
    await _snapshot(db, snapshot);
    stripVault(snapshot);

    final receipts = <({String path, String name, int len})>[];
    final withReceipts = await (db.select(
      db.expenses,
    )..where((t) => t.receiptPath.isNotNull())).get();
    // Vault receipts stay out of backups too.
    final rows = withReceipts.where((e) => e.source != 'vault');
    var i = 0;
    for (final row in rows) {
      final f = File(row.receiptPath!);
      if (await f.exists()) {
        final base = row.receiptPath!.split('/').last;
        receipts.add((
          path: row.receiptPath!,
          name: 'r${i++}_$base',
          len: await f.length(),
        ));
      }
    }

    final prefMap = <String, Object?>{
      for (final key in prefs.getKeys())
        if (!_skipPref(key)) key: prefs.get(key),
    };

    final snapFile = File(snapshot);
    final header = utf8.encode(
      jsonEncode({
        'format': 1,
        'schema': db.schemaVersion,
        'created': DateTime.now().toIso8601String(),
        'prefs': prefMap,
        'dbLen': await snapFile.length(),
        'files': [
          for (final r in receipts)
            {'path': r.path, 'name': r.name, 'len': r.len},
        ],
      }),
    );

    final sink = dest.openWrite();
    sink.add(_magic);
    sink.add((ByteData(4)..setUint32(0, header.length)).buffer.asUint8List());
    sink.add(header);
    await sink.addStream(snapFile.openRead());
    for (final r in receipts) {
      await sink.addStream(File(r.path).openRead());
    }
    await sink.close();
    await snapFile.delete();
  }

  static Future<void> backup(
    BuildContext context,
    AppDatabase db,
    SharedPreferences prefs,
  ) async {
    try {
      final tmp = await getTemporaryDirectory();
      final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final dest = File('${tmp.path}/saathi_backup_$date.saathi');
      await _writeBackup(db, prefs, dest);

      await Share.shareXFiles([
        XFile(dest.path, mimeType: 'application/octet-stream'),
      ], subject: 'Saathi backup $date');
      await prefs.setInt(
        'last_export_at',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (error) {
      _say(context, AppLocalizations.of(context).backupFailed('$error'));
    }
  }

  // ── Automatic backups ───────────────────────────────────────────────────

  static const _autoKey = 'auto_backup_at';
  static const _autoInterval = Duration(days: 7);
  static const _autoKeep = 4;

  static Future<Directory> _autoDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/auto_backups');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  /// Saves a backup inside the app once a week and keeps the last few. It
  /// protects against mistakes and damage; sharing a copy off the phone is
  /// still what protects against losing the phone. Safe to call often.
  static Future<void> autoBackupIfDue(
    AppDatabase db,
    SharedPreferences prefs,
  ) async {
    try {
      final now = DateTime.now();
      final last = prefs.getInt(_autoKey);
      if (last != null &&
          now.millisecondsSinceEpoch - last < _autoInterval.inMilliseconds) {
        return;
      }
      final dir = await _autoDir();
      final name =
          'saathi_auto_${DateFormat('yyyy-MM-dd_HHmm').format(now)}.saathi';
      final dest = File('${dir.path}/$name');
      await _writeBackup(db, prefs, dest);
      await prefs.setInt(_autoKey, now.millisecondsSinceEpoch);

      final files = (await dir.list().toList()).whereType<File>().toList()
        ..sort((a, b) => b.path.compareTo(a.path));
      for (final old in files.skip(_autoKeep)) {
        await old.delete();
      }
    } catch (_) {
      // Best effort: a failed automatic backup must never disturb the app.
    }
  }

  /// Automatic backups, newest first.
  static Future<List<File>> autoBackups() async {
    final dir = await _autoDir();
    final files = (await dir.list().toList()).whereType<File>().toList()
      ..sort((a, b) => b.path.compareTo(a.path));
    return files;
  }

  // ── Restore ─────────────────────────────────────────────────────────────

  @visibleForTesting
  static Future<Object?> readBackup(File file) async {
    final raf = await file.open();
    try {
      final total = await raf.length();
      final head = await raf.read(16);
      if (head.length >= 16 && _equal(head, _sqliteMagic, 16)) {
        return _Backup(file, null, null, const {}, const [], 0, total);
      }
      if (head.length < 12 || !_equal(head, _magic, 8)) return null;

      final headerLen = ByteData.sublistView(
        Uint8List.fromList(head),
        8,
        12,
      ).getUint32(0);
      if (headerLen == 0 ||
          headerLen > _maxHeaderBytes ||
          12 + headerLen > total) {
        return null;
      }
      await raf.setPosition(12);
      final json = jsonDecode(utf8.decode(await raf.read(headerLen)));
      if (json is! Map<String, dynamic>) return null;

      final dbLen = json['dbLen'];
      final schema = json['schema'];
      final files = json['files'];
      final prefs = json['prefs'];
      if (dbLen is! int || schema is! int || files is! List || prefs is! Map)
        return null;

      var expected = 12 + headerLen + dbLen;
      final receipts = <({String path, String name, int len})>[];
      for (final f in files) {
        if (f is! Map ||
            f['path'] is! String ||
            f['name'] is! String ||
            f['len'] is! int) {
          return null;
        }
        receipts.add((
          path: f['path'] as String,
          name: f['name'] as String,
          len: f['len'] as int,
        ));
        expected += f['len'] as int;
      }
      if (expected != total) return null; // truncated or damaged

      return _Backup(
        file,
        schema,
        json['created'] as String?,
        prefs.cast<String, Object?>(),
        receipts,
        12 + headerLen,
        dbLen,
      );
    } catch (_) {
      return null;
    } finally {
      await raf.close();
    }
  }

  static bool _equal(List<int> bytes, List<int> expected, int length) {
    for (var i = 0; i < expected.length && i < length; i++) {
      if (bytes[i] != expected[i]) return false;
    }
    return true;
  }

  static Future<void> _copyRange(
    File from,
    int start,
    int length,
    File to,
  ) async {
    final raf = await from.open();
    final sink = to.openWrite();
    try {
      await raf.setPosition(start);
      var left = length;
      while (left > 0) {
        final chunk = await raf.read(left < 1048576 ? left : 1048576);
        if (chunk.isEmpty)
          throw const FileSystemException('Unexpected end of backup');
        sink.add(chunk);
        left -= chunk.length;
      }
    } finally {
      await raf.close();
      await sink.close();
    }
  }

  /// Returns a reason the extracted database cannot be used, or null if it is fine.
  @visibleForTesting
  static BackupProblem? validateDatabase(File db, int currentSchema) {
    sql.Database? probe;
    try {
      probe = sql.sqlite3.open(db.path, mode: sql.OpenMode.readOnly);
      final version =
          probe.select('PRAGMA user_version').first.values.first as int;
      if (version < 1) return BackupProblem.notSaathi;
      if (version > currentSchema) {
        return BackupProblem.newer;
      }
      final tables = probe
          .select("SELECT name FROM sqlite_master WHERE type = 'table'")
          .map((r) => r['name'] as String)
          .toSet();
      if (!tables.containsAll(['prayer_logs', 'settings_history'])) {
        return BackupProblem.notSaathi;
      }
      final check = probe.select('PRAGMA quick_check').first.values.first;
      if (check != 'ok') return BackupProblem.damaged;
      return null;
    } catch (_) {
      return BackupProblem.notSaathi;
    } finally {
      probe?.close();
    }
  }

  static Future<void> restore(
    BuildContext context,
    AppDatabase db,
    SharedPreferences prefs,
  ) async {
    final picked = await FilePicker.pickFile(type: FileType.any);
    final pickedPath = picked?.path;
    if (picked == null) return;
    if (pickedPath == null) {
      _say(context, AppLocalizations.of(context).backupNoAccess);
      return;
    }
    if (!context.mounted) return;
    await restoreFile(context, db, prefs, File(pickedPath));
  }

  /// Restores from [source], after checking it and asking for confirmation.
  static Future<void> restoreFile(
    BuildContext context,
    AppDatabase db,
    SharedPreferences prefs,
    File source,
  ) async {
    final docs = await getApplicationDocumentsDirectory();
    final staged = File('${docs.path}/saathi.restore.tmp');
    var touchedLive = false;
    try {
      final backup = await readBackup(source) as _Backup?;
      if (backup == null) {
        _say(context, AppLocalizations.of(context).backupIncomplete);
        return;
      }

      if (await staged.exists()) await staged.delete();
      await _copyRange(backup.file, backup.dbStart, backup.dbLen, staged);
      final problem = validateDatabase(staged, db.schemaVersion);
      if (problem != null) {
        await staged.delete();
        if (!context.mounted) return;
        final l10n = AppLocalizations.of(context);
        _say(context, switch (problem) {
          BackupProblem.newer => l10n.backupNewer,
          BackupProblem.damaged => l10n.backupDamaged,
          BackupProblem.notSaathi => l10n.backupNotSaathi,
        });
        return;
      }

      if (!context.mounted) return;
      final when = backup.created == null
          ? AppLocalizations.of(context).backupOlder
          : DateFormat('d MMM yyyy, h:mm a')
                .format(DateTime.parse(backup.created!));
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(AppLocalizations.of(ctx).restoreConfirmTitle),
          content: Text(AppLocalizations.of(ctx).restoreConfirmBody(when)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(AppLocalizations.of(ctx).cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error,
              ),
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(AppLocalizations.of(ctx).restoreButton),
            ),
          ],
        ),
      );
      if (confirmed != true) {
        await staged.delete();
        return;
      }

      // Everything that can fail happens before the live database is touched.
      await _snapshot(db, '${docs.path}/saathi_before_restore.bak');
      await File('${docs.path}/prefs_before_restore.json').writeAsString(
        jsonEncode({for (final key in prefs.getKeys()) key: prefs.get(key)}),
      );

      final receiptDir = await ReceiptStore.directory();
      final stamp = DateTime.now().millisecondsSinceEpoch;
      final remap = <String, String>{};
      var offset = backup.dbStart + backup.dbLen;
      var n = 0;
      for (final r in backup.receipts) {
        final safe = r.name.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
        final target = File(
          '${receiptDir.path}/restored_${stamp}_${n++}_$safe',
        );
        await _copyRange(backup.file, offset, r.len, target);
        remap[r.path] = target.path;
        offset += r.len;
      }
      if (remap.isNotEmpty) {
        final edit = sql.sqlite3.open(staged.path);
        try {
          final hasExpenses = edit
              .select("SELECT name FROM sqlite_master WHERE name = 'expenses'")
              .isNotEmpty;
          if (hasExpenses) {
            for (final e in remap.entries) {
              edit.execute(
                'UPDATE expenses SET receipt_path = ? WHERE receipt_path = ?',
                [e.value, e.key],
              );
            }
          }
        } finally {
          edit.close();
        }
      }

      // The backup has no vault; keep the one on this phone.
      final safety = '${docs.path}/saathi_before_restore.bak';
      if (hasVault(safety)) {
        stripVault(staged.path);
        carryVault(from: safety, into: staged.path);
      }

      final live = await _livePath(db);
      touchedLive = true;
      await db.close();
      for (final suffix in ['-wal', '-shm', '-journal']) {
        final stale = File('$live$suffix');
        if (await stale.exists()) await stale.delete();
      }
      await staged.rename(live);

      for (final e in backup.prefs.entries) {
        if (_skipPref(e.key)) continue;
        final v = e.value;
        if (v is bool) {
          await prefs.setBool(e.key, v);
        } else if (v is int) {
          await prefs.setInt(e.key, v);
        } else if (v is double) {
          await prefs.setDouble(e.key, v);
        } else if (v is String) {
          await prefs.setString(e.key, v);
        } else if (v is List) {
          await prefs.setStringList(e.key, v.cast<String>());
        }
      }

      if (context.mounted) {
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: Text(AppLocalizations.of(ctx).restoreDoneTitle),
            content: Text(AppLocalizations.of(ctx).restoreDoneBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(AppLocalizations.of(ctx).ok),
              ),
            ],
          ),
        );
      }
      exit(0);
    } catch (error) {
      if (await staged.exists()) await staged.delete();
      _say(
        context,
        touchedLive
            ? AppLocalizations.of(context).restoreFailedKept('$error')
            : AppLocalizations.of(context).restoreFailedSafe('$error'),
      );
    }
  }
}
