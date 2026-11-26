import 'dart:io';
import 'dart:math' show max;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app/providers.dart';
import '../../../../core/pdf/pdf_generator.dart';
import '../../../../core/storage/app_database.dart';
import '../../../../core/storage/receipt_store.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/income_source.dart';
import '../providers/khata_providers.dart';
import '../../../../app/router.dart';
import '../../background/recurring_check.dart';
import 'add_expense_screen.dart';
import 'budget_screen.dart';
import 'recurring_screen.dart';

class KhataScreen extends ConsumerStatefulWidget {
  const KhataScreen({super.key});

  @override
  ConsumerState<KhataScreen> createState() => _KhataScreenState();
}

enum _TxFilter { all, incoming, outgoing }

enum _KhataTab { khata, bank }

class _KhataScreenState extends ConsumerState<KhataScreen> {
  DateTime? _month;
  _KhataTab _tab = _KhataTab.khata;
  _TxFilter _filter = _TxFilter.all;
  String _khataQuery = '';
  final _khataSearchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final db = ref.read(appDatabaseProvider);
      runRecurringCheckWithDb(db.expensesDao, db.recurringExpensesDao);
      ReceiptStore.migrateExisting(db);
    });
  }

  @override
  void dispose() {
    _khataSearchCtrl.dispose();
    super.dispose();
  }

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

  String _filterLabel(_TxFilter f, AppLocalizations l10n) => switch (f) {
        _TxFilter.all => l10n.filterAll,
        _TxFilter.incoming => l10n.khataIncoming,
        _TxFilter.outgoing => l10n.khataOutgoing,
      };

  List<Expense> _applyFilter(List<Expense> all) => switch (_filter) {
        _TxFilter.all => all,
        _TxFilter.incoming => all.where((e) => e.type == 'income').toList(),
        _TxFilter.outgoing => all.where((e) => e.type != 'income').toList(),
      };

  List<Expense> _applySearch(List<Expense> all) {
    if (_khataQuery.isEmpty) return all;
    final q = _khataQuery.toLowerCase();
    return all
        .where((e) =>
            e.note.toLowerCase().contains(q) ||
            e.amount.toString().contains(q))
        .toList();
  }

  Future<void> _exportCsv(List<Expense> expenses, DateTime month) async {
    final monthLabel = DateFormat('yyyy-MM').format(month);
    final catalog = ref.read(categoryCatalogProvider);
    final csv = StringBuffer('Date,Type,Category,Amount (Rs.),Note\n');
    for (final e in expenses) {
      final note = e.note.replaceAll('"', '""');
      final category = e.type == 'income' ? e.category : catalog.resolve(e.category).plainName;
      csv.write('${e.date},${e.type},$category,${e.amount},"$note"\n');
    }
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/khata_$monthLabel.csv');
    await file.writeAsString(csv.toString());
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'text/csv')],
      subject: 'Khata – ${DateFormat.yMMMM().format(month)}',
    );
  }

  Future<void> _exportPdf(DateTime month) async {
    final entries = await ref.read(appDatabaseProvider).expensesDao.getMonth(
          DateFormat('yyyy-MM').format(month),
        );
    final catalog = ref.read(categoryCatalogProvider);
    await shareKhataPdf(entries, month, categoryName: (key) => catalog.resolve(key).plainName);
  }

  void _showExportMenu(BuildContext context, List<Expense> expenses, DateTime month) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_outlined),
              title: Text(AppLocalizations.of(context).khataExportPdf),
              onTap: () { Navigator.pop(context); _exportPdf(month); },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart_outlined),
              title: Text(AppLocalizations.of(context).khataExportCsv),
              onTap: () { Navigator.pop(context); _exportCsv(expenses, month); },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final month = _month ?? DateTime(now.year, now.month);
    final monthLabel = DateFormat.yMMMM().format(month);
    final expensesAsync = ref.watch(monthExpensesProvider((month.year, month.month)));
    final spendingAsync = ref.watch(monthSpendingProvider((month.year, month.month)));
    final budgets = ref.watch(budgetNotifierProvider);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final segmented = Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: SegmentedButton<_KhataTab>(
        segments: [
          ButtonSegment(
            value: _KhataTab.khata,
            label: Text(l10n.khataTabExpenses),
            icon: const Icon(Icons.receipt_long_outlined),
          ),
          ButtonSegment(
            value: _KhataTab.bank,
            label: Text(l10n.khataBank),
            icon: Icon(Icons.account_balance_outlined),
          ),
        ],
        selected: {_tab},
        onSelectionChanged: (s) => setState(() => _tab = s.first),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.khataTitle),
        actions: [
          expensesAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (expenses) => expenses.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip: l10n.khataExport,
                    icon: const Icon(Icons.upload_outlined),
                    onPressed: () => _showExportMenu(context, expenses, month),
                  ),
          ),
          IconButton(
            tooltip: l10n.summaryTitle,
            icon: const Icon(Icons.bar_chart_outlined),
            onPressed: () => context.push(Routes.monthlySummary),
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
          segmented,
          Expanded(
            child: _tab == _KhataTab.bank
                    ? _BankFeed(month: month)
                    : Column(
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

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                for (final f in _TxFilter.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: _filter == f,
                      label: Text(_filterLabel(f, l10n)),
                      onSelected: (_) => setState(() => _filter = f),
                    ),
                  ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _khataSearchCtrl,
              decoration: InputDecoration(
                hintText: l10n.khataSearchEntries,
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _khataQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          _khataSearchCtrl.clear();
                          setState(() => _khataQuery = '');
                        },
                      )
                    : null,
                isDense: true,
                filled: true,
                fillColor: scheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              onChanged: (v) => setState(() => _khataQuery = v.trim()),
            ),
          ),

          // Summary card — always based on full month, not filtered
          spendingAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox.shrink(),
            data: (entries) {
              final income = entries.where((e) => e.type == 'income').fold(0.0, (s, e) => s + e.amount);
              final expense = entries.where((e) => e.type != 'income').fold(0.0, (s, e) => s + e.amount);
              final card = _SummaryCard(income: income, expense: expense, scheme: scheme, text: text, l10n: l10n);
              if (!entries.any((e) => e.source == 'bank')) return card;
              return Column(children: [
                card,
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(l10n.khataIncludesBank, style: text.labelSmall?.copyWith(color: scheme.onSurfaceVariant)),
                ),
              ]);
            },
          ),

          // Category chart (shown only for All / Outgoing filter)
          if (_filter == _TxFilter.all || _filter == _TxFilter.outgoing)
            spendingAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (entries) {
                final catTotals = _categoryTotals(entries.where((e) => e.type != 'income').toList(), ref.watch(categoryCatalogProvider));
                if (catTotals.isEmpty) return const SizedBox.shrink();
                return _CategoryChartCard(totals: catTotals, l10n: l10n);
              },
            ),

          // Budget progress
          if (_filter == _TxFilter.all || _filter == _TxFilter.outgoing)
            spendingAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (entries) {
                final hasBudget = budgets.values.any((v) => v > 0);
                if (!hasBudget) return const SizedBox.shrink();
                return _BudgetCard(
                  totals: _categoryTotals(entries.where((e) => e.type != 'income').toList(), ref.watch(categoryCatalogProvider)),
                  catalog: ref.watch(categoryCatalogProvider),
                  budgets: budgets,
                  l10n: l10n,
                );
              },
            ),

          // Transaction list (filtered)
          Expanded(
            child: expensesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(l10n.genericError)),
              data: (expenses) {
                final filtered = _applySearch(_applyFilter(expenses));
                if (filtered.isEmpty) return _EmptyState(l10n: l10n, scheme: scheme, text: text);
                return _ExpenseList(
                  expenses: filtered,
                  catalog: ref.watch(categoryCatalogProvider),
                  l10n: l10n,
                  onDelete: (id) =>
                      ref.read(appDatabaseProvider).expensesDao.remove(id),
                  onMoveToVault: (id) => ref
                      .read(appDatabaseProvider)
                      .expensesDao
                      .setSource(id, 'vault'),
                );
              },
            ),
          ),
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: _tab == _KhataTab.bank
          ? null
          : FloatingActionButton(
              onPressed: () => _showAddMenu(context),
              child: const Icon(Icons.add),
            ),
    );
  }

  void _showAddMenu(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.arrow_upward, color: Colors.red),
              title: Text(l10n.khataAddExpense),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const AddExpenseScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.arrow_downward, color: Colors.green),
              title: Text(l10n.khataAddIncome),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) =>
                        const AddExpenseScreen(startAsIncome: true)));
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.repeat_outlined),
              title: Text(AppLocalizations.of(context).recurringTitle),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RecurringScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Extracts "[HBL]" → "HBL" from auto-imported transaction notes.
String? _bankTag(String note) {
  final m = RegExp(r'^\[([^\]]+)\]').firstMatch(note);
  return m?.group(1);
}

// Returns the note with the leading [BankName] tag stripped.
String _cleanNote(String note) {
  return note.replaceFirst(RegExp(r'^\[[^\]]+\]\s*'), '').trim();
}

Map<Category, double> _categoryTotals(List<Expense> expenses, CategoryCatalog catalog) {
  final map = <Category, double>{};
  for (final e in expenses) {
    final cat = catalog.resolve(e.category);
    map[cat] = (map[cat] ?? 0) + e.amount;
  }
  return map;
}

// ─── Summary card ────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.income,
    required this.expense,
    required this.scheme,
    required this.text,
    required this.l10n,
  });

  final double income;
  final double expense;
  final ColorScheme scheme;
  final TextTheme text;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##0', 'en');
    final net = income - expense;
    final isPositive = net >= 0;
    final netColor = isPositive ? Colors.green.shade700 : scheme.error;

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Net balance — most prominent number
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '${isPositive ? '+' : ''}Rs ${fmt.format(net)}',
                  style: text.headlineSmall?.copyWith(
                    color: netColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.khataNet,
                  style: text.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),
            // Income + Expense side by side
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.khataTotalIncome,
                              style: text.labelSmall?.copyWith(
                                  color: scheme.onSurfaceVariant)),
                          Text('Rs ${fmt.format(income)}',
                              style: text.labelLarge?.copyWith(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: scheme.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.khataTotalExpense,
                              style: text.labelSmall?.copyWith(
                                  color: scheme.onSurfaceVariant)),
                          Text('Rs ${fmt.format(expense)}',
                              style: text.labelLarge?.copyWith(
                                  color: scheme.error,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Category chart ───────────────────────────────────────────────────────────

class _CategoryChartCard extends StatelessWidget {
  const _CategoryChartCard({required this.totals, required this.l10n});

  final Map<Category, double> totals;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    final sorted = totals.keys
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

  final Category cat;
  final double amount;
  final double maxAmount;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final color = cat.color;
    final formatted = NumberFormat('#,##0', 'en').format(amount);

    return Row(
      children: [
        cat.iconWidget(size: 14, color: color),
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
    required this.catalog,
    required this.budgets,
    required this.l10n,
  });

  final Map<Category, double> totals;
  final CategoryCatalog catalog;
  final Map<String, double> budgets;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final catsWithBudget =
        catalog.all.where((c) => (budgets[c.key] ?? 0) > 0).toList();
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
                limit: budgets[cat.key]!,
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

  final Category cat;
  final double spent;
  final double limit;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final fraction = (spent / limit).clamp(0.0, 1.0);
    final isOver = spent > limit;
    final color = isOver ? scheme.error : cat.color;
    final spentFmt = NumberFormat('#,##0', 'en').format(spent);
    final limitFmt = NumberFormat('#,##0', 'en').format(limit);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            cat.iconWidget(size: 14, color: color),
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
              const SizedBox(width: 6),
              Icon(Icons.warning_amber_rounded, size: 14, color: scheme.error),
              const SizedBox(width: 2),
              Text(
                l10n.khataOverBudget,
                style: text.labelSmall?.copyWith(color: scheme.error, fontWeight: FontWeight.w600),
              ),
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
  const _ExpenseList({
    required this.expenses,
    required this.catalog,
    required this.l10n,
    required this.onDelete,
    required this.onMoveToVault,
  });

  final List<Expense> expenses;
  final CategoryCatalog catalog;
  final AppLocalizations l10n;
  final Future<void> Function(int id) onDelete;
  final Future<void> Function(int id) onMoveToVault;

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
            _DayHeader(label: dayLabel, entries: dayExpenses),
            for (final expense in dayExpenses)
              _ExpenseTile(
                expense: expense,
                catalog: catalog,
                l10n: l10n,
                onDelete: onDelete,
                onMoveToVault: onMoveToVault,
                onEdit: (e) => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AddExpenseScreen(expense: e),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  String _dateStr(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.label, required this.entries});

  final String label;
  final List<Expense> entries;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final fmt = NumberFormat('#,##0', 'en');
    final income = entries.where((e) => e.type == 'income').fold(0.0, (s, e) => s + e.amount);
    final expense = entries.where((e) => e.type != 'income').fold(0.0, (s, e) => s + e.amount);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: text.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Spacer(),
          if (income > 0)
            Text('+${fmt.format(income)}',
                style: text.labelSmall?.copyWith(color: Colors.green.shade700, fontWeight: FontWeight.w600)),
          if (income > 0 && expense > 0)
            Text('  ·  ', style: text.labelSmall?.copyWith(color: scheme.outlineVariant)),
          if (expense > 0)
            Text('-${fmt.format(expense)}',
                style: text.labelSmall?.copyWith(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _ExpenseTile extends StatelessWidget {
  const _ExpenseTile({
    required this.expense,
    required this.catalog,
    required this.l10n,
    required this.onDelete,
    required this.onMoveToVault,
    required this.onEdit,
  });

  final Expense expense;
  final CategoryCatalog catalog;
  final AppLocalizations l10n;
  final Future<void> Function(int id) onDelete;
  final Future<void> Function(int id) onMoveToVault;
  final void Function(Expense e) onEdit;

  @override
  Widget build(BuildContext context) {
    final isIncome = expense.type == 'income';
    final cat = isIncome ? null : catalog.resolve(expense.category);
    final src = isIncome ? IncomeSource.fromString(expense.category) : null;
    final scheme = Theme.of(context).colorScheme;
    final fmt = NumberFormat('#,##0', 'en');
    final formatted = fmt.format(expense.amount);
    final label = isIncome ? src!.label(l10n) : cat!.label(l10n);
    final catColor = isIncome ? Colors.green.shade700 : cat!.color;

    return Dismissible(
      key: ValueKey(expense.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.khataDelete),
          content: Text('Rs $formatted — $label'),
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
      child: InkWell(
        onTap: () => onEdit(expense),
        onLongPress: () => _showLongPressMenu(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              // Rounded-square category avatar with category color
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: catColor.withAlpha(28),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: isIncome
                    ? Icon(src!.icon, size: 22, color: catColor)
                    : cat!.iconWidget(size: 22, color: catColor),
              ),
              const SizedBox(width: 12),
              // Category label + subtitle row
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: label + bank badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            label,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (_bankTag(expense.note) != null) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _bankTag(expense.note)!,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSecondaryContainer,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    // Subtitle: note text (if any)
                    if (_cleanNote(expense.note).isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        _cleanNote(expense.note),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Amount + optional receipt thumb
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isIncome ? '+Rs $formatted' : 'Rs $formatted',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isIncome ? Colors.green.shade700 : null,
                    ),
                  ),
                  if (expense.receiptPath != null) ...[
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.file(
                        File(expense.receiptPath!),
                        width: 28,
                        height: 28,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.receipt_outlined, size: 16),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLongPressMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: Text(AppLocalizations.of(context).khataShareWhatsApp),
              onTap: () {
                Navigator.pop(context);
                _shareWhatsApp(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock_outlined),
              title: Text(AppLocalizations.of(context).vaultMove),
              subtitle: Text(AppLocalizations.of(context).vaultMoveHint),
              onTap: () {
                Navigator.pop(context);
                onMoveToVault(expense.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _shareWhatsApp(BuildContext context) {
    final fmt = NumberFormat('#,##0', 'en');
    final isIncome = expense.type == 'income';
    final sign = isIncome ? '+' : '-';
    final l10n = AppLocalizations.of(context);
    final typeLabel = isIncome ? l10n.khataIncome : l10n.khataExpense;
    final note = expense.note.isNotEmpty ? '\n📝 ${expense.note}' : '';
    final text = '📅 ${expense.date}\n'
        '$typeLabel: ${sign}Rs ${fmt.format(expense.amount)}'
        '$note';
    Share.share(text);
  }
}

// ── Bank feed tab ─────────────────────────────────────────────────────────────

enum _BankDirection { all, in_, out }

class _BankFeed extends ConsumerStatefulWidget {
  const _BankFeed({required this.month});
  final DateTime month;

  @override
  ConsumerState<_BankFeed> createState() => _BankFeedState();
}

class _BankFeedState extends ConsumerState<_BankFeed> {
  _BankDirection _direction = _BankDirection.all;
  String? _selectedBank;
  String _bankQuery = '';
  final _bankSearchCtrl = TextEditingController();

  @override
  void dispose() {
    _bankSearchCtrl.dispose();
    super.dispose();
  }

  static String _bankName(Expense e) =>
      e.note.isNotEmpty ? e.note.split(':').first.trim() : 'Bank';

  List<Expense> _applyFilters(List<Expense> all) {
    var list = all;
    if (_direction == _BankDirection.in_) {
      list = list.where((e) => e.type == 'income').toList();
    } else if (_direction == _BankDirection.out) {
      list = list.where((e) => e.type != 'income').toList();
    }
    if (_selectedBank != null) {
      list = list.where((e) => _bankName(e) == _selectedBank).toList();
    }
    if (_bankQuery.isNotEmpty) {
      final q = _bankQuery.toLowerCase();
      list = list
          .where((e) =>
              e.note.toLowerCase().contains(q) ||
              _bankName(e).toLowerCase().contains(q) ||
              e.amount.toString().contains(q))
          .toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final yearMonth = DateFormat('yyyy-MM').format(widget.month);
    final stream = ref.watch(appDatabaseProvider).expensesDao.watchBankMonth(yearMonth);
    final fmt = NumberFormat('#,##0', 'en');
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return StreamBuilder<List<Expense>>(
      stream: stream,
      builder: (context, snap) {
        final all = snap.data ?? [];
        final filtered = _applyFilters(all);

        // Dynamic bank list from actual data
        final banks = all.map(_bankName).toSet().toList()..sort();
        // Reset selected bank if it no longer exists in data
        if (_selectedBank != null && !banks.contains(_selectedBank)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _selectedBank = null);
          });
        }

        return Column(
          children: [
            // ── Search bar ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: TextField(
                controller: _bankSearchCtrl,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).bankSearch,
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _bankQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            _bankSearchCtrl.clear();
                            setState(() => _bankQuery = '');
                          },
                        )
                      : null,
                  isDense: true,
                  filled: true,
                  fillColor: scheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onChanged: (v) => setState(() => _bankQuery = v.trim()),
              ),
            ),
            // ── Filter row 1: Direction ──────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: SegmentedButton<_BankDirection>(
                segments: [
                  ButtonSegment(value: _BankDirection.all,  label: Text(AppLocalizations.of(context).filterAll)),
                  ButtonSegment(value: _BankDirection.in_,  label: Text(AppLocalizations.of(context).bankIn),  icon: Icon(Icons.arrow_downward, size: 14)),
                  ButtonSegment(value: _BankDirection.out,  label: Text(AppLocalizations.of(context).bankOut), icon: Icon(Icons.arrow_upward,   size: 14)),
                ],
                selected: {_direction},
                onSelectionChanged: (s) => setState(() => _direction = s.first),
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
              ),
            ),
            // ── Filter row 2: Bank picker (only if >1 bank) ──────
            if (banks.length > 1)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(AppLocalizations.of(context).bankAllBanks),
                        selected: _selectedBank == null,
                        onSelected: (_) => setState(() => _selectedBank = null),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    for (final bank in banks)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(bank),
                          selected: _selectedBank == bank,
                          onSelected: (_) => setState(() =>
                              _selectedBank = _selectedBank == bank ? null : bank),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 4),
            // ── Transaction list ──────────────────────────────────
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.account_balance_outlined, size: 56, color: scheme.outlineVariant),
                          const SizedBox(height: 12),
                          Text(
                            all.isEmpty ? AppLocalizations.of(context).bankEmpty : AppLocalizations.of(context).bankNoMatch,
                            style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                          if (all.isEmpty) ...[
                            const SizedBox(height: 6),
                            Text(AppLocalizations.of(context).bankAutoCaptured,
                                style: text.bodySmall?.copyWith(color: scheme.outlineVariant)),
                          ],
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => Divider(height: 1, indent: 72, color: scheme.outlineVariant.withAlpha(60)),
                      itemBuilder: (context, i) {
                        final e = filtered[i];
                        final isCredit = e.type == 'income';
                        final bank = _bankName(e);
                        final color = isCredit ? Colors.green.shade700 : scheme.error;
                        final sign = isCredit ? '+' : '-';
                        return Dismissible(
                          key: ValueKey(e.id),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (_) => showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(AppLocalizations.of(context).entryDelete),
                              content: Text('$sign Rs ${fmt.format(e.amount)} — $bank'),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: Text(AppLocalizations.of(context).cancel)),
                                FilledButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  style: FilledButton.styleFrom(backgroundColor: scheme.error),
                                  child: Text(AppLocalizations.of(context).delete),
                                ),
                              ],
                            ),
                          ),
                          onDismissed: (_) =>
                              ref.read(appDatabaseProvider).expensesDao.remove(e.id),
                          background: Container(
                            color: scheme.error,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: Icon(Icons.delete_outline, color: scheme.onError),
                          ),
                          child: ListTile(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => AddExpenseScreen(expense: e)),
                            ),
                            onLongPress: () => Share.share(
                                '📅 ${e.date}\n$bank\n${sign}Rs ${fmt.format(e.amount)}\n${e.note}'),
                            leading: CircleAvatar(
                              backgroundColor: color.withAlpha(28),
                              child: Icon(Icons.account_balance_outlined,
                                  size: 20, color: color),
                            ),
                            title: Text(
                              '$sign Rs ${fmt.format(e.amount)}',
                              style: text.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w700, color: color),
                            ),
                            subtitle: Text(e.note,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: text.bodySmall),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(e.date,
                                    style: text.bodySmall
                                        ?.copyWith(color: scheme.onSurfaceVariant)),
                                Text(bank,
                                    style: text.bodySmall?.copyWith(
                                        color: scheme.primary,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
