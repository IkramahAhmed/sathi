import 'dart:math' as math;

/// The Kaaba, in degrees.
const double kaabaLat = 21.4225241;
const double kaabaLng = 39.8261818;

/// [degrees] wrapped into 0 to 360, excluding 360.
double normalizeDegrees(double degrees) => ((degrees % 360) + 360) % 360;

/// Initial great-circle bearing from a place to the Kaaba, in degrees clockwise
/// from true north.
double qiblaBearingDegrees(double lat, double lng) {
  final p1 = lat * math.pi / 180;
  final p2 = kaabaLat * math.pi / 180;
  final dl = (kaabaLng - lng) * math.pi / 180;
  final y = math.sin(dl) * math.cos(p2);
  final x = math.cos(p1) * math.sin(p2) - math.sin(p1) * math.cos(p2) * math.cos(dl);
  return normalizeDegrees(math.atan2(y, x) * 180 / math.pi);
}

/// Distance to the Kaaba in kilometres.
double distanceToKaabaKm(double lat, double lng) {
  const earth = 6371.0088;
  final p1 = lat * math.pi / 180;
  final p2 = kaabaLat * math.pi / 180;
  final dp = p2 - p1;
  final dl = (kaabaLng - lng) * math.pi / 180;
  final a = math.pow(math.sin(dp / 2), 2) + math.cos(p1) * math.cos(p2) * math.pow(math.sin(dl / 2), 2);
  return 2 * earth * math.asin(math.sqrt(a));
}

/// Turns a compass reading into a true-north heading.
///
/// A phone compass points to magnetic north, but the Qibla bearing is measured from
/// true north. They differ by the magnetic [declination] (east is positive), which
/// is about 2 degrees in Karachi but 15 or more in parts of North America.
double trueHeading(double magneticHeading, double declination) =>
    normalizeDegrees(magneticHeading + declination);

/// How far to turn to face the Qibla: positive is to the right (clockwise),
/// negative to the left, always between -180 and 180.
double turnToQibla({required double heading, required double bearing}) {
  final delta = normalizeDegrees(bearing - heading);
  return delta > 180 ? delta - 360 : delta;
}

/// Whether [turn] is close enough to zero to count as facing the Qibla.
bool isFacingQibla(double turn, {double tolerance = 4}) => turn.abs() <= tolerance;
