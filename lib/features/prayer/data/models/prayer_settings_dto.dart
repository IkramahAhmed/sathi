import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/calc_method.dart';
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
    @Default(AzanSound.beep)
    AzanSound sound,
    @Default(0) int hijriAdjustDays,
    @Default(true) bool followMeLocation,
    @Default(false) bool methodIsManual,
    @Default(false) bool madhabIsManual,
    @Default('en') String localeTag,
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
    );
  }
}
