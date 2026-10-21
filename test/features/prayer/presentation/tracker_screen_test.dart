import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:saathi/app/providers.dart';
import 'package:saathi/features/prayer/domain/entities/end_reminder.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_name.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_settings.dart';
import 'package:saathi/features/prayer/presentation/providers/tracker_providers.dart';
import 'package:saathi/features/prayer/presentation/screens/tracker_screen.dart';

import '../../../support/harness.dart';

void main() {
  setUpAll(Harness.setUpAll);

  // Thursday 2026-10-15, 12:00 in Karachi (07:00 UTC). Dhuhr is open (about 11:50 to 16:30).
  final now = DateTime.utc(2026, 10, 15, 7);

  // 13:00 in Karachi: Dhuhr (starts about 12:20) is open, Isha has not started.
  final dhuhrOpen = DateTime.utc(2026, 10, 15, 8);

  Future<Harness> pump(
    WidgetTester tester, {
    PrayerSettings? settings,
    List<GoRoute> routes = const [],
    DateTime? at,
  }) =>
      Harness.pump(tester, home: const TrackerScreen(), now: at ?? now, settings: settings, extraRoutes: routes);

  Future<void> tickAll(Harness h, String date, {DateTime? at}) async {
    for (final p in PrayerName.obligatory) {
      await h.db.prayerLogsDao.markDone(date, p.name, at ?? DateTime.utc(2026, 10, 14, 12));
    }
  }

  Text textOf(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(ValueKey(key)));

  group('streak', () {
    testWidgets('starts with an invitation and no streak', (tester) async {
      await pump(tester);
      expect(textOf(tester, 'streak-current').data, 'Pray all five today to start a streak');
      expect(find.byKey(const ValueKey('streak-best')), findsNothing);
    });

    testWidgets('counts consecutive complete days and shows the best', (tester) async {
      final h = await pump(tester);
      for (final d in ['2026-10-12', '2026-10-13', '2026-10-14']) {
        await tickAll(h, d, at: DateTime.utc(2026, 10, 14, 12));
      }
      await h.container.read(trackingStartProvider.future);
      await h.db.prayerLogsDao.markDone('2026-10-12', 'fajr', DateTime.utc(2026, 10, 12));
      await Harness.settle(tester);
      expect(textOf(tester, 'streak-current').data, '3-day streak');
      expect(textOf(tester, 'streak-best').data, 'Best: 3');
    });

    testWidgets('a missed day resets the current streak but keeps the best', (tester) async {
      final h = await pump(tester);
      await h.container.read(trackingStartProvider.future);
      // Tracking starts today, so move it back first.
      h.container.read(trackingStartStoreProvider).write(DateTime(2026, 10, 1));
      h.container.invalidate(trackingStartProvider);
      await tickAll(h, '2026-10-05');
      await tickAll(h, '2026-10-06');
      await tickAll(h, '2026-10-07');
      await tickAll(h, '2026-10-14');
      await Harness.settle(tester);
      await h.container.read(trackingStartProvider.future);
      await Harness.settle(tester);
      expect(textOf(tester, 'streak-current').data, '1-day streak');
      expect(textOf(tester, 'streak-best').data, 'Best: 3');
    });
  });

  group('editing days', () {
    testWidgets('ticking a prayer today is saved and marked for syncing', (tester) async {
      final h = await pump(tester);
      await tester.tap(find.byKey(const ValueKey('tracker-fajr')));
      await Harness.settle(tester);
      expect(await h.db.prayerLogsDao.doneFor('2026-10-15'), {'fajr'});
      expect(await h.db.prayerLogsDao.dirtyCount(), 1);
      expect(tester.widget<CheckboxListTile>(find.byKey(const ValueKey('tracker-fajr'))).value, isTrue);
    });

    testWidgets('a past day can be opened from the week strip and edited', (tester) async {
      final h = await pump(tester);
      await tester.tap(find.byKey(const ValueKey('week-day-2026-10-13')));
      await Harness.settle(tester);
      expect(textOf(tester, 'day-title').data, contains('13'));
      await tester.tap(find.byKey(const ValueKey('tracker-asr')));
      await Harness.settle(tester);
      expect(await h.db.prayerLogsDao.doneFor('2026-10-13'), {'asr'});
      expect(await h.db.prayerLogsDao.doneFor('2026-10-15'), isEmpty, reason: 'today is untouched');
    });

    testWidgets('un-ticking a past prayer keeps a marker so the change can sync', (tester) async {
      final h = await pump(tester);
      await h.db.prayerLogsDao.markDone('2026-10-14', 'isha', DateTime.utc(2026, 10, 14, 17));
      await tester.tap(find.byKey(const ValueKey('week-day-2026-10-14')));
      await Harness.settle(tester);
      await tester.tap(find.byKey(const ValueKey('tracker-isha')));
      await Harness.settle(tester);
      expect(await h.db.prayerLogsDao.doneFor('2026-10-14'), isEmpty);
      final rows = await h.db.select(h.db.prayerLogs).get();
      expect(rows.single.done, isFalse);
      expect(rows.single.dirty, isTrue);
    });

    testWidgets('previous and next buttons walk through days, and next is disabled on today', (tester) async {
      await pump(tester);
      expect(tester.widget<IconButton>(find.byKey(const ValueKey('day-next'))).onPressed, isNull);
      await tester.tap(find.byKey(const ValueKey('day-prev')));
      await Harness.settle(tester);
      expect(textOf(tester, 'day-title').data, contains('14'));
      await tester.tap(find.byKey(const ValueKey('day-prev')));
      await Harness.settle(tester);
      expect(textOf(tester, 'day-title').data, contains('13'));
      await tester.tap(find.byKey(const ValueKey('day-next')));
      await Harness.settle(tester);
      await tester.tap(find.byKey(const ValueKey('day-next')));
      await Harness.settle(tester);
      expect(textOf(tester, 'day-title').data, contains('15'));
    });

    testWidgets('Friday shows Jumma in place of Dhuhr', (tester) async {
      await pump(tester);
      // 2026-10-09 is a Friday: walk back six days from the 15th.
      for (var i = 0; i < 6; i++) {
        await tester.tap(find.byKey(const ValueKey('day-prev')));
        await Harness.settle(tester);
      }
      expect(textOf(tester, 'day-title').data, contains('Fri'));
      expect(find.descendant(of: find.byKey(const ValueKey('tracker-dhuhr')), matching: find.text('Jumma')), findsOneWidget);
    });
  });

  group('photo proof', () {
    testWidgets('with proof on, ticking an open prayer opens the photo screen instead of ticking', (tester) async {
      final h = await pump(
        tester,
        at: dhuhrOpen,
        settings: PrayerSettings.defaults().copyWith(
          endReminder: const EndReminderSettings(enabled: true, requirePhoto: true),
        ),
        routes: [GoRoute(path: '/verify', builder: (_, s) => Text('VERIFY ${s.uri.queryParameters['prayer']} ${s.uri.queryParameters['date']}'))],
      );
      await tester.tap(find.byKey(const ValueKey('tracker-dhuhr')));
      await Harness.settle(tester);
      expect(find.text('VERIFY dhuhr 2026-10-15'), findsOneWidget);
      expect(await h.db.prayerLogsDao.doneFor('2026-10-15'), isEmpty, reason: 'nothing ticked yet');
    });

    testWidgets('proof is not asked for a past day or for a prayer whose time is not open', (tester) async {
      final h = await pump(
        tester,
        at: dhuhrOpen,
        settings: PrayerSettings.defaults().copyWith(
          endReminder: const EndReminderSettings(enabled: true, requirePhoto: true),
        ),
        routes: [GoRoute(path: '/verify', builder: (_, _) => const Text('VERIFY'))],
      );
      // Isha has not started at noon: can be ticked freely (e.g. prayed early by mistake or catching up).
      await tester.tap(find.byKey(const ValueKey('tracker-isha')));
      await Harness.settle(tester);
      expect(find.text('VERIFY'), findsNothing);
      expect(await h.db.prayerLogsDao.doneFor('2026-10-15'), {'isha'});

      await tester.tap(find.byKey(const ValueKey('week-day-2026-10-14')));
      await Harness.settle(tester);
      await tester.tap(find.byKey(const ValueKey('tracker-fajr')));
      await Harness.settle(tester);
      expect(find.text('VERIFY'), findsNothing);
      expect(await h.db.prayerLogsDao.doneFor('2026-10-14'), {'fajr'});
    });

    testWidgets('ticking a prayer (no photo required) cancels its remaining reminders', (tester) async {
      final h = await pump(
        tester,
        at: dhuhrOpen,
        settings: PrayerSettings.defaults().copyWith(
          endReminder: const EndReminderSettings(enabled: true, requirePhoto: false),
        ),
      );
      await tester.tap(find.byKey(const ValueKey('tracker-dhuhr')));
      await Harness.settle(tester);
      expect(h.scheduler.cancelled, isNotEmpty);
      expect(h.scheduler.cancelled.length, 10);
    });
  });

  group('pause', () {
    testWidgets('starting a pause marks today as paused and keeps the streak safe', (tester) async {
      final h = await pump(tester);
      await tester.tap(find.byKey(const ValueKey('pause-start')));
      await Harness.settle(tester);
      expect(find.byKey(const ValueKey('pause-since')), findsOneWidget);
      expect(find.byKey(const ValueKey('paused-banner')), findsOneWidget);
      expect((await h.db.pauseRangesDao.all()).single.endDate, isNull);
    });

    testWidgets('resuming ends the pause', (tester) async {
      final h = await pump(tester);
      await tester.tap(find.byKey(const ValueKey('pause-start')));
      await Harness.settle(tester);
      await tester.tap(find.byKey(const ValueKey('pause-end')));
      await Harness.settle(tester);
      expect(find.byKey(const ValueKey('pause-since')), findsNothing);
      expect((await h.db.pauseRangesDao.all()).single.endDate, '2026-10-15');
    });

    testWidgets('past pause ranges are listed and can be removed', (tester) async {
      final h = await pump(tester);
      final id = await h.db.pauseRangesDao.addRange('2026-10-05', '2026-10-09');
      await Harness.settle(tester);
      expect(find.byKey(ValueKey('pause-range-$id')), findsOneWidget);
      await tester.tap(find.descendant(of: find.byKey(ValueKey('pause-range-$id')), matching: find.byIcon(Icons.delete_outline)));
      await Harness.settle(tester);
      expect(find.byKey(ValueKey('pause-range-$id')), findsNothing);
      expect(await h.db.pauseRangesDao.all(), isEmpty);
    });

    testWidgets('a paused day does not break a streak', (tester) async {
      final h = await pump(tester);
      h.container.read(trackingStartStoreProvider).write(DateTime(2026, 10, 10));
      h.container.invalidate(trackingStartProvider);
      await tickAll(h, '2026-10-12');
      await tickAll(h, '2026-10-14');
      await h.db.pauseRangesDao.addRange('2026-10-13', '2026-10-13');
      await h.container.read(trackingStartProvider.future);
      await Harness.settle(tester);
      expect(textOf(tester, 'streak-current').data, '2-day streak');
    });
  });

  testWidgets('the qaza card shows the total owed', (tester) async {
    final h = await pump(tester);
    expect(textOf(tester, 'qaza-card-count').data, 'Nothing owed');
    await h.db.qazaDao.change('fajr', 3, now, 'added');
    await Harness.settle(tester);
    expect(textOf(tester, 'qaza-card-count').data, '3 to make up');
  });
}
