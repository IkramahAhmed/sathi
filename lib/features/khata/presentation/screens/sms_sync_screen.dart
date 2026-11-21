import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers.dart';
import '../../../../core/services/sms_reader.dart';
import '../../../../core/services/transaction_parser.dart';
import '../../../../core/storage/app_database.dart';
import '../../domain/entities/gmail_transaction.dart';

final _fmt = NumberFormat('#,##0', 'en_US');

class SmsSyncScreen extends ConsumerStatefulWidget {
  const SmsSyncScreen({super.key});

  @override
  ConsumerState<SmsSyncScreen> createState() => _SmsSyncScreenState();
}

class _SmsSyncScreenState extends ConsumerState<SmsSyncScreen> {
  final _reader = SmsReader();

  _Phase _phase = _Phase.idle;
  String? _error;
  List<_SelectableTx> _transactions = [];

  @override
  void initState() {
    super.initState();
    _startFetch();
  }

  Future<void> _startFetch() async {
    setState(() {
      _phase = _Phase.loading;
      _error = null;
      _transactions = [];
    });

    try {
      final txs = await _reader.fetchTransactions(monthsBack: 3);
      setState(() {
        _transactions = txs.map((t) => _SelectableTx(t)).toList();
        _phase = _transactions.isEmpty ? _Phase.empty : _Phase.review;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _phase = _Phase.error;
      });
    }
  }

  Future<void> _importSelected() async {
    final selected = _transactions.where((t) => t.selected).toList();
    if (selected.isEmpty) return;

    setState(() => _phase = _Phase.importing);

    final dao = ref.read(appDatabaseProvider).expensesDao;
    final now = DateTime.now().toUtc();

    for (final item in selected) {
      final tx = item.tx;
      final isCredit = tx.type == GmailTxType.credit;
      final dateStr =
          '${tx.date.year.toString().padLeft(4, '0')}-${tx.date.month.toString().padLeft(2, '0')}-${tx.date.day.toString().padLeft(2, '0')}';

      final (category, _) = suggestCategory(tx.description, tx.type);
      await dao.addIfNew(
        ExpensesCompanion.insert(
          amount: tx.amount,
          category: category,
          type: Value(isCredit ? 'income' : 'expense'),
          note: Value('[${tx.sourceName}]${tx.currency != 'PKR' ? ' (${tx.currency})' : ''} ${tx.description}'),
          date: dateStr,
          createdAt: now,
        ),
      );
    }

    await SmsReader.markImported(selected.map((t) => t.tx.messageId).toList());

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${selected.length} transaction(s) imported')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Sync'),
        actions: [
          if (_phase == _Phase.review)
            TextButton(
              onPressed: _importSelected,
              child: const Text('Import'),
            ),
        ],
      ),
      body: switch (_phase) {
        _Phase.idle => const SizedBox.shrink(),
        _Phase.loading => const Center(child: CircularProgressIndicator()),
        _Phase.importing => const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Saving transactions…'),
              ],
            ),
          ),
        _Phase.error => _ErrorView(message: _error!, onRetry: _startFetch),
        _Phase.empty => _EmptyView(onRetry: _startFetch),
        _Phase.review => _ReviewList(
            transactions: _transactions,
            scheme: scheme,
            onToggle: (i) => setState(() => _transactions[i].selected = !_transactions[i].selected),
            onSelectAll: () => setState(() {
              final allSelected = _transactions.every((t) => t.selected);
              for (final t in _transactions) {
                t.selected = !allSelected;
              }
            }),
          ),
      },
    );
  }
}

class _ReviewList extends StatelessWidget {
  const _ReviewList({
    required this.transactions,
    required this.scheme,
    required this.onToggle,
    required this.onSelectAll,
  });

  final List<_SelectableTx> transactions;
  final ColorScheme scheme;
  final void Function(int) onToggle;
  final VoidCallback onSelectAll;

  @override
  Widget build(BuildContext context) {
    final allSelected = transactions.every((t) => t.selected);
    final selectedCount = transactions.where((t) => t.selected).length;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '$selectedCount of ${transactions.length} selected',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              TextButton(
                onPressed: onSelectAll,
                child: Text(allSelected ? 'Deselect all' : 'Select all'),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.separated(
            itemCount: transactions.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final item = transactions[i];
              final tx = item.tx;
              final isCredit = tx.type == GmailTxType.credit;
              final color = isCredit ? Colors.green : scheme.error;

              return CheckboxListTile(
                value: item.selected,
                onChanged: (_) => onToggle(i),
                title: Text(tx.description),
                subtitle: Text(
                  '${tx.sourceName} · ${DateFormat('d MMM yyyy').format(tx.date)}',
                ),
                secondary: Text(
                  '${isCredit ? '+' : '-'}${tx.currencyPrefix}${_fmt.format(tx.amount.round())}',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                controlAffinity: ListTileControlAffinity.leading,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sms_outlined, size: 56),
            const SizedBox(height: 16),
            Text(
              'No new bank SMS found.\nMake sure SMS alerts are ON in\nyour bank app settings.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      );
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 56),
              const SizedBox(height: 16),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
}

enum _Phase { idle, loading, review, empty, importing, error }

class _SelectableTx {
  _SelectableTx(this.tx);
  final GmailTransaction tx;
  bool selected = true;
}
