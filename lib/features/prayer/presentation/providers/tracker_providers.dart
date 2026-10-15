import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart' show Notifier, NotifierProvider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers.dart';
import '../../data/qaza/qaza_service.dart';
import '../../domain/entities/pause_range.dart';
import '../../domain/entities/prayer_name.dart';
import '../../domain/entities/prayer_window.dart';
import '../../domain/entities/streaks.dart';
import '../../domain/usecases/schedule_upcoming_azans.dart';
import 'prayer_providers.dart';
import 'reschedule_controller.dart';
import 'sync_controller.dart';

part 'tracker_providers.g.dart';

/// How far back the tracker looks.
const int kTrackerHistoryDays = 400;

DateTime _daysAgo(DateTime d, int n) => DateTime(d.year, d.month, d.day - n);

/// The first day the user has been tracking. Days before it are never counted
/// as missed. Set the first time it is needed.
@Riverpod(keepAlive: true)
Future<DateTime> trackingStart(Ref ref) async {
  final store = ref.watch(trackingStartStoreProvider);
  final today = ref.read(todayDateProvider);
  final saved = store.read();
  if (saved != null) return saved;
  // First run of the tracker: start at the earliest existing log, else today.
  final earliest = await ref.read(appDatabaseProvider).prayerLogsDao.earliestDate();
  final start = earliest == null ? today : DateTime.parse(earliest);
  final chosen = start.isAfter(today) ? today : start;
  await store.write(chosen);
  return chosen;
}

/// Everything ticked in the tracker window, by date.
@Riverpod(keepAlive: true)
Stream<Map<String, Set<PrayerName>>> doneByDate(Ref ref) {
  final from = dateKey(_daysAgo(ref.watch(todayDateProvider), kTrackerHistoryDays));
  return ref.watch(appDatabaseProvider).prayerLogsDao.watchDoneSince(from).map((raw) => {
        for (final e in raw.entries)
          e.key: {
            for (final p in PrayerName.obligatory)
              if (e.value.contains(p.name)) p,
          },
      });
}


@Riverpod(keepAlive: true)
Stream<List<PauseRange>> pauses(Ref ref) =>
    ref.watch(appDatabaseProvider).pauseRangesDao.watchAll().map(pauseRangesFrom);

@Riverpod(keepAlive: true)
StreakSummary streakSummary(Ref ref) {
  final done = ref.watch(doneByDateProvider).value ?? const {};
  final pauses = ref.watch(pausesProvider).value ?? const [];
  final today = ref.watch(todayDateProvider);
  var start = ref.watch(trackingStartProvider).value ?? today;
  // Days the user filled in before tracking "began" still count: tracking
  // starts at the earliest day that has any tick.
  for (final key in done.keys) {
    final d = DateTime.tryParse(key);
    if (d != null && d.isBefore(start)) start = d;
  }
  return computeStreaks(doneByDate: done, pauses: pauses, today: today, trackingStart: start);
}

/// The day shown in the tracker. Null means today.
final selectedDayProvider = NotifierProvider<SelectedDay, DateTime?>(SelectedDay.new);

class SelectedDay extends Notifier<DateTime?> {
  @override
  DateTime? build() => null;

  void select(DateTime? day) => state = day;
}

/// Owed qaza prayers per prayer.
@Riverpod(keepAlive: true)
Stream<Map<PrayerName, int>> qazaOwed(Ref ref) =>
    ref.watch(appDatabaseProvider).qazaDao.watchOwed().map((raw) => {
          for (final p in PrayerName.obligatory)
            if ((raw[p.name] ?? 0) > 0) p: raw[p.name]!,
        });

@Riverpod(keepAlive: true)
int qazaTotal(Ref ref) => (ref.watch(qazaOwedProvider).value ?? const {}).values.fold(0, (a, b) => a + b);

/// What happened when the user tried to tick a prayer.
enum TickResult {
  saved,

  /// Photo proof is required for this prayer right now; open the camera screen.
  needsProof,
}

/// The one place that ticks and un-ticks prayers, so every screen behaves the same.
@Riverpod(keepAlive: true)
PrayerActions prayerActions(Ref ref) => PrayerActions(ref);

class PrayerActions {
  PrayerActions(this._ref);

  final Ref _ref;

  /// Whether ticking [prayer] right now must be backed by a photo.
  bool proofRequiredNow(PrayerName prayer, DateTime date) {
    final settings = _ref.read(currentSettingsProvider);
    if (!settings.endReminder.requirePhoto || !settings.endReminder.appliesTo(prayer)) return false;
    if (date != _ref.read(todayDateProvider)) return false;
    final now = _ref.read(clockProvider)();
    final windows = prayerWindows(_ref.read(todayTimesProvider), _ref.read(tomorrowTimesProvider));
    return windows.firstWhere((w) => w.prayer == prayer).contains(now);
  }

  /// Ticks or un-ticks [prayer] on [date]. Past days can be edited freely.
  /// Returns [TickResult.needsProof] instead of ticking when a photo is required.
  Future<TickResult> setDone(DateTime date, PrayerName prayer, {required bool done}) async {
    if (done && proofRequiredNow(prayer, date)) return TickResult.needsProof;
    await _record(date, prayer, done: done);
    return TickResult.saved;
  }

  /// Ticks a prayer after the photo check passed. Skips the proof rule.
  Future<void> markVerified(DateTime date, PrayerName prayer) => _record(date, prayer, done: true);

  Future<void> _record(DateTime date, PrayerName prayer, {required bool done}) async {
    await _ref.read(markPrayerDoneProvider)(date, prayer, done: done);
    if (done) {
      // No more "time is ending" reminders for a prayer that is done.
      await _ref.read(notificationSchedulerProvider).cancel(endReminderIds(date, prayer));
    } else {
      // Un-ticking today's prayer may need its reminders back.
      unawaited(_ref.read(rescheduleControllerProvider.notifier).reschedule());
    }
    unawaited(reconcileQaza());
    _ref.read(syncStatusControllerProvider.notifier).scheduleSoon();
  }

  /// Brings the automatic qaza count up to date. Cheap and safe to repeat.
  Future<void> reconcileQaza() async {
    final settings = _ref.read(currentSettingsProvider);
    final from = settings.autoQazaFrom;
    if (from == null) return;
    await _ref.read(qazaServiceProvider).reconcile(
          settings: settings,
          now: _ref.read(clockProvider)(),
          from: DateTime.parse(from),
        );
  }
}
