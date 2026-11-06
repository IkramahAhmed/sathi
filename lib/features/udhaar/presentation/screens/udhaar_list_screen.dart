import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers.dart';
import '../../../../core/storage/app_database.dart';
import '../../../../l10n/app_localizations.dart';
import 'udhaar_contact_screen.dart';

class UdhaarListScreen extends ConsumerStatefulWidget {
  const UdhaarListScreen({super.key});

  @override
  ConsumerState<UdhaarListScreen> createState() => _UdhaarListScreenState();
}

class _UdhaarListScreenState extends ConsumerState<UdhaarListScreen> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _addContact() async {
    final name = await _contactDialog(context);
    if (name == null || name.trim().isEmpty) return;
    await ref.read(appDatabaseProvider).udhaarDao.addContact(
          UdhaarContactsCompanion.insert(
            name: name.trim(),
            createdAt: DateTime.now().toUtc(),
          ),
        );
  }

  Future<String?> _contactDialog(BuildContext context, {String initial = ''}) {
    final ctrl = TextEditingController(text: initial);
    final l10n = AppLocalizations.of(context);
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.udhaarAddContact),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: l10n.udhaarContactName,
            border: const OutlineInputBorder(),
          ),
          onSubmitted: (_) => Navigator.pop(ctx, ctrl.text),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text),
              child: Text(l10n.udhaarSave)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final db = ref.watch(appDatabaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.udhaarTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _search,
              onChanged: (v) => setState(() => _query = v.toLowerCase()),
              decoration: InputDecoration(
                hintText: l10n.udhaarSearch,
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<Map<int, double>>(
        stream: db.udhaarDao.watchBalances(),
        builder: (context, balSnap) {
          final balances = balSnap.data ?? {};
          return StreamBuilder<List<UdhaarContact>>(
            stream: db.udhaarDao.watchContacts(),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final all = snap.data!;
              final filtered = _query.isEmpty
                  ? all
                  : all
                      .where((c) => c.name.toLowerCase().contains(_query))
                      .toList();

              if (all.isEmpty) {
                return _EmptyState(l10n: l10n, onAdd: _addContact);
              }

              // Summary row at top
              double totalOwedToMe = 0;
              double totalIOwe = 0;
              for (final b in balances.values) {
                if (b > 0) totalOwedToMe += b;
                if (b < 0) totalIOwe += b.abs();
              }

              return Column(
                children: [
                  _SummaryBar(
                    owedToMe: totalOwedToMe,
                    iOwe: totalIOwe,
                    scheme: scheme,
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, indent: 72),
                      itemBuilder: (_, i) {
                        final c = filtered[i];
                        final bal = balances[c.id] ?? 0;
                        return _ContactTile(
                          contact: c,
                          balance: bal,
                          l10n: l10n,
                          scheme: scheme,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  UdhaarContactScreen(contact: c),
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
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addContact,
        icon: const Icon(Icons.person_add_outlined),
        label: Text(l10n.udhaarAddContact),
      ),
    );
  }
}

// ── Summary bar ──────────────────────────────────────────────────────────────

class _SummaryBar extends StatelessWidget {
  const _SummaryBar(
      {required this.owedToMe, required this.iOwe, required this.scheme});

  final double owedToMe;
  final double iOwe;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fmt = NumberFormat('#,##0', 'en');
    return Container(
      color: scheme.surfaceContainerLow,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: _SummaryCell(
              label: l10n.udhaarOwedToMe,
              amount: 'Rs. ${fmt.format(owedToMe)}',
              color: Colors.green.shade700,
            ),
          ),
          Container(width: 1, height: 32, color: scheme.outlineVariant),
          Expanded(
            child: _SummaryCell(
              label: l10n.udhaarIOwe,
              amount: 'Rs. ${fmt.format(iOwe)}',
              color: scheme.error,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCell extends StatelessWidget {
  const _SummaryCell(
      {required this.label, required this.amount, required this.color});

  final String label;
  final String amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(label,
            style: text.labelSmall
                ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        const SizedBox(height: 2),
        Text(amount,
            style: text.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}

// ── Contact tile ─────────────────────────────────────────────────────────────

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.contact,
    required this.balance,
    required this.l10n,
    required this.scheme,
    required this.onTap,
  });

  final UdhaarContact contact;
  final double balance;
  final AppLocalizations l10n;
  final ColorScheme scheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##0', 'en');
    final isPositive = balance >= 0;
    final color =
        isPositive ? Colors.green.shade700 : scheme.error;
    final label = isPositive ? l10n.udhaarOwes : l10n.udhaarYouOwe;

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: scheme.primaryContainer,
        child: Text(
          contact.name.isNotEmpty
              ? contact.name[0].toUpperCase()
              : '?',
          style: TextStyle(
              color: scheme.onPrimaryContainer, fontWeight: FontWeight.w700),
        ),
      ),
      title: Text(contact.name,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: balance == 0
          ? Text(l10n.udhaarSettled,
              style: TextStyle(color: scheme.onSurfaceVariant))
          : Text(label, style: TextStyle(color: color)),
      trailing: balance == 0
          ? Icon(Icons.check_circle_outline,
              color: scheme.onSurfaceVariant, size: 20)
          : Text(
              'Rs. ${fmt.format(balance.abs())}',
              style: TextStyle(
                  fontWeight: FontWeight.w700, color: color, fontSize: 15),
            ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.l10n, required this.onAdd});

  final AppLocalizations l10n;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.handshake_outlined, size: 72,
                color: scheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(l10n.udhaarEmpty,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(l10n.udhaarEmptyHint,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: scheme.onSurfaceVariant),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.person_add_outlined),
              label: Text(l10n.udhaarAddContact),
            ),
          ],
        ),
      ),
    );
  }
}
