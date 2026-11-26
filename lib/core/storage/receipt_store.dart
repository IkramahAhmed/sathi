import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:path_provider/path_provider.dart';

import 'app_database.dart';

/// Receipt photos live in the app's documents folder so Android cannot
/// clear them like it can the camera/gallery cache.
class ReceiptStore {
  static Future<Directory> directory() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/receipts');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  static Future<bool> _isPermanent(String path) async =>
      path.startsWith((await directory()).path);

  /// Copies [path] into permanent storage and returns the new path.
  /// Returns [path] unchanged when it is already permanent or cannot be copied.
  static Future<String> persist(String path) async {
    try {
      if (await _isPermanent(path)) return path;
      final source = File(path);
      if (!await source.exists()) return path;
      final dir = await directory();
      final ext = path.contains('.')
          ? path.substring(path.lastIndexOf('.'))
          : '.jpg';
      final target =
          '${dir.path}/receipt_${DateTime.now().microsecondsSinceEpoch}$ext';
      await source.copy(target);
      return target;
    } catch (_) {
      return path;
    }
  }

  /// Moves receipts of existing entries out of temporary folders. Entries whose
  /// photo is already gone are left alone.
  static Future<void> migrateExisting(AppDatabase db) async {
    final rows = await (db.select(
      db.expenses,
    )..where((t) => t.receiptPath.isNotNull())).get();
    for (final row in rows) {
      final old = row.receiptPath!;
      final moved = await persist(old);
      if (moved != old) {
        await db.expensesDao.updateExpense(
          row.id,
          ExpensesCompanion(receiptPath: Value(moved)),
        );
      }
    }
  }
}
