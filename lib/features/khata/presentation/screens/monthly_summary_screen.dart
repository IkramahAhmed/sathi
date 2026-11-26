import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/category.dart';
import '../../domain/month_trend.dart';
import '../providers/khata_providers.dart';

class MonthlySummaryScreen extends ConsumerStatefulWidget {
  const MonthlySummaryScreen({super.key});

  @override
  ConsumerState<MonthlySummaryScreen> createState() => _MonthlySummaryScreenState();
}

class _MonthlySummaryScreenState extends ConsumerState<MonthlySummaryScreen> {
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  void _shift(int delta) =>
      setState(() => _month = DateTime(_month.year, _month.month + delta));

  DateTime get _prevMonth => DateTime(_month.year, _month.month - 1);

  bool _isCurrent() =>
      _month.year == DateTime.now().year && _month.month == DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final monthLabel = DateFormat('MMMM yyyy').format(_month);
    final fmt = NumberFormat('#,##0', 'en');

    final expensesAsync = ref.watch(monthSpendingProvider((_month.year, _month.month)));
    final budgets = ref.watch(budgetNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.summaryTitle),
        centerTitle: true,
      ),
      body: expensesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (entries) {
          final income = entries
              .where((e) => e.type == 'income')
              .fold(0.0, (s, e) => s + e.amount);
          final expense = entries
              .where((e) => e.type != 'income')
              .fold(0.0, (s, e) => s + e.amount);
          final net = income - expense;

          final catalog = ref.watch(categoryCatalogProvider);
          final Map<Category, double> catTotals = {};
          for (final e in entries.where((e) => e.type != 'income')) {
            final cat = catalog.resolve(e.category);
            catTotals[cat] = (catTotals[cat] ?? 0) + e.amount;
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              // Month navigator
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => _shift(-1),
                  ),
                  Expanded(
                    child: Text(monthLabel,
                        textAlign: TextAlign.center,
                        style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _isCurrent() ? null : () => _shift(1),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Top summary cards
              Row(
                children: [
                  _SummaryCard(
                    label: l10n.khataIncome,
                    amount: 'Rs ${fmt.format(income)}',
                    color: Colors.green.shade700,
                    icon: Icons.arrow_downward_rounded,
                  ),
                  const SizedBox(width: 10),
                  _SummaryCard(
                    label: l10n.khataExpense,
                    amount: 'Rs ${fmt.format(expense)}',
                    color: scheme.error,
                    icon: Icons.arrow_upward_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Net balance card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: net >= 0
                      ? Colors.green.shade700.withAlpha(20)
                      : scheme.error.withAlpha(20),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: net >= 0 ? Colors.green.shade700 : scheme.error,
                    width: 1.2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.summaryNet,
                        style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    Text(
                      '${net >= 0 ? '+' : ''}Rs ${fmt.format(net.abs())}',
                      style: text.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: net >= 0 ? Colors.green.shade700 : scheme.error,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _TrendCard(
                labelFor: (key) => catalog.resolve(key).label(l10n),
                trend: compareMonths(
                  entries,
                  ref.watch(monthSpendingProvider((_prevMonth.year, _prevMonth.month))).value ?? const [],
                ),
              ),
              const SizedBox(height: 24),

              if (expense > 0) ...[
                Text(l10n.summaryByCategory,
                    style: text.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurfaceVariant)),
                const SizedBox(height: 12),
                for (final cat in catalog.all)
                  if ((catTotals[cat] ?? 0) > 0)
                    _CategoryRow(
                      cat: cat,
                      spent: catTotals[cat]!,
                      budget: budgets[cat.key] ?? 0,
                      total: expense,
                      l10n: l10n,
                      fmt: fmt,
                    ),
              ] else
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Text(l10n.summaryNoExpenses,
                        style: text.bodyMedium
                            ?.copyWith(color: scheme.onSurfaceVariant)),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  final String label;
  final String amount;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color.withAlpha(18),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: text.bodySmall
                          ?.copyWith(color: color, fontWeight: FontWeight.w600)),
                  Text(amount,
                      style: text.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.cat,
    required this.spent,
    required this.budget,
    required this.total,
    required this.l10n,
    required this.fmt,
  });

  final Category cat;
  final double spent;
  final double budget;
  final double total;
  final AppLocalizations l10n;
  final NumberFormat fmt;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final pct = total > 0 ? spent / total : 0.0;
    final overBudget = budget > 0 && spent > budget;
    final barColor = overBudget ? scheme.error : scheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              cat.iconWidget(size: 16, color: scheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Expanded(
                child: Text(cat.label(l10n),
                    style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
              ),
              Text(
                'Rs ${fmt.format(spent)}',
                style: text.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: overBudget ? scheme.error : null,
                ),
              ),
              if (budget > 0) ...[
                Text(' / Rs ${fmt.format(budget)}',
                    style: text.bodySmall
                        ?.copyWith(color: scheme.onSurfaceVariant)),
              ],
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: budget > 0 ? (spent / budget).clamp(0.0, 1.0) : pct,
              minHeight: 6,
              backgroundColor: scheme.outlineVariant.withAlpha(60),
              valueColor: AlwaysStoppedAnimation(barColor),
            ),
          ),
          if (overBudget)
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                'Over budget by Rs ${fmt.format(spent - budget)}',
                style: text.bodySmall?.copyWith(color: scheme.error),
              ),
            ),
        ],
      ),
    );
  }
}

class _TrendCard extends StatelessWidget {
  const _TrendCard({required this.trend, required this.labelFor});

  final MonthTrend trend;
  final String Function(String key) labelFor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final fmt = NumberFormat('#,##0', 'en');
    if (trend.previous == 0 && trend.current == 0) return const SizedBox.shrink();

    final up = trend.change > 0;
    final amount = fmt.format(trend.change.abs());
    final percent = trend.percent?.abs().round();
    final String line;
    if (trend.change == 0) {
      line = l10n.trendSame;
    } else if (percent == null) {
      line = l10n.trendMoreNoPercent(amount);
    } else {
      line = up ? l10n.trendMore(amount, '') : l10n.trendLess(amount, '');
    }
    final color = trend.change == 0
        ? scheme.onSurfaceVariant
        : up
            ? scheme.error
            : Colors.green.shade700;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.trendTitle, style: text.labelMedium?.copyWith(color: scheme.onSurfaceVariant)),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  trend.change == 0 ? Icons.drag_handle : up ? Icons.trending_up : Icons.trending_down,
                  color: color,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(line, style: text.bodyLarge?.copyWith(color: color, fontWeight: FontWeight.w600))),
              ],
            ),
            if (trend.biggestRise != null) ...[
              const SizedBox(height: 6),
              Text(
                l10n.trendBiggestRise(
                  labelFor(trend.biggestRise!.key),
                  fmt.format(trend.biggestRise!.change),
                ),
                style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
