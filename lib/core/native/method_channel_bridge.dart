import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../features/prayer/domain/entities/native_state.dart';
import '../../features/prayer/domain/repositories/native_bridge.dart';
import '../utils/logger.dart';

/// Talks to the `saathi_native` Android plugin. Does nothing on other platforms.
class MethodChannelNativeBridge implements NativeBridge {
  const MethodChannelNativeBridge();

  static const MethodChannel _channel = MethodChannel('com.ikramah.saathi/native');

  bool get _supported => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Future<T?> _call<T>(String method, [Object? arguments]) async {
    if (!_supported) return null;
    try {
      return await _channel.invokeMethod<T>(method, arguments);
    } on MissingPluginException {
      // Another engine (a test, or a build without the plugin).
      return null;
    } on PlatformException catch (error) {
      appLog.warning('Native call $method failed: ${error.message}');
      return null;
    }
  }

  @override
  Future<bool> silentAccessGranted() async => await _call<bool>('silentAccess') ?? false;

  @override
  Future<void> openSilentAccessSettings() => _call<void>('openSilentAccessSettings');

  @override
  Future<void> setSilentWindows(List<SilentWindow> windows) => _call<void>('setSilentWindows', {
        'windows': [
          for (final w in windows) {'start': w.start.millisecondsSinceEpoch, 'end': w.end.millisecondsSinceEpoch},
        ],
      });

  @override
  Future<void> setWidgetData(WidgetSnapshot snapshot) => _call<void>('setWidgetData', {
        'city': snapshot.city,
        'nextLabel': snapshot.nextLabel,
        'entries': [
          for (final e in snapshot.entries)
            {'label': e.label, 'at': e.at.millisecondsSinceEpoch, 'timeText': e.timeText},
        ],
      });

  @override
  Future<double?> magneticDeclination(double lat, double lng) async {
    final value = await _call<double>('declination', {'lat': lat, 'lng': lng});
    return value;
  }
}
