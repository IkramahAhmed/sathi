import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:saathi/app/providers.dart';
import 'package:saathi/core/storage/app_database.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_settings.dart';
import 'package:saathi/features/prayer/domain/repositories/native_bridge.dart';
import 'package:saathi/features/prayer/presentation/l10n_helpers.dart';
import 'package:saathi/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import 'fakes.dart';

/// A lifecycle that is never "resumed", so the one-second clock timer does not
/// start and tests do not end with a pending timer.
class _PausedLifecycle extends AppLifecycle {
  @override
  AppLifecycleState build() => AppLifecycleState.paused;
}

/// Everything a screen test needs: a real in-memory database, a controllable
/// clock and fakes for the platform pieces.
class Harness {
  Harness._(this.db, this.settingsRepo, this.scheduler, this.container, this.router);

  final AppDatabase db;
  final FakeSettingsRepository settingsRepo;
  final RecordingScheduler scheduler;
  final ProviderContainer container;
  final GoRouter router;

  static Future<void> setUpAll() async {
    tzdata.initializeTimeZones();
    await initializeDateFormatting();
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  }

  /// Pumps [home] at route '/', with extra stub routes for navigation checks.
  static Future<Harness> pump(
    WidgetTester tester, {
    required Widget home,
    required DateTime now,
    PrayerSettings? settings,
    List<GoRoute> extraRoutes = const [],
    Size size = const Size(420, 1800),
    List<Override> overrides = const [],
    NativeBridge? bridge,
  }) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = FakeSettingsRepository(settings ?? PrayerSettings.defaults());
    final scheduler = RecordingScheduler();
    final router = GoRouter(routes: [
      GoRoute(path: '/', builder: (_, _) => home),
      ...extraRoutes,
    ]);
    final container = ProviderContainer(overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      secretStoreProvider.overrideWithValue(FakeSecretStore()),
      appDatabaseProvider.overrideWithValue(db),
      clockProvider.overrideWithValue(() => now),
      settingsRepositoryProvider.overrideWithValue(repo),
      notificationSchedulerProvider.overrideWithValue(scheduler),
      appLifecycleProvider.overrideWith(_PausedLifecycle.new),
      // Unless a test brings its own, the phone-side features do nothing.
      nativeBridgeProvider.overrideWithValue(bridge ?? const NoNativeBridge()),
      ...overrides,
    ]);
    addTearDown(container.dispose);

    // Size the view itself (not just the surface) so MediaQuery, and therefore
    // dialogs like the time picker, see a portrait phone.
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          locale: localeFromTag((settings ?? PrayerSettings.defaults()).localeTag),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    return Harness._(db, repo, scheduler, container, router);
  }

  /// Lets streams and async work settle.
  static Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
  }
}
