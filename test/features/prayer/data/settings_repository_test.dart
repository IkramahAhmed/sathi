import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/core/storage/app_database.dart';
import 'package:saathi/features/prayer/data/datasources/settings_local_data_source.dart';
import 'package:saathi/features/prayer/data/models/prayer_settings_dto.dart';
import 'package:saathi/features/prayer/data/repositories/settings_repository_impl.dart';
import 'package:saathi/features/prayer/domain/entities/calc_method.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_name.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;
  late AppDatabase db;
  late SettingsRepositoryImpl repo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    db = AppDatabase(NativeDatabase.memory());
    repo = SettingsRepositoryImpl(
      SettingsLocalDataSource(prefs),
      history: db.settingsHistoryDao,
      clock: () => DateTime.utc(2026, 10, 12),
    );
  });

  tearDown(() => db.close());

  test('first run returns the Karachi / Hanafi defaults', () async {
    final s = await repo.load();
    expect(s.cityName, 'Karachi');
    expect(s.method, CalcMethod.karachi);
    expect(s.madhab, Madhab.hanafi);
    expect(s.azanFor(PrayerName.sunrise), isFalse, reason: 'sunrise has no azan');
    expect(s.azanFor(PrayerName.fajr), isTrue);
    expect(s.followMeLocation, isTrue);
  });

  test('saved settings round-trip exactly, including manual overrides', () async {
    final custom = PrayerSettings.defaults().copyWith(
      lat: 31.5204,
      lng: 74.3587,
      cityName: 'Lahore',
      method: CalcMethod.egyptian,
      methodIsManual: true,
      madhab: Madhab.shafi,
      madhabIsManual: true,
      highLat: HighLatitudeRule.seventhOfTheNight,
      adjustmentsMin: {for (final p in PrayerName.values) p: p == PrayerName.fajr ? -3 : 2},
      preReminderMin: {for (final p in PrayerName.values) p: p == PrayerName.isha ? 15 : 0},
      sound: AzanSound.madina,
      hijriAdjustDays: -1,
      localeTag: 'en_PK',
    );
    await repo.save(custom);

    final reloaded = await repo.load();
    expect(reloaded, custom);
    expect(reloaded.methodIsManual, isTrue);
    expect(reloaded.sound, AzanSound.madina);
    expect(reloaded.adjustmentFor(PrayerName.fajr), -3);
  });

  test('missing per-prayer entries are filled from defaults when loading old data', () async {
    await prefs.setString(
      'prayer_settings_v1',
      jsonEncode({'cityName': 'Quetta', 'azanEnabled': {'fajr': false}}),
    );
    final s = await repo.load();
    expect(s.cityName, 'Quetta');
    expect(s.azanFor(PrayerName.fajr), isFalse);
    expect(s.azanFor(PrayerName.asr), isTrue);
    expect(s.adjustmentsMin.length, PrayerName.values.length);
  });

  test('corrupted stored settings fall back to defaults instead of crashing', () async {
    await prefs.setString('prayer_settings_v1', '{not json');
    expect((await repo.load()).cityName, 'Karachi');
  });

  test('hijri adjustment is clamped to -1..+1 when loading', () {
    final dto = PrayerSettingsDto.fromJson({'hijriAdjustDays': 9});
    expect(dto.toEntity().hijriAdjustDays, 1);
  });

  test('watch() emits every saved change', () async {
    final emitted = <PrayerSettings>[];
    final sub = repo.watch().listen(emitted.add);
    await repo.save(PrayerSettings.defaults().copyWith(cityName: 'A'));
    await repo.save(PrayerSettings.defaults().copyWith(cityName: 'B'));
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    expect(emitted.map((s) => s.cityName), ['A', 'B']);
  });

  test('only changed keys are recorded in the settings history', () async {
    await repo.save(PrayerSettings.defaults().copyWith(sound: AzanSound.makkah, hijriAdjustDays: 1));
    final rows = await db.settingsHistoryDao.recent();
    final keys = rows.map((r) => r.settingKey).toSet();
    expect(keys, {'sound', 'hijriAdjustDays'});
    final sound = rows.firstWhere((r) => r.settingKey == 'sound');
    expect(jsonDecode(sound.oldValue!), 'beep');
    expect(jsonDecode(sound.newValue), 'makkah');
    expect(sound.changedAt.toUtc(), DateTime.utc(2026, 10, 12));
  });

  test('saving identical settings writes no history', () async {
    await repo.save(PrayerSettings.defaults());
    expect(await db.settingsHistoryDao.recent(), isEmpty);
  });

  test('small flags persist: last scheduled, onboarding, oem guide', () async {
    expect(await repo.lastScheduledAt(), isNull);
    expect(await repo.isOnboardingDone(), isFalse);
    expect(await repo.isOemGuideShown(), isFalse);

    final at = DateTime.utc(2026, 10, 12, 7, 30);
    await repo.setLastScheduledAt(at);
    await repo.setOnboardingDone(done: true);
    await repo.setOemGuideShown(shown: true);

    expect(await repo.lastScheduledAt(), at);
    expect(await repo.isOnboardingDone(), isTrue);
    expect(await repo.isOemGuideShown(), isTrue);
  });
}
