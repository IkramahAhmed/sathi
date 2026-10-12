import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../utils/logger.dart';
import '../utils/result.dart';
import 'cities.dart';

/// A resolved device location.
class LocationFix {
  const LocationFix({
    required this.lat,
    required this.lng,
    required this.countryCode,
    required this.cityName,
    required this.timezoneId,
  });

  final double lat;
  final double lng;
  final String countryCode;
  final String cityName;
  final String timezoneId;
}

/// Coarse state of the location permission, independent of the plugin.
enum LocationAccess { granted, denied, deniedForever, serviceOff }

abstract interface class LocationService {
  Future<LocationAccess> access();
  Future<LocationAccess> requestAccess();

  /// Gets a fix and resolves country, city and timezone. Falls back to the
  /// bundled city list when reverse geocoding is unavailable (offline).
  ///
  /// With [interactive] false (background checks) only the last known
  /// position is used, so nothing can ever prompt the user or wake the GPS.
  Future<Result<LocationFix>> currentFix({
    String fallbackCountryCode = 'PK',
    bool interactive = true,
  });

  /// Distance in kilometres between two points.
  double distanceKm(double lat1, double lng1, double lat2, double lng2);
}

class GeolocatorLocationService implements LocationService {
  const GeolocatorLocationService();

  @override
  Future<LocationAccess> access() async {
    if (!await Geolocator.isLocationServiceEnabled()) return LocationAccess.serviceOff;
    return _map(await Geolocator.checkPermission());
  }

  @override
  Future<LocationAccess> requestAccess() async {
    if (!await Geolocator.isLocationServiceEnabled()) return LocationAccess.serviceOff;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return _map(permission);
  }

  LocationAccess _map(LocationPermission p) => switch (p) {
        LocationPermission.always || LocationPermission.whileInUse => LocationAccess.granted,
        LocationPermission.deniedForever => LocationAccess.deniedForever,
        _ => LocationAccess.denied,
      };

  /// Settings that avoid Google Play services' "Location Accuracy" system
  /// dialog. Prayer times only need a city-level fix, so the platform
  /// location manager is enough and never prompts.
  static LocationSettings _settings(LocationAccuracy accuracy, Duration timeLimit) =>
      defaultTargetPlatform == TargetPlatform.android
          ? AndroidSettings(
              accuracy: accuracy,
              forceLocationManager: true,
              timeLimit: timeLimit,
            )
          : LocationSettings(accuracy: accuracy, timeLimit: timeLimit);

  /// Tries a quick coarse (network) fix, then a GPS fix, then the last known
  /// position. Each step is bounded so the UI never waits long.
  Future<Position?> _lookUpPosition() async {
    const attempts = [
      (LocationAccuracy.low, Duration(seconds: 6)),
      (LocationAccuracy.high, Duration(seconds: 25)),
    ];
    for (final (accuracy, limit) in attempts) {
      try {
        return await Geolocator.getCurrentPosition(locationSettings: _settings(accuracy, limit));
      } catch (error) {
        appLog.info('Location fix at $accuracy failed: $error');
      }
    }
    return null;
  }

  @override
  Future<Result<LocationFix>> currentFix({
    String fallbackCountryCode = 'PK',
    bool interactive = true,
  }) =>
      guard(() async {
        final state = await access();
        if (state != LocationAccess.granted) {
          throw StateError('Location is not available ($state)');
        }
        Position? position;
        if (interactive) position = await _lookUpPosition();
        position ??= await Geolocator.getLastKnownPosition(
          forceAndroidLocationManager: defaultTargetPlatform == TargetPlatform.android,
        );
        if (position == null) throw StateError('No location fix');

        final timezoneId = (await FlutterTimezone.getLocalTimezone()).identifier;
        var countryCode = fallbackCountryCode;
        var city = nearestCityName(position.latitude, position.longitude);
        try {
          final marks = await Geocoding()
              .placemarkFromCoordinates(position.latitude, position.longitude)
              // Offline the platform geocoder can stall for a long time.
              .timeout(const Duration(seconds: 5));
          final mark = marks.isEmpty ? null : marks.first;
          final iso = mark?.isoCountryCode;
          if (iso != null && iso.isNotEmpty) countryCode = iso.toUpperCase();
          final name = [mark?.locality, mark?.subAdministrativeArea, mark?.administrativeArea]
              .whereType<String>()
              .firstWhere((s) => s.isNotEmpty, orElse: () => '');
          if (name.isNotEmpty) city = name;
        } catch (error) {
          // Offline or no geocoder: keep the bundled-city fallback.
          appLog.info('Reverse geocoding unavailable ($error); using bundled cities');
          final near = nearestCity(position.latitude, position.longitude);
          if (near != null) countryCode = near.countryCode;
        }
        return LocationFix(
          lat: position.latitude,
          lng: position.longitude,
          countryCode: countryCode,
          cityName: city ?? 'My location',
          timezoneId: timezoneId,
        );
      }, message: 'Could not get your location');

  @override
  double distanceKm(double lat1, double lng1, double lat2, double lng2) =>
      Geolocator.distanceBetween(lat1, lng1, lat2, lng2) / 1000;
}

/// The bundled city closest to a point, if within [maxKm].
City? nearestCity(double lat, double lng, {double maxKm = 100}) {
  City? best;
  var bestKm = double.infinity;
  for (final city in kCities) {
    final km = haversineKm(lat, lng, city.lat, city.lng);
    if (km < bestKm) {
      bestKm = km;
      best = city;
    }
  }
  return bestKm <= maxKm ? best : null;
}

String? nearestCityName(double lat, double lng) => nearestCity(lat, lng)?.name;

/// Great-circle distance in kilometres.
double haversineKm(double lat1, double lng1, double lat2, double lng2) {
  const r = 6371.0;
  double rad(double d) => d * math.pi / 180;
  final dLat = rad(lat2 - lat1);
  final dLng = rad(lng2 - lng1);
  final a = math.pow(math.sin(dLat / 2), 2) +
      math.cos(rad(lat1)) * math.cos(rad(lat2)) * math.pow(math.sin(dLng / 2), 2);
  return 2 * r * math.asin(math.sqrt(a.toDouble()));
}
