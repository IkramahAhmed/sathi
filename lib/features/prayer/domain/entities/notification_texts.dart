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

  String leaveTitle(PrayerName prayer, {bool isFriday = false}) {
    final name = prayerName(prayer, isFriday: isFriday);
    return switch (_tag) {
      'ur' => '$name کی جماعت کے لیے روانہ ہوں',
      'en_PK' => '$name ki jamaat ke liye rawana hon',
      _ => 'Time to leave for $name jama\'at',
    };
  }

  String leaveBody(String time) => switch (_tag) {
        'ur' => 'جماعت $time پر ہے',
        'en_PK' => 'Jamaat $time par hai',
        _ => 'Jama\'at is at $time',
      };

  /// "Asr ends in 20 min", or a last call when [last] is true.
  String endingTitle(PrayerName prayer, int minutesLeft, {bool last = false, bool isFriday = false}) {
    final name = prayerName(prayer, isFriday: isFriday);
    return switch (_tag) {
      'ur' => last ? '$name کا وقت ختم ہونے والا ہے!' : '$name کا وقت $minutesLeft منٹ میں ختم',
      'en_PK' => last ? '$name ka waqt khatam hone wala hai!' : '$name ka waqt $minutesLeft minute mein khatam',
      _ => last ? '$name time is ending!' : '$name ends in $minutesLeft min',
    };
  }

  String endingBody({required bool requirePhoto}) => switch (_tag) {
        'ur' => requirePhoto ? 'نماز پڑھیں، پھر جائے نماز کی تصویر لے کر تصدیق کریں' : 'نماز پڑھ لیں',
        'en_PK' => requirePhoto ? 'Namaz parhein, phir jaye-namaz ki tasveer le kar tasdeeq karein' : 'Namaz parh lein',
        _ => requirePhoto ? 'Pray, then take a photo of your prayer place to confirm' : 'Time to pray',
      };

  String get actionTakePhoto => switch (_tag) {
        'ur' => 'تصویر لیں',
        'en_PK' => 'Tasveer lein',
        _ => 'Take photo',
      };

  String get actionStop => switch (_tag) {
        'ur' => 'یاد دہانی بند کریں',
        'en_PK' => 'Yaad-dehani band karein',
        _ => 'Stop reminders',
      };

  String get actionPrayed => switch (_tag) {
        'ur' => 'پڑھ لی',
        'en_PK' => 'Parh li',
        _ => 'Prayed',
      };

  String preReminderBody(String city) => switch (_tag) {
        'ur' => '$city: تیاری کر لیں',
        'en_PK' => '$city: tayari kar lein',
        _ => 'Get ready — $city',
      };
}
