import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/app/providers.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_name.dart';
import 'package:saathi/features/prayer/domain/repositories/photo_verifier.dart';
import 'package:saathi/features/prayer/domain/usecases/schedule_upcoming_azans.dart';
import 'package:saathi/features/prayer/presentation/screens/verify_screen.dart';

import '../../../support/harness.dart';

class _FakeSource implements PhotoSource {
  _FakeSource({this.path = '/tmp/p.jpg', this.fails = false});

  final String? path;
  final bool fails;
  final List<String> discarded = [];
  int taken = 0;

  @override
  Future<String?> takePhoto() async {
    taken++;
    if (fails) throw StateError('no camera');
    return path;
  }

  @override
  Future<void> discard(String path) async => discarded.add(path);
}

class _FakeVerifier implements PhotoVerifier {
  _FakeVerifier(this.verdict);

  PhotoVerdict verdict;
  int checks = 0;

  @override
  Future<PhotoVerdict> check(String path) async {
    checks++;
    return verdict;
  }
}

void main() {
  setUpAll(Harness.setUpAll);

  // Thursday 2026-10-15, 12:00 in Karachi.
  final now = DateTime.utc(2026, 10, 15, 7);
  final date = DateTime(2026, 10, 15);

  final accepted = PhotoVerdict(accepted: true, labels: [const PhotoLabel('Mosque', 0.9)]);
  final rejected = PhotoVerdict(accepted: false, labels: [const PhotoLabel('Dog', 0.9)]);

  Future<(Harness, _FakeSource, _FakeVerifier)> pump(
    WidgetTester tester, {
    PhotoVerdict? verdict,
    _FakeSource? source,
  }) async {
    final s = source ?? _FakeSource();
    final v = _FakeVerifier(verdict ?? accepted);
    final h = await Harness.pump(
      tester,
      home: VerifyScreen(prayer: PrayerName.dhuhr, date: date),
      now: now,
      overrides: [photoSourceProvider.overrideWithValue(s), photoVerifierProvider.overrideWithValue(v)],
    );
    return (h, s, v);
  }

  Future<Set<PrayerName>> done(Harness h) => h.container.read(prayerRepositoryProvider).donePrayers(date);

  testWidgets('a good photo ticks the prayer, cancels its reminders and discards the picture', (tester) async {
    final (h, source, _) = await pump(tester);
    await tester.tap(find.byKey(const ValueKey('verify-take')));
    await Harness.settle(tester);

    expect(find.byKey(const ValueKey('verify-success')), findsOneWidget);
    expect(await done(h), contains(PrayerName.dhuhr));
    expect(h.scheduler.cancelled, containsAll(endReminderIds(date, PrayerName.dhuhr)));
    expect(source.discarded, ['/tmp/p.jpg']);
    expect(find.byKey(const ValueKey('verify-take')), findsNothing);
  });

  testWidgets('a wrong photo is rejected, shows what was seen and ticks nothing', (tester) async {
    final (h, source, _) = await pump(tester, verdict: rejected);
    await tester.tap(find.byKey(const ValueKey('verify-take')));
    await Harness.settle(tester);

    expect(find.byKey(const ValueKey('verify-fail')), findsOneWidget);
    expect(find.textContaining('Dog'), findsOneWidget);
    expect(await done(h), isEmpty);
    expect(source.discarded, ['/tmp/p.jpg']);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('trying again after a rejection can succeed', (tester) async {
    final (h, _, verifier) = await pump(tester, verdict: rejected);
    await tester.tap(find.byKey(const ValueKey('verify-take')));
    await Harness.settle(tester);
    verifier.verdict = accepted;
    await tester.tap(find.byKey(const ValueKey('verify-take')));
    await Harness.settle(tester);

    expect(find.byKey(const ValueKey('verify-success')), findsOneWidget);
    expect(await done(h), contains(PrayerName.dhuhr));
    expect(verifier.checks, 2);
  });

  testWidgets('backing out of the camera changes nothing', (tester) async {
    final (h, _, verifier) = await pump(tester, source: _FakeSource(path: null));
    await tester.tap(find.byKey(const ValueKey('verify-take')));
    await Harness.settle(tester);

    expect(verifier.checks, 0);
    expect(await done(h), isEmpty);
    expect(find.byKey(const ValueKey('verify-take')), findsOneWidget);
  });

  testWidgets('a camera that cannot open shows a message and allows another try', (tester) async {
    final (_, _, verifier) = await pump(tester, source: _FakeSource(fails: true));
    await tester.tap(find.byKey(const ValueKey('verify-take')));
    await Harness.settle(tester);

    expect(find.byKey(const ValueKey('verify-no-camera')), findsOneWidget);
    expect(verifier.checks, 0);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('stop reminding mutes the prayer and cancels reminders without ticking it', (tester) async {
    final (h, _, _) = await pump(tester);
    await tester.tap(find.byKey(const ValueKey('verify-stop')));
    await Harness.settle(tester);

    expect(h.container.read(reminderMuteStoreProvider).isMuted(date, PrayerName.dhuhr), isTrue);
    expect(h.scheduler.cancelled, containsAll(endReminderIds(date, PrayerName.dhuhr)));
    expect(await done(h), isEmpty);
  });
}
