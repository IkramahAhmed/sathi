import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers.dart';
import '../../../../core/storage/app_database.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../tasks/data/task_reminders.dart';

final _goalsProvider = StreamProvider<List<SavingsGoal>>(
    (ref) => ref.watch(appDatabaseProvider).savingsGoalsDao.watchAll());

/// How much to put aside each month to reach [target] by [deadline], or null
/// when there is no deadline, nothing left to save, or the date has passed.
double? monthlySavingNeeded({
  required double target,
  required double saved,
  required DateTime? deadline,
  required DateTime today,
}) {
  if (deadline == null || saved >= target) return null;
  final months = (deadline.year - today.year) * 12 + deadline.month - today.month;
  if (months <= 0) return null;
  return (target - saved) / months;
}

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final goals = ref.watch(_goalsProvider).value ?? const <SavingsGoal>[];
    final fmt = NumberFormat('#,##0', 'en');

    return Scaffold(
      appBar: AppBar(title: Text(l10n.goalsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: Text(l10n.goalAdd),
        onPressed: () => _editGoal(context, ref),
      ),
      body: goals.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(l10n.goalsEmpty,
                    textAlign: TextAlign.center,
                    style: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant)),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              itemCount: goals.length,
              itemBuilder: (context, i) {
                final g = goals[i];
                final progress = g.target <= 0 ? 0.0 : (g.saved / g.target).clamp(0.0, 1.0);
                final perMonth = monthlySavingNeeded(
                  target: g.target,
                  saved: g.saved,
                  deadline: g.deadline == null ? null : DateTime.tryParse(g.deadline!),
                  today: DateTime.now(),
                );
                return Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _actions(context, ref, g),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(g.name, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(value: progress, minHeight: 8),
                          const SizedBox(height: 8),
                          Text(
                            g.saved >= g.target
                                ? l10n.goalReached
                                : l10n.goalSaved(fmt.format(g.saved), fmt.format(g.target)),
                            style: text.bodyMedium,
                          ),
                          if (perMonth != null)
                            Text(
                              l10n.goalPerMonth(
                                fmt.format(perMonth.ceil()),
                                DateFormat.yMMM().format(DateTime.parse(g.deadline!)),
                              ),
                              style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _actions(BuildContext context, WidgetRef ref, SavingsGoal goal) {
    final l10n = AppLocalizations.of(context);
    final dao = ref.read(appDatabaseProvider).savingsGoalsDao;
    return showModalBottomSheet<void>(
      context: context,
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: Text(l10n.goalAddMoney),
              onTap: () async {
                Navigator.pop(sheet);
                final amount = await _askAmount(context, l10n.goalAddMoney);
                if (amount != null) await dao.addMoney(goal.id, amount);
              },
            ),
            ListTile(
              leading: const Icon(Icons.remove_circle_outline),
              title: Text(l10n.goalTakeOut),
              onTap: () async {
                Navigator.pop(sheet);
                final amount = await _askAmount(context, l10n.goalTakeOut);
                if (amount != null) await dao.addMoney(goal.id, -amount);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(l10n.edit),
              onTap: () {
                Navigator.pop(sheet);
                _editGoal(context, ref, goal: goal);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
              title: Text(l10n.delete),
              onTap: () async {
                Navigator.pop(sheet);
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(l10n.goalDeleteConfirm),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
                      FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.delete)),
                    ],
                  ),
                );
                if (ok == true) await dao.remove(goal.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<double?> _askAmount(BuildContext context, String title) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    final result = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
          decoration: InputDecoration(labelText: l10n.goalAmount, prefixText: 'Rs. '),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, double.tryParse(controller.text)),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
    controller.dispose();
    return result != null && result > 0 ? result : null;
  }

  Future<void> _editGoal(BuildContext context, WidgetRef ref, {SavingsGoal? goal}) async {
    final l10n = AppLocalizations.of(context);
    final name = TextEditingController(text: goal?.name ?? '');
    final target = TextEditingController(text: goal == null ? '' : goal.target.toStringAsFixed(0));
    DateTime? deadline = goal?.deadline == null ? null : DateTime.tryParse(goal!.deadline!);
    final dao = ref.read(appDatabaseProvider).savingsGoalsDao;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(goal == null ? l10n.goalAdd : l10n.edit),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(labelText: l10n.goalName),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: target,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                decoration: InputDecoration(labelText: l10n.goalTarget, prefixText: 'Rs. '),
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event_outlined),
                title: Text(deadline == null
                    ? l10n.goalDeadline
                    : DateFormat.yMMMd().format(deadline!)),
                trailing: deadline == null
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () => setState(() => deadline = null),
                      ),
                onTap: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: ctx,
                    initialDate: deadline ?? now.add(const Duration(days: 365)),
                    firstDate: now,
                    lastDate: DateTime(now.year + 30),
                  );
                  if (picked != null) setState(() => deadline = picked);
                },
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
    final amount = double.tryParse(target.text);
    name.dispose();
    target.dispose();
    if (ok != true || title.isEmpty || amount == null || amount <= 0) return;

    final deadlineKey = deadline == null ? null : dateKey(deadline!);
    if (goal == null) {
      await dao.add(SavingsGoalsCompanion.insert(
        name: title,
        target: amount,
        deadline: Value(deadlineKey),
        createdAt: DateTime.now().toUtc(),
      ));
    } else {
      await dao.updateGoal(
        goal.id,
        SavingsGoalsCompanion(name: Value(title), target: Value(amount), deadline: Value(deadlineKey)),
      );
    }
  }
}
