import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/notifications/local_notification_scheduler.dart';
import '../core/storage/app_database.dart';
import '../core/sync/sync_config.dart';
import '../core/utils/clock.dart';
import '../core/utils/logger.dart';
import '../core/utils/result.dart';
import '../core/utils/timezone_setup.dart';
import '../features/prayer/data/datasources/adhan_calculator.dart';
import '../features/prayer/data/datasources/settings_local_data_source.dart';
import '../features/prayer/data/reminders/drift_reminder_state.dart';
import '../features/prayer/data/reminders/reminder_mute_store.dart';
import '../features/prayer/data/repositories/prayer_repository_impl.dart';
import '../features/prayer/data/repositories/settings_repository_impl.dart';
import '../features/prayer/domain/usecases/handle_reminder_action.dart';
import '../features/prayer/domain/usecases/schedule_upcoming_azans.dart';
import 'providers.dart' show maxPendingNotificationsForPlatform;

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
  // The reminders need to know what is already prayed, so open the database.
  final db = AppDatabase();
  try {
    final useCase = ScheduleUpcomingAzans(
      SettingsRepositoryImpl(SettingsLocalDataSource(prefs)),
      const AdhanCalculator(),
      LocalNotificationScheduler(plugin),
      systemClock,
      reminderState: DriftReminderState(
        logs: db.prayerLogsDao,
        pauses: db.pauseRangesDao,
        mutes: ReminderMuteStore(PrefsKeyValueStore(prefs)),
      ),
      maxPending: maxPendingNotificationsForPlatform,
    );
    final result = await useCase();
    appLog.info(result.when(
      success: (r) => 'Background reschedule: ${r.scheduledCount} notifications over ${r.days} days',
      failure: (f) => 'Background reschedule failed: ${f.message}',
    ));
    return result;
  } finally {
    await db.close();
  }
}

/// Runs when the user taps a button on a reminder while the app is closed
/// ("Prayed" or "Stop reminders"). It must be a top-level function.
@pragma('vm:entry-point')
Future<void> notificationBackgroundHandler(NotificationResponse response) async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLogging();
  await initializeTimezones();

  final plugin = FlutterLocalNotificationsPlugin();
  await LocalNotificationScheduler.initialize(plugin);
  final prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  final db = AppDatabase();
  try {
    final mutes = ReminderMuteStore(PrefsKeyValueStore(prefs));
    final repo = PrayerRepositoryImpl(const AdhanCalculator(), db.prayerLogsDao);
    final handler = HandleReminderAction(
      scheduler: LocalNotificationScheduler(plugin),
      mute: (date, prayer) => mutes.mute(date, prayer, today: systemClock()),
      markPrayed: (date, prayer) => repo.setDone(date, prayer, done: true),
    );
    final outcome = await handler(actionId: response.actionId, payload: response.payload);
    appLog.info('Background reminder action ${response.actionId}: $outcome');
  } catch (error, stackTrace) {
    appLog.severe('Background reminder action failed', error, stackTrace);
  } finally {
    await db.close();
  }
}
