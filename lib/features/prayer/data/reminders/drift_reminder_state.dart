import '../../../../core/storage/daos.dart';
import '../../domain/entities/prayer_name.dart';
import '../../domain/entities/streaks.dart';
import '../../domain/repositories/reminder_state.dart';
import '../qaza/qaza_service.dart';
import 'reminder_mute_store.dart';

/// [ReminderState] backed by the local database and the mute list.
class DriftReminderState implements ReminderState {
  const DriftReminderState({required this.logs, required this.pauses, required this.mutes});

  final PrayerLogsDao logs;
  final PauseRangesDao pauses;
  final ReminderMuteStore mutes;

  @override
  Future<bool> isDone(DateTime date, PrayerName prayer) async =>
      (await logs.doneFor(dateKey(date))).contains(prayer.name);

  @override
  Future<bool> isPaused(DateTime date) async =>
      pauseRangesFrom(await pauses.all()).any((p) => p.contains(date));

  @override
  Future<bool> isMuted(DateTime date, PrayerName prayer) async => mutes.isMuted(date, prayer);
}
