import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';

import '../../../../app/providers.dart';
import '../../../../core/storage/app_database.dart';
import '../../../khata/domain/entities/expense_category.dart';
import '../../../khata/domain/entities/income_source.dart';
import '../../../khata/presentation/screens/add_expense_screen.dart';
import '../../../udhaar/presentation/screens/udhaar_contact_screen.dart';
import '../../../../l10n/app_localizations.dart';

class VaultScreen extends ConsumerStatefulWidget {
  const VaultScreen({super.key});

  @override
  ConsumerState<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends ConsumerState<VaultScreen>
    with WidgetsBindingObserver {
  bool _unlocked = false;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      if (!mounted) return;
      // Close any entry opened from the vault, so it is not still on screen when
      // the app comes back.
      final vaultRoute = ModalRoute.of(context);
      Navigator.of(context).popUntil((route) => route == vaultRoute || route.isFirst);
      setState(() { _unlocked = false; _error = null; });
    }
  }

  Future<void> _unlock() async {
    final auth = LocalAuthentication();
    bool canCheck = false;
    try {
      canCheck = await auth.canCheckBiometrics;
    } catch (_) {
      canCheck = false;
    }

    if (!canCheck) {
      setState(() => _error =
          'No biometrics enrolled.\nGo to device Settings → Security to add a fingerprint or face.');
      return;
    }

    setState(() { _busy = true; _error = null; });
    try {
      final ok = await auth.authenticate(
        localizedReason: AppLocalizations.of(context).vaultUnlockReason,
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (ok && mounted) setState(() => _unlocked = true);
    } on Exception catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _lock() => setState(() { _unlocked = false; _error = null; });

  @override
  Widget build(BuildContext context) {
    if (!_unlocked) {
      return _LockedVault(busy: _busy, error: _error, onUnlock: _unlock);
    }
    return _UnlockedVault(onLock: _lock);
  }
}

// ── Locked state ──────────────────────────────────────────────────────────────

class _LockedVault extends StatelessWidget {
  const _LockedVault({
    required this.busy,
    required this.error,
    required this.onUnlock,
  });

  final bool busy;
  final String? error;
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).vaultTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_outlined, size: 72, color: scheme.primary),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context).vaultTitle,
                style: text.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Your private entries are locked.\nUnlock with biometrics to view them.',
                textAlign: TextAlign.center,
                style: text.bodyMedium
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
              if (error != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: scheme.errorContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    error!,
                    textAlign: TextAlign.center,
                    style: text.bodySmall
                        ?.copyWith(color: scheme.onErrorContainer),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              busy
                  ? const CircularProgressIndicator()
                  : FilledButton.icon(
                      onPressed: onUnlock,
                      icon: const Icon(Icons.fingerprint),
                      label: Text(AppLocalizations.of(context).vaultUnlock),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(180, 48),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Unlocked vault ────────────────────────────────────────────────────────────

class _UnlockedVault extends ConsumerStatefulWidget {
  const _UnlockedVault({required this.onLock});

  final VoidCallback onLock;

  @override
  ConsumerState<_UnlockedVault> createState() => _UnlockedVaultState();
}

class _UnlockedVaultState extends ConsumerState<_UnlockedVault>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).vaultTitle),
        actions: [
          IconButton(
            tooltip: AppLocalizations.of(context).vaultLock,
            icon: Icon(Icons.lock_outline),
            onPressed: widget.onLock,
          ),
        ],
        bottom: TabBar(
          controller: _tab,
          tabs: [
            Tab(icon: Icon(Icons.receipt_long_outlined), text: AppLocalizations.of(context).khataTabExpenses),
            Tab(icon: Icon(Icons.handshake_outlined), text: AppLocalizations.of(context).vaultTabContacts),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: const [
          _VaultExpensesTab(),
          _VaultContactsTab(),
        ],
      ),
    );
  }
}

// ── Vault expenses tab ────────────────────────────────────────────────────────

class _VaultExpensesTab extends ConsumerWidget {
  const _VaultExpensesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(appDatabaseProvider);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final fmt = NumberFormat('#,##0', 'en');
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<List<Expense>>(
      stream: db.expensesDao.watchVault(),
      builder: (context, snap) {
        final items = snap.data ?? [];
        if (items.isEmpty) {
          return _EmptyVaultTab(
            icon: Icons.receipt_long_outlined,
            message: 'No private expenses yet.\nLong-press any entry in Khata to move it here.',
            scheme: scheme,
            text: text,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: items.length,
          separatorBuilder: (_, __) =>
              Divider(height: 1, indent: 72, color: scheme.outlineVariant.withAlpha(60)),
          itemBuilder: (ctx, i) {
            final e = items[i];
            final isIncome = e.type == 'income';
            final cat = isIncome ? null : ExpenseCategory.fromString(e.category);
            final src = isIncome ? IncomeSource.fromString(e.category) : null;
            final icon = isIncome ? src!.icon : cat!.icon;
            final label = isIncome ? src!.label(l10n) : cat!.label(l10n);
            final color = isIncome ? Colors.green.shade700 : scheme.error;
            final sign = isIncome ? '+' : '-';

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: color.withAlpha(28),
                child: Icon(icon, size: 20, color: color),
              ),
              title: Text(
                '$sign Rs ${fmt.format(e.amount)}',
                style: text.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w700, color: color),
              ),
              subtitle: Text(
                e.note.isNotEmpty ? '$label · ${e.note}' : label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(e.date,
                  style: text.bodySmall
                      ?.copyWith(color: scheme.onSurfaceVariant)),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => AddExpenseScreen(expense: e)),
              ),
              onLongPress: () => _showOptions(ctx, ref, e, l10n),
            );
          },
        );
      },
    );
  }

  void _showOptions(
      BuildContext ctx, WidgetRef ref, Expense e, AppLocalizations l10n) {
    showModalBottomSheet<void>(
      context: ctx,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.lock_open_outlined),
              title: Text(AppLocalizations.of(ctx).vaultRemove),
              onTap: () {
                Navigator.pop(ctx);
                ref
                    .read(appDatabaseProvider)
                    .expensesDao
                    .setSource(e.id, 'manual');
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline,
                  color: Theme.of(ctx).colorScheme.error),
              title: Text(AppLocalizations.of(ctx).delete,
                  style: TextStyle(
                      color: Theme.of(ctx).colorScheme.error)),
              onTap: () async {
                Navigator.pop(ctx);
                final confirmed = await showDialog<bool>(
                  context: ctx,
                  builder: (d) => AlertDialog(
                    title: Text(l10n.khataDelete),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(d, false),
                          child: Text(l10n.cancel)),
                      FilledButton(
                        onPressed: () => Navigator.pop(d, true),
                        style: FilledButton.styleFrom(
                            backgroundColor:
                                Theme.of(ctx).colorScheme.error),
                        child: Text(l10n.khataDelete),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  await ref
                      .read(appDatabaseProvider)
                      .expensesDao
                      .remove(e.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Vault contacts tab ────────────────────────────────────────────────────────

class _VaultContactsTab extends ConsumerWidget {
  const _VaultContactsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(appDatabaseProvider);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return StreamBuilder<List<UdhaarContact>>(
      stream: db.udhaarDao.watchVaultContacts(),
      builder: (context, snap) {
        final items = snap.data ?? [];
        if (items.isEmpty) {
          return _EmptyVaultTab(
            icon: Icons.handshake_outlined,
            message: 'No private contacts yet.\nLong-press any contact in Udhaar to move them here.',
            scheme: scheme,
            text: text,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: items.length,
          separatorBuilder: (_, __) =>
              const Divider(height: 1, indent: 72),
          itemBuilder: (ctx, i) {
            final c = items[i];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: scheme.primaryContainer,
                child: Text(
                  c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                  style: TextStyle(
                      color: scheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700),
                ),
              ),
              title: Text(c.name,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: c.phone.isNotEmpty
                  ? Text(c.phone,
                      style:
                          TextStyle(color: scheme.onSurfaceVariant))
                  : null,
              onTap: () => Navigator.of(ctx).push(
                MaterialPageRoute(
                    builder: (_) => UdhaarContactScreen(contact: c)),
              ),
              onLongPress: () => _showOptions(ctx, ref, c),
            );
          },
        );
      },
    );
  }

  void _showOptions(
      BuildContext ctx, WidgetRef ref, UdhaarContact c) {
    final scheme = Theme.of(ctx).colorScheme;
    showModalBottomSheet<void>(
      context: ctx,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.lock_open_outlined),
              title: Text(AppLocalizations.of(ctx).vaultRemove),
              onTap: () {
                Navigator.pop(ctx);
                ref
                    .read(appDatabaseProvider)
                    .udhaarDao
                    .setContactSource(c.id, 'normal');
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: scheme.error),
              title: Text(AppLocalizations.of(ctx).vaultDeleteContact,
                  style: TextStyle(color: scheme.error)),
              onTap: () async {
                Navigator.pop(ctx);
                final confirmed = await showDialog<bool>(
                  context: ctx,
                  builder: (d) => AlertDialog(
                    title: Text(AppLocalizations.of(ctx).vaultDeleteContactQ),
                    content: Text(
                        'This will also delete all entries for ${c.name}.'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(d, false),
                          child: Text(AppLocalizations.of(ctx).cancel)),
                      FilledButton(
                        onPressed: () => Navigator.pop(d, true),
                        style: FilledButton.styleFrom(
                            backgroundColor: scheme.error),
                        child: Text(AppLocalizations.of(ctx).delete),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  await ref
                      .read(appDatabaseProvider)
                      .udhaarDao
                      .deleteContact(c.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyVaultTab extends StatelessWidget {
  const _EmptyVaultTab({
    required this.icon,
    required this.message,
    required this.scheme,
    required this.text,
  });

  final IconData icon;
  final String message;
  final ColorScheme scheme;
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: scheme.outlineVariant),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: text.bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
