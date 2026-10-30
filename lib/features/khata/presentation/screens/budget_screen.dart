import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/expense_category.dart';
import '../providers/khata_providers.dart';

class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key});

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  late final Map<ExpenseCategory, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    final current = ref.read(budgetNotifierProvider);
    _controllers = {
      for (final cat in ExpenseCategory.values)
        cat: TextEditingController(
          text: (current[cat] ?? 0) > 0 ? _fmt(current[cat]!) : '',
        ),
    };
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  String _fmt(double v) =>
      v == v.truncateToDouble() ? v.toInt().toString() : v.toStringAsFixed(2);

  Future<void> _save(AppLocalizations l10n) async {
    final budgets = <ExpenseCategory, double>{};
    for (final cat in ExpenseCategory.values) {
      final raw = _controllers[cat]!.text.trim();
      budgets[cat] = double.tryParse(raw) ?? 0;
    }
    await ref.read(budgetNotifierProvider.notifier).saveAll(budgets);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.khataBudgetSaved), duration: const Duration(seconds: 2)),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.khataBudget),
        actions: [
          TextButton(
            onPressed: () => _save(l10n),
            child: Text(l10n.done, style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 16),
            child: Text(l10n.khataBudgetHint, style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
          ),
          for (final cat in ExpenseCategory.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: scheme.secondaryContainer,
                    child: Icon(cat.icon, size: 18, color: scheme.onSecondaryContainer),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(cat.label(l10n), style: text.bodyLarge),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 110,
                    child: TextField(
                      controller: _controllers[cat],
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                      ],
                      textAlign: TextAlign.right,
                      style: text.bodyLarge,
                      decoration: InputDecoration(
                        prefixText: 'Rs. ',
                        prefixStyle: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                        hintText: '0',
                        isDense: true,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: () => _save(l10n),
            child: Text(l10n.done),
          ),
        ],
      ),
    );
  }
}
