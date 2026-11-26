import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers.dart';
import '../../../../core/storage/app_database.dart';
import '../../domain/entities/category.dart';
import '../providers/khata_providers.dart';
import '../../domain/entities/income_source.dart';
import '../../../../l10n/app_localizations.dart';

class RecurringScreen extends ConsumerWidget {
  const RecurringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final stream =
        ref.watch(appDatabaseProvider).recurringExpensesDao.watchAll();
    final fmt = NumberFormat('#,##0', 'en');
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).recurringTitle)),
      body: StreamBuilder<List<RecurringExpense>>(
        stream: stream,
        builder: (context, snap) {
          final items = snap.data ?? [];
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.repeat_outlined,
                      size: 56, color: scheme.outlineVariant),
                  const SizedBox(height: 12),
                  Text(AppLocalizations.of(context).recurringEmpty,
                      style: text.bodyMedium
                          ?.copyWith(color: scheme.onSurfaceVariant)),
                  const SizedBox(height: 6),
                  Text(
                    AppLocalizations.of(context).recurringEmptyHint,
                    style: text.bodySmall
                        ?.copyWith(color: scheme.outlineVariant),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: items.length,
            separatorBuilder: (_, __) => Divider(
                height: 1,
                indent: 72,
                color: scheme.outlineVariant.withAlpha(60)),
            itemBuilder: (context, i) {
              final r = items[i];
              return _RecurringTile(
                catalog: ref.watch(categoryCatalogProvider),
                item: r,
                fmt: fmt,
                l10n: l10n,
                onDelete: () => ref
                    .read(appDatabaseProvider)
                    .recurringExpensesDao
                    .remove(r.id),
              );
            },
          );
        },
      ),
    );
  }
}

class _RecurringTile extends StatelessWidget {
  const _RecurringTile({
    required this.item,
    required this.catalog,
    required this.fmt,
    required this.l10n,
    required this.onDelete,
  });

  final RecurringExpense item;
  final CategoryCatalog catalog;
  final NumberFormat fmt;
  final AppLocalizations l10n;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final isIncome = item.type == 'income';
    final color = isIncome ? Colors.green.shade700 : scheme.error;
    final sign = isIncome ? '+' : '-';

    final cat = isIncome ? null : catalog.resolve(item.category);
    final src = isIncome ? IncomeSource.fromString(item.category) : null;
    final Widget icon = isIncome
        ? Icon(src!.icon, size: 20, color: color)
        : cat!.iconWidget(size: 20, color: color);
    final label = isIncome ? src!.label(l10n) : cat!.label(l10n);

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(AppLocalizations.of(context).recurringStopQ),
          content: Text(
              '$sign Rs ${fmt.format(item.amount)} · $label\n${AppLocalizations.of(context).recurringStopNote}'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(AppLocalizations.of(context).cancel)),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style:
                  FilledButton.styleFrom(backgroundColor: scheme.error),
              child: Text(AppLocalizations.of(context).recurringStop),
            ),
          ],
        ),
      ),
      onDismissed: (_) => onDelete(),
      background: Container(
        color: scheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Icon(Icons.delete_outline, color: scheme.onError),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(28),
          child: icon,
        ),
        title: Text(
          '$sign Rs ${fmt.format(item.amount)}',
          style: text.bodyLarge
              ?.copyWith(fontWeight: FontWeight.w700, color: color),
        ),
        subtitle: Text(
          item.note.isNotEmpty ? '$label · ${item.note}' : label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _FrequencyBadge(frequency: item.frequency, scheme: scheme),
            const SizedBox(height: 4),
            Text(
              'Next: ${item.nextDue}',
              style: text.bodySmall
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _FrequencyBadge extends StatelessWidget {
  const _FrequencyBadge(
      {required this.frequency, required this.scheme});

  final String frequency;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        switch (frequency) {
          'daily' => AppLocalizations.of(context).freqDaily,
          'weekly' => AppLocalizations.of(context).freqWeekly,
          'yearly' => AppLocalizations.of(context).freqYearly,
          _ => AppLocalizations.of(context).freqMonthly,
        },
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: scheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
