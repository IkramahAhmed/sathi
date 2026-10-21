import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../../app/providers.dart';
import 'package:drift/drift.dart' show OrderingTerm;

import '../../../../core/storage/app_database.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/prayer_name.dart';
import '../../domain/entities/streaks.dart';
import '../l10n_helpers.dart';
import '../providers/prayer_providers.dart';
import '../providers/settings_controller.dart';
import '../providers/tracker_providers.dart';

/// Missed prayers still to be made up.
class QazaScreen extends ConsumerStatefulWidget {
  const QazaScreen({super.key});

  @override
  ConsumerState<QazaScreen> createState() => _QazaScreenState();
}

class _QazaScreenState extends ConsumerState<QazaScreen> {
  @override
  void initState() {
    super.initState();
    // Catch up on anything that was missed since the last visit. Wait for the
    // settings first: until they load, automatic counting looks switched off.
    unawaited(ref.read(settingsControllerProvider.future).then((_) => ref.read(prayerActionsProvider).reconcileQaza()));
  }

  Future<void> _change(PrayerName prayer, int delta, String source) =>
      ref.read(appDatabaseProvider).qazaDao.change(prayer.name, delta, ref.read(clockProvider)(), source);

  Future<void> _setBalance(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final owed = ref.read(qazaOwedProvider).value ?? const {};
    final controllers = {
      for (final p in PrayerName.obligatory) p: TextEditingController(text: '${owed[p] ?? 0}'),
    };
    final years = TextEditingController();
    final applied = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.qazaSetBalance),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.qazaBalanceHelp),
              const SizedBox(height: 12),
              for (final p in PrayerName.obligatory)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextField(
                    key: ValueKey('balance-${p.name}'),
                    controller: controllers[p],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: prayerLabel(l10n, p),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              const Divider(),
              Text(l10n.qazaEstimate, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(l10n.qazaYearsHelp, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              TextField(
                key: const ValueKey('balance-years'),
                controller: years,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.qazaYears, border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  key: const ValueKey('balance-estimate'),
                  onPressed: () {
                    final y = int.tryParse(years.text.trim()) ?? 0;
                    for (final c in controllers.values) {
                      c.text = '${(y.clamp(0, 100)) * 365}';
                    }
                  },
                  child: Text(l10n.qazaEstimate),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancel)),
          FilledButton(
            key: const ValueKey('balance-apply'),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.qazaApply),
          ),
        ],
      ),
    );
    if (applied != true) return;
    final dao = ref.read(appDatabaseProvider).qazaDao;
    final now = ref.read(clockProvider)();
    for (final p in PrayerName.obligatory) {
      final count = int.tryParse(controllers[p]!.text.trim()) ?? 0;
      await dao.setInitial(p.name, count.clamp(0, 100000), now);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final owed = ref.watch(qazaOwedProvider).value ?? const {};
    final total = ref.watch(qazaTotalProvider);
    final settings = ref.watch(currentSettingsProvider);
    final today = ref.watch(todayDateProvider);
    final history = ref.watch(_historyProvider).value ?? const <QazaHistoryData>[];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.qazaTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Card(
            color: scheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                total > 0 ? l10n.qazaTotal(total) : l10n.qazaCardNone,
                key: const ValueKey('qaza-total'),
                style: text.headlineSmall,
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (final p in PrayerName.obligatory)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(child: Text(prayerLabel(l10n, p), style: text.titleMedium)),
                      IconButton(
                        key: ValueKey('qaza-minus-${p.name}'),
                        tooltip: l10n.qazaMadeUp,
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: (owed[p] ?? 0) > 0 ? () => _change(p, -1, 'madeUp') : null,
                      ),
                      SizedBox(
                        width: 64,
                        child: Text(
                          '${owed[p] ?? 0}',
                          key: ValueKey('qaza-count-${p.name}'),
                          textAlign: TextAlign.center,
                          style: text.headlineSmall,
                        ),
                      ),
                      IconButton(
                        key: ValueKey('qaza-plus-${p.name}'),
                        tooltip: l10n.qazaAddOne,
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => _change(p, 1, 'added'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          OutlinedButton.icon(
            key: const ValueKey('qaza-set-balance'),
            icon: const Icon(Icons.tune),
            label: Text(l10n.qazaSetBalance),
            onPressed: () => _setBalance(context),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            key: const ValueKey('qaza-auto'),
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.qazaAuto),
            subtitle: Text(l10n.qazaAutoHelp),
            value: settings.autoQazaFrom != null,
            onChanged: (on) async {
              await ref.read(settingsControllerProvider.notifier).change(
                    (s) => on ? s.copyWith(autoQazaFrom: dateKey(today)) : s.copyWith(clearAutoQaza: true),
                  );
              if (on) await ref.read(prayerActionsProvider).reconcileQaza();
            },
          ),
          const Divider(),
          Text(l10n.qazaHistory, style: text.titleMedium),
          const SizedBox(height: 8),
          if (history.isEmpty) Text(l10n.qazaHistoryEmpty, key: const ValueKey('qaza-history-empty')),
          for (final h in history.take(30))
            ListTile(
              key: ValueKey('qaza-history-${h.id}'),
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(h.delta >= 0 ? Icons.add : Icons.remove, color: h.delta >= 0 ? scheme.error : scheme.primary),
              title: Text('${prayerLabel(l10n, PrayerName.values.firstWhere((p) => p.name == h.prayer, orElse: () => PrayerName.fajr))} ${h.delta >= 0 ? '+' : ''}${h.delta}'),
              subtitle: Text(
                '${switch (h.source) {
                  'initial' => l10n.qazaSourceInitial,
                  'madeUp' => l10n.qazaSourceMadeUp,
                  'auto' => l10n.qazaSourceAuto,
                  _ => l10n.qazaSourceAdded,
                }} · ${DateFormat.MMMd(dateLocale(locale)).add_jm().format(h.at.toLocal())}',
              ),
            ),
        ],
      ),
    );
  }
}

final _historyProvider = StreamProvider<List<QazaHistoryData>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.qazaHistory)..orderBy([(t) => OrderingTerm.desc(t.id)])..limit(30)).watch();
});
