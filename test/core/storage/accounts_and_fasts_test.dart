import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/core/storage/app_database.dart';

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('a fast day can be changed again and cleared', () async {
    await db.fastLogsDao.setStatus('2026-11-01', 'kept');
    await db.fastLogsDao.setStatus('2026-11-01', 'missed');
    var rows = await db.select(db.fastLogs).get();
    expect(rows.map((r) => r.status), ['missed']);

    await db.fastLogsDao.setStatus('2026-11-01', null);
    rows = await db.select(db.fastLogs).get();
    expect(rows, isEmpty);
  });

  test('account balances follow entries and edits to the opening balance', () async {
    final id = await db.accountsDao.add(AccountsCompanion.insert(
      name: 'Cash',
      openingBalance: const Value(100),
      createdAt: DateTime.utc(2026),
    ));
    await db.expensesDao.add(ExpensesCompanion.insert(
      amount: 10, category: 'food', date: '2026-11-01', createdAt: DateTime.utc(2026), accountId: Value(id)));
    await db.expensesDao.add(ExpensesCompanion.insert(
      amount: 50, category: 'salary', type: const Value('income'), date: '2026-11-02',
      createdAt: DateTime.utc(2026), accountId: Value(id)));
    await db.expensesDao.add(ExpensesCompanion.insert(
      amount: 999, category: 'food', date: '2026-11-03', source: const Value('vault'),
      createdAt: DateTime.utc(2026), accountId: Value(id)));

    final seen = <double>[];
    final sub = db.accountsDao.watchBalances().listen((m) => seen.add(m[id]!));
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(seen.last, 140, reason: '100 - 10 + 50, vault entry ignored');

    await (db.update(db.accounts)..where((t) => t.id.equals(id)))
        .write(const AccountsCompanion(openingBalance: Value(500)));
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(seen.last, 540);

    await db.accountsDao.add(AccountsCompanion.insert(name: 'Bank', createdAt: DateTime.utc(2026)));
    await Future<void>.delayed(const Duration(milliseconds: 100));
    await sub.cancel();
    expect(seen.length, greaterThanOrEqualTo(3));
  });
}
