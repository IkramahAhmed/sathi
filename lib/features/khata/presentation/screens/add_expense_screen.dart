import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers.dart';
import '../../../../core/storage/app_database.dart';
import '../../../../core/storage/receipt_store.dart';
import '../../../../l10n/app_localizations.dart';
import 'accounts_screen.dart' show accountsProvider;
import '../../../khata/background/budget_check.dart';
import '../../../khata/background/recurring_check.dart';
import '../../../khata/domain/entities/expense_category.dart';
import '../../../khata/domain/entities/income_source.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key, this.expense, this.startAsIncome = false});

  final Expense? expense;
  final bool startAsIncome;

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;
  late ExpenseCategory _category;
  late IncomeSource _incomeSource;
  late DateTime _date;
  late bool _isIncome;
  String? _receiptPath;
  int? _accountId;
  bool _saving = false;
  bool _isRecurring = false;
  String _frequency = 'monthly';

  bool get _isEditing => widget.expense != null;

  @override
  void initState() {
    super.initState();
    final e = widget.expense;
    _amountController = TextEditingController(
      text: e != null ? e.amount.toStringAsFixed(e.amount % 1 == 0 ? 0 : 2) : '',
    );
    _noteController = TextEditingController(text: e?.note ?? '');
    _isIncome = e?.type == 'income' || widget.startAsIncome;
    _category = e != null && !_isIncome
        ? ExpenseCategory.fromString(e.category)
        : ExpenseCategory.food;
    _incomeSource = e != null && _isIncome
        ? IncomeSource.fromString(e.category)
        : IncomeSource.salary;
    _date = e != null ? DateTime.parse(e.date) : DateTime.now();
    _receiptPath = e?.receiptPath;
    _accountId = e?.accountId;
  }

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
    final dateStr =
        '${_date.year.toString().padLeft(4, '0')}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}';
    final categoryStr = _isIncome ? _incomeSource.name : _category.name;
    try {
      final dao = ref.read(appDatabaseProvider).expensesDao;
      final db = ref.read(appDatabaseProvider);
      if (_isEditing) {
        await dao.updateExpense(
          widget.expense!.id,
          ExpensesCompanion(
            amount: Value(amount),
            category: Value(categoryStr),
            type: Value(_isIncome ? 'income' : 'expense'),
            note: Value(_noteController.text.trim()),
            date: Value(dateStr),
            receiptPath: Value(_receiptPath),
            accountId: Value(_accountId),
          ),
        );
      } else {
        await dao.add(
          ExpensesCompanion.insert(
            amount: amount,
            category: categoryStr,
            type: Value(_isIncome ? 'income' : 'expense'),
            note: Value(_noteController.text.trim()),
            date: dateStr,
            receiptPath: Value(_receiptPath),
            accountId: Value(_accountId),
            createdAt: DateTime.now().toUtc(),
          ),
        );
      }
      // Budget check (only for expense entries)
      if (!_isIncome) {
        final yearMonth =
            '${_date.year.toString().padLeft(4, '0')}-${_date.month.toString().padLeft(2, '0')}';
        // Editing adds only the difference, and only if the entry stayed in the
        // same category and month; otherwise the whole amount is new there.
        final old = widget.expense;
        final sameBucket = old != null &&
            old.type != 'income' &&
            old.category == _category.name &&
            old.date.startsWith(yearMonth);
        final added = sameBucket ? amount - old.amount : amount;
        if (added > 0) {
          checkBudgetAndNotify(
            db: db,
            yearMonth: yearMonth,
            category: _category,
            addedAmount: added,
          );
        }
      }
      // Create recurring rule (new entries only)
      if (!_isEditing && _isRecurring) {
        final nextDue = advanceDate(_date, _frequency);
        final nds = '${nextDue.year.toString().padLeft(4, '0')}-'
            '${nextDue.month.toString().padLeft(2, '0')}-'
            '${nextDue.day.toString().padLeft(2, '0')}';
        await db.recurringExpensesDao.add(RecurringExpensesCompanion.insert(
          amount: amount,
          category: categoryStr,
          type: Value(_isIncome ? 'income' : 'expense'),
          note: Value(_noteController.text.trim()),
          frequency: _frequency,
          nextDue: nds,
          anchorDay: Value(_date.day),
          createdAt: DateTime.now().toUtc(),
        ));
      }
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

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (img != null) {
      final kept = await ReceiptStore.persist(img.path);
      if (mounted) setState(() => _receiptPath = kept);
    }
  }

  Future<void> _pickPhotoFromGallery() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (img != null) {
      final kept = await ReceiptStore.persist(img.path);
      if (mounted) setState(() => _receiptPath = kept);
    }
  }

  Future<void> _showPhotoOptions(AppLocalizations l10n) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: Text(l10n.expensePhotoTake),
              onTap: () { Navigator.pop(context); _pickPhoto(); },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.expensePhotoGallery),
              onTap: () { Navigator.pop(context); _pickPhotoFromGallery(); },
            ),
            if (_receiptPath != null)
              ListTile(
                leading: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                title: Text(l10n.khataRemovePhoto,
                    style: TextStyle(color: Theme.of(context).colorScheme.error)),
                onTap: () { Navigator.pop(context); setState(() => _receiptPath = null); },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final dateLabel = DateFormat.yMMMd().format(_date);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing
            ? (_isIncome ? l10n.khataAddIncome : l10n.khataAddExpense)
            : (_isIncome ? l10n.khataAddIncome : l10n.khataAddExpense)),
        actions: [
          if (_saving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else ...[
            if (_isEditing)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: l10n.khataDelete,
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(l10n.khataDelete),
                      content:
                          Text('Rs. ${_amountController.text}'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text(l10n.cancel)),
                        FilledButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          style: FilledButton.styleFrom(
                              backgroundColor: scheme.error),
                          child: Text(l10n.khataDelete),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true && mounted) {
                    await ref
                        .read(appDatabaseProvider)
                        .expensesDao
                        .remove(widget.expense!.id);
                    if (mounted) Navigator.of(context).pop();
                  }
                },
              ),
            TextButton(
              onPressed: () => _save(l10n),
              child: Text(l10n.khataSave),
            ),
          ],
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Income / Expense toggle
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(
                value: false,
                label: Text(l10n.khataExpense),
                icon: const Icon(Icons.arrow_upward, size: 16),
              ),
              ButtonSegment(
                value: true,
                label: Text(l10n.khataIncome),
                icon: const Icon(Icons.arrow_downward, size: 16),
              ),
            ],
            selected: {_isIncome},
            onSelectionChanged: (s) => setState(() => _isIncome = s.first),
          ),

          const SizedBox(height: 20),

          // Amount
          TextField(
            controller: _amountController,
            autofocus: true,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'^\d*\.?\d{0,2}'))
            ],
            style: text.displaySmall
                ?.copyWith(fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              prefixText: 'Rs. ',
              prefixStyle: text.headlineSmall
                  ?.copyWith(color: scheme.onSurfaceVariant),
              hintText: '0',
              hintStyle: text.displaySmall
                  ?.copyWith(color: scheme.onSurfaceVariant),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
              label: Text(l10n.khataAmount),
            ),
          ),

          const SizedBox(height: 24),

          // Category / Source chips
          Text(
            _isIncome ? l10n.expenseSource : l10n.khataCategory,
            style: text.labelLarge,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _isIncome
                ? [
                    for (final src in IncomeSource.values)
                      FilterChip(
                        avatar: Icon(src.icon, size: 16),
                        label: Text(src.label(l10n)),
                        selected: _incomeSource == src,
                        onSelected: (_) =>
                            setState(() => _incomeSource = src),
                      ),
                  ]
                : [
                    for (final cat in ExpenseCategory.values)
                      FilterChip(
                        avatar: Icon(cat.icon, size: 16),
                        label: Text(cat.label(l10n)),
                        selected: _category == cat,
                        onSelected: (_) =>
                            setState(() => _category = cat),
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
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            maxLines: 2,
          ),

          Builder(builder: (context) {
            final accounts = ref.watch(accountsProvider).value ?? const <Account>[];
            if (accounts.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: DropdownButtonFormField<int?>(
                initialValue: accounts.any((a) => a.id == _accountId) ? _accountId : null,
                decoration: InputDecoration(
                  labelText: l10n.accountPick,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: [
                  DropdownMenuItem<int?>(value: null, child: Text(l10n.accountNone)),
                  for (final a in accounts) DropdownMenuItem<int?>(value: a.id, child: Text(a.name)),
                ],
                onChanged: (v) => setState(() => _accountId = v),
              ),
            );
          }),

          const SizedBox(height: 16),

          // Date
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today_outlined),
            title: Text(l10n.khataDate),
            trailing: Text(dateLabel, style: text.bodyLarge),
            onTap: _pickDate,
          ),

          // Repeat
          if (!_isEditing) ...[
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(Icons.repeat_outlined),
              title: Text(l10n.expenseRepeat),
              value: _isRecurring,
              onChanged: (v) => setState(() => _isRecurring = v),
            ),
            if (_isRecurring)
              Padding(
                padding: const EdgeInsets.only(left: 56, bottom: 8),
                child: Wrap(
                  spacing: 8,
                  children: [
                    for (final f in ['daily', 'weekly', 'monthly', 'yearly'])
                      ChoiceChip(
                        label: Text(switch (f) {
                          'daily' => l10n.freqDaily,
                          'weekly' => l10n.freqWeekly,
                          'yearly' => l10n.freqYearly,
                          _ => l10n.freqMonthly,
                        }),
                        selected: _frequency == f,
                        onSelected: (_) =>
                            setState(() => _frequency = f),
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
              ),
          ],

          // Receipt photo
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.receipt_long_outlined),
            title: Text(l10n.khataReceiptPhoto),
            trailing: _receiptPath != null
                ? GestureDetector(
                    onTap: () => _showPhotoOptions(l10n),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.file(
                        File(_receiptPath!),
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image_outlined),
                      ),
                    ),
                  )
                : TextButton(
                    onPressed: () => _showPhotoOptions(l10n),
                    child: Text(l10n.khataAddPhoto),
                  ),
            onTap: () => _showPhotoOptions(l10n),
          ),
        ],
      ),
    );
  }
}
