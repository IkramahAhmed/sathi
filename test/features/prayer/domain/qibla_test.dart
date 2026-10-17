import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/features/prayer/data/datasources/adhan_calculator.dart';
import 'package:saathi/features/prayer/domain/entities/qibla.dart';

void main() {
  // Directions published by Qibla finders for these cities, in degrees from true north.
  const published = <String, (double, double, double)>{
    'Karachi': (24.8607, 67.0011, 267.9),
    'Lahore': (31.5497, 74.3436, 260.4),
    'London': (51.5074, -0.1278, 118.9),
    'New York': (40.7128, -74.0060, 58.5),
    'Jakarta': (-6.2088, 106.8456, 295.1),
    'Sydney': (-33.8688, 151.2093, 277.5),
    'Tokyo': (35.6762, 139.6503, 293.0),
    'Cairo': (30.0444, 31.2357, 136.2),
    'Istanbul': (41.0082, 28.9784, 151.6),
    'Toronto': (43.6532, -79.3832, 55.2),
    'Dhaka': (23.8103, 90.4125, 277.2),
  };

  group('qibla bearing', () {
    published.forEach((city, v) {
      test('$city matches the published direction within 0.7 degrees', () {
        expect(qiblaBearingDegrees(v.$1, v.$2), closeTo(v.$3, 0.7));
      });
    });

    test('the app uses the same bearing as an independent calculation, everywhere', () {
      const calculator = AdhanCalculator();
      final random = math.Random(42);
      for (var i = 0; i < 400; i++) {
        final lat = random.nextDouble() * 160 - 80;
        final lng = random.nextDouble() * 360 - 180;
        final app = calculator.qiblaBearing(lat, lng);
        final mine = qiblaBearingDegrees(lat, lng);
        final diff = ((app - mine + 540) % 360) - 180;
        expect(diff.abs(), lessThan(0.05), reason: 'lat $lat lng $lng: app $app, independent $mine');
      }
    });

    test('is always in 0 to 360', () {
      for (var lat = -89.0; lat <= 89; lat += 7) {
        for (var lng = -180.0; lng <= 180; lng += 9) {
          final b = qiblaBearingDegrees(lat, lng);
          expect(b, inInclusiveRange(0, 360));
          expect(b, lessThan(360));
        }
      }
    });

    test('on the same meridian the Qibla is due north or due south', () {
      expect(qiblaBearingDegrees(-30, kaabaLng), closeTo(0, 0.01));
      expect(qiblaBearingDegrees(60, kaabaLng), closeTo(180, 0.01));
    });

    test('far west of Makkah the Qibla is east of north, far east it is west', () {
      expect(qiblaBearingDegrees(21.4225, -60), inInclusiveRange(45, 135));
      expect(qiblaBearingDegrees(21.4225, 120), inInclusiveRange(225, 315));
    });

    test('the pole does not break it', () {
      expect(qiblaBearingDegrees(89.999, 0).isFinite, isTrue);
      expect(qiblaBearingDegrees(-89.999, 0).isFinite, isTrue);
    });
  });

  group('distance', () {
    test('rough distances to the Kaaba', () {
      expect(distanceToKaabaKm(24.8607, 67.0011), inInclusiveRange(2800, 3000));
      expect(distanceToKaabaKm(51.5074, -0.1278), inInclusiveRange(4700, 4900));
      expect(distanceToKaabaKm(-6.2088, 106.8456), inInclusiveRange(7800, 8100));
    });

    test('is zero at the Kaaba', () {
      expect(distanceToKaabaKm(kaabaLat, kaabaLng), closeTo(0, 0.001));
    });
  });

  group('heading maths', () {
    test('normalizeDegrees wraps both ways', () {
      expect(normalizeDegrees(370), 10);
      expect(normalizeDegrees(-10), 350);
      expect(normalizeDegrees(720), 0);
      expect(normalizeDegrees(0), 0);
    });

    test('true heading adds the declination (east positive) and wraps', () {
      expect(trueHeading(100, 2), 102);
      expect(trueHeading(100, -14), 86);
      expect(trueHeading(359, 3), 2);
      expect(trueHeading(1, -3), 358);
    });

    test('turning left or right takes the short way', () {
      expect(turnToQibla(heading: 0, bearing: 90), 90);
      expect(turnToQibla(heading: 90, bearing: 0), -90);
      expect(turnToQibla(heading: 350, bearing: 10), 20);
      expect(turnToQibla(heading: 10, bearing: 350), -20);
      expect(turnToQibla(heading: 0, bearing: 180).abs(), 180);
      expect(turnToQibla(heading: 268, bearing: 268), 0);
    });

    test('facing means within four degrees either side', () {
      expect(isFacingQibla(0), isTrue);
      expect(isFacingQibla(3.9), isTrue);
      expect(isFacingQibla(-3.9), isTrue);
      expect(isFacingQibla(4.5), isFalse);
      expect(isFacingQibla(-10), isFalse);
    });

    test('ignoring declination would misdirect by exactly that much', () {
      // Toronto: Qibla 55 degrees, declination about -10. A user who faces what the
      // compass calls 55 magnetic is really facing 45 true.
      const bearing = 55.2;
      final magnetic = 55.0;
      final withFix = turnToQibla(heading: trueHeading(magnetic, -10), bearing: bearing);
      final withoutFix = turnToQibla(heading: magnetic, bearing: bearing);
      expect(withoutFix.abs(), lessThan(1));
      expect(withFix, closeTo(10.2, 0.01));
    });
  });
}
