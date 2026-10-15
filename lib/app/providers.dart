import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/location/location_service.dart';
import '../core/notifications/local_notification_scheduler.dart';
import '../core/notifications/notification_scheduler.dart';
import '../core/notifications/permission_service.dart';
import '../core/storage/app_database.dart';
import '../core/sync/cloud_api.dart';
import '../core/sync/sync_config.dart';
import '../core/utils/clock.dart';
import '../features/prayer/data/datasources/adhan_calculator.dart';
import '../features/prayer/data/datasources/settings_local_data_source.dart';
import '../features/prayer/data/repositories/prayer_repository_impl.dart';
import '../features/prayer/data/qaza/qaza_service.dart';
import '../features/prayer/data/reminders/drift_reminder_state.dart';
import '../features/prayer/data/reminders/reminder_mute_store.dart';
import '../features/prayer/data/sync/prayer_sync_service.dart';
import '../features/prayer/domain/repositories/reminder_state.dart';
import '../features/prayer/domain/usecases/handle_reminder_action.dart';
import '../features/prayer/data/repositories/settings_repository_impl.dart';
import '../features/prayer/domain/repositories/prayer_repository.dart';
import '../features/prayer/domain/repositories/settings_repository.dart';
import '../features/prayer/domain/usecases/get_prayer_times_range.dart';
import '../features/prayer/domain/usecases/get_today_prayer_times.dart';
import '../features/prayer/domain/usecases/mark_prayer_done.dart';
import '../features/prayer/domain/usecases/schedule_upcoming_azans.dart';

part 'providers.g.dart';

/// Overridden in `main()` with the loaded instance.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) =>
    throw UnimplementedError('sharedPreferencesProvider must be overridden');

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

/// The current instant (UTC). Override in tests for deterministic time.
@Riverpod(keepAlive: true)
Clock clock(Ref ref) => systemClock;

@Riverpod(keepAlive: true)
AdhanCalculator adhanCalculator(Ref ref) => const AdhanCalculator();

@Riverpod(keepAlive: true)
FlutterLocalNotificationsPlugin notificationsPlugin(Ref ref) => FlutterLocalNotificationsPlugin();

@Riverpod(keepAlive: true)
LocalNotificationScheduler localNotifications(Ref ref) =>
    LocalNotificationScheduler(ref.watch(notificationsPluginProvider));

@Riverpod(keepAlive: true)
NotificationScheduler notificationScheduler(Ref ref) => ref.watch(localNotificationsProvider);

@Riverpod(keepAlive: true)
PermissionService permissionService(Ref ref) => const PermissionHandlerService();

@Riverpod(keepAlive: true)
LocationService locationService(Ref ref) => const GeolocatorLocationService();

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) => SettingsRepositoryImpl(
      SettingsLocalDataSource(ref.watch(sharedPreferencesProvider)),
      history: ref.watch(appDatabaseProvider).settingsHistoryDao,
      clock: ref.watch(clockProvider),
    );

@Riverpod(keepAlive: true)
PrayerRepository prayerRepository(Ref ref) => PrayerRepositoryImpl(
      ref.watch(adhanCalculatorProvider),
      ref.watch(appDatabaseProvider).prayerLogsDao,
    );

@Riverpod(keepAlive: true)
GetTodayPrayerTimes getTodayPrayerTimes(Ref ref) => GetTodayPrayerTimes(
      ref.watch(prayerRepositoryProvider),
      ref.watch(settingsRepositoryProvider),
      ref.watch(clockProvider),
    );

@Riverpod(keepAlive: true)
GetPrayerTimesRange getPrayerTimesRange(Ref ref) => GetPrayerTimesRange(
      ref.watch(prayerRepositoryProvider),
      ref.watch(settingsRepositoryProvider),
      ref.watch(clockProvider),
    );

@Riverpod(keepAlive: true)
MarkPrayerDone markPrayerDone(Ref ref) => MarkPrayerDone(ref.watch(prayerRepositoryProvider));

/// iOS keeps 64 pending notifications; Android has no such small limit.
int get maxPendingNotificationsForPlatform =>
    defaultTargetPlatform == TargetPlatform.android ? 140 : kMaxPendingNotifications;

@Riverpod(keepAlive: true)
ReminderMuteStore reminderMuteStore(Ref ref) =>
    ReminderMuteStore(PrefsKeyValueStore(ref.watch(sharedPreferencesProvider)));

@Riverpod(keepAlive: true)
ReminderState reminderState(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftReminderState(
    logs: db.prayerLogsDao,
    pauses: db.pauseRangesDao,
    mutes: ref.watch(reminderMuteStoreProvider),
  );
}

@Riverpod(keepAlive: true)
ScheduleUpcomingAzans scheduleUpcomingAzans(Ref ref) => ScheduleUpcomingAzans(
      ref.watch(settingsRepositoryProvider),
      ref.watch(prayerRepositoryProvider),
      ref.watch(notificationSchedulerProvider),
      ref.watch(clockProvider),
      reminderState: ref.watch(reminderStateProvider),
      maxPending: maxPendingNotificationsForPlatform,
    );

@Riverpod(keepAlive: true)
QazaService qazaService(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return QazaService(
    qaza: db.qazaDao,
    logs: db.prayerLogsDao,
    pauses: db.pauseRangesDao,
    times: ref.watch(adhanCalculatorProvider),
  );
}

/// Handles taps on "prayer ending" reminders while the app is running.
@Riverpod(keepAlive: true)
HandleReminderAction handleReminderAction(Ref ref) => HandleReminderAction(
      scheduler: ref.watch(notificationSchedulerProvider),
      mute: (date, prayer) =>
          ref.read(reminderMuteStoreProvider).mute(date, prayer, today: ref.read(clockProvider)()),
      markPrayed: (date, prayer) => ref.read(prayerRepositoryProvider).setDone(date, prayer, done: true),
    );

/// Where the sync key is stored (Android Keystore / iOS Keychain).
@Riverpod(keepAlive: true)
SecretStore secretStore(Ref ref) => const SecureSecretStore();

@Riverpod(keepAlive: true)
SyncConfigStore syncConfigStore(Ref ref) => SyncConfigStore(
      PrefsKeyValueStore(ref.watch(sharedPreferencesProvider)),
      ref.watch(secretStoreProvider),
    );

@Riverpod(keepAlive: true)
CloudApi cloudApi(Ref ref) => HttpCloudApi();

@Riverpod(keepAlive: true)
PrayerSyncService prayerSyncService(Ref ref) => PrayerSyncService(
      logs: ref.watch(appDatabaseProvider).prayerLogsDao,
      api: ref.watch(cloudApiProvider),
      config: ref.watch(syncConfigStoreProvider),
      clock: ref.watch(clockProvider),
    );

/// Tracks whether the app is in the foreground so tickers can pause.
@Riverpod(keepAlive: true)
class AppLifecycle extends _$AppLifecycle {
  @override
  AppLifecycleState build() => AppLifecycleState.resumed;

  // ignore: use_setters_to_change_properties
  void update(AppLifecycleState next) => state = next;
}
