import 'prayer_name.dart';
import 'prayer_window.dart';

/// "This prayer is about to end" reminders, optionally repeated until the user
/// proves they prayed.
class EndReminderSettings {
  const EndReminderSettings({
    this.enabled = false,
    this.prayers = const {
      PrayerName.fajr: true,
      PrayerName.dhuhr: true,
      PrayerName.asr: true,
      PrayerName.maghrib: true,
      PrayerName.isha: true,
    },
    this.leadMin = 30,
    this.repeatMin = 10,
    this.requirePhoto = false,
  });

  final bool enabled;

  /// Which prayers get reminders.
  final Map<PrayerName, bool> prayers;

  /// The first reminder comes this many minutes before the window ends.
  final int leadMin;

  /// Gap between repeated reminders.
  final int repeatMin;

  /// When true, only a verified photo (or "I'm excused") stops the reminders.
  /// When false, ticking the prayer as prayed stops them.
  final bool requirePhoto;

  bool appliesTo(PrayerName prayer) => enabled && (prayers[prayer] ?? false);

  EndReminderSettings copyWith({
    bool? enabled,
    Map<PrayerName, bool>? prayers,
    int? leadMin,
    int? repeatMin,
    bool? requirePhoto,
  }) =>
      EndReminderSettings(
        enabled: enabled ?? this.enabled,
        prayers: prayers ?? this.prayers,
        leadMin: leadMin ?? this.leadMin,
        repeatMin: repeatMin ?? this.repeatMin,
        requirePhoto: requirePhoto ?? this.requirePhoto,
      );

  Map<String, Object?> toComparableMap() => {
        'enabled': enabled,
        'prayers': {for (final e in prayers.entries) e.key.name: e.value},
        'leadMin': leadMin,
        'repeatMin': repeatMin,
        'requirePhoto': requirePhoto,
      };
}

/// One reminder in the plan.
class EndReminderSlot {
  const EndReminderSlot({required this.index, required this.at, required this.minutesLeft});

  /// 0, 1, 2... in time order. Used to build a stable notification id.
  final int index;
  final DateTime at;

  /// Whole minutes between this reminder and the end of the window.
  final int minutesLeft;
}

/// Hard cap so a long lead with a short gap cannot flood the user or the alarm budget.
const int kMaxEndReminders = 8;

/// The times to remind about [window], earliest first.
///
/// Reminders start [EndReminderSettings.leadMin] before the end and repeat every
/// [EndReminderSettings.repeatMin]. They never start before the window opens, and
/// the last one is never later than five minutes before the end, so the user
/// always has time to pray.
List<EndReminderSlot> endReminderPlan(PrayerWindow window, EndReminderSettings settings) {
  if (!settings.appliesTo(window.prayer)) return const [];
  final lead = settings.leadMin.clamp(5, 180);
  final repeat = settings.repeatMin.clamp(1, 60);

  // Do not nag in the first minutes of a window that is shorter than the lead.
  final earliest = window.start.add(const Duration(minutes: 5));
  final lastAllowed = window.end.subtract(const Duration(minutes: 5));
  var at = window.end.subtract(Duration(minutes: lead));
  if (at.isBefore(earliest)) at = earliest;

  final slots = <EndReminderSlot>[];
  // Keep one slot free for the final "last call".
  while (!at.isAfter(lastAllowed) && slots.length < kMaxEndReminders - 1) {
    slots.add(EndReminderSlot(
      index: slots.length,
      at: at,
      minutesLeft: window.end.difference(at).inMinutes,
    ));
    at = at.add(Duration(minutes: repeat));
  }
  // Always finish with a last call five minutes before the end, unless a regular
  // reminder already landed within three minutes of it.
  final last = slots.isEmpty ? null : slots.last;
  if (!lastAllowed.isBefore(earliest) &&
      (last == null || lastAllowed.difference(last.at).inMinutes >= 3)) {
    slots.add(EndReminderSlot(index: slots.length, at: lastAllowed, minutesLeft: 5));
  }
  return slots;
}
