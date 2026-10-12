import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/core/storage/app_database.dart';
import 'package:saathi/features/prayer/data/datasources/adhan_calculator.dart';
import 'package:saathi/features/prayer/data/repositories/prayer_repository_impl.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_name.dart';

void main() {
  late AppDatabase db;
  late PrayerRepositoryImpl repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = PrayerRepositoryImpl(const AdhanCalculator(), db.prayerLogsDao);
  });

  tearDown(() => db.close());

  final day = DateTime(2026, 10, 12);

  test('nothing is marked at first', () async {
    expect(await repo.donePrayers(day), isEmpty);
  });

  test('marking and unmarking a prayer', () async {
    await repo.setDone(day, PrayerName.fajr, done: true);
    await repo.setDone(day, PrayerName.asr, done: true);
    expect(await repo.donePrayers(day), {PrayerName.fajr, PrayerName.asr});

    await repo.setDone(day, PrayerName.fajr, done: false);
    expect(await repo.donePrayers(day), {PrayerName.asr});
  });

  test('marking twice does not duplicate (unique per date and prayer)', () async {
    await repo.setDone(day, PrayerName.isha, done: true);
    await repo.setDone(day, PrayerName.isha, done: true);
    expect(await repo.donePrayers(day), {PrayerName.isha});
  });

  test('days are independent', () async {
    await repo.setDone(day, PrayerName.fajr, done: true);
    expect(await repo.donePrayers(DateTime(2026, 10, 13)), isEmpty);
  });

  test('watchDonePrayers emits as prayers are ticked', () async {
    final stream = repo.watchDonePrayers(day);
    final expectation = expectLater(
      stream,
      emitsInOrder([
        isEmpty,
        {PrayerName.dhuhr},
      ]),
    );
    await Future<void>.delayed(const Duration(milliseconds: 20));
    await repo.setDone(day, PrayerName.dhuhr, done: true);
    await expectation;
  });
}
