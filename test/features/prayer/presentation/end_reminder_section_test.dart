import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_name.dart';
import 'package:saathi/features/prayer/presentation/widgets/end_reminder_section.dart';

import '../../../support/harness.dart';

void main() {
  setUpAll(Harness.setUpAll);

  final now = DateTime.utc(2026, 10, 15, 7);

  Future<Harness> pump(WidgetTester tester) => Harness.pump(
        tester,
        home: const Scaffold(body: SingleChildScrollView(child: EndReminderSection())),
        now: now,
      );

  testWidgets('options show by default since reminders are enabled', (tester) async {
    final h = await pump(tester);
    expect(h.settingsRepo.current.endReminder.enabled, isTrue);
    expect(find.byKey(const ValueKey('end-enable')), findsOneWidget);
    expect(find.byKey(const ValueKey('end-lead-dropdown')), findsOneWidget);
    expect(find.byKey(const ValueKey('end-photo')), findsOneWidget);
  });

  testWidgets('turning it off hides the options', (tester) async {
    final h = await pump(tester);
    await tester.tap(find.byKey(const ValueKey('end-enable')));
    await Harness.settle(tester);

    expect(h.settingsRepo.current.endReminder.enabled, isFalse);
    expect(find.byKey(const ValueKey('end-lead-dropdown')), findsNothing);
    expect(find.byKey(const ValueKey('end-repeat-dropdown')), findsNothing);
    for (final p in PrayerName.obligatory) {
      expect(find.byKey(ValueKey('end-prayer-${p.name}')), findsNothing);
    }
  });

  testWidgets('a prayer can be left out', (tester) async {
    final h = await pump(tester);
    // Enabled by default; tap a prayer chip to deselect it.
    await tester.tap(find.byKey(const ValueKey('end-prayer-fajr')));
    await Harness.settle(tester);

    final end = h.settingsRepo.current.endReminder;
    expect(end.prayers[PrayerName.fajr], isFalse);
    expect(end.appliesTo(PrayerName.fajr), isFalse);
    expect(end.appliesTo(PrayerName.isha), isTrue);
  });

  testWidgets('lead time and repeat gap can be changed', (tester) async {
    final h = await pump(tester);
    // Enabled by default; no need to tap the enable switch.

    await tester.tap(find.byKey(const ValueKey('end-lead-dropdown')));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('45 min before the end').last);
    await Harness.settle(tester);
    expect(h.settingsRepo.current.endReminder.leadMin, 45);

    await tester.tap(find.byKey(const ValueKey('end-repeat-dropdown')));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('5 min').last);
    await Harness.settle(tester);
    expect(h.settingsRepo.current.endReminder.repeatMin, 5);
  });

  testWidgets('photo proof is on by default and can be toggled off', (tester) async {
    final h = await pump(tester);
    // Enabled and photo required by default.
    expect(h.settingsRepo.current.endReminder.requirePhoto, isTrue);
    expect(find.textContaining('never saved or sent'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('end-photo')));
    await Harness.settle(tester);
    expect(h.settingsRepo.current.endReminder.requirePhoto, isFalse);
  });
}
