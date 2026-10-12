import 'dart:async';
import 'dart:convert';

import '../../../../core/storage/daos.dart';
import '../../../../core/utils/clock.dart';
import '../../domain/entities/prayer_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._local, {this._history, this._clock = systemClock});

  final SettingsLocalDataSource _local;
  final SettingsHistoryDao? _history;
  final Clock _clock;
  final _changes = StreamController<PrayerSettings>.broadcast();

  @override
  Future<PrayerSettings> load() async => _local.loadSettings();

  @override
  Future<void> save(PrayerSettings settings) async {
    final before = _local.loadSettings();
    await _local.saveSettings(settings);
    await _recordHistory(before, settings);
    _changes.add(settings);
  }

  Future<void> _recordHistory(PrayerSettings before, PrayerSettings after) async {
    final history = _history;
    if (history == null) return;
    final old = before.toComparableMap();
    final next = after.toComparableMap();
    final now = _clock();
    for (final key in next.keys) {
      final oldValue = jsonEncode(old[key]);
      final newValue = jsonEncode(next[key]);
      if (oldValue != newValue) {
        await history.record(now, key, oldValue, newValue);
      }
    }
  }

  @override
  Stream<PrayerSettings> watch() => _changes.stream;

  @override
  Future<DateTime?> lastScheduledAt() async => _local.lastScheduledAt();

  @override
  Future<void> setLastScheduledAt(DateTime at) => _local.setLastScheduledAt(at);

  @override
  Future<bool> isOnboardingDone() async => _local.onboardingDone();

  @override
  Future<void> setOnboardingDone({required bool done}) => _local.setOnboardingDone(done);

  @override
  Future<bool> isOemGuideShown() async => _local.oemGuideShown();

  @override
  Future<void> setOemGuideShown({required bool shown}) => _local.setOemGuideShown(shown);
}
