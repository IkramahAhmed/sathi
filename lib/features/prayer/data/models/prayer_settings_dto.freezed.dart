// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prayer_settings_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PrayerSettingsDto {

 double get lat; double get lng; String get countryCode; String get timezoneId; String get cityName; CalcMethod get method; Madhab get madhab; HighLatitudeRule get highLat; Map<PrayerName, int> get adjustmentsMin; Map<PrayerName, bool> get azanEnabled; Map<PrayerName, int> get preReminderMin;@JsonKey(fromJson: _soundFromJson, toJson: _soundToJson) AzanSound get sound; int get hijriAdjustDays; bool get followMeLocation; bool get methodIsManual; bool get madhabIsManual; String get localeTag;
/// Create a copy of PrayerSettingsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrayerSettingsDtoCopyWith<PrayerSettingsDto> get copyWith => _$PrayerSettingsDtoCopyWithImpl<PrayerSettingsDto>(this as PrayerSettingsDto, _$identity);

  /// Serializes this PrayerSettingsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PrayerSettingsDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrayerSettingsDto&&(identical(other.lat, _this.lat) || other.lat == _this.lat)&&(identical(other.lng, _this.lng) || other.lng == _this.lng)&&(identical(other.countryCode, _this.countryCode) || other.countryCode == _this.countryCode)&&(identical(other.timezoneId, _this.timezoneId) || other.timezoneId == _this.timezoneId)&&(identical(other.cityName, _this.cityName) || other.cityName == _this.cityName)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.madhab, _this.madhab) || other.madhab == _this.madhab)&&(identical(other.highLat, _this.highLat) || other.highLat == _this.highLat)&&const DeepCollectionEquality().equals(other.adjustmentsMin, _this.adjustmentsMin)&&const DeepCollectionEquality().equals(other.azanEnabled, _this.azanEnabled)&&const DeepCollectionEquality().equals(other.preReminderMin, _this.preReminderMin)&&(identical(other.sound, _this.sound) || other.sound == _this.sound)&&(identical(other.hijriAdjustDays, _this.hijriAdjustDays) || other.hijriAdjustDays == _this.hijriAdjustDays)&&(identical(other.followMeLocation, _this.followMeLocation) || other.followMeLocation == _this.followMeLocation)&&(identical(other.methodIsManual, _this.methodIsManual) || other.methodIsManual == _this.methodIsManual)&&(identical(other.madhabIsManual, _this.madhabIsManual) || other.madhabIsManual == _this.madhabIsManual)&&(identical(other.localeTag, _this.localeTag) || other.localeTag == _this.localeTag));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PrayerSettingsDto;
  return Object.hash(runtimeType,_this.lat,_this.lng,_this.countryCode,_this.timezoneId,_this.cityName,_this.method,_this.madhab,_this.highLat,const DeepCollectionEquality().hash(_this.adjustmentsMin),const DeepCollectionEquality().hash(_this.azanEnabled),const DeepCollectionEquality().hash(_this.preReminderMin),_this.sound,_this.hijriAdjustDays,_this.followMeLocation,_this.methodIsManual,_this.madhabIsManual,_this.localeTag);
}

@override
String toString() {
  final _this = this as PrayerSettingsDto;
  return 'PrayerSettingsDto(lat: ${_this.lat}, lng: ${_this.lng}, countryCode: ${_this.countryCode}, timezoneId: ${_this.timezoneId}, cityName: ${_this.cityName}, method: ${_this.method}, madhab: ${_this.madhab}, highLat: ${_this.highLat}, adjustmentsMin: ${_this.adjustmentsMin}, azanEnabled: ${_this.azanEnabled}, preReminderMin: ${_this.preReminderMin}, sound: ${_this.sound}, hijriAdjustDays: ${_this.hijriAdjustDays}, followMeLocation: ${_this.followMeLocation}, methodIsManual: ${_this.methodIsManual}, madhabIsManual: ${_this.madhabIsManual}, localeTag: ${_this.localeTag})';
}


}

/// @nodoc
abstract mixin class $PrayerSettingsDtoCopyWith<$Res>  {
  factory $PrayerSettingsDtoCopyWith(PrayerSettingsDto value, $Res Function(PrayerSettingsDto) _then) = _$PrayerSettingsDtoCopyWithImpl;
@useResult
$Res call({
 double lat, double lng, String countryCode, String timezoneId, String cityName, CalcMethod method, Madhab madhab, HighLatitudeRule highLat, Map<PrayerName, int> adjustmentsMin, Map<PrayerName, bool> azanEnabled, Map<PrayerName, int> preReminderMin,@JsonKey(fromJson: _soundFromJson, toJson: _soundToJson) AzanSound sound, int hijriAdjustDays, bool followMeLocation, bool methodIsManual, bool madhabIsManual, String localeTag
});




}
/// @nodoc
class _$PrayerSettingsDtoCopyWithImpl<$Res>
    implements $PrayerSettingsDtoCopyWith<$Res> {
  _$PrayerSettingsDtoCopyWithImpl(this._self, this._then);

  final PrayerSettingsDto _self;
  final $Res Function(PrayerSettingsDto) _then;

/// Create a copy of PrayerSettingsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lat = null,Object? lng = null,Object? countryCode = null,Object? timezoneId = null,Object? cityName = null,Object? method = null,Object? madhab = null,Object? highLat = null,Object? adjustmentsMin = null,Object? azanEnabled = null,Object? preReminderMin = null,Object? sound = null,Object? hijriAdjustDays = null,Object? followMeLocation = null,Object? methodIsManual = null,Object? madhabIsManual = null,Object? localeTag = null,}) {
  return _then(PrayerSettingsDto(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,timezoneId: null == timezoneId ? _self.timezoneId : timezoneId // ignore: cast_nullable_to_non_nullable
as String,cityName: null == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as CalcMethod,madhab: null == madhab ? _self.madhab : madhab // ignore: cast_nullable_to_non_nullable
as Madhab,highLat: null == highLat ? _self.highLat : highLat // ignore: cast_nullable_to_non_nullable
as HighLatitudeRule,adjustmentsMin: null == adjustmentsMin ? _self.adjustmentsMin : adjustmentsMin // ignore: cast_nullable_to_non_nullable
as Map<PrayerName, int>,azanEnabled: null == azanEnabled ? _self.azanEnabled : azanEnabled // ignore: cast_nullable_to_non_nullable
as Map<PrayerName, bool>,preReminderMin: null == preReminderMin ? _self.preReminderMin : preReminderMin // ignore: cast_nullable_to_non_nullable
as Map<PrayerName, int>,sound: null == sound ? _self.sound : sound // ignore: cast_nullable_to_non_nullable
as AzanSound,hijriAdjustDays: null == hijriAdjustDays ? _self.hijriAdjustDays : hijriAdjustDays // ignore: cast_nullable_to_non_nullable
as int,followMeLocation: null == followMeLocation ? _self.followMeLocation : followMeLocation // ignore: cast_nullable_to_non_nullable
as bool,methodIsManual: null == methodIsManual ? _self.methodIsManual : methodIsManual // ignore: cast_nullable_to_non_nullable
as bool,madhabIsManual: null == madhabIsManual ? _self.madhabIsManual : madhabIsManual // ignore: cast_nullable_to_non_nullable
as bool,localeTag: null == localeTag ? _self.localeTag : localeTag // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PrayerSettingsDto].
extension PrayerSettingsDtoPatterns on PrayerSettingsDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrayerSettingsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrayerSettingsDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrayerSettingsDto value)  $default,){
final _that = this;
switch (_that) {
case _PrayerSettingsDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrayerSettingsDto value)?  $default,){
final _that = this;
switch (_that) {
case _PrayerSettingsDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double lat,  double lng,  String countryCode,  String timezoneId,  String cityName,  CalcMethod method,  Madhab madhab,  HighLatitudeRule highLat,  Map<PrayerName, int> adjustmentsMin,  Map<PrayerName, bool> azanEnabled,  Map<PrayerName, int> preReminderMin, @JsonKey(fromJson: _soundFromJson, toJson: _soundToJson)  AzanSound sound,  int hijriAdjustDays,  bool followMeLocation,  bool methodIsManual,  bool madhabIsManual,  String localeTag)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrayerSettingsDto() when $default != null:
return $default(_that.lat,_that.lng,_that.countryCode,_that.timezoneId,_that.cityName,_that.method,_that.madhab,_that.highLat,_that.adjustmentsMin,_that.azanEnabled,_that.preReminderMin,_that.sound,_that.hijriAdjustDays,_that.followMeLocation,_that.methodIsManual,_that.madhabIsManual,_that.localeTag);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double lat,  double lng,  String countryCode,  String timezoneId,  String cityName,  CalcMethod method,  Madhab madhab,  HighLatitudeRule highLat,  Map<PrayerName, int> adjustmentsMin,  Map<PrayerName, bool> azanEnabled,  Map<PrayerName, int> preReminderMin, @JsonKey(fromJson: _soundFromJson, toJson: _soundToJson)  AzanSound sound,  int hijriAdjustDays,  bool followMeLocation,  bool methodIsManual,  bool madhabIsManual,  String localeTag)  $default,) {final _that = this;
switch (_that) {
case _PrayerSettingsDto():
return $default(_that.lat,_that.lng,_that.countryCode,_that.timezoneId,_that.cityName,_that.method,_that.madhab,_that.highLat,_that.adjustmentsMin,_that.azanEnabled,_that.preReminderMin,_that.sound,_that.hijriAdjustDays,_that.followMeLocation,_that.methodIsManual,_that.madhabIsManual,_that.localeTag);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double lat,  double lng,  String countryCode,  String timezoneId,  String cityName,  CalcMethod method,  Madhab madhab,  HighLatitudeRule highLat,  Map<PrayerName, int> adjustmentsMin,  Map<PrayerName, bool> azanEnabled,  Map<PrayerName, int> preReminderMin, @JsonKey(fromJson: _soundFromJson, toJson: _soundToJson)  AzanSound sound,  int hijriAdjustDays,  bool followMeLocation,  bool methodIsManual,  bool madhabIsManual,  String localeTag)?  $default,) {final _that = this;
switch (_that) {
case _PrayerSettingsDto() when $default != null:
return $default(_that.lat,_that.lng,_that.countryCode,_that.timezoneId,_that.cityName,_that.method,_that.madhab,_that.highLat,_that.adjustmentsMin,_that.azanEnabled,_that.preReminderMin,_that.sound,_that.hijriAdjustDays,_that.followMeLocation,_that.methodIsManual,_that.madhabIsManual,_that.localeTag);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PrayerSettingsDto extends PrayerSettingsDto {
  const _PrayerSettingsDto({this.lat = 24.8607, this.lng = 67.0011, this.countryCode = 'PK', this.timezoneId = 'Asia/Karachi', this.cityName = 'Karachi', this.method = CalcMethod.karachi, this.madhab = Madhab.hanafi, this.highLat = HighLatitudeRule.middleOfTheNight,  Map<PrayerName, int> adjustmentsMin = const <PrayerName, int>{},  Map<PrayerName, bool> azanEnabled = const <PrayerName, bool>{},  Map<PrayerName, int> preReminderMin = const <PrayerName, int>{}, @JsonKey(fromJson: _soundFromJson, toJson: _soundToJson) this.sound = AzanSound.beep, this.hijriAdjustDays = 0, this.followMeLocation = true, this.methodIsManual = false, this.madhabIsManual = false, this.localeTag = 'en'}): _adjustmentsMin = adjustmentsMin,_azanEnabled = azanEnabled,_preReminderMin = preReminderMin,super._();
  factory _PrayerSettingsDto.fromJson(Map<String, dynamic> json) => _$PrayerSettingsDtoFromJson(json);

@override@JsonKey() final  double lat;
@override@JsonKey() final  double lng;
@override@JsonKey() final  String countryCode;
@override@JsonKey() final  String timezoneId;
@override@JsonKey() final  String cityName;
@override@JsonKey() final  CalcMethod method;
@override@JsonKey() final  Madhab madhab;
@override@JsonKey() final  HighLatitudeRule highLat;
 final  Map<PrayerName, int> _adjustmentsMin;
@override@JsonKey() Map<PrayerName, int> get adjustmentsMin {
  if (_adjustmentsMin is EqualUnmodifiableMapView) return _adjustmentsMin;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_adjustmentsMin);
}

 final  Map<PrayerName, bool> _azanEnabled;
@override@JsonKey() Map<PrayerName, bool> get azanEnabled {
  if (_azanEnabled is EqualUnmodifiableMapView) return _azanEnabled;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_azanEnabled);
}

 final  Map<PrayerName, int> _preReminderMin;
@override@JsonKey() Map<PrayerName, int> get preReminderMin {
  if (_preReminderMin is EqualUnmodifiableMapView) return _preReminderMin;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_preReminderMin);
}

@override@JsonKey(fromJson: _soundFromJson, toJson: _soundToJson) final  AzanSound sound;
@override@JsonKey() final  int hijriAdjustDays;
@override@JsonKey() final  bool followMeLocation;
@override@JsonKey() final  bool methodIsManual;
@override@JsonKey() final  bool madhabIsManual;
@override@JsonKey() final  String localeTag;

/// Create a copy of PrayerSettingsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrayerSettingsDtoCopyWith<_PrayerSettingsDto> get copyWith => __$PrayerSettingsDtoCopyWithImpl<_PrayerSettingsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrayerSettingsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrayerSettingsDto&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.timezoneId, timezoneId) || other.timezoneId == timezoneId)&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.method, method) || other.method == method)&&(identical(other.madhab, madhab) || other.madhab == madhab)&&(identical(other.highLat, highLat) || other.highLat == highLat)&&const DeepCollectionEquality().equals(other.adjustmentsMin, _adjustmentsMin)&&const DeepCollectionEquality().equals(other.azanEnabled, _azanEnabled)&&const DeepCollectionEquality().equals(other.preReminderMin, _preReminderMin)&&(identical(other.sound, sound) || other.sound == sound)&&(identical(other.hijriAdjustDays, hijriAdjustDays) || other.hijriAdjustDays == hijriAdjustDays)&&(identical(other.followMeLocation, followMeLocation) || other.followMeLocation == followMeLocation)&&(identical(other.methodIsManual, methodIsManual) || other.methodIsManual == methodIsManual)&&(identical(other.madhabIsManual, madhabIsManual) || other.madhabIsManual == madhabIsManual)&&(identical(other.localeTag, localeTag) || other.localeTag == localeTag));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,lat,lng,countryCode,timezoneId,cityName,method,madhab,highLat,const DeepCollectionEquality().hash(_adjustmentsMin),const DeepCollectionEquality().hash(_azanEnabled),const DeepCollectionEquality().hash(_preReminderMin),sound,hijriAdjustDays,followMeLocation,methodIsManual,madhabIsManual,localeTag);
}

@override
String toString() {
    return 'PrayerSettingsDto(lat: $lat, lng: $lng, countryCode: $countryCode, timezoneId: $timezoneId, cityName: $cityName, method: $method, madhab: $madhab, highLat: $highLat, adjustmentsMin: $adjustmentsMin, azanEnabled: $azanEnabled, preReminderMin: $preReminderMin, sound: $sound, hijriAdjustDays: $hijriAdjustDays, followMeLocation: $followMeLocation, methodIsManual: $methodIsManual, madhabIsManual: $madhabIsManual, localeTag: $localeTag)';
}


}

/// @nodoc
abstract mixin class _$PrayerSettingsDtoCopyWith<$Res> implements $PrayerSettingsDtoCopyWith<$Res> {
  factory _$PrayerSettingsDtoCopyWith(_PrayerSettingsDto value, $Res Function(_PrayerSettingsDto) _then) = __$PrayerSettingsDtoCopyWithImpl;
@override @useResult
$Res call({
 double lat, double lng, String countryCode, String timezoneId, String cityName, CalcMethod method, Madhab madhab, HighLatitudeRule highLat, Map<PrayerName, int> adjustmentsMin, Map<PrayerName, bool> azanEnabled, Map<PrayerName, int> preReminderMin,@JsonKey(fromJson: _soundFromJson, toJson: _soundToJson) AzanSound sound, int hijriAdjustDays, bool followMeLocation, bool methodIsManual, bool madhabIsManual, String localeTag
});




}
/// @nodoc
class __$PrayerSettingsDtoCopyWithImpl<$Res>
    implements _$PrayerSettingsDtoCopyWith<$Res> {
  __$PrayerSettingsDtoCopyWithImpl(this._self, this._then);

  final _PrayerSettingsDto _self;
  final $Res Function(_PrayerSettingsDto) _then;

/// Create a copy of PrayerSettingsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lat = null,Object? lng = null,Object? countryCode = null,Object? timezoneId = null,Object? cityName = null,Object? method = null,Object? madhab = null,Object? highLat = null,Object? adjustmentsMin = null,Object? azanEnabled = null,Object? preReminderMin = null,Object? sound = null,Object? hijriAdjustDays = null,Object? followMeLocation = null,Object? methodIsManual = null,Object? madhabIsManual = null,Object? localeTag = null,}) {
  return _then(_PrayerSettingsDto(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,timezoneId: null == timezoneId ? _self.timezoneId : timezoneId // ignore: cast_nullable_to_non_nullable
as String,cityName: null == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as CalcMethod,madhab: null == madhab ? _self.madhab : madhab // ignore: cast_nullable_to_non_nullable
as Madhab,highLat: null == highLat ? _self.highLat : highLat // ignore: cast_nullable_to_non_nullable
as HighLatitudeRule,adjustmentsMin: null == adjustmentsMin ? _self._adjustmentsMin : adjustmentsMin // ignore: cast_nullable_to_non_nullable
as Map<PrayerName, int>,azanEnabled: null == azanEnabled ? _self._azanEnabled : azanEnabled // ignore: cast_nullable_to_non_nullable
as Map<PrayerName, bool>,preReminderMin: null == preReminderMin ? _self._preReminderMin : preReminderMin // ignore: cast_nullable_to_non_nullable
as Map<PrayerName, int>,sound: null == sound ? _self.sound : sound // ignore: cast_nullable_to_non_nullable
as AzanSound,hijriAdjustDays: null == hijriAdjustDays ? _self.hijriAdjustDays : hijriAdjustDays // ignore: cast_nullable_to_non_nullable
as int,followMeLocation: null == followMeLocation ? _self.followMeLocation : followMeLocation // ignore: cast_nullable_to_non_nullable
as bool,methodIsManual: null == methodIsManual ? _self.methodIsManual : methodIsManual // ignore: cast_nullable_to_non_nullable
as bool,madhabIsManual: null == madhabIsManual ? _self.madhabIsManual : madhabIsManual // ignore: cast_nullable_to_non_nullable
as bool,localeTag: null == localeTag ? _self.localeTag : localeTag // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
