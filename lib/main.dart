import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/providers.dart';
import 'app/router.dart';
import 'app/saathi_app.dart';
import 'core/background/workmanager_bootstrap.dart';
import 'core/notifications/local_notification_scheduler.dart';
import 'core/utils/logger.dart';
import 'core/utils/timezone_setup.dart';
import 'features/prayer/data/datasources/settings_local_data_source.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLogging();
  await initializeTimezones();
  await initializeDateFormatting();

  final prefs = await SharedPreferences.getInstance();

  // A notification problem must never stop the app from opening: the prayer
  // times and timetable work without it. Log it and carry on.
  String? launchPayload;
  try {
    final plugin = FlutterLocalNotificationsPlugin();
    await LocalNotificationScheduler.initialize(plugin);
    final launch = await plugin.getNotificationAppLaunchDetails();
    launchPayload =
        (launch?.didNotificationLaunchApp ?? false) ? launch?.notificationResponse?.payload : null;
  } catch (error, stackTrace) {
    appLog.severe('Notifications could not be initialised', error, stackTrace);
  }

  final onboardingDone = SettingsLocalDataSource(prefs).onboardingDone();
  await WorkmanagerBootstrap.init();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        initialRouteProvider.overrideWithValue(onboardingDone ? Routes.home : Routes.onboarding),
      ],
      child: SaathiApp(launchPayload: launchPayload),
    ),
  );
}
