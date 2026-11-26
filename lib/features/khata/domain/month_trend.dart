import '../../../core/storage/app_database.dart';
import 'entities/expense_category.dart';

/// How spending this month compares with the month before.
class MonthTrend {
  const MonthTrend({required this.current, required this.previous, this.biggestRise});

  final double current;
  final double previous;

  /// The category whose spending grew the most, or null if none grew.
  final ({ExpenseCategory category, double change})? biggestRise;

  double get change => current - previous;

  /// Change as a percentage of last month, or null when last month had no spending.
  double? get percent => previous > 0 ? change / previous * 100 : null;
}

MonthTrend compareMonths(List<Expense> current, List<Expense> previous) {
  Map<ExpenseCategory, double> totals(List<Expense> entries) {
    final result = <ExpenseCategory, double>{};
    for (final e in entries.where((e) => e.type != 'income')) {
      final c = ExpenseCategory.fromString(e.category);
      result[c] = (result[c] ?? 0) + e.amount;
    }
    return result;
  }

  final now = totals(current);
  final before = totals(previous);
  ({ExpenseCategory category, double change})? rise;
  for (final c in ExpenseCategory.values) {
    final delta = (now[c] ?? 0) - (before[c] ?? 0);
    if (delta > 0 && (rise == null || delta > rise.change)) rise = (category: c, change: delta);
  }
  return MonthTrend(
    current: now.values.fold(0.0, (a, b) => a + b),
    previous: before.values.fold(0.0, (a, b) => a + b),
    biggestRise: rise,
  );
}
