import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/features/khata/domain/entities/expense_category.dart';
import 'package:saathi/features/khata/domain/entities/income_source.dart';
import 'package:saathi/features/khata/domain/quick_add.dart';

void main() {
  group('parseQuickAdd', () {
    test('amount first or last', () {
      final a = parseQuickAdd('250 chai')!;
      expect((a.amount, a.note, a.category, a.isIncome), (250.0, 'Chai', ExpenseCategory.food, false));
      final b = parseQuickAdd('chai 250')!;
      expect((b.amount, b.category), (250.0, ExpenseCategory.food));
    });

    test('commas, currency words and k / lakh suffixes', () {
      expect(parseQuickAdd('Rs 1,500 petrol')!.amount, 1500);
      expect(parseQuickAdd('rs. 1,500 petrol')!.category, ExpenseCategory.transport);
      expect(parseQuickAdd('5k grocery')!.amount, 5000);
      expect(parseQuickAdd('2.5k kapray')!.amount, 2500);
      expect(parseQuickAdd('1.5 lakh rent')!.amount, 150000);
      expect(parseQuickAdd('PKR 800 bijli bill')!.category, ExpenseCategory.bills);
    });

    test('a dot after rs does not leak into the note', () {
      expect(parseQuickAdd('rs. 1,500 petrol')!.note, 'Petrol');
      expect(parseQuickAdd('Rs.300 chai')!.note, 'Chai');
    });

    test('with several numbers the biggest is the amount', () {
      final e = parseQuickAdd('3 samosa 150')!;
      expect(e.amount, 150);
      expect(e.category, ExpenseCategory.food);
    });

    test('income is recognised by a plus sign or a word', () {
      final salary = parseQuickAdd('+50000 salary')!;
      expect((salary.isIncome, salary.incomeSource, salary.amount), (true, IncomeSource.salary, 50000.0));
      expect(parseQuickAdd('freelance 12000')!.incomeSource, IncomeSource.freelance);
      expect(parseQuickAdd('+500 eidi')!.incomeSource, IncomeSource.gift);
    });

    test('unknown words go to Other and nothing without an amount parses', () {
      expect(parseQuickAdd('300 xyz')!.category, ExpenseCategory.other);
      expect(parseQuickAdd('chai'), isNull);
      expect(parseQuickAdd('   '), isNull);
      expect(parseQuickAdd('0 chai'), isNull);
    });

    test('short words only match whole words', () {
      expect(guessExpenseCategory('vegas trip'), ExpenseCategory.other);
      expect(guessExpenseCategory('gas bill'), ExpenseCategory.bills);
    });
  });

  group('bank notification text', () {
    test('merchant names inside a longer message are found', () {
      expect(guessExpenseCategory('Debit PKR 1,200 at FOODPANDA-PK via card'), ExpenseCategory.food);
      expect(guessExpenseCategory('Payment of Rs 8,000 to K-Electric'), ExpenseCategory.bills);
      expect(guessExpenseCategory('Rs 4500 spent at PSO Fuel Station'), ExpenseCategory.transport);
      expect(guessExpenseCategory('Rs 700 transferred to Ali'), ExpenseCategory.other);
      expect(guessIncomeSource('Salary credited Rs 90,000'), IncomeSource.salary);
    });
  });
}
