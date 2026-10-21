import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../../app/providers.dart';
import '../../../../app/router.dart';
import '../../../../app/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/pause_range.dart';
import '../../domain/entities/prayer_name.dart';
import '../../domain/entities/streaks.dart';
import '../l10n_helpers.dart';
import '../providers/prayer_providers.dart';
import '../providers/reschedule_controller.dart';
import '../providers/tracker_providers.dart';

/// The prayer tracker: streaks, any past day, pauses and a link to qaza.
class TrackerScreen extends ConsumerWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.trackerTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: const [
          _StreakCard(),
          SizedBox(height: 12),
          _WeekStrip(),
          SizedBox(height: 12),
          _DayDetail(),
          SizedBox(height: 12),
          _QazaCard(),
          SizedBox(height: 12),
          _PauseCard(),
        ],
      ),
    );
  }
}

DateTime _selected(WidgetRef ref) => ref.watch(selectedDayProvider) ?? ref.watch(todayDateProvider);

class _StreakCard extends ConsumerWidget {
  const _StreakCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final streak = ref.watch(streakSummaryProvider);
    return Card(
      color: scheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.local_fire_department,
              size: 48,
              color: streak.current > 0 ? AppTheme.gold : scheme.onPrimary.withValues(alpha: 0.4),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    streak.current > 0 ? l10n.streakCurrent(streak.current) : l10n.streakNone,
                    key: const ValueKey('streak-current'),
                    style: (streak.current > 0 ? text.headlineSmall : text.titleMedium)?.copyWith(
                      color: scheme.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (streak.best > 0)
                    Text(
                      l10n.streakBest(streak.best),
                      key: const ValueKey('streak-best'),
                      style: text.bodyMedium?.copyWith(
                        color: scheme.onPrimary.withValues(alpha: 0.65),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekStrip extends ConsumerWidget {
  const _WeekStrip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context);
    final scheme = Theme.of(context).colorScheme;
    final today = ref.watch(todayDateProvider);
    final selected = _selected(ref);
    final done = ref.watch(doneByDateProvider).value ?? const {};
    final pauses = ref.watch(pausesProvider).value ?? const <PauseRange>[];

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var i = 6; i >= 0; i--)
              Builder(builder: (context) {
                final day = DateTime(today.year, today.month, today.day - i);
                final status = dayStatus(date: day, today: today, doneByDate: done, pauses: pauses);
                final isSelected = day == selected;
                final (icon, color) = switch (status) {
                  DayStatus.complete => (Icons.check_circle, scheme.primary),
                  DayStatus.partial => (Icons.timelapse, scheme.tertiary),
                  DayStatus.none => (Icons.radio_button_unchecked, scheme.outline),
                  DayStatus.paused => (Icons.pause_circle_outline, scheme.secondary),
                  DayStatus.future => (Icons.circle_outlined, scheme.outlineVariant),
                };
                return InkWell(
                  key: ValueKey('week-day-${dateKey(day)}'),
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => ref.read(selectedDayProvider.notifier).select(day == today ? null : day),
                  child: Container(
                    width: 44,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: isSelected ? scheme.secondaryContainer : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(DateFormat.E(dateLocale(locale)).format(day).substring(0, 1),
                            style: Theme.of(context).textTheme.labelMedium),
                        const SizedBox(height: 4),
                        Icon(icon, color: color),
                        const SizedBox(height: 4),
                        Text('${day.day}', style: Theme.of(context).textTheme.labelSmall),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _DayDetail extends ConsumerWidget {
  const _DayDetail();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final settings = ref.watch(currentSettingsProvider);
    final today = ref.watch(todayDateProvider);
    final date = _selected(ref);
    final done = ref.watch(doneByDateProvider).value ?? const {};
    final pauses = ref.watch(pausesProvider).value ?? const <PauseRange>[];
    final times = ref.watch(prayerRepositoryProvider).timesFor(date, settings);
    final ticked = done[dateKey(date)] ?? const <PrayerName>{};
    final isFuture = date.isAfter(today);
    final isPaused = pauses.any((p) => p.contains(date));
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final earliest = DateTime(today.year, today.month, today.day - kTrackerHistoryDays + 1);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  key: const ValueKey('day-prev'),
                  tooltip: l10n.trackerPrevDay,
                  icon: const Icon(Icons.chevron_left),
                  onPressed: date.isAfter(earliest)
                      ? () => ref.read(selectedDayProvider.notifier).select(DateTime(date.year, date.month, date.day - 1))
                      : null,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        DateFormat.yMMMEd(dateLocale(locale)).format(date),
                        key: const ValueKey('day-title'),
                        style: text.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      if (date == today) Text(l10n.trackerToday, style: text.bodySmall?.copyWith(color: scheme.primary)),
                    ],
                  ),
                ),
                IconButton(
                  key: const ValueKey('day-next'),
                  tooltip: l10n.trackerNextDay,
                  icon: const Icon(Icons.chevron_right),
                  onPressed: date.isBefore(today)
                      ? () {
                          final next = DateTime(date.year, date.month, date.day + 1);
                          ref.read(selectedDayProvider.notifier).select(next == today ? null : next);
                        }
                      : null,
                ),
              ],
            ),
            if (isPaused)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.pause_circle_outline, color: scheme.secondary),
                    const SizedBox(width: 8),
                    Expanded(child: Text(l10n.trackerPausedDay, key: const ValueKey('paused-banner'))),
                  ],
                ),
              ),
            if (isFuture)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(l10n.trackerFuture, key: const ValueKey('future-note')),
              ),
            for (final prayer in PrayerName.obligatory)
              if (times.times[prayer] != null)
                CheckboxListTile(
                  key: ValueKey('tracker-${prayer.name}'),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  controlAffinity: ListTileControlAffinity.trailing,
                  title: Text(prayerLabel(l10n, prayer, jumma: times.isFriday)),
                  subtitle: Text(formatClock(times.times[prayer]!, settings.timezoneId, locale)),
                  secondary: Icon(Icons.access_time, color: scheme.outline),
                  value: ticked.contains(prayer),
                onChanged: isFuture
                    ? null
                    : (value) async {
                        final router = GoRouter.maybeOf(context);
                        final result = await ref
                            .read(prayerActionsProvider)
                            .setDone(date, prayer, done: value ?? false);
                        if (result == TickResult.needsProof) {
                          router?.push('${Routes.verify}?prayer=${prayer.name}&date=${dateKey(date)}');
                        }
                      },
              ),
          ],
        ),
      ),
    );
  }
}

class _QazaCard extends ConsumerWidget {
  const _QazaCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final total = ref.watch(qazaTotalProvider);
    return Card(
      child: ListTile(
        key: const ValueKey('qaza-card'),
        leading: const Icon(Icons.history_edu_outlined),
        title: Text(l10n.qazaTitle),
        subtitle: Text(total > 0 ? l10n.qazaCardOwed(total) : l10n.qazaCardNone, key: const ValueKey('qaza-card-count')),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push(Routes.qaza),
      ),
    );
  }
}

class _PauseCard extends ConsumerWidget {
  const _PauseCard();

  Future<void> _changed(WidgetRef ref) async {
    await ref.read(prayerActionsProvider).reconcileQaza();
    unawaited(ref.read(rescheduleControllerProvider.notifier).reschedule());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final today = ref.watch(todayDateProvider);
    final pauses = ref.watch(pausesProvider).value ?? const <PauseRange>[];
    final ongoing = pauses.where((p) => p.isOngoing).firstOrNull;
    String fmt(DateTime d) => DateFormat.MMMd(dateLocale(locale)).format(d);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.pause_circle_outline, color: scheme.secondary),
              const SizedBox(width: 8),
              Text(l10n.pauseTitle, style: text.titleMedium),
            ]),
            const SizedBox(height: 8),
            Text(l10n.pauseHelp, style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
            const SizedBox(height: 12),
            if (ongoing != null) ...[
              Text(l10n.pauseSince(fmt(ongoing.start)), key: const ValueKey('pause-since')),
              const SizedBox(height: 8),
              FilledButton(
                key: const ValueKey('pause-end'),
                onPressed: () async {
                  await ref.read(appDatabaseProvider).pauseRangesDao.endOngoing(dateKey(today));
                  await _changed(ref);
                },
                child: Text(l10n.pauseEnd),
              ),
            ] else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.tonal(
                    key: const ValueKey('pause-start'),
                    onPressed: () async {
                      await ref.read(appDatabaseProvider).pauseRangesDao.startPause(dateKey(today));
                      await _changed(ref);
                    },
                    child: Text(l10n.pauseStart),
                  ),
                  OutlinedButton(
                    key: const ValueKey('pause-add-past'),
                    onPressed: () async {
                      final range = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(today.year, today.month, today.day - 120),
                        lastDate: today,
                      );
                      if (range == null) return;
                      await ref.read(appDatabaseProvider).pauseRangesDao.addRange(dateKey(range.start), dateKey(range.end));
                      await _changed(ref);
                    },
                    child: Text(l10n.pauseAddPast),
                  ),
                ],
              ),
            for (final p in pauses.where((p) => !p.isOngoing && p.end != null && p.id != null).take(5))
              ListTile(
                key: ValueKey('pause-range-${p.id}'),
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: Text(l10n.pauseRange(fmt(p.start), fmt(p.end!))),
                trailing: IconButton(
                  tooltip: l10n.pauseRemove,
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    await ref.read(appDatabaseProvider).pauseRangesDao.remove(p.id!);
                    await _changed(ref);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
