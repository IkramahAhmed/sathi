import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/headless.dart' show notificationBackgroundHandler;
import 'features/udhaar/background/udhaar_overdue_check.dart';
import 'app/providers.dart';
import 'app/router.dart';
import 'app/saathi_app.dart';
import 'core/background/workmanager_bootstrap.dart';
import 'core/notifications/local_notification_scheduler.dart';
import 'core/notifications/notification_tap_bus.dart';
import 'core/utils/logger.dart';
import 'core/utils/timezone_setup.dart';
import 'features/prayer/data/datasources/settings_local_data_source.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLogging();

  // Run the three blocking inits in parallel — timezone load is the biggest
  // culprit (~1-2 s). SharedPreferences is fast and needed for the route
  // decision, so we await it after kicking off the others.
  final timezoneFuture = initializeTimezones();
  final localeFuture = initializeDateFormatting();
  final prefs = await SharedPreferences.getInstance();
  await timezoneFuture;
  await localeFuture;

  final onboardingDone = SettingsLocalDataSource(prefs).onboardingDone();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        initialRouteProvider.overrideWithValue(onboardingDone ? Routes.home : Routes.onboarding),
      ],
      // launchPayload is delivered via notificationTapBus once the plugin
      // initialises below — avoids blocking runApp on Android system calls.
      child: const SaathiApp(),
    ),
  );

  // Defer Android system calls (WorkManager + notifications) to after the
  // first frame so the UI appears without waiting for them.
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    // A notification problem must never stop the app from opening.
    try {
      final plugin = FlutterLocalNotificationsPlugin();
      await LocalNotificationScheduler.initialize(plugin, onBackgroundResponse: notificationBackgroundHandler);
      final launch = await plugin.getNotificationAppLaunchDetails();
      final payload =
          (launch?.didNotificationLaunchApp ?? false) ? launch?.notificationResponse?.payload : null;
      if (payload != null) notificationTapBus.add(NotificationTap(payload));
    } catch (error, stackTrace) {
      appLog.severe('Notifications could not be initialised', error, stackTrace);
    }

    unawaited(WorkmanagerBootstrap.init());
    // Fire-and-forget: show overdue notification after migration completes.
    Future.delayed(const Duration(seconds: 3), runHeadlessUdhaarCheck);
  });
}
