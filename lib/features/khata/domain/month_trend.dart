import '../../../core/storage/app_database.dart';

/// How spending this month compares with the month before.
class MonthTrend {
  const MonthTrend({required this.current, required this.previous, this.biggestRise});

  final double current;
  final double previous;

  /// The category key whose spending grew the most, or null if none grew.
  final ({String key, double change})? biggestRise;

  double get change => current - previous;

  /// Change as a percentage of last month, or null when last month had no spending.
  double? get percent => previous > 0 ? change / previous * 100 : null;
}

MonthTrend compareMonths(List<Expense> current, List<Expense> previous) {
  Map<String, double> totals(List<Expense> entries) {
    final result = <String, double>{};
    for (final e in entries.where((e) => e.type != 'income')) {
      result[e.category] = (result[e.category] ?? 0) + e.amount;
    }
    return result;
  }

  final now = totals(current);
  final before = totals(previous);
  ({String key, double change})? rise;
  for (final key in {...now.keys, ...before.keys}) {
    final delta = (now[key] ?? 0) - (before[key] ?? 0);
    if (delta > 0 && (rise == null || delta > rise.change)) rise = (key: key, change: delta);
  }
  return MonthTrend(
    current: now.values.fold(0.0, (a, b) => a + b),
    previous: before.values.fold(0.0, (a, b) => a + b),
    biggestRise: rise,
  );
}
