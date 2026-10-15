import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_name.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_settings.dart';
import 'package:saathi/features/prayer/presentation/screens/qaza_screen.dart';

import '../../../support/harness.dart';

void main() {
  setUpAll(Harness.setUpAll);

  // Thursday 2026-10-15, 12:00 in Karachi. Only Fajr's window has ended today.
  final now = DateTime.utc(2026, 10, 15, 7);

  Future<Harness> pump(WidgetTester tester) => Harness.pump(tester, home: const QazaScreen(), now: now);

  String text(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(ValueKey(key))).data!;

  testWidgets('starts with nothing owed and empty history', (tester) async {
    await pump(tester);
    expect(text(tester, 'qaza-total'), 'Nothing owed');
    for (final p in PrayerName.obligatory) {
      expect(text(tester, 'qaza-count-${p.name}'), '0');
      expect(tester.widget<IconButton>(find.byKey(ValueKey('qaza-minus-${p.name}'))).onPressed, isNull,
          reason: 'cannot make up what is not owed');
    }
    expect(find.byKey(const ValueKey('qaza-history-empty')), findsOneWidget);
  });

  testWidgets('adding and making up change the count and the total, and are listed in history', (tester) async {
    final h = await pump(tester);
    await tester.tap(find.byKey(const ValueKey('qaza-plus-fajr')));
    await Harness.settle(tester);
    await tester.tap(find.byKey(const ValueKey('qaza-plus-fajr')));
    await Harness.settle(tester);
    await tester.tap(find.byKey(const ValueKey('qaza-plus-isha')));
    await Harness.settle(tester);
    expect(text(tester, 'qaza-count-fajr'), '2');
    expect(text(tester, 'qaza-total'), '3 prayers to make up');

    await tester.tap(find.byKey(const ValueKey('qaza-minus-fajr')));
    await Harness.settle(tester);
    expect(text(tester, 'qaza-count-fajr'), '1');
    expect(text(tester, 'qaza-total'), '2 prayers to make up');
    expect(await h.db.qazaDao.owedFor('fajr'), 1);
    expect(find.byKey(const ValueKey('qaza-history-empty')), findsNothing);
    expect(find.textContaining('Made up'), findsOneWidget);
  });

  testWidgets('set starting balance applies each prayer', (tester) async {
    final h = await pump(tester);
    await tester.tap(find.byKey(const ValueKey('qaza-set-balance')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('balance-fajr')), '120');
    await tester.enterText(find.byKey(const ValueKey('balance-asr')), '40');
    await tester.tap(find.byKey(const ValueKey('balance-apply')));
    await tester.pumpAndSettle();
    expect(await h.db.qazaDao.owed(), {'fajr': 120, 'asr': 40});
    expect(text(tester, 'qaza-total'), '160 prayers to make up');
  });

  testWidgets('the years estimate fills every prayer with years times 365', (tester) async {
    final h = await pump(tester);
    await tester.tap(find.byKey(const ValueKey('qaza-set-balance')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('balance-years')), '2');
    await tester.tap(find.byKey(const ValueKey('balance-estimate')));
    await tester.pump();
    expect(tester.widget<TextField>(find.byKey(const ValueKey('balance-isha'))).controller!.text, '730');
    await tester.tap(find.byKey(const ValueKey('balance-apply')));
    await tester.pumpAndSettle();
    expect(await h.db.qazaDao.owedFor('dhuhr'), 730);
  });

  testWidgets('cancelling the balance dialog changes nothing, and garbage input counts as zero', (tester) async {
    final h = await pump(tester);
    await h.db.qazaDao.change('asr', 5, now, 'added');
    await Harness.settle(tester);
    await tester.tap(find.byKey(const ValueKey('qaza-set-balance')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('balance-asr')), '999');
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(await h.db.qazaDao.owedFor('asr'), 5);

    await tester.tap(find.byKey(const ValueKey('qaza-set-balance')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('balance-asr')), 'abc');
    await tester.tap(find.byKey(const ValueKey('balance-apply')));
    await tester.pumpAndSettle();
    expect(await h.db.qazaDao.owedFor('asr'), 0);
  });

  testWidgets('turning on automatic counting starts from today and counts windows that already ended', (tester) async {
    final h = await pump(tester);
    expect(tester.widget<SwitchListTile>(find.byKey(const ValueKey('qaza-auto'))).value, isFalse);
    await tester.tap(find.byKey(const ValueKey('qaza-auto')));
    await Harness.settle(tester);
    await Harness.settle(tester);
    expect((await h.settingsRepo.load()).autoQazaFrom, '2026-10-15');
    expect(await h.db.qazaDao.owedFor('fajr'), 1, reason: "today's Fajr ended without a tick");
    expect(await h.db.qazaDao.owedFor('dhuhr'), 0, reason: 'Dhuhr is still open');
    expect(find.textContaining('Counted automatically'), findsOneWidget);
  });

  testWidgets('turning it off stops counting but keeps what was counted', (tester) async {
    final h = await pump(tester);
    await tester.tap(find.byKey(const ValueKey('qaza-auto')));
    await Harness.settle(tester);
    await Harness.settle(tester);
    await tester.tap(find.byKey(const ValueKey('qaza-auto')));
    await Harness.settle(tester);
    expect((await h.settingsRepo.load()).autoQazaFrom, isNull);
    expect(await h.db.qazaDao.owedFor('fajr'), 1);
  });

  testWidgets('opening the screen catches up automatic counting', (tester) async {
    final h = await Harness.pump(
      tester,
      home: const QazaScreen(),
      now: now,
      settings: PrayerSettings.defaults().copyWith(autoQazaFrom: '2026-10-14'),
    );
    await Harness.settle(tester);
    await Harness.settle(tester);
    // 14th: all five ended; 15th: Fajr ended.
    expect(await h.db.qazaDao.owedFor('fajr'), 2);
    expect(await h.db.qazaDao.owedFor('isha'), 1);
  });
}
