import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/calc_method.dart';
import '../../domain/entities/end_reminder.dart';
import '../../domain/entities/jamaat.dart';
import '../../domain/entities/prayer_name.dart';
import '../../domain/entities/prayer_settings.dart';

part 'prayer_settings_dto.freezed.dart';
part 'prayer_settings_dto.g.dart';

AzanSound _soundFromJson(Object? value) => AzanSound.fromStored(value as String?);

String _soundToJson(AzanSound sound) => sound.name;

/// Serializable form of [PrayerSettings]. Unknown or missing fields fall back
/// to the defaults so old stored settings keep loading after upgrades.
@freezed
abstract class PrayerSettingsDto with _$PrayerSettingsDto {
  const PrayerSettingsDto._();

  const factory PrayerSettingsDto({
    @Default(24.8607) double lat,
    @Default(67.0011) double lng,
    @Default('PK') String countryCode,
    @Default('Asia/Karachi') String timezoneId,
    @Default('Karachi') String cityName,
    @Default(CalcMethod.karachi) CalcMethod method,
    @Default(Madhab.hanafi) Madhab madhab,
    @Default(HighLatitudeRule.middleOfTheNight) HighLatitudeRule highLat,
    @Default(<PrayerName, int>{}) Map<PrayerName, int> adjustmentsMin,
    @Default(<PrayerName, bool>{}) Map<PrayerName, bool> azanEnabled,
    @Default(<PrayerName, int>{}) Map<PrayerName, int> preReminderMin,
    @JsonKey(fromJson: _soundFromJson, toJson: _soundToJson)
    @Default(AzanSound.full)
    AzanSound sound,
    @Default(0) int hijriAdjustDays,
    @Default(true) bool followMeLocation,
    @Default(false) bool methodIsManual,
    @Default(false) bool madhabIsManual,
    @Default('en') String localeTag,
    @Default(<PrayerName, int>{}) Map<PrayerName, int> jamaatOffsetMin,
    @Default(<PrayerName, int>{}) Map<PrayerName, int> jamaatFixedMin,
    int? jummaFixedMin,
    @Default(0) int leaveReminderMin,
    @Default(false) bool silentDuringJamaat,
    @Default(15) int silentMinutes,
    @Default(true) bool endReminderEnabled,
    @Default(<PrayerName, bool>{}) Map<PrayerName, bool> endReminderPrayers,
    @Default(999) int endLeadMin,
    @Default(5) int endRepeatMin,
    @Default(true) bool endRequirePhoto,
    @Default(true) bool azanOnAlarm,
    String? autoQazaFrom,
  }) = _PrayerSettingsDto;

  factory PrayerSettingsDto.fromJson(Map<String, dynamic> json) =>
      _$PrayerSettingsDtoFromJson(json);

  factory PrayerSettingsDto.fromEntity(PrayerSettings s) => PrayerSettingsDto(
        lat: s.lat,
        lng: s.lng,
        countryCode: s.countryCode,
        timezoneId: s.timezoneId,
        cityName: s.cityName,
        method: s.method,
        madhab: s.madhab,
        highLat: s.highLat,
        adjustmentsMin: s.adjustmentsMin,
        azanEnabled: s.azanEnabled,
        preReminderMin: s.preReminderMin,
        sound: s.sound,
        hijriAdjustDays: s.hijriAdjustDays,
        followMeLocation: s.followMeLocation,
        methodIsManual: s.methodIsManual,
        madhabIsManual: s.madhabIsManual,
        localeTag: s.localeTag,
        jamaatOffsetMin: s.jamaat.offsetMin,
        jamaatFixedMin: s.jamaat.fixedMin,
        jummaFixedMin: s.jamaat.jummaFixedMin,
        leaveReminderMin: s.jamaat.leaveReminderMin,
        silentDuringJamaat: s.jamaat.silentDuringJamaat,
        silentMinutes: s.jamaat.silentMinutes,
        endReminderEnabled: s.endReminder.enabled,
        endReminderPrayers: s.endReminder.prayers,
        endLeadMin: s.endReminder.leadMin,
        endRepeatMin: s.endReminder.repeatMin,
        endRequirePhoto: s.endReminder.requirePhoto,
        azanOnAlarm: s.azanOnAlarm,
        autoQazaFrom: s.autoQazaFrom,
      );

  /// Converts to the domain entity, filling any missing per-prayer entries
  /// from the defaults.
  PrayerSettings toEntity() {
    final defaults = PrayerSettings.defaults();
    return PrayerSettings(
      lat: lat,
      lng: lng,
      countryCode: countryCode,
      timezoneId: timezoneId,
      cityName: cityName,
      method: method,
      madhab: madhab,
      highLat: highLat,
      adjustmentsMin: {
        for (final p in PrayerName.values) p: adjustmentsMin[p] ?? defaults.adjustmentsMin[p]!,
      },
      azanEnabled: {
        for (final p in PrayerName.values) p: azanEnabled[p] ?? defaults.azanEnabled[p]!,
      },
      preReminderMin: {
        for (final p in PrayerName.values) p: preReminderMin[p] ?? defaults.preReminderMin[p]!,
      },
      sound: sound,
      hijriAdjustDays: hijriAdjustDays.clamp(-1, 1),
      followMeLocation: followMeLocation,
      methodIsManual: methodIsManual,
      madhabIsManual: madhabIsManual,
      localeTag: localeTag,
      jamaat: JamaatSettings(
        offsetMin: {for (final e in jamaatOffsetMin.entries) if (e.key.hasAzan) e.key: e.value.clamp(0, 120)},
        fixedMin: {for (final e in jamaatFixedMin.entries) if (e.key.hasAzan) e.key: e.value.clamp(0, 1439)},
        jummaFixedMin: jummaFixedMin?.clamp(0, 1439),
        leaveReminderMin: leaveReminderMin.clamp(0, 120),
        silentDuringJamaat: silentDuringJamaat,
        silentMinutes: silentMinutes.clamp(5, 90),
      ),
      endReminder: EndReminderSettings(
        enabled: endReminderEnabled,
        prayers: {
          for (final p in PrayerName.obligatory) p: endReminderPrayers[p] ?? true,
        },
        leadMin: endLeadMin.clamp(5, 999),
        repeatMin: endRepeatMin.clamp(1, 60),
        requirePhoto: endRequirePhoto,
      ),
      azanOnAlarm: azanOnAlarm,
      autoQazaFrom: autoQazaFrom,
    );
  }
}
