import 'prayer_name.dart';

/// Notification copy. Kept in pure Dart because notifications are also built
/// from a background isolate that has no `BuildContext` / l10n delegate.
class NotificationTexts {
  const NotificationTexts._(this._tag);

  /// Builds the texts for a locale tag: `en`, `ur` or `en_PK` (Roman Urdu).
  factory NotificationTexts.forLocale(String localeTag) =>
      NotificationTexts._(_names.containsKey(localeTag) ? localeTag : 'en');

  final String _tag;

  static const Map<String, Map<PrayerName, String>> _names = {
    'en': {
      PrayerName.fajr: 'Fajr',
      PrayerName.sunrise: 'Sunrise',
      PrayerName.dhuhr: 'Dhuhr',
      PrayerName.asr: 'Asr',
      PrayerName.maghrib: 'Maghrib',
      PrayerName.isha: 'Isha',
    },
    'ur': {
      PrayerName.fajr: 'فجر',
      PrayerName.sunrise: 'طلوعِ آفتاب',
      PrayerName.dhuhr: 'ظہر',
      PrayerName.asr: 'عصر',
      PrayerName.maghrib: 'مغرب',
      PrayerName.isha: 'عشاء',
    },
    'en_PK': {
      PrayerName.fajr: 'Fajr',
      PrayerName.sunrise: 'Tuloo-e-Aftab',
      PrayerName.dhuhr: 'Zuhr',
      PrayerName.asr: 'Asr',
      PrayerName.maghrib: 'Maghrib',
      PrayerName.isha: 'Isha',
    },
  };

  static const Map<String, String> _jumma = {'en': 'Jumma', 'ur': 'جمعہ', 'en_PK': 'Jumma'};

  /// Localised prayer name; Dhuhr becomes Jumma on Fridays.
  String prayerName(PrayerName prayer, {bool isFriday = false}) {
    if (isFriday && prayer == PrayerName.dhuhr) return _jumma[_tag]!;
    return _names[_tag]![prayer]!;
  }

  String azanTitle(PrayerName prayer, {bool isFriday = false}) {
    final name = prayerName(prayer, isFriday: isFriday);
    return switch (_tag) {
      'ur' => '$name کا وقت',
      'en_PK' => '$name ka waqt',
      _ => 'Time for $name',
    };
  }

  String azanBody(PrayerName prayer, String city, {bool isFriday = false}) {
    final name = prayerName(prayer, isFriday: isFriday);
    return switch (_tag) {
      'ur' => '$city میں $name کا وقت ہو گیا ہے',
      'en_PK' => '$city mein $name ka waqt ho gaya hai',
      _ => 'It is time for $name in $city',
    };
  }

  String preReminderTitle(PrayerName prayer, int minutes, {bool isFriday = false}) {
    final name = prayerName(prayer, isFriday: isFriday);
    return switch (_tag) {
      'ur' => '$name میں $minutes منٹ باقی',
      'en_PK' => '$name mein $minutes minute baqi',
      _ => '$name in $minutes min',
    };
  }

  String preReminderBody(String city) => switch (_tag) {
        'ur' => '$city: تیاری کر لیں',
        'en_PK' => '$city: tayari kar lein',
        _ => 'Get ready — $city',
      };
}
