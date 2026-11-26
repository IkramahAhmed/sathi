import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat, NumberFormat;

import '../../../l10n/app_localizations.dart';
import '../../khata/presentation/providers/khata_providers.dart';
import '../../prayer/presentation/l10n_helpers.dart';
import '../domain/weekly_review.dart';
import 'review_providers.dart';

class WeeklyReviewScreen extends ConsumerWidget {
  const WeeklyReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final review = ref.watch(weeklyReviewProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reviewTitle)),
      body: review.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(l10n.genericError)),
        data: (r) => _Review(review: r),
      ),
    );
  }
}

class _Review extends ConsumerWidget {
  const _Review({required this.review});

  final WeeklyReview review;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final locale = dateLocale(Localizations.localeOf(context));
    final fmt = NumberFormat('#,##0', 'en');
    final day = DateFormat.MMMd(locale);
    final r = review;

    Widget section(IconData icon, String title, List<Widget> children) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(icon, color: scheme.primary),
                  const SizedBox(width: 8),
                  Text(title, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 10),
                ...children,
              ],
            ),
          ),
        );

    Widget line(String value, {Color? color, bool bold = false}) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(value,
              style: text.bodyLarge?.copyWith(color: color, fontWeight: bold ? FontWeight.w700 : null)),
        );

    final children = <Widget>[
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          l10n.reviewRange(day.format(r.from), day.format(r.to)),
          style: text.labelLarge?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ),
    ];

    if (r.isEmpty) {
      children.add(Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Text(l10n.reviewEmpty,
            textAlign: TextAlign.center,
            style: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant)),
      ));
    }

    if (r.hasMoney) {
      final up = r.change > 0;
      final amount = fmt.format(r.change.abs());
      final percent = r.percent?.abs().round();
      final String vsLast;
      if (r.change == 0) {
        vsLast = l10n.reviewSameAsBefore;
      } else if (percent == null) {
        vsLast = l10n.reviewMoreNoPercent(amount);
      } else {
        vsLast = up ? l10n.reviewMoreThanBefore(amount, '$percent') : l10n.reviewLessThanBefore(amount, '$percent');
      }
      final catalog = ref.watch(categoryCatalogProvider);
      children.add(section(Icons.account_balance_wallet_outlined, l10n.todayMoney, [
        line(l10n.reviewSpent(fmt.format(r.spent)), bold: true),
        line(vsLast, color: r.change == 0 ? scheme.onSurfaceVariant : up ? scheme.error : Colors.green.shade700),
        if (r.biggestRiseKey != null)
          line(l10n.trendBiggestRise(catalog.resolve(r.biggestRiseKey!).label(l10n), fmt.format(r.biggestRise)),
              color: scheme.onSurfaceVariant),
      ]));
    }

    if (r.hasPrayers) {
      children.add(section(Icons.mosque_outlined, l10n.reviewPrayers, [
        line(l10n.reviewPrayed('${r.prayed}', '${r.possible}'), bold: true),
        LinearProgressIndicator(
          value: r.possible == 0 ? 0 : r.prayed / r.possible,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
        if (r.weakest != null) ...[
          const SizedBox(height: 8),
          line(
            l10n.trackerWeakest(prayerLabel(l10n, r.weakest!), '${r.weakestDone}', '${r.countedDays}'),
            color: scheme.error,
          ),
        ],
      ]));
    }

    if (r.hasTasks) {
      children.add(section(Icons.checklist, l10n.navTasks, [
        line(l10n.reviewTasksDone('${r.tasksDone}'), bold: true),
        line(
          r.tasksOverdue == 0 ? l10n.reviewNoOverdue : l10n.reviewTasksOverdue('${r.tasksOverdue}'),
          color: r.tasksOverdue == 0 ? Colors.green.shade700 : scheme.error,
        ),
      ]));
    }

    if (r.hasFasts) {
      children.add(section(Icons.nights_stay_outlined, l10n.toolRoza, [
        line(l10n.reviewFastsKept('${r.fastsKept}', '${r.fastsMissed}'), bold: true),
      ]));
    }

    if (r.hasDebts) {
      children.add(section(Icons.handshake_outlined, l10n.reviewDebts, [
        if (r.owedToMe > 0) line(l10n.reviewOwedToMe(fmt.format(r.owedToMe)), color: Colors.green.shade700, bold: true),
        if (r.iOwe > 0) line(l10n.reviewIOwe(fmt.format(r.iOwe)), color: scheme.error, bold: true),
        for (final d in r.dues)
          line(
            '${d.theyOweMe ? l10n.todayDueTheyOwe(d.contact.name, fmt.format(d.amount)) : l10n.todayDueYouOwe(d.contact.name, fmt.format(d.amount))}'
            ' · ${d.daysLeft < 0 ? l10n.todayDueLate('${-d.daysLeft}') : d.daysLeft == 0 ? l10n.todayDueToday : d.daysLeft == 1 ? l10n.todayDueTomorrow : l10n.todayDueInDays('${d.daysLeft}')}',
            color: d.daysLeft < 0 ? scheme.error : scheme.onSurfaceVariant,
          ),
      ]));
    }

    return ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 32), children: children);
  }
}
