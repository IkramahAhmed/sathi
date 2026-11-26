import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers.dart';
import '../../../../core/storage/app_database.dart';
import '../../../../l10n/app_localizations.dart';

final accountsProvider = StreamProvider<List<Account>>(
    (ref) => ref.watch(appDatabaseProvider).accountsDao.watchAll());

final accountBalancesProvider = StreamProvider<Map<int, double>>(
    (ref) => ref.watch(appDatabaseProvider).accountsDao.watchBalances());

IconData accountIcon(String kind) => switch (kind) {
      'bank' => Icons.account_balance_outlined,
      'wallet' => Icons.phone_android_outlined,
      _ => Icons.payments_outlined,
    };

String accountKindLabel(AppLocalizations l10n, String kind) => switch (kind) {
      'bank' => l10n.accountBank,
      'wallet' => l10n.accountWallet,
      _ => l10n.accountCash,
    };

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final accounts = ref.watch(accountsProvider).value ?? const <Account>[];
    final balances = ref.watch(accountBalancesProvider).value ?? const <int, double>{};
    final fmt = NumberFormat('#,##0', 'en');
    final total = accounts.fold(0.0, (s, a) => s + (balances[a.id] ?? a.openingBalance));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.accountsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: Text(l10n.accountAdd),
        onPressed: () => _edit(context, ref),
      ),
      body: accounts.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(l10n.accountsEmpty,
                    textAlign: TextAlign.center,
                    style: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant)),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              children: [
                Card(
                  color: scheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.accountTotal,
                            style: text.labelMedium?.copyWith(color: scheme.onPrimaryContainer)),
                        const SizedBox(height: 4),
                        Text('Rs ${fmt.format(total)}',
                            style: text.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700, color: scheme.onPrimaryContainer)),
                      ],
                    ),
                  ),
                ),
                for (final a in accounts)
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: scheme.secondaryContainer,
                        child: Icon(accountIcon(a.kind), color: scheme.onSecondaryContainer),
                      ),
                      title: Text(a.name),
                      subtitle: Text(accountKindLabel(l10n, a.kind)),
                      trailing: Text(
                        'Rs ${fmt.format(balances[a.id] ?? a.openingBalance)}',
                        style: text.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: (balances[a.id] ?? a.openingBalance) < 0 ? scheme.error : null,
                        ),
                      ),
                      onTap: () => _actions(context, ref, a),
                    ),
                  ),
              ],
            ),
    );
  }

  Future<void> _actions(BuildContext context, WidgetRef ref, Account account) {
    final l10n = AppLocalizations.of(context);
    return showModalBottomSheet<void>(
      context: context,
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(l10n.edit),
              onTap: () {
                Navigator.pop(sheet);
                _edit(context, ref, account: account);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
              title: Text(l10n.delete),
              subtitle: Text(l10n.accountDeleteWarn),
              onTap: () async {
                Navigator.pop(sheet);
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('${l10n.delete}: ${account.name}?'),
                    content: Text(l10n.accountDeleteWarn),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
                      FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.delete)),
                    ],
                  ),
                );
                if (ok == true) await ref.read(appDatabaseProvider).accountsDao.remove(account.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, {Account? account}) async {
    final l10n = AppLocalizations.of(context);
    final name = TextEditingController(text: account?.name ?? '');
    final opening = TextEditingController(
        text: account == null || account.openingBalance == 0 ? '' : account.openingBalance.toStringAsFixed(0));
    var kind = account?.kind ?? 'cash';
    final db = ref.read(appDatabaseProvider);

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(account == null ? l10n.accountAdd : l10n.edit),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(labelText: l10n.accountName),
              ),
              const SizedBox(height: 12),
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(value: 'cash', label: Text(l10n.accountCash)),
                  ButtonSegment(value: 'bank', label: Text(l10n.accountBank)),
                  ButtonSegment(value: 'wallet', label: Text(l10n.accountWallet)),
                ],
                selected: {kind},
                onSelectionChanged: (s) => setState(() => kind = s.first),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: opening,
                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d{0,2}'))],
                decoration: InputDecoration(labelText: l10n.accountOpening, prefixText: 'Rs. '),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.save)),
          ],
        ),
      ),
    );

    final title = name.text.trim();
    final balance = double.tryParse(opening.text) ?? 0;
    name.dispose();
    opening.dispose();
    if (ok != true || title.isEmpty) return;

    if (account == null) {
      await db.accountsDao.add(AccountsCompanion.insert(
        name: title,
        kind: Value(kind),
        openingBalance: Value(balance),
        createdAt: DateTime.now().toUtc(),
      ));
    } else {
      await (db.update(db.accounts)..where((t) => t.id.equals(account.id))).write(
        AccountsCompanion(name: Value(title), kind: Value(kind), openingBalance: Value(balance)),
      );
    }
  }
}
