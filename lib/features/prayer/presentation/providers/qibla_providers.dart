import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers.dart';
import '../../data/compass/compass_source.dart';
import '../../domain/entities/qibla.dart';
import 'prayer_providers.dart';

part 'qibla_providers.g.dart';

@Riverpod(keepAlive: true)
CompassSource compassSource(Ref ref) => const PlatformCompassSource();

/// Magnetic declination at the saved location, so the compass can be turned into a
/// true-north heading. Zero when the phone cannot tell (then the error is only the
/// local declination).
@riverpod
Future<double> magneticDeclination(Ref ref) async {
  final settings = ref.watch(currentSettingsProvider);
  return await ref.watch(nativeBridgeProvider).magneticDeclination(settings.lat, settings.lng) ?? 0;
}

/// Kilometres from the saved location to the Kaaba.
@riverpod
double kaabaDistanceKm(Ref ref) {
  final settings = ref.watch(currentSettingsProvider);
  return distanceToKaabaKm(settings.lat, settings.lng);
}
