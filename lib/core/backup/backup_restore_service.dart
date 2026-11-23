import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

// SQLite magic bytes: "SQLite format 3\0"
const _sqliteMagic = [83, 81, 76, 105, 116, 101, 32, 102, 111, 114, 109, 97, 116, 32, 51, 0];

class BackupRestoreService {
  static Future<String> _dbPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/saathi.sqlite';
  }

  /// Copies the live DB to a temp .saathi file and shares it.
  static Future<void> backup(BuildContext context) async {
    final dbPath = await _dbPath();
    final dbFile = File(dbPath);
    if (!await dbFile.exists()) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No database found to back up.')),
        );
      }
      return;
    }

    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final tmp = await getTemporaryDirectory();
    final dest = File('${tmp.path}/saathi_backup_$date.saathi');
    await dbFile.copy(dest.path);

    await Share.shareXFiles(
      [XFile(dest.path, mimeType: 'application/octet-stream')],
      subject: 'Saathi backup $date',
    );
  }

  /// Picks a .saathi file, validates it, confirms with the user, then restores.
  /// Calls exit(0) on success so the app restarts cleanly.
  static Future<void> restore(BuildContext context) async {
    final picked = await FilePicker.pickFile(type: FileType.any);
    if (picked == null) return;

    final pickedPath = picked.path;
    if (pickedPath == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not access the selected file.')),
        );
      }
      return;
    }

    final pickedFile = File(pickedPath);

    // Validate SQLite magic bytes
    final bytes = await pickedFile.openRead(0, 16).expand((x) => x).toList();
    if (bytes.length < 16 || !_isSqlite(bytes)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid backup file. Please select a .saathi file.')),
        );
      }
      return;
    }

    if (!context.mounted) return;

    // Confirm before overwriting
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restore backup?'),
        content: const Text(
          'This will replace ALL current data with the backup. '
          'The app will restart. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Restore'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final dbPath = await _dbPath();
    await pickedFile.copy(dbPath);
    exit(0); // cleanest restart — Riverpod providers reinit on cold start
  }

  static bool _isSqlite(List<int> bytes) {
    for (var i = 0; i < _sqliteMagic.length; i++) {
      if (bytes[i] != _sqliteMagic[i]) return false;
    }
    return true;
  }
}
