import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers.dart';
import '../../../../app/router.dart';
import '../../../../core/backup/backup_restore_service.dart';
import '../../../../core/storage/app_database.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../khata/background/budget_check.dart';
import '../../../khata/domain/quick_add.dart';
import '../../../khata/presentation/providers/khata_providers.dart';
import '../../../prayer/domain/entities/prayer_name.dart';
import '../../../prayer/presentation/l10n_helpers.dart';
import '../../../prayer/presentation/providers/prayer_providers.dart';
import '../../../prayer/presentation/providers/tracker_providers.dart';
import '../../../tasks/data/task_reminders.dart';
import '../../../tasks/presentation/bill_prompt.dart';
import '../../../tasks/presentation/task_providers.dart';
import '../../../udhaar/domain/dues.dart';

// ── Data ──────────────────────────────────────────────────────────────────────

final _todayKeyProvider = Provider<String>((ref) => dateKey(ref.watch(todayDateProvider)));

final _overdueTasksProvider = StreamProvider<List<Task>>((ref) =>
    ref.watch(appDatabaseProvider).tasksDao.watchOverdue(ref.watch(_todayKeyProvider), null));

final _todayTasksProvider = StreamProvider<List<Task>>((ref) =>
    ref.watch(appDatabaseProvider).tasksDao.watchToday(ref.watch(_todayKeyProvider), null));

final _contactsProvider = StreamProvider<List<UdhaarContact>>(
    (ref) => ref.watch(appDatabaseProvider).udhaarDao.watchContacts());

final _udhaarEntriesProvider = StreamProvider<List<UdhaarEntry>>(
    (ref) => ref.watch(appDatabaseProvider).udhaarDao.watchAllEntries());

final _recurringProvider = StreamProvider<List<RecurringExpense>>(
    (ref) => ref.watch(appDatabaseProvider).recurringExpensesDao.watchAll());

// ── Screen ────────────────────────────────────────────────────────────────────

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock_outline),
            tooltip: l10n.vaultTitle,
            onPressed: () => context.push(Routes.vault),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.navSettings,
            onPressed: () => context.push(Routes.settings),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          const _QuickAddCard(),
          const SizedBox(height: 12),
          const _PrayerCard(),
          const SizedBox(height: 12),
          const _TasksCard(),
          const SizedBox(height: 12),
          const _MoneyCard(),
          const SizedBox(height: 12),
          const _ComingUpCard(),
          const _BackupNudge(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              l10n.dashTools,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.05,
            children: [
              _ToolTile(
                icon: Icons.local_fire_department_outlined,
                label: l10n.navTracker,
                onTap: () => context.push(Routes.tracker),
              ),
              _ToolTile(
                icon: Icons.calendar_month_outlined,
                label: l10n.navTimetable,
                onTap: () => context.push(Routes.monthly),
              ),
              _ToolTile(
                icon: Icons.explore_outlined,
                label: l10n.navQibla,
                onTap: () => context.push(Routes.qibla),
              ),
              _ToolTile(
                icon: Icons.nights_stay_outlined,
                label: l10n.toolRoza,
                onTap: () => context.push(Routes.roza),
              ),
              _ToolTile(
                icon: Icons.savings_outlined,
                label: l10n.toolGoals,
                onTap: () => context.push(Routes.goals),
              ),
              _ToolTile(
                icon: Icons.account_balance_wallet_outlined,
                label: l10n.toolAccounts,
                onTap: () => context.push(Routes.accounts),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Quick add ─────────────────────────────────────────────────────────────────

class _QuickAddCard extends ConsumerStatefulWidget {
  const _QuickAddCard();

  @override
  ConsumerState<_QuickAddCard> createState() => _QuickAddCardState();
}

class _QuickAddCardState extends ConsumerState<_QuickAddCard> {
  final _controller = TextEditingController();
  final _fmt = NumberFormat('#,##0.##', 'en');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _categoryLabel(QuickEntry e, AppLocalizations l10n) => e.isIncome
      ? e.incomeSource.label(l10n)
      : ref.read(categoryCatalogProvider).resolve(e.categoryKey).label(l10n);

  QuickEntry? _parse(String text) => parseQuickAdd(
        text,
        custom: [
          for (final c in ref.read(categoryCatalogProvider).custom) (key: c.key, name: c.customName ?? ''),
        ],
      );

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final entry = _parse(_controller.text);
    if (entry == null) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.todayQuickAddNeedAmount)));
      return;
    }
    final db = ref.read(appDatabaseProvider);
    final now = DateTime.now();
    final id = await db.expensesDao.add(ExpensesCompanion.insert(
      amount: entry.amount,
      category: entry.categoryKey,
      type: Value(entry.isIncome ? 'income' : 'expense'),
      note: Value(entry.note),
      date: dateKey(now),
      createdAt: now.toUtc(),
    ));
    if (!entry.isIncome) {
      checkBudgetAndNotify(
        db: db,
        yearMonth: DateFormat('yyyy-MM').format(now),
        categoryKey: entry.categoryKey,
        addedAmount: entry.amount,
      );
    }
    _controller.clear();
    if (!mounted) return;
    setState(() {});
    final amount = _fmt.format(entry.amount);
    final category = _categoryLabel(entry, l10n);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(entry.isIncome
            ? l10n.todayQuickAddedIncome(amount, category)
            : l10n.todayQuickAdded(amount, category)),
        action: SnackBarAction(label: l10n.undo, onPressed: () => db.expensesDao.remove(id)),
      ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final entry = _parse(_controller.text);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.done,
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      hintText: l10n.todayQuickAddHint,
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.bolt_outlined),
                    ),
                  ),
                ),
                IconButton.filled(
                  icon: const Icon(Icons.arrow_upward),
                  onPressed: _submit,
                ),
              ],
            ),
            if (entry != null)
              Padding(
                padding: const EdgeInsets.only(left: 48, bottom: 4),
                child: Text(
                  l10n.todayQuickAddPreview(_fmt.format(entry.amount), _categoryLabel(entry, l10n)),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Prayers ───────────────────────────────────────────────────────────────────

class _PrayerCard extends ConsumerWidget {
  const _PrayerCard();

  Future<void> _toggle(BuildContext context, WidgetRef ref, PrayerName prayer, bool done) async {
    final date = ref.read(todayDateProvider);
    final result = await ref.read(prayerActionsProvider).setDone(date, prayer, done: !done);
    if (result == TickResult.needsProof && context.mounted) {
      context.push('${Routes.verify}?prayer=${prayer.name}&date=${dateKey(date)}');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final settings = ref.watch(currentSettingsProvider);
    final next = ref.watch(nextPrayerProvider);
    final times = ref.watch(todayTimesProvider);
    final prayed = ref.watch(prayedTodayProvider).value ?? const <PrayerName>{};
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            InkWell(
              onTap: () => context.go(Routes.prayer),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: scheme.primaryContainer,
                    child: Icon(Icons.mosque_outlined, color: scheme.onPrimaryContainer),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: next == null
                        ? Text(l10n.prayerTimesTitle, style: text.titleMedium)
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                prayerLabel(l10n, next.prayer),
                                style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              Text(
                                formatClock(next.at, settings.timezoneId, locale),
                                style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                  ),
                  Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                for (final p in PrayerName.obligatory)
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => _toggle(context, ref, p, prayed.contains(p)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          children: [
                            Text(
                              prayerLabel(l10n, p, jumma: p == PrayerName.dhuhr && times.isFriday),
                              style: text.labelSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Icon(
                              prayed.contains(p) ? Icons.check_circle : Icons.radio_button_unchecked,
                              size: 26,
                              color: prayed.contains(p) ? scheme.primary : scheme.outline,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              times[p] == null
                                  ? ''
                                  : formatClock(times[p]!, settings.timezoneId, locale),
                              style: text.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
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

// ── Tasks ─────────────────────────────────────────────────────────────────────

class _TasksCard extends ConsumerWidget {
  const _TasksCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final today = ref.watch(_todayKeyProvider);
    final overdue = ref.watch(_overdueTasksProvider).value ?? const <Task>[];
    final due = ref.watch(_todayTasksProvider).value ?? const <Task>[];
    final items = [...overdue, ...due].take(6).toList();

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.checklist, color: scheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(l10n.navTasks,
                      style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                ),
                TextButton(
                  onPressed: () => context.go(Routes.tasks),
                  child: Text(l10n.todaySeeAll),
                ),
              ],
            ),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 8),
                child: Text(l10n.todayNothingDue,
                    style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
              )
            else
              for (final task in items)
                InkWell(
                  onTap: () => context.go(Routes.tasks),
                  child: Row(
                    children: [
                      Checkbox(
                        shape: const CircleBorder(),
                        value: false,
                        onChanged: (_) async {
                          await completeTask(ref.read(appDatabaseProvider), task,
                              prayerTime: ref.read(prayerTimeResolverProvider));
                          if (context.mounted) await offerBillToKhata(context, ref, task);
                        },
                      ),
                      Expanded(
                        child: Text(
                          task.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.bodyLarge?.copyWith(
                            color: (task.dueDate ?? today).compareTo(today) < 0 ? scheme.error : null,
                          ),
                        ),
                      ),
                      if (task.dueTime != null)
                        Text(task.dueTime!,
                            style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

// ── Money ─────────────────────────────────────────────────────────────────────

class _MoneyCard extends ConsumerWidget {
  const _MoneyCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final fmt = NumberFormat('#,##0', 'en');
    final now = DateTime.now();
    final todayStr = dateKey(now);
    final entries = ref.watch(monthSpendingProvider((now.year, now.month))).value ?? const <Expense>[];
    final budgets = ref.watch(budgetNotifierProvider);

    final spent = entries.where((e) => e.type != 'income').toList();
    final month = spent.fold(0.0, (s, e) => s + e.amount);
    final today = spent.where((e) => e.date == todayStr).fold(0.0, (s, e) => s + e.amount);

    final catalog = ref.watch(categoryCatalogProvider);
    final budgeted = catalog.all.where((c) => (budgets[c.key] ?? 0) > 0).map((c) => c.key).toSet();
    final totalBudget = budgeted.fold(0.0, (s, key) => s + budgets[key]!);
    final budgetedSpend = spent
        .where((e) => budgeted.contains(catalog.resolve(e.category).key))
        .fold(0.0, (s, e) => s + e.amount);
    final left = totalBudget - budgetedSpend;

    Widget cell(String label, String value, {Color? color}) => Expanded(
          child: Column(
            children: [
              Text(label, style: text.labelSmall?.copyWith(color: scheme.onSurfaceVariant)),
              const SizedBox(height: 2),
              Text(value, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: color)),
            ],
          ),
        );

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.go(Routes.khata),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.account_balance_wallet_outlined, color: scheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(l10n.todayMoney,
                        style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  ),
                  Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  cell(l10n.todaySpentToday, 'Rs ${fmt.format(today)}'),
                  cell(l10n.todaySpentMonth, 'Rs ${fmt.format(month)}'),
                  if (totalBudget > 0)
                    cell(
                      left >= 0 ? l10n.todayBudgetLeft : l10n.todayOverBudget,
                      'Rs ${fmt.format(left.abs())}',
                      color: left >= 0 ? Colors.green.shade700 : scheme.error,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Coming up ─────────────────────────────────────────────────────────────────

class _ComingUpCard extends ConsumerWidget {
  const _ComingUpCard();

  String _when(AppLocalizations l10n, int days) {
    if (days < 0) return l10n.todayDueLate('${-days}');
    if (days == 0) return l10n.todayDueToday;
    if (days == 1) return l10n.todayDueTomorrow;
    return l10n.todayDueInDays('$days');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final fmt = NumberFormat('#,##0', 'en');
    final todayKey = ref.watch(_todayKeyProvider);
    final today = DateTime.parse(todayKey);

    final dues = upcomingUdhaarDues(
      contacts: ref.watch(_contactsProvider).value ?? const [],
      entries: ref.watch(_udhaarEntriesProvider).value ?? const [],
      today: today,
    );
    final weekAway = dateKey(DateTime(today.year, today.month, today.day + 7));
    final recurring = (ref.watch(_recurringProvider).value ?? const <RecurringExpense>[])
        .where((r) => r.nextDue.compareTo(todayKey) >= 0 && r.nextDue.compareTo(weekAway) <= 0)
        .toList();

    final rows = <Widget>[
      for (final d in dues)
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          onTap: () => context.go(Routes.udhaar),
          leading: Icon(
            d.theyOweMe ? Icons.call_received : Icons.call_made,
            color: d.daysLeft < 0 ? scheme.error : scheme.primary,
          ),
          title: Text(d.theyOweMe
              ? l10n.todayDueTheyOwe(d.contact.name, fmt.format(d.amount))
              : l10n.todayDueYouOwe(d.contact.name, fmt.format(d.amount))),
          subtitle: Text(_when(l10n, d.daysLeft),
              style: TextStyle(color: d.daysLeft < 0 ? scheme.error : null)),
        ),
      for (final r in recurring)
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          onTap: () => context.go(Routes.khata),
          leading: Icon(Icons.repeat, color: scheme.primary),
          title: Text(l10n.todayRecurring(
            r.note.isNotEmpty ? r.note : ref.watch(categoryCatalogProvider).resolve(r.category).label(l10n),
            fmt.format(r.amount),
            DateFormat.MMMd().format(DateTime.parse(r.nextDue)),
          )),
        ),
    ];

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.event_outlined, color: scheme.primary),
                const SizedBox(width: 8),
                Text(l10n.todayComingUp,
                    style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 4),
            if (rows.isEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 4, top: 4),
                child: Text(l10n.todayNothingComing,
                    style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
              )
            else
              ...rows,
          ],
        ),
      ),
    );
  }
}

// ── Backup reminder ───────────────────────────────────────────────────────────

class _BackupNudge extends ConsumerStatefulWidget {
  const _BackupNudge();

  @override
  ConsumerState<_BackupNudge> createState() => _BackupNudgeState();
}

class _BackupNudgeState extends ConsumerState<_BackupNudge> {
  static const _lastExportKey = 'last_export_at';
  static const _firstSeenKey = 'first_seen_at';
  static const _snoozeKey = 'backup_nudge_snooze_until';
  static const _interval = Duration(days: 14);
  bool _hidden = false;

  @override
  void initState() {
    super.initState();
    final prefs = ref.read(sharedPreferencesProvider);
    if (!prefs.containsKey(_firstSeenKey)) {
      prefs.setInt(_firstSeenKey, DateTime.now().millisecondsSinceEpoch);
    }
  }

  bool get _due {
    final prefs = ref.read(sharedPreferencesProvider);
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now < (prefs.getInt(_snoozeKey) ?? 0)) return false;
    final since = prefs.getInt(_lastExportKey) ?? prefs.getInt(_firstSeenKey) ?? now;
    return now - since > _interval.inMilliseconds;
  }

  @override
  Widget build(BuildContext context) {
    if (_hidden || !_due) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Card(
        margin: EdgeInsets.zero,
        color: scheme.tertiaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.todayBackupTitle,
                  style: text.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700, color: scheme.onTertiaryContainer)),
              const SizedBox(height: 4),
              Text(l10n.todayBackupBody,
                  style: text.bodySmall?.copyWith(color: scheme.onTertiaryContainer)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      ref.read(sharedPreferencesProvider).setInt(
                            _snoozeKey,
                            DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch,
                          );
                      setState(() => _hidden = true);
                    },
                    child: Text(l10n.todayLater),
                  ),
                  FilledButton(
                    onPressed: () async {
                      await BackupRestoreService.backup(
                        context,
                        ref.read(appDatabaseProvider),
                        ref.read(sharedPreferencesProvider),
                      );
                      if (mounted) setState(() {});
                    },
                    child: Text(l10n.todayBackupNow),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Tools ─────────────────────────────────────────────────────────────────────

class _ToolTile extends StatelessWidget {
  const _ToolTile({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: scheme.primary),
              const SizedBox(height: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
