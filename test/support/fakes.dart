import 'dart:async';

import 'package:saathi/core/notifications/notification_scheduler.dart';
import 'package:saathi/features/prayer/data/datasources/adhan_calculator.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_name.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_settings.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_times_day.dart';
import 'package:saathi/features/prayer/domain/repositories/prayer_repository.dart';
import 'package:saathi/features/prayer/domain/repositories/settings_repository.dart';

/// In-memory [SettingsRepository] for tests.
class FakeSettingsRepository implements SettingsRepository {
  FakeSettingsRepository([PrayerSettings? initial]) : _settings = initial ?? PrayerSettings.defaults();

  PrayerSettings _settings;
  DateTime? _lastScheduled;
  bool _onboarding = false;
  bool _oem = false;
  final _controller = StreamController<PrayerSettings>.broadcast();

  @override
  Future<PrayerSettings> load() async => _settings;

  @override
  Future<void> save(PrayerSettings settings) async {
    _settings = settings;
    _controller.add(settings);
  }

  @override
  Stream<PrayerSettings> watch() => _controller.stream;

  @override
  Future<DateTime?> lastScheduledAt() async => _lastScheduled;

  @override
  Future<void> setLastScheduledAt(DateTime at) async => _lastScheduled = at;

  @override
  Future<bool> isOnboardingDone() async => _onboarding;

  @override
  Future<void> setOnboardingDone({required bool done}) async => _onboarding = done;

  @override
  Future<bool> isOemGuideShown() async => _oem;

  @override
  Future<void> setOemGuideShown({required bool shown}) async => _oem = shown;
}

/// [PrayerRepository] backed by the real calculator and an in-memory log.
class FakePrayerRepository implements PrayerRepository {
  FakePrayerRepository({this._calculator = const AdhanCalculator()});

  final AdhanCalculator _calculator;
  final Map<String, Set<PrayerName>> _done = {};
  final _controller = StreamController<void>.broadcast();

  String _key(DateTime d) => '${d.year}-${d.month}-${d.day}';

  @override
  PrayerTimesDay timesFor(DateTime date, PrayerSettings settings) =>
      _calculator.compute(date, settings);

  @override
  Future<Set<PrayerName>> donePrayers(DateTime date) async =>
      Set.of(_done[_key(date)] ?? const <PrayerName>{});

  @override
  Stream<Set<PrayerName>> watchDonePrayers(DateTime date) async* {
    yield await donePrayers(date);
    await for (final _ in _controller.stream) {
      yield await donePrayers(date);
    }
  }

  @override
  Future<void> setDone(DateTime date, PrayerName prayer, {required bool done}) async {
    final set = _done.putIfAbsent(_key(date), () => <PrayerName>{});
    done ? set.add(prayer) : set.remove(prayer);
    _controller.add(null);
  }
}

/// Records scheduler calls instead of touching the platform.
class RecordingScheduler implements NotificationScheduler {
  int cancelAllCalls = 0;
  List<ScheduledAlarm> scheduled = const [];
  bool exact = true;

  @override
  Future<void> cancelAll() async => cancelAllCalls++;

  @override
  Future<bool> canScheduleExact() async => exact;

  @override
  Future<int> pendingCount() async => scheduled.length;

  @override
  Future<void> scheduleAll(List<ScheduledAlarm> alarms) async => scheduled = alarms;
}
