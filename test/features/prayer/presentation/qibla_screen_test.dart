import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_settings.dart';
import 'package:saathi/features/prayer/domain/entities/qibla.dart';
import 'package:saathi/features/prayer/presentation/providers/qibla_providers.dart';
import 'package:saathi/features/prayer/presentation/screens/qibla_screen.dart';

import '../../../support/fakes.dart';
import '../../../support/harness.dart';

void main() {
  setUpAll(Harness.setUpAll);

  final now = DateTime.utc(2026, 10, 15, 7);
  // Karachi is the default location.
  final settings = PrayerSettings.defaults();
  final bearing = qiblaBearingDegrees(settings.lat, settings.lng);

  Future<FakeCompassSource> pump(
    WidgetTester tester, {
    FakeCompassSource? compass,
    double? declination,
  }) async {
    final source = compass ?? FakeCompassSource();
    await Harness.pump(
      tester,
      home: const QiblaScreen(),
      now: now,
      settings: settings,
      bridge: RecordingBridge()..declination = declination,
      overrides: [compassSourceProvider.overrideWithValue(source)],
    );
    await Harness.settle(tester);
    return source;
  }

  /// The clockwise angle a keyed Transform.rotate is turned by, in degrees.
  double angleOf(WidgetTester tester, String key) {
    final m = tester.widget<Transform>(find.byKey(ValueKey(key))).transform;
    return math.atan2(m.storage[1], m.storage[0]) * 180 / math.pi;
  }

  String textOf(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(ValueKey(key))).data!;

  Future<void> feed(WidgetTester tester, FakeCompassSource s, double heading, {double? accuracy = 15}) async {
    s.emit(heading, accuracy: accuracy);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  double diff(double a, double b) => ((a - b + 540) % 360) - 180;

  testWidgets('shows the bearing and the distance from the saved location', (tester) async {
    await pump(tester);
    expect(textOf(tester, 'qibla-bearing'), 'Qibla is ${bearing.round()}° from north');
    expect(textOf(tester, 'qibla-distance'), matches(RegExp(r'^[\d,]+ km to the Kaaba$')));
  });

  testWidgets('waits for the first reading with a spinner', (tester) async {
    await pump(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byKey(const ValueKey('qibla-needle')), findsNothing);
  });

  testWidgets('a phone with no compass shows the fallback and no live needle', (tester) async {
    await pump(tester, compass: FakeCompassSource(hasCompass: false));
    expect(find.textContaining('no compass sensor'), findsOneWidget);
    expect(find.byKey(const ValueKey('qibla-needle')), findsNothing);
  });

  testWidgets('a sensor error falls back to the fixed bearing', (tester) async {
    final s = await pump(tester);
    s.controller.addError(StateError('sensor died'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.textContaining('no compass sensor'), findsOneWidget);
  });

  testWidgets('facing the Qibla: needle straight up and a clear message', (tester) async {
    final s = await pump(tester);
    await feed(tester, s, bearing);
    expect(angleOf(tester, 'qibla-needle').abs(), lessThan(0.5));
    expect(textOf(tester, 'qibla-guidance'), 'You are facing the Qibla');
  });

  testWidgets('facing north: the Qibla is to the left', (tester) async {
    final s = await pump(tester);
    await feed(tester, s, 0);
    final turn = turnToQibla(heading: 0, bearing: bearing);
    expect(turn, lessThan(0));
    expect(textOf(tester, 'qibla-guidance'), 'Turn left ${turn.abs().round()}°');
    // The needle points to the Kaaba: bearing - heading, clockwise from the top.
    expect(diff(angleOf(tester, 'qibla-needle'), bearing).abs(), lessThan(0.5));
  });

  testWidgets('facing south: the Qibla is to the right', (tester) async {
    final s = await pump(tester);
    await feed(tester, s, 180);
    final turn = turnToQibla(heading: 180, bearing: bearing);
    expect(turn, greaterThan(0));
    expect(textOf(tester, 'qibla-guidance'), 'Turn right ${turn.round()}°');
    expect(diff(angleOf(tester, 'qibla-needle'), bearing - 180).abs(), lessThan(0.5));
  });

  testWidgets('the dial turns opposite to the phone so N stays on true north', (tester) async {
    final s = await pump(tester);
    await feed(tester, s, 90);
    expect(diff(angleOf(tester, 'qibla-dial'), -90).abs(), lessThan(0.5));
    await feed(tester, s, 270);
    expect(diff(angleOf(tester, 'qibla-dial'), -270).abs(), lessThan(0.5));
  });

  testWidgets('turning the phone slowly walks the guidance to zero', (tester) async {
    final s = await pump(tester);
    double? previous;
    // Turn left from north (heading falls from 360) towards the Qibla bearing in steps.
    for (var h = 359.0; h >= bearing; h -= 20) {
      await feed(tester, s, h);
      final turn = turnToQibla(heading: h, bearing: bearing).abs();
      if (previous != null) expect(turn, lessThan(previous), reason: 'heading $h');
      previous = turn;
    }
    await feed(tester, s, bearing);
    expect(textOf(tester, 'qibla-guidance'), 'You are facing the Qibla');
  });

  testWidgets('magnetic declination is applied: a compass that reads 10 degrees low still finds the Qibla', (tester) async {
    // Declination is +10: true heading = magnetic + 10. A phone reading (bearing - 10) magnetic
    // really faces the Qibla.
    final s = await pump(tester, declination: 10);
    await feed(tester, s, bearing - 10);
    expect(textOf(tester, 'qibla-guidance'), 'You are facing the Qibla');
    expect(angleOf(tester, 'qibla-needle').abs(), lessThan(0.5));
  });

  testWidgets('with a negative declination the correction goes the other way', (tester) async {
    final s = await pump(tester, declination: -12);
    await feed(tester, s, bearing + 12);
    expect(textOf(tester, 'qibla-guidance'), 'You are facing the Qibla');
  });

  testWidgets('without the fix a 10 degree declination would not read as facing', (tester) async {
    final s = await pump(tester, declination: 10);
    await feed(tester, s, bearing);
    expect(textOf(tester, 'qibla-guidance'), isNot('You are facing the Qibla'));
  });

  testWidgets('shows the heading the phone is pointing at', (tester) async {
    final s = await pump(tester);
    await feed(tester, s, 123.4);
    expect(textOf(tester, 'qibla-heading'), 'Phone points 123°');
    await feed(tester, s, 359.7);
    expect(textOf(tester, 'qibla-heading'), 'Phone points 0°');
  });

  testWidgets('a low-accuracy reading asks the user to calibrate; a good one does not', (tester) async {
    final s = await pump(tester);
    await feed(tester, s, 100, accuracy: 15);
    expect(find.byKey(const ValueKey('qibla-calibrate')), findsNothing);
    await feed(tester, s, 100, accuracy: 45);
    expect(find.byKey(const ValueKey('qibla-calibrate')), findsOneWidget);
    await feed(tester, s, 100, accuracy: 30);
    expect(find.byKey(const ValueKey('qibla-calibrate')), findsNothing);
  });

  testWidgets('Urdu labels render without errors', (tester) async {
    final source = FakeCompassSource();
    await Harness.pump(
      tester,
      home: const QiblaScreen(),
      now: now,
      settings: settings.copyWith(localeTag: 'ur'),
      overrides: [compassSourceProvider.overrideWithValue(source)],
    );
    await Harness.settle(tester);
    await feed(tester, source, 0);
    expect(textOf(tester, 'qibla-guidance'), contains('بائیں'));
  });
}
