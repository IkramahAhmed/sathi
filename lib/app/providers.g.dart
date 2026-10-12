// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Overridden in `main()` with the loaded instance.

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

/// Overridden in `main()` with the loaded instance.

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
  /// Overridden in `main()` with the loaded instance.
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'70ef90bd70df9f89260fca9b542d9f8d25d8e3cb';

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'59cce38d45eeaba199eddd097d8e149d66f9f3e1';

/// The current instant (UTC). Override in tests for deterministic time.

@ProviderFor(clock)
final clockProvider = ClockProvider._();

/// The current instant (UTC). Override in tests for deterministic time.

final class ClockProvider extends $FunctionalProvider<Clock, Clock, Clock>
    with $Provider<Clock> {
  /// The current instant (UTC). Override in tests for deterministic time.
  ClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockHash();

  @$internal
  @override
  $ProviderElement<Clock> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Clock create(Ref ref) {
    return clock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Clock value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Clock>(value),
    );
  }
}

String _$clockHash() => r'b2969fc7f5261f62137e0cfbaf5eccd68cd4516e';

@ProviderFor(adhanCalculator)
final adhanCalculatorProvider = AdhanCalculatorProvider._();

final class AdhanCalculatorProvider
    extends
        $FunctionalProvider<AdhanCalculator, AdhanCalculator, AdhanCalculator>
    with $Provider<AdhanCalculator> {
  AdhanCalculatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adhanCalculatorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adhanCalculatorHash();

  @$internal
  @override
  $ProviderElement<AdhanCalculator> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AdhanCalculator create(Ref ref) {
    return adhanCalculator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdhanCalculator value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdhanCalculator>(value),
    );
  }
}

String _$adhanCalculatorHash() => r'2a97e26ba6f936f8c8c629184b27e65d8ecfa23d';

@ProviderFor(notificationsPlugin)
final notificationsPluginProvider = NotificationsPluginProvider._();

final class NotificationsPluginProvider
    extends
        $FunctionalProvider<
          FlutterLocalNotificationsPlugin,
          FlutterLocalNotificationsPlugin,
          FlutterLocalNotificationsPlugin
        >
    with $Provider<FlutterLocalNotificationsPlugin> {
  NotificationsPluginProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsPluginProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsPluginHash();

  @$internal
  @override
  $ProviderElement<FlutterLocalNotificationsPlugin> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FlutterLocalNotificationsPlugin create(Ref ref) {
    return notificationsPlugin(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FlutterLocalNotificationsPlugin value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FlutterLocalNotificationsPlugin>(
        value,
      ),
    );
  }
}

String _$notificationsPluginHash() =>
    r'72e9ab2508a411c6fb2e0c7c54e8021857b57564';

@ProviderFor(localNotifications)
final localNotificationsProvider = LocalNotificationsProvider._();

final class LocalNotificationsProvider
    extends
        $FunctionalProvider<
          LocalNotificationScheduler,
          LocalNotificationScheduler,
          LocalNotificationScheduler
        >
    with $Provider<LocalNotificationScheduler> {
  LocalNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localNotificationsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localNotificationsHash();

  @$internal
  @override
  $ProviderElement<LocalNotificationScheduler> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalNotificationScheduler create(Ref ref) {
    return localNotifications(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalNotificationScheduler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalNotificationScheduler>(value),
    );
  }
}

String _$localNotificationsHash() =>
    r'241cfefbfc2c29d652662615357b884f5e812923';

@ProviderFor(notificationScheduler)
final notificationSchedulerProvider = NotificationSchedulerProvider._();

final class NotificationSchedulerProvider
    extends
        $FunctionalProvider<
          NotificationScheduler,
          NotificationScheduler,
          NotificationScheduler
        >
    with $Provider<NotificationScheduler> {
  NotificationSchedulerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationSchedulerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationSchedulerHash();

  @$internal
  @override
  $ProviderElement<NotificationScheduler> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationScheduler create(Ref ref) {
    return notificationScheduler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationScheduler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationScheduler>(value),
    );
  }
}

String _$notificationSchedulerHash() =>
    r'ab2107d02a68f049f8e977978ec3dab10a5fb9d1';

@ProviderFor(permissionService)
final permissionServiceProvider = PermissionServiceProvider._();

final class PermissionServiceProvider
    extends
        $FunctionalProvider<
          PermissionService,
          PermissionService,
          PermissionService
        >
    with $Provider<PermissionService> {
  PermissionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'permissionServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$permissionServiceHash();

  @$internal
  @override
  $ProviderElement<PermissionService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PermissionService create(Ref ref) {
    return permissionService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PermissionService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PermissionService>(value),
    );
  }
}

String _$permissionServiceHash() => r'4840c7c94a37eab7efd7dece28f029b51cb688a2';

@ProviderFor(locationService)
final locationServiceProvider = LocationServiceProvider._();

final class LocationServiceProvider
    extends
        $FunctionalProvider<LocationService, LocationService, LocationService>
    with $Provider<LocationService> {
  LocationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationServiceHash();

  @$internal
  @override
  $ProviderElement<LocationService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocationService create(Ref ref) {
    return locationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocationService>(value),
    );
  }
}

String _$locationServiceHash() => r'33637312fa510b0662eebf6c32e8e62519b7c7c3';

@ProviderFor(settingsRepository)
final settingsRepositoryProvider = SettingsRepositoryProvider._();

final class SettingsRepositoryProvider
    extends
        $FunctionalProvider<
          SettingsRepository,
          SettingsRepository,
          SettingsRepository
        >
    with $Provider<SettingsRepository> {
  SettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<SettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsRepository create(Ref ref) {
    return settingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsRepository>(value),
    );
  }
}

String _$settingsRepositoryHash() =>
    r'2700b820a60da6ef7b442902b5cc901b9c8cb54d';

@ProviderFor(prayerRepository)
final prayerRepositoryProvider = PrayerRepositoryProvider._();

final class PrayerRepositoryProvider
    extends
        $FunctionalProvider<
          PrayerRepository,
          PrayerRepository,
          PrayerRepository
        >
    with $Provider<PrayerRepository> {
  PrayerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'prayerRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$prayerRepositoryHash();

  @$internal
  @override
  $ProviderElement<PrayerRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PrayerRepository create(Ref ref) {
    return prayerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrayerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrayerRepository>(value),
    );
  }
}

String _$prayerRepositoryHash() => r'0c2bf045b26bc210172d8355748f9d730bf156cf';

@ProviderFor(getTodayPrayerTimes)
final getTodayPrayerTimesProvider = GetTodayPrayerTimesProvider._();

final class GetTodayPrayerTimesProvider
    extends
        $FunctionalProvider<
          GetTodayPrayerTimes,
          GetTodayPrayerTimes,
          GetTodayPrayerTimes
        >
    with $Provider<GetTodayPrayerTimes> {
  GetTodayPrayerTimesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getTodayPrayerTimesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getTodayPrayerTimesHash();

  @$internal
  @override
  $ProviderElement<GetTodayPrayerTimes> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetTodayPrayerTimes create(Ref ref) {
    return getTodayPrayerTimes(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetTodayPrayerTimes value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetTodayPrayerTimes>(value),
    );
  }
}

String _$getTodayPrayerTimesHash() =>
    r'd76ea49d5f95de4c1bdc1252a26fa73213c9a8b4';

@ProviderFor(getPrayerTimesRange)
final getPrayerTimesRangeProvider = GetPrayerTimesRangeProvider._();

final class GetPrayerTimesRangeProvider
    extends
        $FunctionalProvider<
          GetPrayerTimesRange,
          GetPrayerTimesRange,
          GetPrayerTimesRange
        >
    with $Provider<GetPrayerTimesRange> {
  GetPrayerTimesRangeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getPrayerTimesRangeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getPrayerTimesRangeHash();

  @$internal
  @override
  $ProviderElement<GetPrayerTimesRange> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetPrayerTimesRange create(Ref ref) {
    return getPrayerTimesRange(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetPrayerTimesRange value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetPrayerTimesRange>(value),
    );
  }
}

String _$getPrayerTimesRangeHash() =>
    r'33b728fce3aa949cd46e1b25a1231b9a2bc85850';

@ProviderFor(markPrayerDone)
final markPrayerDoneProvider = MarkPrayerDoneProvider._();

final class MarkPrayerDoneProvider
    extends $FunctionalProvider<MarkPrayerDone, MarkPrayerDone, MarkPrayerDone>
    with $Provider<MarkPrayerDone> {
  MarkPrayerDoneProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'markPrayerDoneProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$markPrayerDoneHash();

  @$internal
  @override
  $ProviderElement<MarkPrayerDone> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MarkPrayerDone create(Ref ref) {
    return markPrayerDone(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MarkPrayerDone value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MarkPrayerDone>(value),
    );
  }
}

String _$markPrayerDoneHash() => r'76e0f9270afff12aefa67245850cbfbd95a14c11';

@ProviderFor(scheduleUpcomingAzans)
final scheduleUpcomingAzansProvider = ScheduleUpcomingAzansProvider._();

final class ScheduleUpcomingAzansProvider
    extends
        $FunctionalProvider<
          ScheduleUpcomingAzans,
          ScheduleUpcomingAzans,
          ScheduleUpcomingAzans
        >
    with $Provider<ScheduleUpcomingAzans> {
  ScheduleUpcomingAzansProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scheduleUpcomingAzansProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scheduleUpcomingAzansHash();

  @$internal
  @override
  $ProviderElement<ScheduleUpcomingAzans> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ScheduleUpcomingAzans create(Ref ref) {
    return scheduleUpcomingAzans(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScheduleUpcomingAzans value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScheduleUpcomingAzans>(value),
    );
  }
}

String _$scheduleUpcomingAzansHash() =>
    r'69e0f23922c091e3ebc1095550bc1e566a16b6e1';

/// Tracks whether the app is in the foreground so tickers can pause.

@ProviderFor(AppLifecycle)
final appLifecycleProvider = AppLifecycleProvider._();

/// Tracks whether the app is in the foreground so tickers can pause.
final class AppLifecycleProvider
    extends $NotifierProvider<AppLifecycle, AppLifecycleState> {
  /// Tracks whether the app is in the foreground so tickers can pause.
  AppLifecycleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLifecycleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLifecycleHash();

  @$internal
  @override
  AppLifecycle create() => AppLifecycle();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppLifecycleState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppLifecycleState>(value),
    );
  }
}

String _$appLifecycleHash() => r'f46016b016c6f6cd439bb31fa2ef1c78ad920134';

/// Tracks whether the app is in the foreground so tickers can pause.

abstract class _$AppLifecycle extends $Notifier<AppLifecycleState> {
  AppLifecycleState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppLifecycleState, AppLifecycleState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppLifecycleState, AppLifecycleState>,
              AppLifecycleState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
