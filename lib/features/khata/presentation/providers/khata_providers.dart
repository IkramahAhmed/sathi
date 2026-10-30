import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../core/storage/app_database.dart';
import '../../domain/entities/expense_category.dart';

/// All expenses for (year, month), newest first. Reacts to DB changes.
final monthExpensesProvider =
    StreamProvider.family<List<Expense>, (int, int)>((ref, args) {
  final yearMonth =
      '${args.$1.toString().padLeft(4, '0')}-${args.$2.toString().padLeft(2, '0')}';
  return ref.watch(appDatabaseProvider).expensesDao.watchMonth(yearMonth);
});

/// Per-category monthly budget limits (0 = no limit). Persisted in SharedPreferences.
class BudgetNotifier extends Notifier<Map<ExpenseCategory, double>> {
  @override
  Map<ExpenseCategory, double> build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return {
      for (final cat in ExpenseCategory.values)
        cat: prefs.getDouble('khata_budget_${cat.name}') ?? 0,
    };
  }

  Future<void> saveAll(Map<ExpenseCategory, double> budgets) async {
    final prefs = ref.read(sharedPreferencesProvider);
    for (final entry in budgets.entries) {
      await prefs.setDouble('khata_budget_${entry.key.name}', entry.value);
    }
    state = Map.unmodifiable(budgets);
  }
}

final budgetNotifierProvider =
    NotifierProvider<BudgetNotifier, Map<ExpenseCategory, double>>(BudgetNotifier.new);
