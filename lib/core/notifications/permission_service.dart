import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// Result of asking for a permission.
enum PermissionOutcome { granted, denied, permanentlyDenied, notNeeded }

/// Notification and exact-alarm permissions.
abstract interface class PermissionService {
  Future<PermissionOutcome> notificationStatus();
  Future<PermissionOutcome> requestNotifications();
  Future<PermissionOutcome> exactAlarmStatus();

  /// On Android 12+ this opens the system "Alarms & reminders" screen.
  Future<PermissionOutcome> requestExactAlarms();

  /// Opens the app's system settings page (battery, notifications...).
  Future<bool> openSettings();
}

class PermissionHandlerService implements PermissionService {
  const PermissionHandlerService();

  PermissionOutcome _map(PermissionStatus s) => switch (s) {
        PermissionStatus.granted || PermissionStatus.limited || PermissionStatus.provisional =>
          PermissionOutcome.granted,
        PermissionStatus.permanentlyDenied => PermissionOutcome.permanentlyDenied,
        _ => PermissionOutcome.denied,
      };

  bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;

  @override
  Future<PermissionOutcome> notificationStatus() async => _map(await Permission.notification.status);

  @override
  Future<PermissionOutcome> requestNotifications() async =>
      _map(await Permission.notification.request());

  @override
  Future<PermissionOutcome> exactAlarmStatus() async {
    if (!_isAndroid) return PermissionOutcome.notNeeded;
    return _map(await Permission.scheduleExactAlarm.status);
  }

  @override
  Future<PermissionOutcome> requestExactAlarms() async {
    if (!_isAndroid) return PermissionOutcome.notNeeded;
    return _map(await Permission.scheduleExactAlarm.request());
  }

  @override
  Future<bool> openSettings() => openAppSettings();
}
