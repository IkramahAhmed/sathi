import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../core/storage/app_database.dart';

/// All expenses for (year, month), newest first. Reacts to DB changes.
final monthExpensesProvider =
    StreamProvider.family<List<Expense>, (int, int)>((ref, args) {
  final yearMonth =
      '${args.$1.toString().padLeft(4, '0')}-${args.$2.toString().padLeft(2, '0')}';
  return ref.watch(appDatabaseProvider).expensesDao.watchMonth(yearMonth);
});
