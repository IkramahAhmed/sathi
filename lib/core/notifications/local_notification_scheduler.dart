import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../utils/logger.dart';
import 'notification_channels.dart';
import 'notification_scheduler.dart';
import 'notification_tap_bus.dart';

/// [NotificationScheduler] backed by `flutter_local_notifications`.
class LocalNotificationScheduler implements NotificationScheduler {
  LocalNotificationScheduler(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  /// Initialises the plugin and creates the Android channels. Safe to call
  /// from both the UI isolate and the background isolate.
  static Future<void> initialize(
    FlutterLocalNotificationsPlugin plugin, {
    bool requestIosPermissionsOnInit = false,
  }) async {
    await plugin.initialize(
      settings: InitializationSettings(
        android: const AndroidInitializationSettings(NotificationChannels.drawableIcon),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: requestIosPermissionsOnInit,
          requestBadgePermission: false,
          requestSoundPermission: requestIosPermissionsOnInit,
        ),
      ),
      onDidReceiveNotificationResponse: (response) => notificationTapBus.add(response.payload),
    );

    final android = plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      for (final channel in NotificationChannels.all()) {
        await android.createNotificationChannel(channel);
      }
    }
  }

  AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  @override
  Future<void> cancelAll() => _plugin.cancelAll();

  @override
  Future<bool> canScheduleExact() async {
    if (defaultTargetPlatform != TargetPlatform.android) return true;
    return await _android?.canScheduleExactNotifications() ?? true;
  }

  @override
  Future<int> pendingCount() async => (await _plugin.pendingNotificationRequests()).length;

  @override
  Future<void> scheduleAll(List<ScheduledAlarm> alarms) async {
    var exact = await canScheduleExact();
    for (final alarm in alarms) {
      final when = tz.TZDateTime.from(alarm.at.toUtc(), tz.getLocation(alarm.timezoneId));
      try {
        await _zoned(alarm, when, exact: exact);
      } on PlatformException catch (error) {
        if (error.code != 'exact_alarms_not_permitted') rethrow;
        // Permission was revoked between the check and now: degrade gracefully.
        appLog.warning('Exact alarms not permitted; falling back to inexact');
        exact = false;
        await _zoned(alarm, when, exact: false);
      }
    }
  }

  Future<void> _zoned(ScheduledAlarm alarm, tz.TZDateTime when, {required bool exact}) =>
      _plugin.zonedSchedule(
        id: alarm.id,
        scheduledDate: when,
        notificationDetails: NotificationChannels.detailsFor(alarm.channelId),
        androidScheduleMode: exact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        title: alarm.title,
        body: alarm.body,
        payload: alarm.payload,
      );

  /// Shows a notification straight away. Used for "Test notification" and
  /// for previewing a sound.
  Future<void> showNow({
    required int id,
    required String title,
    required String body,
    required String channelId,
    String? payload,
  }) =>
      _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: NotificationChannels.detailsFor(channelId),
        payload: payload,
      );

  /// Shows a test notification [delay] from now (the "test in 10 s" button).
  ///
  /// With exact alarms allowed this goes through the real alarm pipeline. Without
  /// them an inexact alarm could fire minutes late, so the app falls back to an
  /// in-app timer, which still proves the channel, sound and permission work.
  Future<void> scheduleTest({
    required int id,
    required String title,
    required String body,
    required String channelId,
    Duration delay = const Duration(seconds: 10),
  }) async {
    if (!await canScheduleExact()) {
      Timer(delay, () {
        showNow(id: id, title: title, body: body, channelId: channelId, payload: '{"test":true}')
            .catchError((Object error, StackTrace stackTrace) {
          appLog.warning('Test notification failed', error, stackTrace);
        });
      });
      return;
    }
    await _plugin.zonedSchedule(
      id: id,
      scheduledDate: tz.TZDateTime.now(tz.local).add(delay),
      notificationDetails: NotificationChannels.detailsFor(channelId),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      title: title,
      body: body,
      payload: '{"test":true}',
    );
  }
}
