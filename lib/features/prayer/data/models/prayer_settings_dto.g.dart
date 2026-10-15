// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_settings_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PrayerSettingsDto _$PrayerSettingsDtoFromJson(
  Map<String, dynamic> json,
) => _PrayerSettingsDto(
  lat: (json['lat'] as num?)?.toDouble() ?? 24.8607,
  lng: (json['lng'] as num?)?.toDouble() ?? 67.0011,
  countryCode: json['countryCode'] as String? ?? 'PK',
  timezoneId: json['timezoneId'] as String? ?? 'Asia/Karachi',
  cityName: json['cityName'] as String? ?? 'Karachi',
  method:
      $enumDecodeNullable(_$CalcMethodEnumMap, json['method']) ??
      CalcMethod.karachi,
  madhab: $enumDecodeNullable(_$MadhabEnumMap, json['madhab']) ?? Madhab.hanafi,
  highLat:
      $enumDecodeNullable(_$HighLatitudeRuleEnumMap, json['highLat']) ??
      HighLatitudeRule.middleOfTheNight,
  adjustmentsMin:
      (json['adjustmentsMin'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry($enumDecode(_$PrayerNameEnumMap, k), (e as num).toInt()),
      ) ??
      const <PrayerName, int>{},
  azanEnabled:
      (json['azanEnabled'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry($enumDecode(_$PrayerNameEnumMap, k), e as bool),
      ) ??
      const <PrayerName, bool>{},
  preReminderMin:
      (json['preReminderMin'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry($enumDecode(_$PrayerNameEnumMap, k), (e as num).toInt()),
      ) ??
      const <PrayerName, int>{},
  sound: json['sound'] == null ? AzanSound.beep : _soundFromJson(json['sound']),
  hijriAdjustDays: (json['hijriAdjustDays'] as num?)?.toInt() ?? 0,
  followMeLocation: json['followMeLocation'] as bool? ?? true,
  methodIsManual: json['methodIsManual'] as bool? ?? false,
  madhabIsManual: json['madhabIsManual'] as bool? ?? false,
  localeTag: json['localeTag'] as String? ?? 'en',
  jamaatOffsetMin:
      (json['jamaatOffsetMin'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry($enumDecode(_$PrayerNameEnumMap, k), (e as num).toInt()),
      ) ??
      const <PrayerName, int>{},
  jamaatFixedMin:
      (json['jamaatFixedMin'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry($enumDecode(_$PrayerNameEnumMap, k), (e as num).toInt()),
      ) ??
      const <PrayerName, int>{},
  jummaFixedMin: (json['jummaFixedMin'] as num?)?.toInt(),
  leaveReminderMin: (json['leaveReminderMin'] as num?)?.toInt() ?? 0,
  silentDuringJamaat: json['silentDuringJamaat'] as bool? ?? false,
  silentMinutes: (json['silentMinutes'] as num?)?.toInt() ?? 15,
  endReminderEnabled: json['endReminderEnabled'] as bool? ?? false,
  endReminderPrayers:
      (json['endReminderPrayers'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry($enumDecode(_$PrayerNameEnumMap, k), e as bool),
      ) ??
      const <PrayerName, bool>{},
  endLeadMin: (json['endLeadMin'] as num?)?.toInt() ?? 30,
  endRepeatMin: (json['endRepeatMin'] as num?)?.toInt() ?? 10,
  endRequirePhoto: json['endRequirePhoto'] as bool? ?? false,
  azanOnAlarm: json['azanOnAlarm'] as bool? ?? false,
  autoQazaFrom: json['autoQazaFrom'] as String?,
);

Map<String, dynamic> _$PrayerSettingsDtoToJson(_PrayerSettingsDto instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'countryCode': instance.countryCode,
      'timezoneId': instance.timezoneId,
      'cityName': instance.cityName,
      'method': _$CalcMethodEnumMap[instance.method]!,
      'madhab': _$MadhabEnumMap[instance.madhab]!,
      'highLat': _$HighLatitudeRuleEnumMap[instance.highLat]!,
      'adjustmentsMin': instance.adjustmentsMin.map(
        (k, e) => MapEntry(_$PrayerNameEnumMap[k]!, e),
      ),
      'azanEnabled': instance.azanEnabled.map(
        (k, e) => MapEntry(_$PrayerNameEnumMap[k]!, e),
      ),
      'preReminderMin': instance.preReminderMin.map(
        (k, e) => MapEntry(_$PrayerNameEnumMap[k]!, e),
      ),
      'sound': _soundToJson(instance.sound),
      'hijriAdjustDays': instance.hijriAdjustDays,
      'followMeLocation': instance.followMeLocation,
      'methodIsManual': instance.methodIsManual,
      'madhabIsManual': instance.madhabIsManual,
      'localeTag': instance.localeTag,
      'jamaatOffsetMin': instance.jamaatOffsetMin.map(
        (k, e) => MapEntry(_$PrayerNameEnumMap[k]!, e),
      ),
      'jamaatFixedMin': instance.jamaatFixedMin.map(
        (k, e) => MapEntry(_$PrayerNameEnumMap[k]!, e),
      ),
      'jummaFixedMin': instance.jummaFixedMin,
      'leaveReminderMin': instance.leaveReminderMin,
      'silentDuringJamaat': instance.silentDuringJamaat,
      'silentMinutes': instance.silentMinutes,
      'endReminderEnabled': instance.endReminderEnabled,
      'endReminderPrayers': instance.endReminderPrayers.map(
        (k, e) => MapEntry(_$PrayerNameEnumMap[k]!, e),
      ),
      'endLeadMin': instance.endLeadMin,
      'endRepeatMin': instance.endRepeatMin,
      'endRequirePhoto': instance.endRequirePhoto,
      'azanOnAlarm': instance.azanOnAlarm,
      'autoQazaFrom': instance.autoQazaFrom,
    };

const _$CalcMethodEnumMap = {
  CalcMethod.karachi: 'karachi',
  CalcMethod.muslimWorldLeague: 'muslimWorldLeague',
  CalcMethod.ummAlQura: 'ummAlQura',
  CalcMethod.dubai: 'dubai',
  CalcMethod.qatar: 'qatar',
  CalcMethod.kuwait: 'kuwait',
  CalcMethod.egyptian: 'egyptian',
  CalcMethod.turkiye: 'turkiye',
  CalcMethod.singapore: 'singapore',
  CalcMethod.indonesian: 'indonesian',
  CalcMethod.northAmerica: 'northAmerica',
  CalcMethod.moonsightingCommittee: 'moonsightingCommittee',
};

const _$MadhabEnumMap = {Madhab.hanafi: 'hanafi', Madhab.shafi: 'shafi'};

const _$HighLatitudeRuleEnumMap = {
  HighLatitudeRule.middleOfTheNight: 'middleOfTheNight',
  HighLatitudeRule.seventhOfTheNight: 'seventhOfTheNight',
  HighLatitudeRule.twilightAngle: 'twilightAngle',
};

const _$PrayerNameEnumMap = {
  PrayerName.fajr: 'fajr',
  PrayerName.sunrise: 'sunrise',
  PrayerName.dhuhr: 'dhuhr',
  PrayerName.asr: 'asr',
  PrayerName.maghrib: 'maghrib',
  PrayerName.isha: 'isha',
};
