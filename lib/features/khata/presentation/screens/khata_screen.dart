import 'dart:io';
import 'dart:math' show max;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app/providers.dart';
import '../../../../core/storage/app_database.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/expense_category.dart';
import '../providers/khata_providers.dart';
import 'add_expense_screen.dart';
import 'budget_screen.dart';

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

  Future<void> _export(List<Expense> expenses, DateTime month, AppLocalizations l10n) async {
    final monthLabel = DateFormat('yyyy-MM').format(month);
    final csv = StringBuffer('Date,Category,Amount (Rs.),Note\n');
    for (final e in expenses) {
      final note = e.note.replaceAll('"', '""');
      csv.write('${e.date},${e.category},${e.amount},"$note"\n');
    }
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/khata_$monthLabel.csv');
    await file.writeAsString(csv.toString());
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'text/csv')],
      subject: 'Khata – ${DateFormat.yMMMM().format(month)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final month = _month ?? DateTime(now.year, now.month);
    final monthLabel = DateFormat.yMMMM().format(month);
    final expensesAsync = ref.watch(monthExpensesProvider((month.year, month.month)));
    final budgets = ref.watch(budgetNotifierProvider);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.khataTitle),
        actions: [
          // Export action — enabled only when there is data
          expensesAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (expenses) => expenses.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip: l10n.khataExport,
                    icon: const Icon(Icons.upload_outlined),
                    onPressed: () => _export(expenses, month, l10n),
                  ),
          ),
          IconButton(
            tooltip: l10n.khataBudget,
            icon: const Icon(Icons.tune_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const BudgetScreen()),
            ),
          ),
        ],
      ),
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

          // Summary card
          expensesAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox.shrink(),
            data: (expenses) {
              final total = expenses.fold(0.0, (s, e) => s + e.amount);
              return _SummaryCard(total: total, scheme: scheme, text: text, l10n: l10n);
            },
          ),

          // Category chart
          expensesAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (expenses) {
              final catTotals = _categoryTotals(expenses);
              if (catTotals.isEmpty) return const SizedBox.shrink();
              return _CategoryChartCard(totals: catTotals, l10n: l10n);
            },
          ),

          // Budget progress
          expensesAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (expenses) {
              final hasBudget = budgets.values.any((v) => v > 0);
              if (!hasBudget) return const SizedBox.shrink();
              return _BudgetCard(
                totals: _categoryTotals(expenses),
                budgets: budgets,
                l10n: l10n,
              );
            },
          ),

          // Expense list
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

Map<ExpenseCategory, double> _categoryTotals(List<Expense> expenses) {
  final map = <ExpenseCategory, double>{};
  for (final e in expenses) {
    final cat = ExpenseCategory.fromString(e.category);
    map[cat] = (map[cat] ?? 0) + e.amount;
  }
  return map;
}

Color _catColor(ExpenseCategory cat) => switch (cat) {
      ExpenseCategory.food => const Color(0xFFFF8F00),
      ExpenseCategory.transport => const Color(0xFF1565C0),
      ExpenseCategory.rent => const Color(0xFF00695C),
      ExpenseCategory.health => const Color(0xFFC62828),
      ExpenseCategory.bills => const Color(0xFF6A1B9A),
      ExpenseCategory.shopping => const Color(0xFFAD1457),
      ExpenseCategory.other => const Color(0xFF546E7A),
    };

// ─── Summary card ────────────────────────────────────────────────────────────

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
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.khataMonthTotal,
                      style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
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
            Icon(Icons.account_balance_wallet_outlined,
                size: 36, color: scheme.primaryContainer),
          ],
        ),
      ),
    );
  }
}

// ─── Category chart ───────────────────────────────────────────────────────────

class _CategoryChartCard extends StatelessWidget {
  const _CategoryChartCard({required this.totals, required this.l10n});

  final Map<ExpenseCategory, double> totals;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    final sorted = ExpenseCategory.values
        .where((c) => (totals[c] ?? 0) > 0)
        .toList()
      ..sort((a, b) => (totals[b] ?? 0).compareTo(totals[a] ?? 0));

    final maxAmount = sorted.map((c) => totals[c]!).reduce(max);

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.khataChart,
                style: text.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            for (final cat in sorted) ...[
              _ChartRow(
                cat: cat,
                amount: totals[cat]!,
                maxAmount: maxAmount,
                l10n: l10n,
              ),
              const SizedBox(height: 7),
            ],
          ],
        ),
      ),
    );
  }
}

class _ChartRow extends StatelessWidget {
  const _ChartRow({
    required this.cat,
    required this.amount,
    required this.maxAmount,
    required this.l10n,
  });

  final ExpenseCategory cat;
  final double amount;
  final double maxAmount;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final color = _catColor(cat);
    final formatted = NumberFormat('#,##0', 'en').format(amount);

    return Row(
      children: [
        Icon(cat.icon, size: 14, color: color),
        const SizedBox(width: 6),
        SizedBox(
          width: 62,
          child: Text(
            cat.label(l10n),
            style: text.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: amount / maxAmount,
              minHeight: 10,
              backgroundColor: scheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: Text('Rs. $formatted', style: text.labelSmall, textAlign: TextAlign.right),
        ),
      ],
    );
  }
}

// ─── Budget card ──────────────────────────────────────────────────────────────

class _BudgetCard extends StatelessWidget {
  const _BudgetCard({
    required this.totals,
    required this.budgets,
    required this.l10n,
  });

  final Map<ExpenseCategory, double> totals;
  final Map<ExpenseCategory, double> budgets;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final catsWithBudget =
        ExpenseCategory.values.where((c) => (budgets[c] ?? 0) > 0).toList();
    if (catsWithBudget.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.khataBudget,
                style: text.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            for (final cat in catsWithBudget) ...[
              _BudgetRow(
                cat: cat,
                spent: totals[cat] ?? 0,
                limit: budgets[cat]!,
                l10n: l10n,
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

class _BudgetRow extends StatelessWidget {
  const _BudgetRow({
    required this.cat,
    required this.spent,
    required this.limit,
    required this.l10n,
  });

  final ExpenseCategory cat;
  final double spent;
  final double limit;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final fraction = (spent / limit).clamp(0.0, 1.0);
    final isOver = spent > limit;
    final color = isOver ? scheme.error : _catColor(cat);
    final spentFmt = NumberFormat('#,##0', 'en').format(spent);
    final limitFmt = NumberFormat('#,##0', 'en').format(limit);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(cat.icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(cat.label(l10n), style: text.labelMedium),
            const Spacer(),
            Text(
              'Rs. $spentFmt / $limitFmt',
              style: text.labelSmall?.copyWith(
                color: isOver ? scheme.error : scheme.onSurfaceVariant,
                fontWeight: isOver ? FontWeight.w600 : null,
              ),
            ),
            if (isOver) ...[
              const SizedBox(width: 4),
              Icon(Icons.warning_amber_rounded, size: 12, color: scheme.error),
            ],
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 8,
            backgroundColor: scheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

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
          Icon(Icons.receipt_long_outlined,
              size: 72, color: scheme.onSurfaceVariant.withAlpha(60)),
          const SizedBox(height: 16),
          Text(l10n.khataEmpty,
              style: text.titleMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 8),
          Text(l10n.khataEmptyHint,
              style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

// ─── Expense list ─────────────────────────────────────────────────────────────

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
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
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
            TextButton(
                onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
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
        subtitle: expense.note.isNotEmpty
            ? Text(expense.note, maxLines: 1, overflow: TextOverflow.ellipsis)
            : null,
        trailing: Text(
          'Rs. $formatted',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
