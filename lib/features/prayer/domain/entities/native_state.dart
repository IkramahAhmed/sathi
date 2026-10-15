import '../../../../core/utils/tz_utils.dart';
import 'jamaat.dart';
import 'prayer_name.dart';
import 'prayer_times_day.dart';

/// A period when the phone should be silent (jama'at).
class SilentWindow {
  const SilentWindow({required this.start, required this.end});

  final DateTime start;
  final DateTime end;

  @override
  bool operator ==(Object other) => other is SilentWindow && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'SilentWindow($start - $end)';
}

/// Most windows handed to the phone at once. Re-planned on every start.
const int kMaxSilentWindows = 15;

/// Silent periods for [days], from [jamaat] settings.
///
/// Each runs from the start of jama'at for `silentMinutes`. Past windows are
/// dropped, overlapping ones are merged and the list is capped.
List<SilentWindow> silentWindows({
  required List<PrayerTimesDay> days,
  required JamaatSettings jamaat,
  required String timezoneId,
  required DateTime now,
}) {
  if (!jamaat.silentDuringJamaat || !jamaat.isConfigured) return const [];
  final length = Duration(minutes: jamaat.silentMinutes.clamp(1, 120));
  final raw = <SilentWindow>[];
  for (final day in days) {
    for (final prayer in PrayerName.obligatory) {
      final start = jamaatTime(prayer: prayer, day: day, settings: jamaat, timezoneId: timezoneId);
      if (start == null) continue;
      final end = start.add(length);
      if (!end.isAfter(now)) continue;
      raw.add(SilentWindow(start: start, end: end));
    }
  }
  raw.sort((a, b) => a.start.compareTo(b.start));
  final merged = <SilentWindow>[];
  for (final w in raw) {
    if (merged.isNotEmpty && !w.start.isAfter(merged.last.end)) {
      final last = merged.removeLast();
      merged.add(SilentWindow(start: last.start, end: w.end.isAfter(last.end) ? w.end : last.end));
    } else {
      merged.add(w);
    }
  }
  return merged.length > kMaxSilentWindows ? merged.sublist(0, kMaxSilentWindows) : merged;
}

/// One upcoming prayer on the home-screen widget.
class WidgetEntry {
  const WidgetEntry({required this.label, required this.at, required this.timeText});

  /// The prayer name in the user's language.
  final String label;
  final DateTime at;

  /// The start time ready to show, in the location's time zone.
  final String timeText;
}

/// What the home-screen widget shows.
class WidgetSnapshot {
  const WidgetSnapshot({required this.entries, required this.city, required this.nextLabel});

  /// Upcoming prayers, earliest first, covering about two days.
  final List<WidgetEntry> entries;
  final String city;

  /// Heading above the countdown, for example "Next prayer".
  final String nextLabel;
}

/// The obligatory prayers after [now] across [days], at most [limit].
List<({PrayerName prayer, DateTime at, bool friday})> upcomingPrayers(
  List<PrayerTimesDay> days,
  DateTime now, {
  int limit = 10,
}) {
  final out = <({PrayerName prayer, DateTime at, bool friday})>[];
  for (final day in days) {
    for (final prayer in PrayerName.obligatory) {
      final at = day.times[prayer];
      if (at != null && at.isAfter(now)) out.add((prayer: prayer, at: at, friday: day.isFriday));
    }
  }
  out.sort((a, b) => a.at.compareTo(b.at));
  return out.length > limit ? out.sublist(0, limit) : out;
}

/// Formats a start time for the widget in the location's time zone.
String widgetTime(DateTime at, String timezoneId, String Function(DateTime local) format) =>
    format(toZoned(at, timezoneId));
