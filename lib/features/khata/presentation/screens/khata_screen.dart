import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers.dart';
import '../../../../core/storage/app_database.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/expense_category.dart';
import '../providers/khata_providers.dart';
import 'add_expense_screen.dart';

class KhataScreen extends ConsumerStatefulWidget {
  const KhataScreen({super.key});

  @override
  ConsumerState<KhataScreen> createState() => _KhataScreenState();
}

class _KhataScreenState extends ConsumerState<KhataScreen> {
  DateTime? _month;

  void _shift(int delta) {
    final now = DateTime.now();
    final current = _month ?? DateTime(now.year, now.month);
    setState(() => _month = DateTime(current.year, current.month + delta));
  }

  bool _isCurrentMonth() {
    final now = DateTime.now();
    final current = _month ?? DateTime(now.year, now.month);
    return current.year == now.year && current.month == now.month;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final month = _month ?? DateTime(now.year, now.month);
    final monthLabel = DateFormat.yMMMM().format(month);
    final expensesAsync = ref.watch(monthExpensesProvider((month.year, month.month)));
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.khataTitle)),
      body: Column(
        children: [
          // Month navigator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                IconButton(
                  tooltip: l10n.previousMonth,
                  onPressed: () => _shift(-1),
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Text(monthLabel, textAlign: TextAlign.center, style: text.titleMedium),
                ),
                IconButton(
                  tooltip: l10n.nextMonth,
                  onPressed: _isCurrentMonth() ? null : () => _shift(1),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),

          expensesAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox.shrink(),
            data: (expenses) {
              final total = expenses.fold(0.0, (s, e) => s + e.amount);
              return _SummaryCard(total: total, scheme: scheme, text: text, l10n: l10n);
            },
          ),

          Expanded(
            child: expensesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(l10n.genericError)),
              data: (expenses) {
                if (expenses.isEmpty) return _EmptyState(l10n: l10n, scheme: scheme, text: text);
                return _ExpenseList(
                  expenses: expenses,
                  l10n: l10n,
                  onDelete: (id) =>
                      ref.read(appDatabaseProvider).expensesDao.remove(id),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.total,
    required this.scheme,
    required this.text,
    required this.l10n,
  });

  final double total;
  final ColorScheme scheme;
  final TextTheme text;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final formatted = NumberFormat('#,##0.##', 'en').format(total);
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.khataMonthTotal, style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                  const SizedBox(height: 4),
                  Text(
                    'Rs. $formatted',
                    style: text.headlineSmall?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.account_balance_wallet_outlined, size: 36, color: scheme.primaryContainer),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.l10n, required this.scheme, required this.text});

  final AppLocalizations l10n;
  final ColorScheme scheme;
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined, size: 72, color: scheme.onSurfaceVariant.withAlpha(60)),
          const SizedBox(height: 16),
          Text(l10n.khataEmpty, style: text.titleMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 8),
          Text(l10n.khataEmptyHint, style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _ExpenseList extends StatelessWidget {
  const _ExpenseList({required this.expenses, required this.l10n, required this.onDelete});

  final List<Expense> expenses;
  final AppLocalizations l10n;
  final Future<void> Function(int id) onDelete;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayStr = _dateStr(now);
    final yesterdayStr = _dateStr(now.subtract(const Duration(days: 1)));

    // Group by date, order is already newest-first from the DAO.
    final grouped = <String, List<Expense>>{};
    for (final e in expenses) {
      (grouped[e.date] ??= []).add(e);
    }
    final dates = grouped.keys.toList();

    return ListView.builder(
      itemCount: dates.length,
      itemBuilder: (context, i) {
        final date = dates[i];
        final dayExpenses = grouped[date]!;
        final dayTotal = dayExpenses.fold(0.0, (s, e) => s + e.amount);

        String dayLabel;
        if (date == todayStr) {
          dayLabel = l10n.khataToday;
        } else if (date == yesterdayStr) {
          dayLabel = l10n.khataYesterday;
        } else {
          final parsed = DateTime.tryParse(date) ?? DateTime.now();
          dayLabel = DateFormat('EEE, d MMM').format(parsed);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DayHeader(label: dayLabel, total: dayTotal),
            for (final expense in dayExpenses)
              _ExpenseTile(expense: expense, l10n: l10n, onDelete: onDelete),
          ],
        );
      },
    );
  }

  String _dateStr(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.label, required this.total});

  final String label;
  final double total;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final formatted = NumberFormat('#,##0.##', 'en').format(total);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            'Rs. $formatted',
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _ExpenseTile extends StatelessWidget {
  const _ExpenseTile({required this.expense, required this.l10n, required this.onDelete});

  final Expense expense;
  final AppLocalizations l10n;
  final Future<void> Function(int id) onDelete;

  @override
  Widget build(BuildContext context) {
    final cat = ExpenseCategory.fromString(expense.category);
    final scheme = Theme.of(context).colorScheme;
    final formatted = NumberFormat('#,##0.##', 'en').format(expense.amount);

    return Dismissible(
      key: ValueKey(expense.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.khataDelete),
          content: Text('Rs. $formatted — ${cat.label(l10n)}'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(backgroundColor: scheme.error),
              child: Text(l10n.khataDelete),
            ),
          ],
        ),
      ),
      onDismissed: (_) => onDelete(expense.id),
      background: Container(
        color: scheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Icon(Icons.delete_outline, color: scheme.onError),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: scheme.primaryContainer,
          child: Icon(cat.icon, size: 20, color: scheme.onPrimaryContainer),
        ),
        title: Text(cat.label(l10n)),
        subtitle: expense.note.isNotEmpty ? Text(expense.note, maxLines: 1, overflow: TextOverflow.ellipsis) : null,
        trailing: Text(
          'Rs. $formatted',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
