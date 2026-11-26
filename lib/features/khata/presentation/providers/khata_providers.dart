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

/// Whether bank transactions count towards budgets and totals (default on).
class CountBankNotifier extends Notifier<bool> {
  static const key = 'khata_count_bank';

  @override
  bool build() => ref.watch(sharedPreferencesProvider).getBool(key) ?? true;

  Future<void> set(bool value) async {
    await ref.read(sharedPreferencesProvider).setBool(key, value);
    state = value;
  }
}

final countBankProvider = NotifierProvider<CountBankNotifier, bool>(CountBankNotifier.new);

/// What was actually spent and earned in (year, month): manual entries, plus
/// bank transactions when the user has that switched on. Vault entries never count.
final monthSpendingProvider =
    StreamProvider.family<List<Expense>, (int, int)>((ref, args) {
  final yearMonth =
      '${args.$1.toString().padLeft(4, '0')}-${args.$2.toString().padLeft(2, '0')}';
  final includeBank = ref.watch(countBankProvider);
  return ref
      .watch(appDatabaseProvider)
      .expensesDao
      .watchMonthFrom(yearMonth, includeBank ? ['manual', 'bank'] : ['manual']);
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
