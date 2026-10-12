import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/notifications/local_notification_scheduler.dart';
import '../core/utils/clock.dart';
import '../core/utils/logger.dart';
import '../core/utils/result.dart';
import '../core/utils/timezone_setup.dart';
import '../features/prayer/data/datasources/adhan_calculator.dart';
import '../features/prayer/data/datasources/settings_local_data_source.dart';
import '../features/prayer/data/repositories/settings_repository_impl.dart';
import '../features/prayer/domain/usecases/schedule_upcoming_azans.dart';

/// Re-schedules the azans with no UI and no Riverpod. Used by the background
/// (WorkManager) isolate, which shares no state with the app.
///
/// Returns the scheduling result so callers can log it.
Future<Result<ScheduleReport>> runHeadlessReschedule() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLogging();
  await initializeTimezones();

  final plugin = FlutterLocalNotificationsPlugin();
  await LocalNotificationScheduler.initialize(plugin);

  final prefs = await SharedPreferences.getInstance();
  // Another isolate (the UI) may have written settings since this one cached them.
  await prefs.reload();
  final useCase = ScheduleUpcomingAzans(
    SettingsRepositoryImpl(SettingsLocalDataSource(prefs)),
    const AdhanCalculator(),
    LocalNotificationScheduler(plugin),
    systemClock,
  );
  final result = await useCase();
  appLog.info(result.when(
    success: (r) => 'Background reschedule: ${r.scheduledCount} notifications over ${r.days} days',
    failure: (f) => 'Background reschedule failed: ${f.message}',
  ));
  return result;
}
