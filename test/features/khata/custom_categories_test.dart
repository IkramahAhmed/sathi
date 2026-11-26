import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/core/storage/app_database.dart';
import 'package:saathi/features/khata/domain/entities/category.dart';
import 'package:saathi/features/khata/domain/quick_add.dart';

void main() {
  group('category catalog', () {
    final catalog = CategoryCatalog([
      Category.custom(id: 3, name: 'Groceries', emoji: '🛒'),
      Category.custom(id: 5, name: 'Mobile load', emoji: '📱'),
    ]);

    test(
      'lists built-in categories first, the user\'s own next, and Other last',
      () {
        expect(catalog.all.map((c) => c.key), [
          'food',
          'transport',
          'rent',
          'health',
          'bills',
          'shopping',
          'c3',
          'c5',
          'other',
        ]);
      },
    );

    test('finds a custom category by its stored key', () {
      expect(catalog.resolve('c3').customName, 'Groceries');
      expect(catalog.resolve('c3').isCustom, isTrue);
      expect(catalog.resolve('food').isCustom, isFalse);
    });

    test('an unknown or deleted key shows as Other instead of failing', () {
      expect(catalog.resolve('c99').key, 'other');
      expect(catalog.resolve('nonsense').key, 'other');
    });

    test('categories are equal by key, so they work as map keys', () {
      final totals = {catalog.resolve('c3'): 100.0};
      expect(
        totals[Category.custom(id: 3, name: 'Renamed', emoji: '🍎')],
        100.0,
      );
    });
  });

  group('quick add with the user\'s own categories', () {
    const custom = [
      (key: 'c3', name: 'Groceries'),
      (key: 'c5', name: 'Mobile load'),
    ];

    test('uses a custom category when its name is in the text', () {
      final e = parseQuickAdd('2500 groceries', custom: custom)!;
      expect(e.categoryKey, 'c3');
      expect(e.amount, 2500);
    });

    test('matches multi-word names and ignores case', () {
      expect(
        parseQuickAdd('Mobile LOAD 300', custom: custom)!.categoryKey,
        'c5',
      );
      expect(
        parseQuickAdd('300 load', custom: custom)!.categoryKey,
        'bills',
        reason: 'only part of the name, so the built-in guess is used',
      );
    });

    test('matches a category named in Urdu', () {
      const urdu = [(key: 'c7', name: 'راشن')];
      final e = parseQuickAdd('2500 راشن', custom: urdu)!;
      expect(e.categoryKey, 'c7');
      expect(e.amount, 2500);
      expect(parseQuickAdd('2500 chai', custom: urdu)!.categoryKey, 'food');
    });

    test('still uses the built-in guess when no custom name matches, and never for income', () {
      expect(parseQuickAdd('250 chai', custom: custom)!.categoryKey, 'food');
      expect(
        parseQuickAdd('+5000 groceries refund', custom: custom)!.isIncome,
        isTrue,
      );
      expect(
        parseQuickAdd('+5000 groceries refund', custom: custom)!.categoryKey,
        isNot('c3'),
      );
    });
  });

  group('storage', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase(NativeDatabase.memory()));
    tearDown(() => db.close());

    test('deleting a category moves its entries, rules and bill tasks to Other and loses nothing', () async {
      final id = await db.customCategoriesDao.add(
        CustomCategoriesCompanion.insert(
          name: 'Groceries',
          createdAt: DateTime.utc(2026),
        ),
      );
      final key = 'c$id';
      await db.expensesDao.add(
        ExpensesCompanion.insert(
          amount: 700,
          category: key,
          date: '2026-11-01',
          createdAt: DateTime.utc(2026),
        ),
      );
      await db.expensesDao.add(
        ExpensesCompanion.insert(
          amount: 50,
          category: 'food',
          date: '2026-11-01',
          createdAt: DateTime.utc(2026),
        ),
      );
      await db.recurringExpensesDao.add(
        RecurringExpensesCompanion.insert(
          amount: 1000,
          category: key,
          frequency: 'monthly',
          nextDue: '2026-12-01',
          createdAt: DateTime.utc(2026),
        ),
      );
      await db.tasksDao.addTask(
        TasksCompanion.insert(
          title: 'Pay',
          billCategory: Value(key),
          createdAt: DateTime.utc(2026),
        ),
      );

      await db.customCategoriesDao.remove(id);

      expect(await db.select(db.customCategories).get(), isEmpty);
      final expenses = await db.select(db.expenses).get();
      expect(expenses.map((e) => e.category).toList()..sort(), [
        'food',
        'other',
      ]);
      expect(
        expenses.fold<double>(0, (s, e) => s + e.amount),
        750,
        reason: 'no amount lost',
      );
      expect(
        (await db.select(db.recurringExpenses).get()).single.category,
        'other',
      );
      expect((await db.select(db.tasks).get()).single.billCategory, 'other');
    });
  });

  group('upgrade', () {
    test('a database from version 16 upgrades, keeps its data and gains the new table', () async {
      final upgraded = AppDatabase(
        NativeDatabase.memory(
          setup: (raw) {
            raw.execute('''
            CREATE TABLE expenses (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              amount REAL NOT NULL,
              category TEXT NOT NULL,
              type TEXT NOT NULL DEFAULT 'expense',
              note TEXT NOT NULL DEFAULT '',
              date TEXT NOT NULL,
              receipt_path TEXT,
              source TEXT NOT NULL DEFAULT 'manual',
              account_id INTEGER,
              created_at INTEGER NOT NULL
            )''');
            raw.execute(
              "INSERT INTO expenses (amount, category, date, created_at) VALUES (250, 'food', '2026-11-20', 1790000000)",
            );
            raw.execute('PRAGMA user_version = 16');
          },
        ),
      );
      addTearDown(upgraded.close);

      expect(
        (await upgraded.select(upgraded.expenses).get()).single.amount,
        250,
      );
      await upgraded.customCategoriesDao.add(
        CustomCategoriesCompanion.insert(
          name: 'Eidi',
          createdAt: DateTime.utc(2026),
        ),
      );
      expect(
        await upgraded.select(upgraded.customCategories).get(),
        hasLength(1),
      );
    });
  });
}
