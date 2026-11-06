import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/providers.dart';
import '../../../../core/storage/app_database.dart';
import '../../../../l10n/app_localizations.dart';

class UdhaarContactScreen extends ConsumerStatefulWidget {
  const UdhaarContactScreen({super.key, required this.contact});

  final UdhaarContact contact;

  @override
  ConsumerState<UdhaarContactScreen> createState() =>
      _UdhaarContactScreenState();
}

class _UdhaarContactScreenState extends ConsumerState<UdhaarContactScreen> {
  late UdhaarContact _contact;

  @override
  void initState() {
    super.initState();
    _contact = widget.contact;
  }

  Future<void> _addEntry(String type) async {
    final l10n = AppLocalizations.of(context);
    final result = await showModalBottomSheet<_EntryInput>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _AddEntrySheet(type: type, l10n: l10n),
    );
    if (result == null) return;
    await ref.read(appDatabaseProvider).udhaarDao.addEntry(
          UdhaarEntriesCompanion.insert(
            contactId: _contact.id,
            amount: result.amount,
            type: type,
            note: Value(result.note),
            date: result.date,
            createdAt: DateTime.now().toUtc(),
          ),
        );
  }

  Future<void> _sendWhatsApp(double balance) async {
    final l10n = AppLocalizations.of(context);
    final fmt = NumberFormat('#,##0', 'en');
    final amount = fmt.format(balance.abs());
    final isLena = balance > 0;
    final message = isLena
        ? l10n.udhaarWhatsAppLena(_contact.name, amount)
        : l10n.udhaarWhatsAppDena(_contact.name, amount);

    // If phone saved, open WhatsApp directly; otherwise share
    final phone = _contact.phone.trim();
    if (phone.isNotEmpty) {
      // Normalize: strip leading 0, prepend +92
      final normalized = phone.startsWith('0') ? '92${phone.substring(1)}' : phone;
      final uri = Uri.parse(
          'https://wa.me/$normalized?text=${Uri.encodeComponent(message)}');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }
    }
    // Fallback: system share sheet
    final uri = Uri.parse(
        'whatsapp://send?text=${Uri.encodeComponent(message)}');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.udhaarWhatsAppNotFound)));
      }
    }
  }

  Future<void> _editName() async {
    final l10n = AppLocalizations.of(context);
    final nameCtrl = TextEditingController(text: _contact.name);
    final phoneCtrl = TextEditingController(text: _contact.phone);
    final result = await showDialog<(String, String)>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.udhaarEditContact),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                  labelText: l10n.udhaarContactName,
                  border: const OutlineInputBorder()),
              onSubmitted: (_) =>
                  Navigator.pop(ctx, (nameCtrl.text, phoneCtrl.text)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: l10n.udhaarPhone,
                hintText: '03001234567',
                prefixText: '+92 ',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          FilledButton(
              onPressed: () =>
                  Navigator.pop(ctx, (nameCtrl.text, phoneCtrl.text)),
              child: Text(l10n.udhaarSave)),
        ],
      ),
    );
    if (result == null || result.$1.trim().isEmpty) return;
    await ref.read(appDatabaseProvider).udhaarDao.updateContact(
          _contact.id,
          UdhaarContactsCompanion(
            name: Value(result.$1.trim()),
            phone: Value(result.$2.trim()),
          ),
        );
    setState(() => _contact =
        _contact.copyWith(name: result.$1.trim(), phone: result.$2.trim()));
  }

  Future<void> _deleteContact() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.udhaarDeleteContact),
        content: Text(l10n.udhaarDeleteContactConfirm(_contact.name)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            child: Text(l10n.udhaarDelete),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await ref
          .read(appDatabaseProvider)
          .udhaarDao
          .deleteContact(_contact.id);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final db = ref.watch(appDatabaseProvider);

    return Scaffold(
      body: StreamBuilder<List<UdhaarEntry>>(
        stream: db.udhaarDao.watchEntries(_contact.id),
        builder: (context, snap) {
          if (!snap.hasData) {
            return Scaffold(
              appBar: AppBar(title: Text(_contact.name)),
              body: const Center(child: CircularProgressIndicator()),
            );
          }
          final entries = snap.data!;

          // Compute running balance
          double balance = 0;
          for (final e in entries) {
            balance += e.type == 'gave' ? e.amount : -e.amount;
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(_contact.name),
              actions: [
                if (balance != 0)
                  IconButton(
                    icon: Image.asset('assets/whatsapp.png',
                        width: 24, height: 24,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.chat_outlined)),
                    tooltip: l10n.udhaarWhatsAppReminder,
                    onPressed: () => _sendWhatsApp(balance),
                  ),
                IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: l10n.udhaarEditContact,
                    onPressed: _editName),
                IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: l10n.udhaarDeleteContact,
                    onPressed: _deleteContact),
              ],
            ),
            body: Column(
              children: [
                _BalanceHeader(
                    balance: balance, contact: _contact, scheme: scheme, l10n: l10n),
              Expanded(
                child: entries.isEmpty
                    ? _EmptyLedger(l10n: l10n)
                    : _EntryList(
                        entries: entries,
                        l10n: l10n,
                        scheme: scheme,
                        onDelete: (id) => ref
                            .read(appDatabaseProvider)
                            .udhaarDao
                            .deleteEntry(id),
                      ),
              ),
              _ActionButtons(
                l10n: l10n,
                onGave: () => _addEntry('gave'),
                onReceived: () => _addEntry('received'),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Balance header ────────────────────────────────────────────────────────────

class _BalanceHeader extends StatelessWidget {
  const _BalanceHeader(
      {required this.balance,
      required this.contact,
      required this.scheme,
      required this.l10n});

  final double balance;
  final UdhaarContact contact;
  final ColorScheme scheme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##0.##', 'en');
    final isPositive = balance >= 0;
    final color = balance == 0
        ? scheme.onSurfaceVariant
        : isPositive
            ? Colors.green.shade700
            : scheme.error;
    final label = balance == 0
        ? l10n.udhaarSettled
        : isPositive
            ? l10n.udhaarOwesYou(contact.name)
            : l10n.udhaarYouOweContact(contact.name);

    return Container(
      width: double.infinity,
      color: scheme.surfaceContainerLow,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: [
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 4),
          Text(
            balance == 0 ? l10n.udhaarClear : 'Rs. ${fmt.format(balance.abs())}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800, color: color),
          ),
        ],
      ),
    );
  }
}

// ── Entry list ────────────────────────────────────────────────────────────────

class _EntryList extends StatelessWidget {
  const _EntryList({
    required this.entries,
    required this.l10n,
    required this.scheme,
    required this.onDelete,
  });

  final List<UdhaarEntry> entries;
  final AppLocalizations l10n;
  final ColorScheme scheme;
  final Future<void> Function(int id) onDelete;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##0.##', 'en');
    return ListView.separated(
      itemCount: entries.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 56),
      itemBuilder: (_, i) {
        final e = entries[i];
        final isGave = e.type == 'gave';
        final color = isGave ? Colors.green.shade700 : scheme.error;
        final sign = isGave ? '+' : '−';
        final dateLabel = DateFormat('d MMM yyyy').format(DateTime.parse(e.date));

        return Dismissible(
          key: ValueKey(e.id),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) => showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(l10n.udhaarDeleteEntry),
              content: Text('Rs. ${fmt.format(e.amount)}'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text(l10n.cancel)),
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  style: FilledButton.styleFrom(
                      backgroundColor: scheme.error),
                  child: Text(l10n.udhaarDelete),
                ),
              ],
            ),
          ),
          onDismissed: (_) => onDelete(e.id),
          background: Container(
            color: scheme.error,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: Icon(Icons.delete_outline, color: scheme.onError),
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: isGave
                  ? Colors.green.shade50
                  : scheme.errorContainer,
              child: Icon(
                isGave ? Icons.arrow_upward : Icons.arrow_downward,
                size: 18,
                color: color,
              ),
            ),
            title: Text(
              '$sign Rs. ${fmt.format(e.amount)}',
              style: TextStyle(fontWeight: FontWeight.w700, color: color),
            ),
            subtitle: Text(
              e.note.isNotEmpty ? '${e.note} · $dateLabel' : dateLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}

// ── Action buttons ────────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  const _ActionButtons(
      {required this.l10n, required this.onGave, required this.onReceived});

  final AppLocalizations l10n;
  final VoidCallback onGave;
  final VoidCallback onReceived;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: onGave,
                style: FilledButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white),
                icon: const Icon(Icons.arrow_upward, size: 18),
                label: Text(l10n.udhaarGave),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: onReceived,
                style: FilledButton.styleFrom(
                    backgroundColor: scheme.error,
                    foregroundColor: scheme.onError),
                icon: const Icon(Icons.arrow_downward, size: 18),
                label: Text(l10n.udhaarReceived),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty ledger ──────────────────────────────────────────────────────────────

class _EmptyLedger extends StatelessWidget {
  const _EmptyLedger({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(l10n.udhaarNoEntries,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ── Add entry bottom sheet ────────────────────────────────────────────────────

class _EntryInput {
  const _EntryInput(
      {required this.amount, required this.note, required this.date});

  final double amount;
  final String note;
  final String date;
}

class _AddEntrySheet extends StatefulWidget {
  const _AddEntrySheet({required this.type, required this.l10n});

  final String type;
  final AppLocalizations l10n;

  @override
  State<_AddEntrySheet> createState() => _AddEntrySheetState();
}

class _AddEntrySheetState extends State<_AddEntrySheet> {
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  String get _dateStr =>
      '${_date.year.toString().padLeft(4, '0')}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _submit() {
    final amount = double.tryParse(_amountCtrl.text.trim());
    if (amount == null || amount <= 0) return;
    Navigator.pop(
      context,
      _EntryInput(
          amount: amount, note: _noteCtrl.text.trim(), date: _dateStr),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final isGave = widget.type == 'gave';
    final scheme = Theme.of(context).colorScheme;
    final color = isGave ? Colors.green.shade700 : scheme.error;
    final title = isGave ? l10n.udhaarGave : l10n.udhaarReceived;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(isGave ? Icons.arrow_upward : Icons.arrow_downward,
                color: color),
            const SizedBox(width: 8),
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700, color: color)),
          ]),
          const SizedBox(height: 16),
          TextField(
            controller: _amountCtrl,
            autofocus: true,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))
            ],
            decoration: InputDecoration(
              prefixText: 'Rs. ',
              labelText: l10n.udhaarAmount,
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _noteCtrl,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.udhaarNote,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today_outlined),
            title: Text(DateFormat.yMMMd().format(_date)),
            trailing: TextButton(
                onPressed: _pickDate, child: Text(l10n.udhaarChangeDate)),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submit,
              style: FilledButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: isGave ? Colors.white : scheme.onError),
              child: Text(l10n.udhaarSave),
            ),
          ),
        ],
      ),
    );
  }
}
