import '../../../../core/storage/daos.dart';
import '../../domain/entities/prayer_name.dart';
import '../../domain/entities/prayer_settings.dart';
import '../../domain/entities/prayer_times_day.dart';
import '../../domain/repositories/prayer_repository.dart';
import '../datasources/adhan_calculator.dart';

class PrayerRepositoryImpl implements PrayerRepository {
  const PrayerRepositoryImpl(this._calculator, this._logs);

  final AdhanCalculator _calculator;
  final PrayerLogsDao _logs;

  static String _key(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static Set<PrayerName> _parse(Set<String> names) => {
        for (final p in PrayerName.values)
          if (names.contains(p.name)) p,
      };

  @override
  PrayerTimesDay timesFor(DateTime date, PrayerSettings settings) =>
      _calculator.compute(date, settings);

  @override
  Future<Set<PrayerName>> donePrayers(DateTime date) async =>
      _parse(await _logs.doneFor(_key(date)));

  @override
  Stream<Set<PrayerName>> watchDonePrayers(DateTime date) =>
      _logs.watchDone(_key(date)).map(_parse);

  @override
  Future<void> setDone(DateTime date, PrayerName prayer, {required bool done}) => done
      ? _logs.markDone(_key(date), prayer.name, DateTime.now().toUtc())
      : _logs.unmark(_key(date), prayer.name);
}
