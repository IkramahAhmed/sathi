import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/app/providers.dart';
import 'package:saathi/core/notifications/permission_service.dart';
import 'package:saathi/features/prayer/presentation/screens/setup_check_screen.dart';

import '../../../support/fakes.dart';
import '../../../support/harness.dart';

void main() {
  setUpAll(Harness.setUpAll);

  final now = DateTime.utc(2026, 10, 15, 7);

  Future<(Harness, FakePermissionService, FakeSetupProbe)> pump(
    WidgetTester tester, {
    FakePermissionService? permissions,
    FakeSetupProbe? probe,
  }) async {
    final p = permissions ?? FakePermissionService();
    final s = probe ?? FakeSetupProbe();
    final h = await Harness.pump(
      tester,
      home: const SetupCheckScreen(),
      now: now,
      overrides: [permissionServiceProvider.overrideWithValue(p), setupProbeProvider.overrideWithValue(s)],
    );
    await Harness.settle(tester);
    return (h, p, s);
  }

  Icon icon(WidgetTester tester, String key) =>
      tester.widget<Icon>(find.descendant(of: find.byKey(ValueKey(key)), matching: find.byType(Icon)).first);

  testWidgets('everything fine shows green ticks and no fix buttons', (tester) async {
    await pump(tester);
    for (final k in ['check-notifications', 'check-exact', 'check-battery', 'check-channel']) {
      expect(icon(tester, k).icon, Icons.check_circle, reason: k);
      expect(find.byKey(ValueKey('$k-fix')), findsNothing, reason: k);
    }
  });

  testWidgets('a problem is marked and offers a fix', (tester) async {
    final probe = FakeSetupProbe()..battery = false;
    final (_, permissions, _) = await pump(tester, probe: probe);

    expect(icon(tester, 'check-battery').icon, Icons.cancel);
    await tester.tap(find.byKey(const ValueKey('check-battery-fix')));
    await Harness.settle(tester);
    expect(permissions.settingsOpened, 1);
  });

  testWidgets('exact alarms off is fixed from the screen and turns green', (tester) async {
    final permissions = FakePermissionService()..exact = PermissionOutcome.denied;
    await pump(tester, permissions: permissions);
    expect(icon(tester, 'check-exact').icon, Icons.cancel);

    await tester.tap(find.byKey(const ValueKey('check-exact-fix')));
    await Harness.settle(tester);
    expect(permissions.exactRequests, 1);
    expect(icon(tester, 'check-exact').icon, Icons.check_circle);
  });

  testWidgets('something that cannot be read shows a question mark and no fix', (tester) async {
    final probe = FakeSetupProbe()..battery = null;
    await pump(tester, probe: probe);
    expect(icon(tester, 'check-battery').icon, Icons.help_outline);
    expect(find.byKey(const ValueKey('check-battery-fix')), findsNothing);
  });

  testWidgets('a muted azan channel is reported', (tester) async {
    final probe = FakeSetupProbe()..channel = false;
    await pump(tester, probe: probe);
    expect(icon(tester, 'check-channel').icon, Icons.cancel);
    expect(find.text('The azan sound is muted for this app. Turn it on in the notification settings.'), findsOneWidget);
  });

  testWidgets('re-planning schedules the alerts again', (tester) async {
    final (h, _, _) = await pump(tester);
    await tester.tap(find.byKey(const ValueKey('check-replan')));
    await Harness.settle(tester);
    expect(h.scheduler.scheduled, isNotEmpty);
    expect(find.text('Alerts re-planned'), findsOneWidget);
  });
}
