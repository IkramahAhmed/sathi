import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../core/storage/app_database.dart';
import '../../domain/entities/category.dart';

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

/// The user's own categories, as saved.
final customCategoriesProvider = StreamProvider<List<CustomCategory>>(
    (ref) => ref.watch(appDatabaseProvider).customCategoriesDao.watchAll());

/// Built-in and custom categories together. Use this to show or look up a category.
final categoryCatalogProvider = Provider<CategoryCatalog>((ref) {
  final rows = ref.watch(customCategoriesProvider).value ?? const <CustomCategory>[];
  return CategoryCatalog([
    for (final r in rows) Category.custom(id: r.id, name: r.name, emoji: r.emoji),
  ]);
});

/// Per-category monthly budget limits by category key (0 = no limit). Persisted in
/// SharedPreferences.
class BudgetNotifier extends Notifier<Map<String, double>> {
  @override
  Map<String, double> build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final catalog = ref.watch(categoryCatalogProvider);
    return {
      for (final cat in catalog.all) cat.key: prefs.getDouble('khata_budget_${cat.key}') ?? 0,
    };
  }

  Future<void> saveAll(Map<String, double> budgets) async {
    final prefs = ref.read(sharedPreferencesProvider);
    for (final entry in budgets.entries) {
      await prefs.setDouble('khata_budget_${entry.key}', entry.value);
    }
    state = Map.unmodifiable(budgets);
  }
}

final budgetNotifierProvider =
    NotifierProvider<BudgetNotifier, Map<String, double>>(BudgetNotifier.new);
