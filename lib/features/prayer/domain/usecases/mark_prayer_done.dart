import '../../../../core/utils/result.dart';
import '../entities/prayer_name.dart';
import '../repositories/prayer_repository.dart';

/// Marks a prayer as prayed (or not) for a given calendar date.
class MarkPrayerDone {
  const MarkPrayerDone(this._prayers);

  final PrayerRepository _prayers;

  Future<Result<void>> call(DateTime date, PrayerName prayer, {required bool done}) =>
      guard(() => _prayers.setDone(date, prayer, done: done));
}
