import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:saathi/core/notifications/notification_scheduler.dart';
import 'package:saathi/features/prayer/domain/entities/jamaat.dart';
import 'package:saathi/features/prayer/domain/entities/native_state.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_name.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_settings.dart';
import 'package:saathi/features/prayer/domain/usecases/schedule_upcoming_azans.dart';
import 'package:saathi/features/prayer/domain/usecases/sync_native_state.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import '../../../../support/fakes.dart';

class MockScheduler extends Mock implements NotificationScheduler {}

void main() {
  setUpAll(() {
    tzdata.initializeTimeZones();
    registerFallbackValue(<dynamic>[]);
  });

  // Thursday 2026-10-15 12:00 in Karachi (UTC+5).
  final now = DateTime.utc(2026, 10, 15, 7);
  final base = PrayerSettings.defaults();
  late FakePrayerRepository prayers;
  late RecordingBridge bridge;

  setUp(() {
    prayers = FakePrayerRepository();
    bridge = RecordingBridge();
  });

  Future<void> run(PrayerSettings s, {DateTime? at}) =>
      SyncNativeState(FakeSettingsRepository(s), prayers, bridge, () => at ?? now)();

  // Jama'at 20 minutes after every azan, silent for 15 minutes.
  PrayerSettings silent({bool on = true, int minutes = 15}) => base.copyWith(
        jamaat: JamaatSettings(
          offsetMin: {for (final p in PrayerName.obligatory) p: 20},
          silentDuringJamaat: on,
          silentMinutes: minutes,
        ),
      );

  group('silent windows', () {
    test('nothing is planned when the option is off', () async {
      await run(silent(on: false));
      expect(bridge.windows, isEmpty);
    });

    test('nothing is planned when no jama\'at time is set', () async {
      await run(base.copyWith(jamaat: const JamaatSettings(silentDuringJamaat: true)));
      expect(bridge.windows, isEmpty);
    });

    test('each window starts at jama\'at and lasts the chosen minutes', () async {
      await run(silent(minutes: 20));
      final windows = bridge.windows!;
      expect(windows, isNotEmpty);
      for (final w in windows) {
        expect(w.end.difference(w.start), const Duration(minutes: 20));
      }
      // Sorted, none already over, and about four days of five prayers at most.
      expect(windows.every((w) => w.end.isAfter(now)), isTrue);
      for (var i = 1; i < windows.length; i++) {
        expect(windows[i].start.isAfter(windows[i - 1].end), isTrue);
      }
      expect(windows.length, lessThanOrEqualTo(kMaxSilentWindows));
    });

    test('a window already over is dropped', () async {
      await run(silent(), at: now);
      final first = bridge.windows!.first;
      // Move to the end of that window: it must be gone.
      await run(silent(), at: first.end);
      expect(bridge.windows!.first.start.isAfter(first.start), isTrue);
    });

    test('windows that touch are merged into one', () {
      final day = prayers.timesFor(DateTime(2026, 10, 15), base);
      // Two prayers 30 min apart with 60 min windows must merge.
      final t = day.times[PrayerName.dhuhr]!;
      final merged = silentWindows(
        days: [day],
        jamaat: JamaatSettings(
          fixedMin: const {PrayerName.dhuhr: 13 * 60, PrayerName.asr: 13 * 60 + 30},
          silentDuringJamaat: true,
          silentMinutes: 60,
        ),
        timezoneId: base.timezoneId,
        now: t.subtract(const Duration(days: 1)),
      );
      expect(merged, hasLength(1));
      expect(merged.single.end.difference(merged.single.start), const Duration(minutes: 90));
    });
  });

  group('widget', () {
    test('lists the next prayers in order with display times', () async {
      await run(base);
      final snapshot = bridge.widget!;
      expect(snapshot.entries, isNotEmpty);
      expect(snapshot.entries.length, lessThanOrEqualTo(10));
      expect(snapshot.entries.every((e) => e.at.isAfter(now)), isTrue);
      for (var i = 1; i < snapshot.entries.length; i++) {
        expect(snapshot.entries[i].at.isAfter(snapshot.entries[i - 1].at), isTrue);
      }
      expect(snapshot.entries.first.timeText, matches(RegExp(r'^\d{1,2}:\d{2} (AM|PM)$')));
      expect(snapshot.nextLabel, 'Next prayer');
      expect(snapshot.city, base.cityName);
    });

    test('shows the prayer names in the chosen language', () async {
      await run(base.copyWith(localeTag: 'ur'));
      expect(bridge.widget!.nextLabel, 'اگلی نماز');
      expect(bridge.widget!.entries.first.label, isNot(matches(RegExp('[A-Za-z]'))));
    });

    test('Friday shows Jumma instead of Dhuhr', () async {
      // Thursday 23:00 Karachi: the next Dhuhr is Friday.
      await run(base, at: DateTime.utc(2026, 10, 15, 18));
      expect(bridge.widget!.entries.map((e) => e.label), contains('Jumma'));
    });
  });

  test('a failing bridge never throws', () async {
    bridge.failing = true;
    await run(silent());
  });

  test('scheduling the azans also refreshes the phone-side features', () async {
    final scheduler = MockScheduler();
    when(() => scheduler.cancelAll()).thenAnswer((_) async {});
    when(() => scheduler.canScheduleExact()).thenAnswer((_) async => true);
    when(() => scheduler.scheduleAll(any())).thenAnswer((_) async {});
    final settings = FakeSettingsRepository(silent());
    final useCase = ScheduleUpcomingAzans(
      settings,
      prayers,
      scheduler,
      () => now,
      nativeSync: SyncNativeState(settings, prayers, bridge, () => now),
    );
    await useCase();
    expect(bridge.windows, isNotEmpty);
    expect(bridge.widget, isNotNull);
  });
}
