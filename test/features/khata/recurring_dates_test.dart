import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/core/storage/app_database.dart';
import 'package:saathi/features/khata/background/recurring_check.dart';
import 'package:saathi/features/udhaar/domain/phone.dart';

void main() {
  group('recurring expense dates', () {
    test('a rule created on the 31st uses the last day of short months, then goes back', () {
      var d = DateTime(2026, 1, 31);
      d = advanceDate(d, 'monthly', anchorDay: 31);
      expect(d, DateTime(2026, 2, 28));
      d = advanceDate(d, 'monthly', anchorDay: 31);
      expect(d, DateTime(2026, 3, 31));
      d = advanceDate(d, 'monthly', anchorDay: 31);
      expect(d, DateTime(2026, 4, 30));
    });

    test('without an anchor it never spills into the next month', () {
      expect(advanceDate(DateTime(2026, 1, 31), 'monthly'), DateTime(2026, 2, 28));
    });

    test('a yearly rule on 29 February follows leap years', () {
      var d = DateTime(2028, 2, 29);
      d = advanceDate(d, 'yearly', anchorDay: 29);
      expect(d, DateTime(2029, 2, 28));
      for (var i = 0; i < 3; i++) {
        d = advanceDate(d, 'yearly', anchorDay: 29);
      }
      expect(d, DateTime(2032, 2, 29));
    });

    test('daily and weekly are calendar days', () {
      expect(advanceDate(DateTime(2026, 12, 31), 'daily'), DateTime(2027, 1, 1));
      expect(advanceDate(DateTime(2026, 12, 28), 'weekly'), DateTime(2027, 1, 4));
    });
  });

  group('WhatsApp numbers', () {
    test('every common way of typing a Pakistani number gives the same result', () {
      for (final typed in ['03001234567', '3001234567', '+92 300 1234567', '923001234567', '00923001234567']) {
        expect(whatsAppNumber(typed), '923001234567', reason: typed);
      }
    });

    test('international numbers are kept and junk is rejected', () {
      expect(whatsAppNumber('00447911123456'), '447911123456');
      expect(whatsAppNumber(''), isNull);
      expect(whatsAppNumber('12345'), isNull);
      expect(whatsAppNumber('abc'), isNull);
    });
  });

  test('upgrading from version 14 keeps existing data and adds the new columns and tables', () async {
    final upgraded = AppDatabase(
      NativeDatabase.memory(setup: (raw) {
        raw.execute('''
          CREATE TABLE recurring_expenses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount REAL NOT NULL,
            category TEXT NOT NULL,
            type TEXT NOT NULL DEFAULT 'expense',
            note TEXT NOT NULL DEFAULT '',
            frequency TEXT NOT NULL,
            next_due TEXT NOT NULL,
            created_at INTEGER NOT NULL
          )''');
        raw.execute("INSERT INTO recurring_expenses (amount, category, frequency, next_due, created_at) VALUES (45000, 'rent', 'monthly', '2026-12-31', 1790000000)");
        raw.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            due_date TEXT,
            due_time TEXT,
            priority TEXT NOT NULL DEFAULT 'normal',
            is_completed INTEGER NOT NULL DEFAULT 0,
            completed_at INTEGER,
            recurrence TEXT NOT NULL DEFAULT 'none',
            note TEXT NOT NULL DEFAULT '',
            list_id INTEGER,
            created_at INTEGER NOT NULL
          )''');
        raw.execute("INSERT INTO tasks (title, due_date, created_at) VALUES ('Pay bill', '2026-12-01', 1790000000)");
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
            created_at INTEGER NOT NULL
          )''');
        raw.execute("INSERT INTO expenses (amount, category, date, created_at) VALUES (250, 'food', '2026-11-20', 1790000000)");
        raw.execute('PRAGMA user_version = 14');
      }),
    );
    addTearDown(upgraded.close);

    final rules = await upgraded.select(upgraded.recurringExpenses).get();
    expect(rules, hasLength(1));
    expect(rules.single.amount, 45000);
    expect(rules.single.nextDue, '2026-12-31');
    expect(rules.single.anchorDay, 0, reason: 'unknown for old rules, falls back to the due date');

    final tasks = await upgraded.select(upgraded.tasks).get();
    expect(tasks.single.title, 'Pay bill');
    expect(tasks.single.remindBefore, 0);
    expect(tasks.single.prayerAnchor, isNull);
    expect(tasks.single.amount, isNull);

    final entries = await upgraded.select(upgraded.expenses).get();
    expect(entries.single.amount, 250);
    expect(entries.single.accountId, isNull);

    await upgraded.savingsGoalsDao.add(SavingsGoalsCompanion.insert(name: 'Hajj', target: 1000000, createdAt: DateTime.utc(2026, 11, 26)));
    expect(await upgraded.select(upgraded.savingsGoals).get(), hasLength(1));
  });
}
