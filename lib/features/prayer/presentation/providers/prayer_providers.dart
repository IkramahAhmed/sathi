import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderListenableSelect;
import 'package:hijri/hijri_calendar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers.dart';
import '../../../../core/utils/tz_utils.dart';
import '../../domain/entities/prayer_name.dart';
import '../../domain/entities/prayer_settings.dart';
import '../../domain/entities/prayer_times_day.dart';
import 'settings_controller.dart';

part 'prayer_providers.g.dart';

/// The effective settings, or the defaults while they are still loading.
@Riverpod(keepAlive: true)
PrayerSettings currentSettings(Ref ref) =>
    ref.watch(settingsControllerProvider).value ?? PrayerSettings.defaults();

/// The current instant, ticking once a second while the app is visible.
@Riverpod(keepAlive: true)
class NowTick extends _$NowTick {
  @override
  DateTime build() {
    final clock = ref.watch(clockProvider);
    final lifecycle = ref.watch(appLifecycleProvider);
    Timer? timer;
    ref.onDispose(() => timer?.cancel());
    if (lifecycle == AppLifecycleState.resumed) {
      timer = Timer.periodic(const Duration(seconds: 1), (_) => state = clock());
    }
    return clock();
  }
}

/// The calendar date at the user's location. Changes only at local midnight,
/// so providers depending on it do not recompute every second.
@Riverpod(keepAlive: true)
DateTime todayDate(Ref ref) {
  final zone = ref.watch(currentSettingsProvider.select((s) => s.timezoneId));
  final now = ref.watch(nowTickProvider);
  return localDateAt(now, zone);
}

@Riverpod(keepAlive: true)
PrayerTimesDay todayTimes(Ref ref) {
  final settings = ref.watch(currentSettingsProvider);
  final date = ref.watch(todayDateProvider);
  return ref.watch(prayerRepositoryProvider).timesFor(date, settings);
}

@Riverpod(keepAlive: true)
PrayerTimesDay tomorrowTimes(Ref ref) {
  final settings = ref.watch(currentSettingsProvider);
  final date = ref.watch(todayDateProvider);
  return ref
      .watch(prayerRepositoryProvider)
      .timesFor(DateTime(date.year, date.month, date.day + 1), settings);
}

/// The next obligatory prayer and when it starts.
@Riverpod(keepAlive: true)
UpcomingPrayer? nextPrayer(Ref ref) {
  final now = ref.watch(nowTickProvider);
  final today = ref.watch(todayTimesProvider);
  final tomorrow = ref.watch(tomorrowTimesProvider);
  return nextPrayerAfter([today, tomorrow], now);
}

/// Which of today's prayers are ticked off.
@Riverpod(keepAlive: true)
Stream<Set<PrayerName>> prayedToday(Ref ref) {
  final date = ref.watch(todayDateProvider);
  return ref.watch(prayerRepositoryProvider).watchDonePrayers(date);
}

/// Hijri date, shifted by the user's moon-sighting correction.
@Riverpod(keepAlive: true)
HijriCalendar hijriToday(Ref ref) {
  final date = ref.watch(todayDateProvider);
  final settings = ref.watch(currentSettingsProvider);
  HijriCalendar.language = settings.localeTag == 'ur' ? 'ar' : 'en';
  return HijriCalendar.fromDate(date.add(Duration(days: settings.hijriAdjustDays)));
}

/// All days of [month] in [year] (1-based month), for the timetable.
@riverpod
List<PrayerTimesDay> monthTimes(Ref ref, int year, int month) {
  final settings = ref.watch(currentSettingsProvider);
  final repo = ref.watch(prayerRepositoryProvider);
  final days = DateTime(year, month + 1, 0).day;
  return [for (var d = 1; d <= days; d++) repo.timesFor(DateTime(year, month, d), settings)];
}

/// True while the current Hijri month is Ramadan (month 9).
@Riverpod(keepAlive: true)
bool isRamadan(Ref ref) => ref.watch(hijriTodayProvider).hMonth == 9;

/// Bearing to the Kaaba from the current location, degrees from true north.
@riverpod
double qiblaBearing(Ref ref) {
  final settings = ref.watch(currentSettingsProvider);
  return ref.watch(adhanCalculatorProvider).qiblaBearing(settings.lat, settings.lng);
}
