import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/core/storage/app_database.dart';
import 'package:saathi/features/khata/domain/month_trend.dart';

Expense e(double amount, String category, {String type = 'expense'}) => Expense(
      id: 1,
      amount: amount,
      category: category,
      type: type,
      note: '',
      date: '2026-11-10',
      source: 'manual',
      createdAt: DateTime.utc(2026, 11, 10),
    );

void main() {
  test('reports the change, its percentage and the category that rose most', () {
    final trend = compareMonths(
      [e(30000, 'rent'), e(12000, 'food'), e(5000, 'transport'), e(90000, 'salary', type: 'income')],
      [e(30000, 'rent'), e(8000, 'food'), e(5000, 'transport')],
    );
    expect(trend.current, 47000);
    expect(trend.previous, 43000);
    expect(trend.change, 4000);
    expect(trend.percent, closeTo(9.30, 0.01));
    expect(trend.biggestRise?.key, 'food');
    expect(trend.biggestRise?.change, 4000);
  });

  test('no previous spending gives no percentage, and no rise when spending fell', () {
    expect(compareMonths([e(100, 'food')], const []).percent, isNull);
    final down = compareMonths([e(100, 'food')], [e(500, 'food')]);
    expect(down.change, -400);
    expect(down.biggestRise, isNull);
  });
}
