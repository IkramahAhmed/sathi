import 'package:flutter_compass_v2/flutter_compass_v2.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';

/// One compass reading.
class CompassReading {
  const CompassReading({required this.magneticHeading, this.accuracy});

  /// Degrees clockwise from magnetic north, 0 to 360.
  final double magneticHeading;

  /// Plus or minus degrees, when the platform reports it. Null if unknown.
  final double? accuracy;
}

/// Where compass readings come from. Replaced in tests.
abstract interface class CompassSource {
  /// Whether this phone has a usable compass.
  Future<bool> available();

  Stream<CompassReading> readings();
}

class PlatformCompassSource implements CompassSource {
  const PlatformCompassSource();

  @override
  Future<bool> available() async {
    try {
      if (FlutterCompass.events == null) return false;
      return await FlutterQiblah.androidDeviceSensorSupport() ?? true;
    } catch (_) {
      return false;
    }
  }

  @override
  Stream<CompassReading> readings() => FlutterCompass.events!
      .where((e) => e.heading != null)
      .map((e) => CompassReading(magneticHeading: (e.heading! + 360) % 360, accuracy: e.accuracy));
}
