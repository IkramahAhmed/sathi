import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/logger.dart';

part 'oem_provider.g.dart';

/// The phone maker, used to decide whether to show the battery guide.
class OemInfo {
  const OemInfo(this.manufacturer);

  final String manufacturer;

  /// Manufacturers whose Android builds aggressively kill background apps.
  static const _aggressive = {
    'xiaomi', 'redmi', 'poco', 'infinix', 'tecno', 'itel', 'transsion',
    'oppo', 'realme', 'oneplus', 'vivo', 'iqoo', 'huawei', 'honor',
  };

  bool get needsGuide => _aggressive.contains(manufacturer.toLowerCase());

  /// Display name such as `Infinix`.
  String get brand =>
      manufacturer.isEmpty ? '' : manufacturer[0].toUpperCase() + manufacturer.substring(1).toLowerCase();
}

/// Null on non-Android platforms or when the lookup fails.
@Riverpod(keepAlive: true)
Future<OemInfo?> oemInfo(Ref ref) async {
  if (defaultTargetPlatform != TargetPlatform.android) return null;
  try {
    final info = await DeviceInfoPlugin().androidInfo;
    return OemInfo(info.manufacturer);
  } catch (error, stackTrace) {
    appLog.warning('Could not read device manufacturer', error, stackTrace);
    return null;
  }
}
