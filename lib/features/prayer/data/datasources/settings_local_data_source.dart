import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/logger.dart';
import '../../domain/entities/prayer_settings.dart';
import '../models/prayer_settings_dto.dart';

/// Reads and writes settings and small flags in `shared_preferences`.
class SettingsLocalDataSource {
  const SettingsLocalDataSource(this._prefs);

  final SharedPreferences _prefs;

  static const _settingsKey = 'prayer_settings_v1';
  static const _lastScheduledKey = 'last_scheduled_at';
  static const _onboardingKey = 'onboarding_done';
  static const _oemKey = 'oem_guide_shown';

  PrayerSettings loadSettings() {
    final raw = _prefs.getString(_settingsKey);
    if (raw == null) return PrayerSettings.defaults();
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return PrayerSettingsDto.fromJson(json).toEntity();
    } catch (error, stackTrace) {
      appLog.warning('Stored settings were unreadable; using defaults', error, stackTrace);
      return PrayerSettings.defaults();
    }
  }

  Future<void> saveSettings(PrayerSettings settings) => _prefs.setString(
        _settingsKey,
        jsonEncode(PrayerSettingsDto.fromEntity(settings).toJson()),
      );

  DateTime? lastScheduledAt() {
    final millis = _prefs.getInt(_lastScheduledKey);
    return millis == null ? null : DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true);
  }

  Future<void> setLastScheduledAt(DateTime at) =>
      _prefs.setInt(_lastScheduledKey, at.toUtc().millisecondsSinceEpoch);

  bool onboardingDone() => _prefs.getBool(_onboardingKey) ?? false;
  Future<void> setOnboardingDone(bool done) => _prefs.setBool(_onboardingKey, done);

  bool oemGuideShown() => _prefs.getBool(_oemKey) ?? false;
  Future<void> setOemGuideShown(bool shown) => _prefs.setBool(_oemKey, shown);
}
