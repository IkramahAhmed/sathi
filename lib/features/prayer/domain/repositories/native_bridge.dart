import '../entities/native_state.dart';

/// The Android-only features: Do Not Disturb during jama'at and the home-screen
/// widget. Everything is a no-op elsewhere.
abstract interface class NativeBridge {
  /// Whether the app may change Do Not Disturb.
  Future<bool> silentAccessGranted();

  /// Opens the system page where the user grants that access.
  Future<void> openSilentAccessSettings();

  /// Replaces every planned silent window. An empty list clears them and
  /// restores the phone if it is silent right now because of one.
  Future<void> setSilentWindows(List<SilentWindow> windows);

  /// Gives the widget what it needs to draw and count down.
  Future<void> setWidgetData(WidgetSnapshot snapshot);

  /// Magnetic declination at a place in degrees, east positive. Null when unknown.
  Future<double?> magneticDeclination(double lat, double lng);
}

/// Does nothing. The default, and used on iOS and in tests.
class NoNativeBridge implements NativeBridge {
  const NoNativeBridge();

  @override
  Future<bool> silentAccessGranted() async => false;

  @override
  Future<void> openSilentAccessSettings() async {}

  @override
  Future<void> setSilentWindows(List<SilentWindow> windows) async {}

  @override
  Future<void> setWidgetData(WidgetSnapshot snapshot) async {}

  @override
  Future<double?> magneticDeclination(double lat, double lng) async => null;
}
