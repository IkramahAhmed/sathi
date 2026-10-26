import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers.dart';
import '../../../../core/storage/app_database.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../khata/domain/entities/expense_category.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  ExpenseCategory _category = ExpenseCategory.food;
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save(AppLocalizations l10n) async {
    final amountText = _amountController.text.trim();
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.khataAmountInvalid)));
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(appDatabaseProvider).expensesDao.add(
            ExpensesCompanion.insert(
              amount: amount,
              category: _category.name,
              note: Value(_noteController.text.trim()),
              date:
                  '${_date.year.toString().padLeft(4, '0')}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}',
              createdAt: DateTime.now().toUtc(),
            ),
          );
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final dateLabel = DateFormat.yMMMd().format(_date);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.khataAddTitle),
        actions: [
          if (_saving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else
            TextButton(
              onPressed: () => _save(l10n),
              child: Text(l10n.khataSave),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Amount
          TextField(
            controller: _amountController,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
            style: text.displaySmall?.copyWith(fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              prefixText: 'Rs. ',
              prefixStyle: text.headlineSmall?.copyWith(color: scheme.onSurfaceVariant),
              hintText: '0',
              hintStyle: text.displaySmall?.copyWith(color: scheme.onSurfaceVariant),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              label: Text(l10n.khataAmount),
            ),
          ),

          const SizedBox(height: 24),

          // Category
          Text(l10n.khataCategory, style: text.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final cat in ExpenseCategory.values)
                FilterChip(
                  avatar: Icon(cat.icon, size: 16),
                  label: Text(cat.label(l10n)),
                  selected: _category == cat,
                  onSelected: (_) => setState(() => _category = cat),
                ),
            ],
          ),

          const SizedBox(height: 24),

          // Note
          TextField(
            controller: _noteController,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              label: Text(l10n.khataNote),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            maxLines: 2,
          ),

          const SizedBox(height: 16),

          // Date
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today_outlined),
            title: Text(l10n.khataDate),
            trailing: Text(dateLabel, style: text.bodyLarge),
            onTap: _pickDate,
          ),
        ],
      ),
    );
  }
}
