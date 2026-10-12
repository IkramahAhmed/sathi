import '../entities/prayer_settings.dart';

/// Persistence for [PrayerSettings] and small app flags.
abstract interface class SettingsRepository {
  Future<PrayerSettings> load();

  /// Persists [settings], notifies [watch] listeners and records history.
  Future<void> save(PrayerSettings settings);

  Stream<PrayerSettings> watch();

  Future<DateTime?> lastScheduledAt();
  Future<void> setLastScheduledAt(DateTime at);

  Future<bool> isOnboardingDone();
  Future<void> setOnboardingDone({required bool done});

  Future<bool> isOemGuideShown();
  Future<void> setOemGuideShown({required bool shown});
}
