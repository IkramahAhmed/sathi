import 'calc_method.dart';
import 'end_reminder.dart';
import 'jamaat.dart';
import 'prayer_name.dart';

/// All user-controllable prayer configuration plus the resolved location.
class PrayerSettings {
  const PrayerSettings({
    required this.lat,
    required this.lng,
    required this.countryCode,
    required this.timezoneId,
    required this.cityName,
    required this.method,
    required this.madhab,
    required this.highLat,
    required this.adjustmentsMin,
    required this.azanEnabled,
    required this.preReminderMin,
    required this.sound,
    required this.hijriAdjustDays,
    required this.followMeLocation,
    required this.methodIsManual,
    required this.madhabIsManual,
    required this.localeTag,
    this.jamaat = const JamaatSettings(),
    this.endReminder = const EndReminderSettings(),
    this.azanOnAlarm = true,
    this.autoQazaFrom,
  });

  /// Defaults for a first run in Karachi, Pakistan.
  factory PrayerSettings.defaults() => PrayerSettings(
        lat: 24.8607,
        lng: 67.0011,
        countryCode: 'PK',
        timezoneId: 'Asia/Karachi',
        cityName: 'Karachi',
        method: CalcMethod.karachi,
        madhab: Madhab.hanafi,
        highLat: HighLatitudeRule.middleOfTheNight,
        adjustmentsMin: {for (final p in PrayerName.values) p: 0},
        azanEnabled: {
          for (final p in PrayerName.values) p: p.hasAzan,
        },
        preReminderMin: {for (final p in PrayerName.values) p: 0},
        sound: AzanSound.full,
        hijriAdjustDays: 0,
        followMeLocation: true,
        methodIsManual: false,
        madhabIsManual: false,
        localeTag: 'en',
      );

  final double lat;
  final double lng;
  final String countryCode;
  final String timezoneId;
  final String cityName;

  /// The effective method. Auto-resolved from [countryCode] unless
  /// [methodIsManual] is true.
  final CalcMethod method;
  final Madhab madhab;
  final HighLatitudeRule highLat;

  /// "Masjid time" correction in minutes per prayer.
  final Map<PrayerName, int> adjustmentsMin;
  final Map<PrayerName, bool> azanEnabled;

  /// Minutes before the prayer to show a reminder. 0 means off.
  final Map<PrayerName, int> preReminderMin;
  final AzanSound sound;

  /// Moon-sighting correction, -1..+1 days.
  final int hijriAdjustDays;

  /// Recompute when the device moves more than 50 km.
  final bool followMeLocation;
  final bool methodIsManual;
  final bool madhabIsManual;

  /// `en`, `ur` or `en_PK` (Roman Urdu).
  final String localeTag;

  /// Mosque jama'at times and the reminders that go with them.
  final JamaatSettings jamaat;

  /// "This prayer is about to end" reminders, optionally needing photo proof.
  final EndReminderSettings endReminder;

  /// Play the azan on the alarm volume, so it is heard in silent mode and does
  /// not depend on the media volume.
  final bool azanOnAlarm;

  /// Missed prayers are counted automatically from this date (`yyyy-MM-dd`).
  /// Null means automatic counting is off.
  final String? autoQazaFrom;

  int adjustmentFor(PrayerName p) => adjustmentsMin[p] ?? 0;
  bool azanFor(PrayerName p) => azanEnabled[p] ?? false;
  int preReminderFor(PrayerName p) => preReminderMin[p] ?? 0;

  PrayerSettings copyWith({
    double? lat,
    double? lng,
    String? countryCode,
    String? timezoneId,
    String? cityName,
    CalcMethod? method,
    Madhab? madhab,
    HighLatitudeRule? highLat,
    Map<PrayerName, int>? adjustmentsMin,
    Map<PrayerName, bool>? azanEnabled,
    Map<PrayerName, int>? preReminderMin,
    AzanSound? sound,
    int? hijriAdjustDays,
    bool? followMeLocation,
    bool? methodIsManual,
    bool? madhabIsManual,
    String? localeTag,
    JamaatSettings? jamaat,
    EndReminderSettings? endReminder,
    bool? azanOnAlarm,
    String? autoQazaFrom,
    bool clearAutoQaza = false,
  }) =>
      PrayerSettings(
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        countryCode: countryCode ?? this.countryCode,
        timezoneId: timezoneId ?? this.timezoneId,
        cityName: cityName ?? this.cityName,
        method: method ?? this.method,
        madhab: madhab ?? this.madhab,
        highLat: highLat ?? this.highLat,
        adjustmentsMin: adjustmentsMin ?? this.adjustmentsMin,
        azanEnabled: azanEnabled ?? this.azanEnabled,
        preReminderMin: preReminderMin ?? this.preReminderMin,
        sound: sound ?? this.sound,
        hijriAdjustDays: hijriAdjustDays ?? this.hijriAdjustDays,
        followMeLocation: followMeLocation ?? this.followMeLocation,
        methodIsManual: methodIsManual ?? this.methodIsManual,
        madhabIsManual: madhabIsManual ?? this.madhabIsManual,
        localeTag: localeTag ?? this.localeTag,
        jamaat: jamaat ?? this.jamaat,
        endReminder: endReminder ?? this.endReminder,
        azanOnAlarm: azanOnAlarm ?? this.azanOnAlarm,
        autoQazaFrom: clearAutoQaza ? null : (autoQazaFrom ?? this.autoQazaFrom),
      );

  /// A stable, comparable snapshot used for change detection and history.
  Map<String, Object?> toComparableMap() => {
        'lat': lat,
        'lng': lng,
        'countryCode': countryCode,
        'timezoneId': timezoneId,
        'cityName': cityName,
        'method': method.name,
        'madhab': madhab.name,
        'highLat': highLat.name,
        'adjustmentsMin': {for (final e in adjustmentsMin.entries) e.key.name: e.value},
        'azanEnabled': {for (final e in azanEnabled.entries) e.key.name: e.value},
        'preReminderMin': {for (final e in preReminderMin.entries) e.key.name: e.value},
        'sound': sound.name,
        'hijriAdjustDays': hijriAdjustDays,
        'followMeLocation': followMeLocation,
        'methodIsManual': methodIsManual,
        'madhabIsManual': madhabIsManual,
        'localeTag': localeTag,
        'jamaat': jamaat.toComparableMap(),
        'endReminder': endReminder.toComparableMap(),
        'azanOnAlarm': azanOnAlarm,
        'autoQazaFrom': autoQazaFrom,
      };

  @override
  bool operator ==(Object other) =>
      other is PrayerSettings &&
      _deepEquals(toComparableMap(), other.toComparableMap());

  @override
  int get hashCode => Object.hashAll(
        toComparableMap().entries.map((e) => Object.hash(e.key, _deepHash(e.value))),
      );
}

bool _deepEquals(Object? a, Object? b) {
  if (a is Map && b is Map) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || !_deepEquals(a[key], b[key])) return false;
    }
    return true;
  }
  return a == b;
}

int _deepHash(Object? v) =>
    v is Map ? Object.hashAll(v.entries.map((e) => Object.hash(e.key, _deepHash(e.value)))) : v.hashCode;
