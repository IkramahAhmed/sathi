import 'package:timezone/timezone.dart' as tz;

import 'prayer_name.dart';
import 'prayer_times_day.dart';

/// Congregational (jama'at) times at the user's mosque.
///
/// Mosques usually either hold jama'at a fixed number of minutes after the azan,
/// or at a fixed clock time. Both are supported; a fixed time wins.
class JamaatSettings {
  const JamaatSettings({
    this.offsetMin = const {},
    this.fixedMin = const {},
    this.jummaFixedMin,
    this.leaveReminderMin = 0,
    this.silentDuringJamaat = false,
    this.silentMinutes = 15,
  });

  /// Minutes after the azan. Missing or 0 means not set.
  final Map<PrayerName, int> offsetMin;

  /// Fixed clock time as minutes after midnight at the location (for example
  /// 13:30 is 810). Takes priority over [offsetMin].
  final Map<PrayerName, int> fixedMin;

  /// Friday jama'at as minutes after midnight. Used instead of Dhuhr's rule on Fridays.
  final int? jummaFixedMin;

  /// Remind the user this many minutes before jama'at so they can leave. 0 is off.
  final int leaveReminderMin;

  /// Silence the phone during jama'at (needs Do Not Disturb access).
  final bool silentDuringJamaat;

  /// How long the phone stays silent after jama'at starts.
  final int silentMinutes;

  /// Whether any jama'at time is set at all.
  bool get isConfigured =>
      offsetMin.values.any((v) => v > 0) || fixedMin.isNotEmpty || jummaFixedMin != null;

  /// Whether [prayer] has a jama'at rule on an ordinary day.
  bool hasRuleFor(PrayerName prayer) => (offsetMin[prayer] ?? 0) > 0 || fixedMin.containsKey(prayer);

  JamaatSettings copyWith({
    Map<PrayerName, int>? offsetMin,
    Map<PrayerName, int>? fixedMin,
    int? jummaFixedMin,
    bool clearJumma = false,
    int? leaveReminderMin,
    bool? silentDuringJamaat,
    int? silentMinutes,
  }) =>
      JamaatSettings(
        offsetMin: offsetMin ?? this.offsetMin,
        fixedMin: fixedMin ?? this.fixedMin,
        jummaFixedMin: clearJumma ? null : (jummaFixedMin ?? this.jummaFixedMin),
        leaveReminderMin: leaveReminderMin ?? this.leaveReminderMin,
        silentDuringJamaat: silentDuringJamaat ?? this.silentDuringJamaat,
        silentMinutes: silentMinutes ?? this.silentMinutes,
      );

  Map<String, Object?> toComparableMap() => {
        'offsetMin': {for (final e in offsetMin.entries) e.key.name: e.value},
        'fixedMin': {for (final e in fixedMin.entries) e.key.name: e.value},
        'jummaFixedMin': jummaFixedMin,
        'leaveReminderMin': leaveReminderMin,
        'silentDuringJamaat': silentDuringJamaat,
        'silentMinutes': silentMinutes,
      };
}

/// The instant jama'at starts for [prayer] on [day], or null when no rule applies.
///
/// [timezoneId] is the location's IANA zone, used to turn a fixed clock time into
/// an absolute instant. The timezone database must be initialised.
DateTime? jamaatTime({
  required PrayerName prayer,
  required PrayerTimesDay day,
  required JamaatSettings settings,
  required String timezoneId,
}) {
  final azan = day.times[prayer];
  if (azan == null || !prayer.hasAzan) return null;

  int? fixed = settings.fixedMin[prayer];
  if (prayer == PrayerName.dhuhr && day.isFriday && settings.jummaFixedMin != null) {
    fixed = settings.jummaFixedMin;
  }
  if (fixed != null) {
    final location = tz.getLocation(timezoneId);
    final local = tz.TZDateTime(location, day.date.year, day.date.month, day.date.day, fixed ~/ 60, fixed % 60);
    return local.toUtc();
  }

  final offset = settings.offsetMin[prayer] ?? 0;
  if (offset > 0) return azan.add(Duration(minutes: offset));
  return null;
}
