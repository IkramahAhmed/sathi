import '../entities/prayer_name.dart';

/// What the scheduler needs to know to decide whether a reminder is still
/// wanted. A prayer that is already done, falls on a paused day, or whose
/// reminders the user stopped must not nag.
abstract interface class ReminderState {
  Future<bool> isDone(DateTime date, PrayerName prayer);

  /// Whether prayers are paused on [date] (illness, a woman's period).
  Future<bool> isPaused(DateTime date);

  /// Whether the user chose "stop reminders" for this prayer on this date.
  Future<bool> isMuted(DateTime date, PrayerName prayer);
}

/// Nothing is done, paused or muted. The default, and handy in tests.
class NoReminderState implements ReminderState {
  const NoReminderState();

  @override
  Future<bool> isDone(DateTime date, PrayerName prayer) async => false;

  @override
  Future<bool> isPaused(DateTime date) async => false;

  @override
  Future<bool> isMuted(DateTime date, PrayerName prayer) async => false;
}
