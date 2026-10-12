import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:saathi/app/providers.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_name.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_settings.dart';
import 'package:saathi/features/prayer/presentation/l10n_helpers.dart';
import 'package:saathi/features/prayer/presentation/screens/home_screen.dart';
import 'package:saathi/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import '../../../support/fakes.dart';

void main() {
  setUpAll(() async {
    tzdata.initializeTimeZones();
    await initializeDateFormatting();
  });

  // 2026-10-12 is a Monday and 2026-10-16 is a Friday. Karachi is UTC+5.
  final mondayAfternoon = DateTime.utc(2026, 10, 12, 10); // 15:00 PKT
  final fridayNoon = DateTime.utc(2026, 10, 16, 7); // 12:00 PKT

  late FakeSettingsRepository settingsRepo;
  late FakePrayerRepository prayerRepo;
  late RecordingScheduler scheduler;

  Future<void> pumpHome(
    WidgetTester tester, {
    required DateTime now,
    String localeTag = 'en',
  }) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    settingsRepo = FakeSettingsRepository(PrayerSettings.defaults().copyWith(localeTag: localeTag));
    prayerRepo = FakePrayerRepository();
    scheduler = RecordingScheduler();

    await tester.binding.setSurfaceSize(const Size(420, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          clockProvider.overrideWithValue(() => now),
          settingsRepositoryProvider.overrideWithValue(settingsRepo),
          prayerRepositoryProvider.overrideWithValue(prayerRepo),
          notificationSchedulerProvider.overrideWithValue(scheduler),
        ],
        child: Consumer(
          builder: (context, ref, _) => MaterialApp(
            locale: localeFromTag(localeTag),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const HomeScreen(),
          ),
        ),
      ),
    );
    // Let the async settings load and the streams deliver.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  /// Disposes the tree so the one-second ticker is cancelled.
  Future<void> dispose(WidgetTester tester) => tester.pumpWidget(const SizedBox());

  testWidgets('renders the five prayer rows with times', (tester) async {
    await pumpHome(tester, now: mondayAfternoon);

    for (final prayer in PrayerName.obligatory) {
      expect(find.byKey(ValueKey('prayer-row-${prayer.name}')), findsOneWidget, reason: prayer.name);
      expect(find.byKey(ValueKey('prayer-time-${prayer.name}')), findsOneWidget);
    }
    expect(find.byKey(const ValueKey('prayer-row-sunrise')), findsNothing);
    expect(find.text('Karachi'), findsOneWidget);
    // Karachi, 2026-10-12: Fajr 5:13 AM, Maghrib 6:08 PM.
    expect(tester.widget<Text>(find.byKey(const ValueKey('prayer-time-fajr'))).data, '5:13 AM');
    expect(tester.widget<Text>(find.byKey(const ValueKey('prayer-time-maghrib'))).data, '6:08 PM');
    expect(find.byKey(const ValueKey('hijri-date')), findsOneWidget);
    expect(find.byKey(const ValueKey('sunrise-text')), findsOneWidget);
    await dispose(tester);
  });

  testWidgets('shows the countdown to the next prayer', (tester) async {
    await pumpHome(tester, now: mondayAfternoon);

    // 15:00 PKT -> Asr at 16:30 PKT is 1 h 30 min away.
    expect(find.text('Next: Asr in 1 h 30 min'), findsOneWidget);
    expect(tester.widget<Text>(find.byKey(const ValueKey('next-prayer-clock'))).data, '01:30:00');
    await dispose(tester);
  });

  testWidgets('countdown ticks every second', (tester) async {
    var now = mondayAfternoon;
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.binding.setSurfaceSize(const Size(420, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          clockProvider.overrideWithValue(() => now),
          settingsRepositoryProvider.overrideWithValue(FakeSettingsRepository()),
          prayerRepositoryProvider.overrideWithValue(FakePrayerRepository()),
          notificationSchedulerProvider.overrideWithValue(RecordingScheduler()),
        ],
        child: const MaterialApp(
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          home: HomeScreen(),
        ),
      ),
    );
    await tester.pump();
    expect(tester.widget<Text>(find.byKey(const ValueKey('next-prayer-clock'))).data, '01:30:00');

    now = now.add(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(tester.widget<Text>(find.byKey(const ValueKey('next-prayer-clock'))).data, '01:29:59');
    await dispose(tester);
  });

  testWidgets('Friday shows Jumma instead of Dhuhr', (tester) async {
    await pumpHome(tester, now: fridayNoon);

    final dhuhrRow = find.byKey(const ValueKey('prayer-row-dhuhr'));
    expect(find.descendant(of: dhuhrRow, matching: find.text('Jumma')), findsOneWidget);
    expect(find.descendant(of: dhuhrRow, matching: find.text('Dhuhr')), findsNothing);
    // 12:00 PKT on a Friday: the next prayer is Jumma.
    expect(find.textContaining('Next: Jumma in'), findsOneWidget);
    await dispose(tester);
  });

  testWidgets('a normal day shows Dhuhr, not Jumma', (tester) async {
    await pumpHome(tester, now: mondayAfternoon);

    final dhuhrRow = find.byKey(const ValueKey('prayer-row-dhuhr'));
    expect(find.descendant(of: dhuhrRow, matching: find.text('Dhuhr')), findsOneWidget);
    expect(find.text('Jumma'), findsNothing);
    await dispose(tester);
  });

  testWidgets('Roman Urdu strings are used for the en_PK locale', (tester) async {
    await pumpHome(tester, now: mondayAfternoon, localeTag: 'en_PK');

    expect(find.text('Namaz ka waqt'), findsOneWidget);
    expect(find.textContaining('Agli namaz: Asr'), findsOneWidget);
    await dispose(tester);
  });

  testWidgets('Urdu is laid out right-to-left with Urdu prayer names', (tester) async {
    await pumpHome(tester, now: mondayAfternoon, localeTag: 'ur');

    expect(find.descendant(of: find.byKey(const ValueKey('prayer-row-fajr')), matching: find.text('فجر')),
        findsOneWidget);
    final direction = Directionality.of(tester.element(find.byKey(const ValueKey('prayer-row-fajr'))));
    expect(direction, TextDirection.rtl);
    await dispose(tester);
  });

  testWidgets('toggling an azan saves the setting and reschedules', (tester) async {
    await pumpHome(tester, now: mondayAfternoon);

    expect((await settingsRepo.load()).azanFor(PrayerName.asr), isTrue);
    await tester.tap(find.byKey(const ValueKey('azan-toggle-asr')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect((await settingsRepo.load()).azanFor(PrayerName.asr), isFalse);
    expect(scheduler.cancelAllCalls, greaterThanOrEqualTo(1));
    // No Asr notification should remain scheduled (Asr is index 3).
    expect(scheduler.scheduled.any((a) => a.payload.contains('"asr"')), isFalse);
    expect(scheduler.scheduled.any((a) => a.payload.contains('"maghrib"')), isTrue);
    await dispose(tester);
  });

  testWidgets('ticking a prayer as prayed is stored', (tester) async {
    await pumpHome(tester, now: mondayAfternoon);

    await tester.tap(find.byKey(const ValueKey('prayed-fajr')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(await prayerRepo.donePrayers(DateTime(2026, 10, 12)), {PrayerName.fajr});
    expect(tester.widget<Checkbox>(find.byKey(const ValueKey('prayed-fajr'))).value, isTrue);
    await dispose(tester);
  });

  testWidgets('the tasbeeh counter counts and resets', (tester) async {
    await pumpHome(tester, now: mondayAfternoon);

    await tester.tap(find.byKey(const ValueKey('tasbeeh-fab')));
    await tester.pumpAndSettle();
    expect(tester.widget<Text>(find.byKey(const ValueKey('tasbeeh-count'))).data, '0');

    await tester.tap(find.byKey(const ValueKey('tasbeeh-tap')));
    await tester.tap(find.byKey(const ValueKey('tasbeeh-tap')));
    await tester.pump();
    expect(tester.widget<Text>(find.byKey(const ValueKey('tasbeeh-count'))).data, '2');

    await tester.tap(find.text('Reset'));
    await tester.pump();
    expect(tester.widget<Text>(find.byKey(const ValueKey('tasbeeh-count'))).data, '0');
    await dispose(tester);
  });
}
