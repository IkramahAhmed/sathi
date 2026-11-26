import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/providers.dart';
import '../../../core/storage/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../khata/background/budget_check.dart';
import '../../khata/domain/entities/expense_category.dart';
import '../data/task_reminders.dart';

/// After a bill task is ticked, offers to record its amount in the Khata.
Future<void> offerBillToKhata(BuildContext context, WidgetRef ref, Task task) async {
  final amount = task.amount;
  if (amount == null || amount <= 0) return;
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final db = ref.read(appDatabaseProvider);

  final add = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.taskAddToKhataTitle),
      content: Text(l10n.taskAddToKhataBody(NumberFormat('#,##0.##', 'en').format(amount), task.title)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.skip)),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.add)),
      ],
    ),
  );
  if (add != true) return;

  final now = DateTime.now();
  final category = ExpenseCategory.fromString(task.billCategory ?? 'bills');
  await db.expensesDao.add(ExpensesCompanion.insert(
    amount: amount,
    category: category.name,
    note: Value(task.title),
    date: dateKey(now),
    createdAt: now.toUtc(),
  ));
  checkBudgetAndNotify(
    db: db,
    yearMonth: DateFormat('yyyy-MM').format(now),
    category: category,
    addedAmount: amount,
  );
  messenger.showSnackBar(SnackBar(content: Text(l10n.taskBillAdded)));
}
