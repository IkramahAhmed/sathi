import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

/// Reads the phone settings that decide whether the azan is really heard.
abstract interface class SetupProbe {
  /// Whether the system lets this app run in the background without limits.
  /// Null when it cannot be known (iOS).
  Future<bool?> batteryUnrestricted();

  /// Whether the notification channel [channelId] can still make a sound.
  /// Null when it cannot be known (iOS, or the channel does not exist yet).
  Future<bool?> channelAudible(String channelId);
}

class PlatformSetupProbe implements SetupProbe {
  const PlatformSetupProbe(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;

  @override
  Future<bool?> batteryUnrestricted() async {
    if (!_isAndroid) return null;
    try {
      return await Permission.ignoreBatteryOptimizations.isGranted;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool?> channelAudible(String channelId) async {
    if (!_isAndroid) return null;
    try {
      final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      final channels = await android?.getNotificationChannels();
      final channel = channels?.where((c) => c.id == channelId).firstOrNull;
      if (channel == null) return null;
      // The system reports the importance the user set, so a channel switched
      // to "silent" or "off" shows up here.
      return channel.importance.value >= Importance.defaultImportance.value && channel.playSound;
    } catch (_) {
      return null;
    }
  }
}
