import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers.dart';
import '../../../../core/storage/app_database.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../tasks/data/task_reminders.dart';

final _fastLogsProvider = StreamProvider<List<FastLog>>(
    (ref) => ref.watch(appDatabaseProvider).fastLogsDao.watchAll());

/// What tapping a day does: none → kept → missed → none.
String? nextFastStatus(String? current) => switch (current) {
      null => 'kept',
      'kept' => 'missed',
      _ => null,
    };

/// Missed fasts that have not been made up yet.
int fastsOwed(Iterable<FastLog> logs) {
  final missed = logs.where((l) => l.status == 'missed').length;
  final madeUp = logs.where((l) => l.status == 'made_up').length;
  return missed > madeUp ? missed - madeUp : 0;
}

class RozaScreen extends ConsumerStatefulWidget {
  const RozaScreen({super.key});

  @override
  ConsumerState<RozaScreen> createState() => _RozaScreenState();
}

class _RozaScreenState extends ConsumerState<RozaScreen> {
  late DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final logs = ref.watch(_fastLogsProvider).value ?? const <FastLog>[];
    final byDate = {for (final l in logs) l.date: l.status};
    final dao = ref.read(appDatabaseProvider).fastLogsDao;
    final now = DateTime.now();
    final todayKey = dateKey(now);
    final owed = fastsOwed(logs);
    final keptThisYear = logs
        .where((l) => l.status == 'kept' && l.date.startsWith('${now.year}-'))
        .length;

    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final leading = (_month.weekday + 6) % 7; // Monday first
    final atCurrentMonth = _month.year == now.year && _month.month == now.month;

    Color? colorFor(String? status) => switch (status) {
          'kept' => Colors.green.shade600,
          'missed' => scheme.error,
          'made_up' => Colors.blue.shade600,
          _ => null,
        };

    return Scaffold(
      appBar: AppBar(title: Text(l10n.rozaTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.rozaOwed('$owed'),
                      style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(l10n.rozaKeptThisYear('$keptThisYear'),
                      style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                  if (owed > 0 && byDate[todayKey] == null) ...[
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      icon: const Icon(Icons.check),
                      label: Text(l10n.rozaMakeUpToday),
                      onPressed: () => dao.setStatus(todayKey, 'made_up'),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => setState(() => _month = DateTime(_month.year, _month.month - 1)),
              ),
              Expanded(
                child: Text(
                  DateFormat.yMMMM().format(_month),
                  textAlign: TextAlign.center,
                  style: text.titleMedium,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: atCurrentMonth
                    ? null
                    : () => setState(() => _month = DateTime(_month.year, _month.month + 1)),
              ),
            ],
          ),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (var i = 0; i < leading; i++) const SizedBox.shrink(),
              for (var day = 1; day <= daysInMonth; day++)
                Builder(builder: (context) {
                  final date = DateTime(_month.year, _month.month, day);
                  final key = dateKey(date);
                  final status = byDate[key];
                  final future = key.compareTo(todayKey) > 0;
                  final fill = colorFor(status);
                  return Padding(
                    padding: const EdgeInsets.all(3),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: future ? null : () => dao.setStatus(key, nextFastStatus(status)),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: fill,
                          shape: BoxShape.circle,
                          border: key == todayKey
                              ? Border.all(color: scheme.primary, width: 2)
                              : null,
                        ),
                        child: Text(
                          '$day',
                          style: TextStyle(
                            color: fill != null
                                ? Colors.white
                                : future
                                    ? scheme.outline
                                    : null,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _Legend(color: Colors.green.shade600, label: l10n.rozaKept),
              _Legend(color: scheme.error, label: l10n.rozaMissed),
              _Legend(color: Colors.blue.shade600, label: l10n.rozaMadeUp),
            ],
          ),
          const SizedBox(height: 12),
          Text(l10n.rozaHint, style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      );
}
