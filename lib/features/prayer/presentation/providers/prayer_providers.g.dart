// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The effective settings, or the defaults while they are still loading.

@ProviderFor(currentSettings)
final currentSettingsProvider = CurrentSettingsProvider._();

/// The effective settings, or the defaults while they are still loading.

final class CurrentSettingsProvider
    extends $FunctionalProvider<PrayerSettings, PrayerSettings, PrayerSettings>
    with $Provider<PrayerSettings> {
  /// The effective settings, or the defaults while they are still loading.
  CurrentSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentSettingsHash();

  @$internal
  @override
  $ProviderElement<PrayerSettings> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PrayerSettings create(Ref ref) {
    return currentSettings(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrayerSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrayerSettings>(value),
    );
  }
}

String _$currentSettingsHash() => r'2c9931ead8cd59d4446678fb5c36791a4e9faf9d';

/// The current instant, ticking once a second while the app is visible.

@ProviderFor(NowTick)
final nowTickProvider = NowTickProvider._();

/// The current instant, ticking once a second while the app is visible.
final class NowTickProvider extends $NotifierProvider<NowTick, DateTime> {
  /// The current instant, ticking once a second while the app is visible.
  NowTickProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nowTickProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nowTickHash();

  @$internal
  @override
  NowTick create() => NowTick();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$nowTickHash() => r'8d85fe2e3c5aac04624733a96c8a15c63233164d';

/// The current instant, ticking once a second while the app is visible.

abstract class _$NowTick extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime, DateTime>,
              DateTime,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The calendar date at the user's location. Changes only at local midnight,
/// so providers depending on it do not recompute every second.

@ProviderFor(todayDate)
final todayDateProvider = TodayDateProvider._();

/// The calendar date at the user's location. Changes only at local midnight,
/// so providers depending on it do not recompute every second.

final class TodayDateProvider
    extends $FunctionalProvider<DateTime, DateTime, DateTime>
    with $Provider<DateTime> {
  /// The calendar date at the user's location. Changes only at local midnight,
  /// so providers depending on it do not recompute every second.
  TodayDateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayDateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayDateHash();

  @$internal
  @override
  $ProviderElement<DateTime> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DateTime create(Ref ref) {
    return todayDate(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$todayDateHash() => r'7260cf5957ec2e8876b0d7d6f74265522d740787';

@ProviderFor(todayTimes)
final todayTimesProvider = TodayTimesProvider._();

final class TodayTimesProvider
    extends $FunctionalProvider<PrayerTimesDay, PrayerTimesDay, PrayerTimesDay>
    with $Provider<PrayerTimesDay> {
  TodayTimesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayTimesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayTimesHash();

  @$internal
  @override
  $ProviderElement<PrayerTimesDay> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PrayerTimesDay create(Ref ref) {
    return todayTimes(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrayerTimesDay value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrayerTimesDay>(value),
    );
  }
}

String _$todayTimesHash() => r'20851b8e8a9af44022f3d2ce14b4b70e2b55e216';

@ProviderFor(tomorrowTimes)
final tomorrowTimesProvider = TomorrowTimesProvider._();

final class TomorrowTimesProvider
    extends $FunctionalProvider<PrayerTimesDay, PrayerTimesDay, PrayerTimesDay>
    with $Provider<PrayerTimesDay> {
  TomorrowTimesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tomorrowTimesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tomorrowTimesHash();

  @$internal
  @override
  $ProviderElement<PrayerTimesDay> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PrayerTimesDay create(Ref ref) {
    return tomorrowTimes(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrayerTimesDay value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrayerTimesDay>(value),
    );
  }
}

String _$tomorrowTimesHash() => r'26e9a6cab4615e103fab5a787f560be10a01cdd3';

/// The next obligatory prayer and when it starts.

@ProviderFor(nextPrayer)
final nextPrayerProvider = NextPrayerProvider._();

/// The next obligatory prayer and when it starts.

final class NextPrayerProvider
    extends
        $FunctionalProvider<UpcomingPrayer?, UpcomingPrayer?, UpcomingPrayer?>
    with $Provider<UpcomingPrayer?> {
  /// The next obligatory prayer and when it starts.
  NextPrayerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nextPrayerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nextPrayerHash();

  @$internal
  @override
  $ProviderElement<UpcomingPrayer?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpcomingPrayer? create(Ref ref) {
    return nextPrayer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpcomingPrayer? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpcomingPrayer?>(value),
    );
  }
}

String _$nextPrayerHash() => r'ece595fdceaafeb799c4874603ac2fe393ea8da8';

/// Which of today's prayers are ticked off.

@ProviderFor(prayedToday)
final prayedTodayProvider = PrayedTodayProvider._();

/// Which of today's prayers are ticked off.

final class PrayedTodayProvider
    extends
        $FunctionalProvider<
          AsyncValue<Set<PrayerName>>,
          Set<PrayerName>,
          Stream<Set<PrayerName>>
        >
    with $FutureModifier<Set<PrayerName>>, $StreamProvider<Set<PrayerName>> {
  /// Which of today's prayers are ticked off.
  PrayedTodayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'prayedTodayProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$prayedTodayHash();

  @$internal
  @override
  $StreamProviderElement<Set<PrayerName>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Set<PrayerName>> create(Ref ref) {
    return prayedToday(ref);
  }
}

String _$prayedTodayHash() => r'6ef667112329085ac69139209ba674d467cb961b';

/// Hijri date, shifted by the user's moon-sighting correction.

@ProviderFor(hijriToday)
final hijriTodayProvider = HijriTodayProvider._();

/// Hijri date, shifted by the user's moon-sighting correction.

final class HijriTodayProvider
    extends $FunctionalProvider<HijriCalendar, HijriCalendar, HijriCalendar>
    with $Provider<HijriCalendar> {
  /// Hijri date, shifted by the user's moon-sighting correction.
  HijriTodayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hijriTodayProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hijriTodayHash();

  @$internal
  @override
  $ProviderElement<HijriCalendar> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HijriCalendar create(Ref ref) {
    return hijriToday(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HijriCalendar value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HijriCalendar>(value),
    );
  }
}

String _$hijriTodayHash() => r'5575cf816ceb19dc085639485416353dc47db370';

/// All days of [month] in [year] (1-based month), for the timetable.

@ProviderFor(monthTimes)
final monthTimesProvider = MonthTimesFamily._();

/// All days of [month] in [year] (1-based month), for the timetable.

final class MonthTimesProvider
    extends
        $FunctionalProvider<
          List<PrayerTimesDay>,
          List<PrayerTimesDay>,
          List<PrayerTimesDay>
        >
    with $Provider<List<PrayerTimesDay>> {
  /// All days of [month] in [year] (1-based month), for the timetable.
  MonthTimesProvider._({
    required MonthTimesFamily super.from,
    required (int, int) super.argument,
  }) : super(
         retry: null,
         name: r'monthTimesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$monthTimesHash();

  @override
  String toString() {
    return r'monthTimesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<List<PrayerTimesDay>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<PrayerTimesDay> create(Ref ref) {
    final argument = this.argument as (int, int);
    return monthTimes(ref, argument.$1, argument.$2);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PrayerTimesDay> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PrayerTimesDay>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MonthTimesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$monthTimesHash() => r'026498c25375b74ab7d6a0ab4de500734efbf531';

/// All days of [month] in [year] (1-based month), for the timetable.

final class MonthTimesFamily extends $Family
    with $FunctionalFamilyOverride<List<PrayerTimesDay>, (int, int)> {
  MonthTimesFamily._()
    : super(
        retry: null,
        name: r'monthTimesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// All days of [month] in [year] (1-based month), for the timetable.

  MonthTimesProvider call(int year, int month) =>
      MonthTimesProvider._(argument: (year, month), from: this);

  @override
  String toString() => r'monthTimesProvider';
}

/// Bearing to the Kaaba from the current location, degrees from true north.

@ProviderFor(qiblaBearing)
final qiblaBearingProvider = QiblaBearingProvider._();

/// Bearing to the Kaaba from the current location, degrees from true north.

final class QiblaBearingProvider
    extends $FunctionalProvider<double, double, double>
    with $Provider<double> {
  /// Bearing to the Kaaba from the current location, degrees from true north.
  QiblaBearingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'qiblaBearingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$qiblaBearingHash();

  @$internal
  @override
  $ProviderElement<double> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  double create(Ref ref) {
    return qiblaBearing(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$qiblaBearingHash() => r'dbb468aea69de275d473de76cb3c659007893055';
