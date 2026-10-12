// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appName => 'ساتھی';

  @override
  String get navHome => 'ہوم';

  @override
  String get navTimetable => 'ٹائم ٹیبل';

  @override
  String get navQibla => 'قبلہ';

  @override
  String get navSettings => 'ترتیبات';

  @override
  String get ok => 'ٹھیک ہے';

  @override
  String get cancel => 'منسوخ';

  @override
  String get skip => 'چھوڑیں';

  @override
  String get next => 'آگے';

  @override
  String get back => 'پیچھے';

  @override
  String get done => 'مکمل';

  @override
  String get retry => 'دوبارہ کوشش کریں';

  @override
  String get close => 'بند کریں';

  @override
  String get allow => 'اجازت دیں';

  @override
  String get allowed => 'اجازت مل گئی';

  @override
  String get genericError => 'کچھ غلط ہو گیا';

  @override
  String get prayerFajr => 'فجر';

  @override
  String get prayerSunrise => 'طلوعِ آفتاب';

  @override
  String get prayerDhuhr => 'ظہر';

  @override
  String get prayerAsr => 'عصر';

  @override
  String get prayerMaghrib => 'مغرب';

  @override
  String get prayerIsha => 'عشاء';

  @override
  String get prayerJumma => 'جمعہ';

  @override
  String get prayerTimesTitle => 'نماز کے اوقات';

  @override
  String nextPrayer(String prayer, String duration) {
    return 'اگلی نماز: $prayer، $duration میں';
  }

  @override
  String sunriseAt(String time) {
    return 'طلوعِ آفتاب $time';
  }

  @override
  String get prayedLabel => 'ادا کی';

  @override
  String markPrayed(String prayer) {
    return '$prayer ادا کی نشان زد کریں';
  }

  @override
  String azanToggle(String prayer) {
    return '$prayer کی اذان';
  }

  @override
  String hijriDate(int day, String month, int year) {
    return '$day $month $year ھ';
  }

  @override
  String get locationRefresh => 'میری لوکیشن اپ ڈیٹ کریں';

  @override
  String locationUpdated(String city) {
    return 'لوکیشن $city مقرر ہو گئی';
  }

  @override
  String get locationFailed => 'آپ کی لوکیشن نہیں مل سکی';

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours گھنٹے $minutes منٹ';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes منٹ';
  }

  @override
  String durationSeconds(int seconds) {
    return '$seconds سیکنڈ';
  }

  @override
  String get bannerExactTitle => 'درست وقت کے الارم بند ہیں';

  @override
  String get bannerExactBody =>
      'اذان چند منٹ دیر سے آ سکتی ہے۔ بروقت اذان کے لیے ’الارم اور ریمائنڈرز‘ کی اجازت دیں۔';

  @override
  String get bannerExactAction => 'اجازت دیں';

  @override
  String get bannerNotifTitle => 'نوٹیفکیشن بند ہیں';

  @override
  String get bannerNotifBody => 'اذان سننے کے لیے نوٹیفکیشن آن کریں۔';

  @override
  String get tasbeehTitle => 'تسبیح';

  @override
  String get tasbeehTapHint => 'گننے کے لیے ٹیپ کریں';

  @override
  String get tasbeehReset => 'ری سیٹ';

  @override
  String get timetableTitle => 'ماہانہ ٹائم ٹیبل';

  @override
  String get shareImage => 'تصویر کے طور پر شیئر کریں';

  @override
  String get shareFailed => 'ٹائم ٹیبل شیئر نہیں ہو سکا';

  @override
  String get colDate => 'تاریخ';

  @override
  String get previousMonth => 'پچھلا مہینہ';

  @override
  String get nextMonth => 'اگلا مہینہ';

  @override
  String get settingsTitle => 'ترتیبات';

  @override
  String get secLocation => 'مقام';

  @override
  String get useMyLocation => 'میری لوکیشن استعمال کریں';

  @override
  String get chooseCity => 'شہر منتخب کریں';

  @override
  String get searchCity => 'شہر تلاش کریں';

  @override
  String currentLocation(String city, String country) {
    return '$city، $country';
  }

  @override
  String get followMe => 'سفر پر خود بخود اپ ڈیٹ کریں';

  @override
  String get followMeHint => '50 کلومیٹر سے زیادہ سفر پر دوبارہ حساب ہوگا';

  @override
  String get secCalculation => 'حساب کا طریقہ';

  @override
  String get method => 'طریقہ';

  @override
  String get madhab => 'عصر (مسلک)';

  @override
  String get madhabHanafi => 'حنفی';

  @override
  String get madhabShafi => 'شافعی / مالکی / حنبلی';

  @override
  String get highLatRule => 'بلند عرض بلد کا اصول';

  @override
  String get highLatMiddle => 'آدھی رات';

  @override
  String get highLatSeventh => 'رات کا ساتواں حصہ';

  @override
  String get highLatAngle => 'شفق کا زاویہ';

  @override
  String autoMethod(String method) {
    return 'خودکار: $method';
  }

  @override
  String get useCountryDefaults => 'ملک کے مطابق طے شدہ';

  @override
  String get secPrayers => 'نمازیں';

  @override
  String get masjidAdjust => 'مسجد کا وقت (± منٹ)';

  @override
  String minutesValue(int minutes) {
    return '$minutes منٹ';
  }

  @override
  String get preReminder => 'نماز سے پہلے یاد دہانی';

  @override
  String get off => 'بند';

  @override
  String get azanSound => 'اذان کی آواز';

  @override
  String get soundBeep => 'بیپ';

  @override
  String get soundFull => 'اذان (مکمل)';

  @override
  String get soundShort => 'اذان (مختصر)';

  @override
  String get soundSilent => 'خاموش';

  @override
  String get audioCredits => 'آڈیو کا حوالہ';

  @override
  String get audioCreditsBody =>
      'اذان کی ریکارڈنگ: “The Adhan - Muslim Call to Prayer - Aaqib Azeez”، جسے Atcovi نے Wikimedia Commons پر CC BY-SA 4.0 کے تحت شیئر کیا۔ مختصر ورژن اسی کی کاٹی گئی کاپی ہے جس کے آخر میں آواز مدھم ہوتی ہے۔ ماخذ: commons.wikimedia.org (File:The Adhan - Muslim Call to Prayer - Aaqib Azeez.mp3)۔ لائسنس: creativecommons.org/licenses/by-sa/4.0';

  @override
  String get previewSound => 'سنیں';

  @override
  String get secHijri => 'ہجری تاریخ';

  @override
  String get hijriAdjust => 'چاند دیکھنے کی تصحیح';

  @override
  String get hijriNoChange => 'کوئی تبدیلی نہیں';

  @override
  String get hijriPlusOne => '+1 دن';

  @override
  String get hijriMinusOne => '−1 دن';

  @override
  String get secLanguage => 'زبان';

  @override
  String get langEnglish => 'English';

  @override
  String get langUrdu => 'اردو';

  @override
  String get langRomanUrdu => 'Roman Urdu';

  @override
  String get testNotification => '10 سیکنڈ میں ٹیسٹ نوٹیفکیشن';

  @override
  String get testScheduled => '10 سیکنڈ میں ٹیسٹ نوٹیفکیشن آئے گا';

  @override
  String get testTitle => 'ساتھی ٹیسٹ';

  @override
  String get testBody => 'اگر آپ یہ سن رہے ہیں تو اذان ٹھیک کام کرے گی';

  @override
  String get batteryHelp => 'بیٹری اور بیک گراؤنڈ مدد';

  @override
  String pendingCount(int count) {
    return '$count اذان الرٹس مقرر ہیں';
  }

  @override
  String get qiblaTitle => 'قبلہ';

  @override
  String qiblaBearing(int degrees) {
    return 'قبلہ شمال سے $degrees° پر ہے';
  }

  @override
  String get qiblaNoSensor =>
      'اس فون میں کمپاس سینسر نہیں۔ اوپر دی گئی ڈگری کمپاس کے ساتھ استعمال کریں۔';

  @override
  String get qiblaFace => 'تیر کے اوپر کی طرف ہونے تک گھمائیں';

  @override
  String stepOf(int current, int total) {
    return 'مرحلہ $current از $total';
  }

  @override
  String get onbWelcomeTitle => 'السلام علیکم';

  @override
  String get onbWelcomeBody =>
      'ساتھی آپ کو نماز کے اوقات بتاتا ہے اور اذان سناتا ہے، انٹرنیٹ کے بغیر بھی۔';

  @override
  String get onbLanguageTitle => 'اپنی زبان منتخب کریں';

  @override
  String get onbLocationTitle => 'آپ کا مقام';

  @override
  String get onbLocationBody =>
      'درست اوقات کے حساب کے لیے استعمال ہوتی ہے۔ یہ آپ کے فون ہی میں رہتی ہے۔';

  @override
  String get onbLocationAllow => 'میری لوکیشن استعمال کریں';

  @override
  String get onbLocationManual => 'یا شہر منتخب کریں';

  @override
  String get onbNotifTitle => 'اذان کے نوٹیفکیشن';

  @override
  String get onbNotifBody =>
      'نوٹیفکیشن کی اجازت دیں تاکہ ساتھی آپ کو نماز کے لیے بلا سکے۔';

  @override
  String get onbExactTitle => 'بروقت الارم';

  @override
  String get onbExactBody =>
      'اذان عین وقت پر بجنے کے لیے ’الارم اور ریمائنڈرز‘ کی اجازت دیں۔';

  @override
  String get onbOemTitle => 'ساتھی کو چالو رکھیں';

  @override
  String get onbOemBody =>
      'آپ کا فون بیک گراؤنڈ ایپس بند کر سکتا ہے۔ چند ترتیبات اذان کو قابلِ اعتماد رکھتی ہیں۔';

  @override
  String get onbOemOpen => 'مراحل دیکھیں';

  @override
  String get onbDoneTitle => 'سب تیار ہے';

  @override
  String get onbDoneBody => 'ساتھی ہر نماز پر آپ کو بلائے گا۔';

  @override
  String get onbStart => 'شروع کریں';

  @override
  String get oemTitle => 'بیک گراؤنڈ اذان کی اجازت';

  @override
  String oemIntro(String brand) {
    return '$brand فونز اکثر بیٹری بچانے کے لیے بیک گراؤنڈ ایپس بند کر دیتے ہیں۔ یہ مراحل ایک بار کریں:';
  }

  @override
  String get oemStep1 =>
      'ایپ کی معلومات کھولیں، پھر بیٹری، اور ’کوئی پابندی نہیں‘ منتخب کریں۔';

  @override
  String get oemStep2 => 'ساتھی کے لیے ’آٹو اسٹارٹ‘ یا ’آٹو لانچ‘ آن کریں۔';

  @override
  String get oemStep3 =>
      'حالیہ ایپس میں ساتھی کو لاک کریں (کارڈ نیچے کھینچیں یا دبائے رکھیں، پھر لاک چنیں)۔';

  @override
  String get oemStep4 => 'نوٹیفکیشن اور نوٹیفکیشن کی آواز آن رکھیں۔';

  @override
  String get oemOpenSettings => 'ایپ کی ترتیبات کھولیں';

  @override
  String get oemDontShow => 'دوبارہ نہ دکھائیں';

  @override
  String get oemGotIt => 'سمجھ گیا';
}
