import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/core/storage/app_database.dart';
import 'package:saathi/features/prayer/data/datasources/adhan_calculator.dart';
import 'package:saathi/features/prayer/data/qaza/qaza_service.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_settings.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_window.dart';
import 'package:timezone/data/latest.dart' as tzdata;

void main() {
  setUpAll(tzdata.initializeTimeZones);

  late AppDatabase db;
  late QazaService service;
  final settings = PrayerSettings.defaults(); // Karachi, UTC+5
  const calculator = AdhanCalculator();

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    service = QazaService(
      qaza: db.qazaDao,
      logs: db.prayerLogsDao,
      pauses: db.pauseRangesDao,
      times: calculator,
    );
  });
  tearDown(() => db.close());

  // A moment late on the evening of 2026-10-15 in Karachi: every window of the
  // 15th except Isha (ends near midnight) has ended. 22:00 PKT = 17:00 UTC.
  final lateEvening = DateTime.utc(2026, 10, 15, 17);
  // The next morning, after Isha's window closed. 06:00 PKT = 01:00 UTC on the 16th... use 08:00 PKT.
  final nextMorning = DateTime.utc(2026, 10, 16, 3);

  Future<int> run(DateTime now, {DateTime? from}) =>
      service.reconcile(settings: settings, now: now, from: from ?? DateTime(2026, 10, 15));

  test('counts nothing before any window has ended', () async {
    // 03:00 PKT on the 15th, before Fajr ends.
    expect(await run(DateTime.utc(2026, 10, 14, 22), from: DateTime(2026, 10, 15)), 0);
    expect(await db.qazaDao.owed(), isEmpty);
  });

  test('counts every prayer whose window ended without a tick', () async {
    expect(await run(lateEvening), 4, reason: 'Fajr, Dhuhr, Asr and Maghrib ended; Isha is still open');
    expect(await db.qazaDao.owed(), {'fajr': 1, 'dhuhr': 1, 'asr': 1, 'maghrib': 1});
  });

  test('a prayer that was ticked is not counted', () async {
    await db.prayerLogsDao.markDone('2026-10-15', 'fajr', DateTime.utc(2026, 10, 15, 1));
    await db.prayerLogsDao.markDone('2026-10-15', 'asr', DateTime.utc(2026, 10, 15, 11));
    await run(lateEvening);
    expect(await db.qazaDao.owed(), {'dhuhr': 1, 'maghrib': 1});
  });

  test('is idempotent: running again changes nothing', () async {
    await run(lateEvening);
    expect(await run(lateEvening), 0);
    expect(await run(lateEvening), 0);
    expect((await db.qazaDao.owed())['fajr'], 1);
    expect((await db.qazaDao.history()), hasLength(4));
  });

  test('Isha is counted once its window (Islamic midnight) has passed', () async {
    await run(lateEvening);
    expect((await db.qazaDao.owed())['isha'], isNull);
    await run(nextMorning);
    expect((await db.qazaDao.owed())['isha'], 1);
  });

  test('ticking a prayer afterwards takes the miss back', () async {
    await run(lateEvening);
    expect((await db.qazaDao.owed())['asr'], 1);
    await db.prayerLogsDao.markDone('2026-10-15', 'asr', DateTime.utc(2026, 10, 15, 16));
    expect(await run(lateEvening), -1);
    expect((await db.qazaDao.owed())['asr'], 0);
    expect(await db.qazaDao.autoKeys(), isNot(contains('2026-10-15|asr')));
  });

  test('un-ticking it again counts it again', () async {
    await db.prayerLogsDao.markDone('2026-10-15', 'asr', DateTime.utc(2026, 10, 15, 11));
    await run(lateEvening);
    expect((await db.qazaDao.owed())['asr'], isNull);
    await db.prayerLogsDao.unmark('2026-10-15', 'asr', DateTime.utc(2026, 10, 15, 12));
    await run(lateEvening);
    expect((await db.qazaDao.owed())['asr'], 1);
  });

  test('a paused day counts nothing', () async {
    await db.pauseRangesDao.addRange('2026-10-15', '2026-10-15');
    expect(await run(lateEvening), 0);
    expect(await db.qazaDao.owed(), isEmpty);
  });

  test('pausing a day later removes the misses already counted for it', () async {
    await run(lateEvening);
    expect(await db.qazaDao.owed(), isNotEmpty);
    await db.pauseRangesDao.addRange('2026-10-15', '2026-10-15');
    await run(lateEvening);
    expect((await db.qazaDao.owed()).values.fold<int>(0, (a, b) => a + b), 0);
  });

  test('days before the starting date are never counted or touched', () async {
    final from = DateTime(2026, 10, 15);
    expect(await run(lateEvening, from: from), 4);
    // Yesterday had nothing ticked but is before `from`.
    expect(await db.qazaDao.autoKeys().then((k) => k.any((e) => e.startsWith('2026-10-14'))), isFalse);
  });

  test('catches up several days at once', () async {
    final r = await run(nextMorning, from: DateTime(2026, 10, 12));
    // 12th, 13th, 14th and 15th: 5 each; the 16th has only Fajr ended by 08:00 PKT.
    expect(r, 5 * 4 + 1);
    expect((await db.qazaDao.owed())['fajr'], 5);
  });

  test('manually entered balances are kept and added to', () async {
    await db.qazaDao.setInitial('fajr', 100, DateTime.utc(2026, 10, 15));
    await run(lateEvening);
    expect((await db.qazaDao.owed())['fajr'], 101);
    // Ticking it later takes back only the auto one.
    await db.prayerLogsDao.markDone('2026-10-15', 'fajr', DateTime.utc(2026, 10, 15, 12));
    await run(lateEvening);
    expect((await db.qazaDao.owed())['fajr'], 100);
  });

  test('a start date in the future does nothing', () async {
    expect(await run(lateEvening, from: DateTime(2026, 11, 1)), 0);
  });

  test('windows used are the real ones (sanity: the sum of windows covers the day)', () {
    final day = calculator.compute(DateTime(2026, 10, 15), settings);
    final next = calculator.compute(DateTime(2026, 10, 16), settings);
    expect(prayerWindows(day, next), hasLength(5));
  });
}
