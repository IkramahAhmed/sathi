import 'dart:async';

import 'package:saathi/core/notifications/notification_scheduler.dart';
import 'package:saathi/core/notifications/permission_service.dart';
import 'package:saathi/core/notifications/setup_probe.dart';
import 'package:saathi/core/sync/cloud_api.dart';
import 'package:saathi/core/sync/sync_config.dart';
import 'package:saathi/core/sync/sync_models.dart';
import 'package:saathi/features/prayer/data/datasources/adhan_calculator.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_name.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_settings.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_times_day.dart';
import 'package:saathi/features/prayer/domain/repositories/prayer_repository.dart';
import 'package:saathi/features/prayer/domain/repositories/reminder_state.dart';
import 'package:saathi/features/prayer/domain/repositories/settings_repository.dart';

/// In-memory [SettingsRepository] for tests.
class FakeSettingsRepository implements SettingsRepository {
  FakeSettingsRepository([PrayerSettings? initial]) : _settings = initial ?? PrayerSettings.defaults();

  PrayerSettings _settings;

  /// What was last saved.
  PrayerSettings get current => _settings;
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

  final List<int> cancelled = [];

  @override
  Future<void> cancel(Iterable<int> ids) async => cancelled.addAll(ids);

  @override
  Future<bool> canScheduleExact() async => exact;

  @override
  Future<int> pendingCount() async => scheduled.length;

  @override
  Future<void> scheduleAll(List<ScheduledAlarm> alarms) async => scheduled = alarms;
}

// ---------------------------------------------------------------------------
// Cloud sync fakes
// ---------------------------------------------------------------------------

/// In-memory [KeyValueStore]. Unlike `SharedPreferences`, every instance is
/// independent, so two simulated phones do not share settings.
class FakeKeyValueStore implements KeyValueStore {
  final Map<String, Object> values = {};

  @override
  int? getInt(String key) => values[key] as int?;

  @override
  String? getString(String key) => values[key] as String?;

  @override
  bool? getBool(String key) => values[key] as bool?;

  @override
  Future<void> setInt(String key, int value) async => values[key] = value;

  @override
  Future<void> setString(String key, String value) async => values[key] = value;

  @override
  Future<void> setBool(String key, bool value) async => values[key] = value;

  @override
  Future<void> remove(String key) async => values.remove(key);
}

/// In-memory [SecretStore].
class FakeSecretStore implements SecretStore {
  final Map<String, String> values = {};

  @override
  Future<String?> read(String name) async => values[name];

  @override
  Future<void> write(String name, String value) async => values[name] = value;

  @override
  Future<void> delete(String name) async => values.remove(name);
}

/// An in-memory server with the same rules as the real API: per-key users,
/// last-write-wins on a strictly newer `updatedAt`, a rising change counter as
/// the cursor, and paging.
class FakeCloudServer implements CloudApi {
  FakeCloudServer({this.pageSize = 1000});

  final int pageSize;
  final Map<String, Map<String, _Row>> _users = {};
  int _seq = 0;

  /// While set, every call fails with this error (simulates being offline).
  CloudApiException? failWith;

  int syncCalls = 0;
  final List<List<SyncChange>> received = [];
  final List<int> cursorsReceived = [];

  /// Number of stored rows for [key].
  int rowsFor(String key) => _users[key]?.length ?? 0;

  @override
  Future<SyncResponse> sync({
    required Uri baseUrl,
    required String key,
    required int cursor,
    required List<SyncChange> changes,
  }) async {
    syncCalls++;
    if (failWith != null) throw failWith!;
    received.add(changes);
    cursorsReceived.add(cursor);
    final rows = _users.putIfAbsent(key, () => {});
    for (final c in changes) {
      final id = '${c.date}|${c.prayer}';
      final existing = rows[id];
      if (existing == null || existing.updatedAt.isBefore(c.updatedAt)) {
        rows[id] = _Row(c, ++_seq);
      }
    }
    final newer = rows.values.where((r) => r.seq > cursor).toList()..sort((a, b) => a.seq.compareTo(b.seq));
    final hasMore = newer.length > pageSize;
    final page = hasMore ? newer.sublist(0, pageSize) : newer;
    return SyncResponse(
      serverTime: DateTime.now().toUtc(),
      cursor: page.isEmpty ? cursor : page.last.seq,
      changes: [for (final r in page) r.change],
      hasMore: hasMore,
    );
  }

  @override
  Future<void> deleteAccount({required Uri baseUrl, required String key}) async {
    if (failWith != null) throw failWith!;
    _users.remove(key);
  }
}

class _Row {
  _Row(this.change, this.seq);

  final SyncChange change;
  final int seq;

  DateTime get updatedAt => change.updatedAt;
}


/// A [ReminderState] you can set up per test.
class FakeReminderState implements ReminderState {
  final Set<String> done = {};
  final Set<String> muted = {};
  final Set<String> paused = {};

  static String key(DateTime d, PrayerName p) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}|${p.name}';

  static String dayKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Future<bool> isDone(DateTime date, PrayerName prayer) async => done.contains(key(date, prayer));

  @override
  Future<bool> isMuted(DateTime date, PrayerName prayer) async => muted.contains(key(date, prayer));

  @override
  Future<bool> isPaused(DateTime date) async => paused.contains(dayKey(date));
}


/// Permissions that never touch the platform.
class FakePermissionService implements PermissionService {
  PermissionOutcome notifications = PermissionOutcome.granted;
  PermissionOutcome exact = PermissionOutcome.granted;
  int settingsOpened = 0;
  int exactRequests = 0;

  @override
  Future<PermissionOutcome> notificationStatus() async => notifications;

  @override
  Future<PermissionOutcome> requestNotifications() async => notifications;

  @override
  Future<PermissionOutcome> exactAlarmStatus() async => exact;

  @override
  Future<PermissionOutcome> requestExactAlarms() async {
    exactRequests++;
    exact = PermissionOutcome.granted;
    return exact;
  }

  @override
  Future<bool> openSettings() async {
    settingsOpened++;
    return true;
  }
}

class FakeSetupProbe implements SetupProbe {
  bool? battery = true;
  bool? channel = true;

  @override
  Future<bool?> batteryUnrestricted() async => battery;

  @override
  Future<bool?> channelAudible(String channelId) async => channel;
}
