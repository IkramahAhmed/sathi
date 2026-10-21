// ignore_for_file: lines_longer_than_80_chars
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

  // ── Authentic Hadith pool (Sahih al-Bukhari & Sahih Muslim only) ──────────
  // Each entry: [English, Urdu, Roman-Urdu, source]
  // Source shown as short reference so the user can verify on sunnah.com.
  static const List<List<String>> _hadithPool = [
    [
      '"The most beloved deed to Allah is to offer prayers at their early stated times." — Bukhari 527',
      '"اللہ کے نزدیک سب سے پسندیدہ عمل نماز کو اس کے وقت پر ادا کرنا ہے۔" — بخاری 527',
      '"Allah ke nazdik sab se pasandeeda amal namaz ko us ke waqt par ada karna hai." — Bukhari 527',
    ],
    [
      '"The five prayers are like a river at your door — bathing five times daily leaves no dirt. Likewise, Allah wipes away sins with five prayers." — Bukhari 528',
      '"پانچ نمازیں گھر کے دروازے پر بہتی نہر کی مانند ہیں۔ پانچ بار غسل کرنے سے کوئی میل نہیں رہتی۔ اسی طرح اللہ پانچ نمازوں سے گناہ مٹا دیتا ہے۔" — بخاری 528',
      '"Panch namazein ghar ke darwaze par behti neher ki maanand hain. Panch baar ghusl karne se koi mail nahi rehti. Isi tarah Allah panch namazon se gunah mita deta hai." — Bukhari 528',
    ],
    [
      '"Pray as you have seen me praying." — Bukhari 631',
      '"نماز اس طرح پڑھو جیسے تم نے مجھے پڑھتے دیکھا ہے۔" — بخاری 631',
      '"Namaz us tarah parho jaise tum ne mujhe parhte dekha hai." — Bukhari 631',
    ],
    [
      '"Between a man and shirk and kufr is the abandonment of salah." — Muslim 82',
      '"انسان اور شرک و کفر کے درمیان نماز کا ترک کرنا ہے۔" — مسلم 82',
      '"Insan aur shirk-o-kufr ke darmiyan namaz ka tark karna hai." — Muslim 82',
    ],
    [
      '"There is no prayer harder for the hypocrites than Fajr and Isha. If they knew the reward, they would attend even crawling." — Bukhari 657',
      '"منافقوں پر فجر اور عشاء سے زیادہ کوئی نماز بھاری نہیں۔ اگر وہ ان کا ثواب جانتے تو گھٹنوں کے بل آتے۔" — بخاری 657',
      '"Munafiqon par Fajr aur Isha se zyada koi namaz bhari nahi. Agar wo in ka sawab jante to ghutno ke bal aate." — Bukhari 657',
    ],
  ];

  /// Returns a different authentic hadith each calendar day (cycles every 5 days).
  /// Pass [dayOfYear] so tests can pin a value; defaults to today's day.
  String hadithForDay({int? dayOfYear}) {
    final day = dayOfYear ?? DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    final row = _hadithPool[day % _hadithPool.length];
    return switch (_tag) {
      'ur' => row[1],
      'en_PK' => row[2],
      _ => row[0],
    };
  }

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

  String azanBody(PrayerName prayer, String city, {bool isFriday = false, int? dayOfYear}) {
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

  /// Put in front of the title of a test reminder.
  String get testPrefix => switch (_tag) {
        'ur' => '[آزمائش] ',
        'en_PK' => '[Test] ',
        _ => '[Test] ',
      };

  /// Heading on the home-screen widget.
  String get widgetNext => switch (_tag) {
        'ur' => 'اگلی نماز',
        'en_PK' => 'Agli namaz',
        _ => 'Next prayer',
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

  // ── Ramadan ───────────────────────────────────────────────────────────────

  String sehriReminderTitle() => switch (_tag) {
        'ur' => 'سحری ختم ہونے والی ہے',
        'en_PK' => 'Sehri khatam hone wali hai',
        _ => 'Sehri ends in 15 minutes',
      };

  String sehriReminderBody() => switch (_tag) {
        'ur' => 'فجر سے پہلے کھانا پینا بند کر لیں',
        'en_PK' => 'Fajr se pehle khana peena band kar lein',
        _ => 'Stop eating before Fajr begins',
      };

  String iftarTitle() => switch (_tag) {
        'ur' => 'افطار کا وقت!',
        'en_PK' => 'Iftar ka waqt!',
        _ => 'Iftar time!',
      };

  String iftarBody(String city) => switch (_tag) {
        'ur' => '$city میں روزہ افطار کریں — مغرب کا وقت ہو گیا',
        'en_PK' => '$city mein roza iftar karein — Maghrib ka waqt ho gaya',
        _ => 'Break your fast in $city — Maghrib has begun',
      };
}
