import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/features/prayer/domain/entities/jamaat.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_name.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_settings.dart';
import 'package:saathi/features/prayer/presentation/screens/home_screen.dart';
import 'package:saathi/features/prayer/presentation/widgets/jamaat_section.dart';

import '../../../support/harness.dart';

void main() {
  setUpAll(Harness.setUpAll);

  // Thursday 2026-10-15, 15:00 in Karachi.
  final now = DateTime.utc(2026, 10, 15, 10);

  Future<Harness> pumpSection(WidgetTester tester, {PrayerSettings? settings}) => Harness.pump(
        tester,
        home: const Scaffold(body: SingleChildScrollView(child: JamaatSection())),
        now: now,
        settings: settings,
        size: const Size(420, 2200),
      );

  Text sub(WidgetTester tester, String key) {
    final tile = tester.widget<ListTile>(find.byKey(ValueKey(key)));
    return tile.subtitle! as Text;
  }

  testWidgets('starts with every prayer not set and no leave reminder option', (tester) async {
    await pumpSection(tester);
    for (final p in PrayerName.obligatory) {
      expect(sub(tester, 'jamaat-${p.name}').data, 'Not set');
    }
    expect(sub(tester, 'jamaat-jumma').data, 'Not set');
    expect(find.byKey(const ValueKey('jamaat-leave')), findsNothing, reason: 'nothing to leave for yet');
  });

  testWidgets('setting minutes after the azan is saved and shown', (tester) async {
    final h = await pumpSection(tester);
    await tester.tap(find.byKey(const ValueKey('jamaat-asr')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('jamaat-minutes')), '12');
    await tester.tap(find.byKey(const ValueKey('jamaat-save')));
    await tester.pumpAndSettle();
    expect(sub(tester, 'jamaat-asr').data, '12 min after azan');
    expect((await h.settingsRepo.load()).jamaat.offsetMin[PrayerName.asr], 12);
    expect(find.byKey(const ValueKey('jamaat-leave')), findsOneWidget, reason: 'now there is something to leave for');
  });

  testWidgets('a fixed time can be picked and replaces the minutes rule', (tester) async {
    final h = await pumpSection(
      tester,
      settings: PrayerSettings.defaults().copyWith(jamaat: const JamaatSettings(offsetMin: {PrayerName.dhuhr: 15})),
    );
    await tester.tap(find.byKey(const ValueKey('jamaat-dhuhr')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fixed time'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('jamaat-pick-time')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('jamaat-save')));
    await tester.pumpAndSettle();
    final saved = (await h.settingsRepo.load()).jamaat;
    expect(saved.fixedMin[PrayerName.dhuhr], 13 * 60);
    expect(saved.offsetMin.containsKey(PrayerName.dhuhr), isFalse, reason: 'a prayer has one rule');
    expect(sub(tester, 'jamaat-dhuhr').data, 'At 1:00 PM');
  });

  testWidgets('clear removes a rule', (tester) async {
    final h = await pumpSection(
      tester,
      settings: PrayerSettings.defaults().copyWith(jamaat: const JamaatSettings(offsetMin: {PrayerName.isha: 20})),
    );
    expect(sub(tester, 'jamaat-isha').data, '20 min after azan');
    await tester.tap(find.byKey(const ValueKey('jamaat-isha')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('jamaat-clear')));
    await tester.pumpAndSettle();
    expect(sub(tester, 'jamaat-isha').data, 'Not set');
    expect((await h.settingsRepo.load()).jamaat.isConfigured, isFalse);
  });

  testWidgets('non-numeric or zero minutes save as "not set"', (tester) async {
    final h = await pumpSection(tester);
    await tester.tap(find.byKey(const ValueKey('jamaat-fajr')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('jamaat-minutes')), '0');
    await tester.tap(find.byKey(const ValueKey('jamaat-save')));
    await tester.pumpAndSettle();
    expect((await h.settingsRepo.load()).jamaat.isConfigured, isFalse);
  });

  testWidgets('the Jumma time can be set and cleared', (tester) async {
    final h = await pumpSection(tester);
    await tester.tap(find.byKey(const ValueKey('jamaat-jumma')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect((await h.settingsRepo.load()).jamaat.jummaFixedMin, 13 * 60);
    await tester.tap(find.byKey(const ValueKey('jamaat-jumma-clear')));
    await tester.pumpAndSettle();
    expect((await h.settingsRepo.load()).jamaat.jummaFixedMin, isNull);
  });

  testWidgets('the leave reminder choice is saved and a rule must exist to see it', (tester) async {
    final h = await pumpSection(
      tester,
      settings: PrayerSettings.defaults().copyWith(jamaat: const JamaatSettings(offsetMin: {PrayerName.asr: 10})),
    );
    await tester.tap(find.byKey(const ValueKey('jamaat-leave-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('15 min').last);
    await tester.pumpAndSettle();
    expect((await h.settingsRepo.load()).jamaat.leaveReminderMin, 15);
  });

  testWidgets('Home shows each prayer\'s jama\'at time under its name', (tester) async {
    await Harness.pump(
      tester,
      home: const HomeScreen(),
      now: now,
      settings: PrayerSettings.defaults().copyWith(
        jamaat: const JamaatSettings(offsetMin: {PrayerName.asr: 10}, fixedMin: {PrayerName.isha: 20 * 60 + 15}),
      ),
    );
    expect(find.byKey(const ValueKey('jamaat-text-asr')), findsOneWidget);
    expect(tester.widget<Text>(find.byKey(const ValueKey('jamaat-text-asr'))).data, startsWith("Jama'at "));
    expect(tester.widget<Text>(find.byKey(const ValueKey('jamaat-text-isha'))).data, "Jama'at 8:15 PM");
    expect(find.byKey(const ValueKey('jamaat-text-fajr')), findsNothing);
  });

  testWidgets('on a Friday the Jumma time shows for Dhuhr', (tester) async {
    await Harness.pump(
      tester,
      home: const HomeScreen(),
      now: DateTime.utc(2026, 10, 16, 5), // Friday 10:00 in Karachi
      settings: PrayerSettings.defaults().copyWith(
        jamaat: const JamaatSettings(fixedMin: {PrayerName.dhuhr: 13 * 60}, jummaFixedMin: 13 * 60 + 45),
      ),
    );
    expect(tester.widget<Text>(find.byKey(const ValueKey('jamaat-text-dhuhr'))).data, "Jama'at 1:45 PM");
  });
}
