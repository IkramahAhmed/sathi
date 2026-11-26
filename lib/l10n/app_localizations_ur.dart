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
  String get syncSection => 'کلاؤڈ بیک اپ';

  @override
  String get syncTitle => 'میری ادا کی گئی نمازوں کا بیک اپ';

  @override
  String get syncSubtitle =>
      'آپ کی نشان زد نمازیں محفوظ رہتی ہیں اور آپ کے تمام فونز پر یکساں';

  @override
  String get syncServer => 'سرور کا پتہ';

  @override
  String get syncServerNotSet => 'مقرر نہیں';

  @override
  String get syncServerHint => 'https://your-server.workers.dev';

  @override
  String get syncServerInvalid => 'https:// والا پتہ درج کریں';

  @override
  String get syncKey => 'سنک کی';

  @override
  String get syncKeyHelp =>
      'اسے خفیہ رکھیں۔ جس کے پاس یہ ہو وہ آپ کی ادا کی گئی نمازیں دیکھ سکتا ہے۔ نئے فون پر لاگ بحال کرنے کے لیے یہ ضروری ہے۔';

  @override
  String get syncKeyCopy => 'کی کاپی کریں';

  @override
  String get syncKeyCopied => 'کی کاپی ہو گئی';

  @override
  String get syncKeyShow => 'کی دکھائیں';

  @override
  String get syncKeyHide => 'کی چھپائیں';

  @override
  String get syncUseKey => 'دوسرے فون کی کی استعمال کریں';

  @override
  String get syncUseKeyHelp =>
      'اپنے دوسرے فون کی کی یہاں پیسٹ کریں۔ اس فون کا لاگ کلاؤڈ کاپی کے ساتھ مل جائے گا۔';

  @override
  String get syncKeyInvalid => 'یہ درست کی نہیں لگتی';

  @override
  String get syncUse => 'یہ کی استعمال کریں';

  @override
  String get syncSave => 'محفوظ کریں';

  @override
  String get syncNow => 'ابھی سنک کریں';

  @override
  String get syncRunning => 'سنک ہو رہا ہے…';

  @override
  String syncLastSynced(String time) {
    return 'آخری سنک $time';
  }

  @override
  String get syncNever => 'ابھی تک سنک نہیں ہوا';

  @override
  String syncPending(int count) {
    return '$count اپ لوڈ کے منتظر';
  }

  @override
  String get syncProblemSetup => 'پہلے سرور کا پتہ مقرر کریں';

  @override
  String get syncProblemOffline => 'رابطہ نہیں۔ بعد میں دوبارہ کوشش ہوگی۔';

  @override
  String get syncProblemServer =>
      'سرور میں مسئلہ تھا۔ بعد میں دوبارہ کوشش ہوگی۔';

  @override
  String get syncProblemKey => 'سرور نے یہ کی قبول نہیں کی۔';

  @override
  String get syncProblemOther => 'سنک نہیں ہو سکا۔ بعد میں دوبارہ کوشش ہوگی۔';

  @override
  String get syncDelete => 'میرا کلاؤڈ ڈیٹا حذف کریں';

  @override
  String get syncDeleteBody =>
      'یہ کلاؤڈ سے آپ کا بیک اپ مٹا دے گا۔ اس فون کا لاگ محفوظ رہے گا۔';

  @override
  String get syncDeleteConfirm => 'حذف کریں';

  @override
  String get syncDeleted => 'کلاؤڈ ڈیٹا حذف ہو گیا';

  @override
  String get navTracker => 'ٹریکر';

  @override
  String get trackerTitle => 'نماز ٹریکر';

  @override
  String streakCurrent(int days) {
    return '$days دن کا سلسلہ';
  }

  @override
  String streakBest(int days) {
    return 'بہترین: $days';
  }

  @override
  String get streakNone => 'سلسلہ شروع کرنے کے لیے آج پانچوں نمازیں پڑھیں';

  @override
  String get trackerToday => 'آج';

  @override
  String get trackerPrevDay => 'پچھلا دن';

  @override
  String get trackerNextDay => 'اگلا دن';

  @override
  String get trackerFuture => 'آنے والے دن کی نماز نشان زد نہیں ہو سکتی';

  @override
  String get trackerPausedDay =>
      'وقفہ: اس دن کی نمازیں چھوٹی ہوئی شمار نہیں ہوں گی';

  @override
  String get dayComplete => 'پانچوں پڑھیں';

  @override
  String get pauseTitle => 'وقفہ';

  @override
  String get pauseHelp =>
      'بیماری یا خواتین کے مخصوص ایام کے لیے۔ وقفے کے دن سلسلہ نہیں توڑتے اور چھوٹی نمازوں میں شمار نہیں ہوتے۔ یہ صرف اسی فون پر رہتا ہے، کبھی اپ لوڈ نہیں ہوتا۔';

  @override
  String get pauseStart => 'آج سے وقفہ شروع کریں';

  @override
  String get pauseEnd => 'دوبارہ شروع کریں';

  @override
  String pauseSince(String date) {
    return '$date سے وقفے میں';
  }

  @override
  String get pauseAddPast => 'پچھلے دن شامل کریں';

  @override
  String pauseRange(String start, String end) {
    return '$start سے $end تک';
  }

  @override
  String get pauseRemove => 'ہٹائیں';

  @override
  String get pauseNone => 'کوئی وقفہ نہیں';

  @override
  String get qazaTitle => 'قضا نمازیں';

  @override
  String qazaCardOwed(int count) {
    return '$count ادا کرنی ہیں';
  }

  @override
  String get qazaCardNone => 'کوئی قضا نہیں';

  @override
  String get qazaMadeUp => 'ایک ادا کی';

  @override
  String get qazaAddOne => 'ایک چھوٹی ہوئی شامل کریں';

  @override
  String get qazaSetBalance => 'ابتدائی تعداد مقرر کریں';

  @override
  String get qazaBalanceHelp => 'ہر نماز کی کتنی قضا ہے؟ نہ ہو تو 0 رہنے دیں۔';

  @override
  String get qazaEstimate => 'برسوں سے اندازہ لگائیں';

  @override
  String get qazaYears => 'چھوٹی نمازوں کے سال';

  @override
  String get qazaYearsHelp =>
      'ہر نماز میں سال × 365 بھر دیتا ہے۔ بعد میں ہر ایک بدل سکتے ہیں۔';

  @override
  String get qazaApply => 'لاگو کریں';

  @override
  String get qazaAuto => 'چھوٹی نمازیں خود گنیں';

  @override
  String get qazaAutoHelp =>
      'نماز کا وقت بغیر نشان زد ہوئے ختم ہو تو قضا میں شامل کر دیتا ہے۔ آج سے شروع ہوتا ہے۔ بعد میں نشان زد کریں تو واپس ہو جاتی ہے، اور وقفے کے دن چھوڑ دیے جاتے ہیں۔';

  @override
  String get qazaHistory => 'تاریخ';

  @override
  String get qazaHistoryEmpty => 'ابھی کچھ نہیں';

  @override
  String get qazaSourceInitial => 'ابتدائی تعداد';

  @override
  String get qazaSourceAdded => 'شامل کی';

  @override
  String get qazaSourceMadeUp => 'ادا کی';

  @override
  String get qazaSourceAuto => 'خود شمار ہوئی';

  @override
  String qazaTotal(int count) {
    return '$count نمازیں ادا کرنی ہیں';
  }

  @override
  String get jamaatSection => 'جماعت (مسجد)';

  @override
  String get jamaatHelp =>
      'اپنی مسجد کی جماعت کے اوقات مقرر کریں تاکہ ہر نماز کے ساتھ نظر آئیں اور روانگی کی یاد دہانی ملے۔ اذان کے بعد منٹ یا مقررہ وقت استعمال کریں۔';

  @override
  String get jamaatNotSet => 'مقرر نہیں';

  @override
  String jamaatAfter(int minutes) {
    return 'اذان کے $minutes منٹ بعد';
  }

  @override
  String jamaatFixed(String time) {
    return '$time پر';
  }

  @override
  String jamaatAt(String time) {
    return 'جماعت $time';
  }

  @override
  String get jamaatEdit => 'جماعت کا وقت';

  @override
  String get jamaatModeAfter => 'اذان کے بعد منٹ';

  @override
  String get jamaatModeFixed => 'مقررہ وقت';

  @override
  String get jamaatPickTime => 'وقت چنیں';

  @override
  String get jamaatClear => 'ہٹائیں';

  @override
  String get jummaTime => 'جمعہ کا وقت';

  @override
  String get leaveReminder => 'روانگی کی یاد دہانی';

  @override
  String leaveMinutes(int minutes) {
    return 'جماعت سے $minutes منٹ پہلے';
  }

  @override
  String get silentDuring => 'جماعت کے دوران فون خاموش کریں';

  @override
  String get silentHelp =>
      'ڈسٹرب نہ کریں کی رسائی درکار ہے۔ بعد میں فون پہلے جیسا ہو جاتا ہے۔';

  @override
  String get silentLength => 'خاموش رہے';

  @override
  String get silentGrantAccess => 'ڈسٹرب نہ کریں کی رسائی دیں';

  @override
  String get azanAlarmVolume => 'اذان الارم کی آواز پر چلائیں';

  @override
  String get azanAlarmHelp =>
      'خاموش موڈ میں بھی سنائی دیتی ہے اور میڈیا والیوم سے متاثر نہیں ہوتی۔';

  @override
  String get checkSetupTitle => 'میری ترتیب جانچیں';

  @override
  String get checkSetupIntro =>
      'یقینی بنائیں کہ اذان واقعی سنائی دے گی۔ سرخ نشان والی چیز درست کریں۔';

  @override
  String get checkNotifications => 'نوٹیفکیشن کی اجازت';

  @override
  String get checkExact => 'الارم اور ریمائنڈرز کی اجازت';

  @override
  String get checkExactHelp => 'اذان ٹھیک منٹ پر بجنے دیتی ہے۔';

  @override
  String get checkBattery => 'بیٹری: بغیر پابندی';

  @override
  String get checkBatteryHelp =>
      'ایپ کی ترتیبات کھولیں، پھر بیٹری، اور بغیر پابندی چنیں۔';

  @override
  String get checkChannel => 'سسٹم ترتیبات میں اذان کی آواز آن ہے';

  @override
  String get checkChannelHelp =>
      'اس ایپ کے لیے اذان کی آواز بند ہے۔ نوٹیفکیشن ترتیبات میں آن کریں۔';

  @override
  String checkScheduled(int count) {
    return '$count الرٹس مقرر ہیں';
  }

  @override
  String get checkNoneScheduled => 'کوئی الرٹ مقرر نہیں';

  @override
  String get checkOk => 'ٹھیک';

  @override
  String get checkFix => 'درست کریں';

  @override
  String get checkTestNow => 'ابھی آزمائشی اذان چلائیں';

  @override
  String get checkReplan => 'تمام الرٹس دوبارہ ترتیب دیں';

  @override
  String get checkReplanned => 'الرٹس دوبارہ ترتیب دیے گئے';

  @override
  String get endSection => 'نماز کا وقت ختم ہونے والا ہے';

  @override
  String get endHelp =>
      'نماز کا وقت ختم ہونے سے پہلے یاد دہانی ملے گی، اور نماز پڑھنے تک بار بار۔ نماز چھوٹ جائے تو قضا فہرست میں چلی جاتی ہے۔';

  @override
  String get endEnable => 'نماز ختم ہونے سے پہلے یاد دلائیں';

  @override
  String get endLead => 'پہلی یاد دہانی';

  @override
  String endLeadValue(int minutes) {
    return 'ختم ہونے سے $minutes منٹ پہلے';
  }

  @override
  String get endRepeat => 'پھر ہر';

  @override
  String endRepeatValue(int minutes) {
    return '$minutes منٹ';
  }

  @override
  String get endPrayers => 'کون سی نمازیں';

  @override
  String get endRequirePhoto => 'تصویری ثبوت';

  @override
  String get endRequirePhotoHelp =>
      'جب تک آپ اپنی نماز کی جگہ، جیسے جائے نماز یا مسجد، کی تصویر نہ لیں یاد دہانی جاری رہے گی۔ تصویر اسی فون پر جانچی جاتی ہے اور کہیں محفوظ یا ارسال نہیں ہوتی۔';

  @override
  String get endTestTitle => 'یاددہانی آزمائیں';

  @override
  String get endTestHelp =>
      '۳ آزمائشی اطلاعات بھیجتا ہے جو ۱ منٹ کے وقفے سے آتی ہیں تاکہ آپ پورا عمل دیکھ سکیں۔';

  @override
  String get endTestSend => 'بھیجیں';

  @override
  String get endTestScheduled =>
      '۳ آزمائشی یاددہانیاں بھیجی گئیں — پہلی ۱۰ سیکنڈ میں آئے گی۔';

  @override
  String get verifyTitle => 'نماز کی تصویر کی جانچ';

  @override
  String get verifyIntro =>
      'نماز کے بعد اپنی نماز کی جگہ، جیسے جائے نماز یا مسجد، کی تصویر لیں۔ یہ صرف اسی فون پر جانچی جاتی ہے اور محفوظ نہیں ہوتی۔';

  @override
  String verifyPrayer(String prayer, String date) {
    return '$prayer · $date';
  }

  @override
  String get verifyTake => 'تصویر لیں';

  @override
  String get verifyChecking => 'جانچ ہو رہی ہے…';

  @override
  String get verifySuccess => 'تصدیق ہو گئی۔ اللہ آپ کی نماز قبول فرمائے۔';

  @override
  String get verifyTestNote =>
      'یہ ایک آزمائشی یاددہانی تھی — آپ کا نماز لاگ تبدیل نہیں کیا گیا۔';

  @override
  String get verifyFail =>
      'یہ نماز کی جگہ نہیں لگتی۔ جائے نماز یا مسجد نظر آتے ہوئے دوبارہ کوشش کریں۔';

  @override
  String get verifyTryAgain => 'دوبارہ کوشش کریں';

  @override
  String get verifyStop => 'یاد دہانی بند کریں';

  @override
  String get verifyStopHelp =>
      'اگر ابھی نماز نہیں پڑھ سکتے تو یہ استعمال کریں۔ نماز پڑھی ہوئی نشان زد نہیں ہوگی۔';

  @override
  String verifySaw(String labels) {
    return 'فون نے دیکھا: $labels';
  }

  @override
  String get verifyEnded =>
      'اس نماز کا وقت ختم ہو چکا ہے۔ آپ اسے ٹریکر میں نشان زد کر سکتے ہیں۔';

  @override
  String get verifyProofNeeded => 'اس نماز کے لیے تصویری ثبوت لازمی ہے';

  @override
  String get verifyNoCamera => 'کیمرہ نہیں کھل سکا';

  @override
  String get verifyChecklistHint =>
      'مشورہ: یقینی بنائیں کہ جائے نماز یا مسجد تصویر کا بڑا حصہ ہو۔';

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
  String qiblaTurnRight(int degrees) {
    return 'دائیں $degrees° گھومیں';
  }

  @override
  String qiblaTurnLeft(int degrees) {
    return 'بائیں $degrees° گھومیں';
  }

  @override
  String get qiblaFacing => 'آپ کا رخ قبلہ کی طرف ہے';

  @override
  String qiblaHeading(int degrees) {
    return 'فون کا رخ $degrees°';
  }

  @override
  String qiblaDistance(String km) {
    return 'کعبہ تک $km کلومیٹر';
  }

  @override
  String get qiblaCalibrate =>
      'کمپاس کی درستی ضروری ہے۔ فون کو دھات اور مقناطیس سے دور آٹھ کے ہندسے کی شکل میں گھمائیں۔';

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

  @override
  String get scanTimetableButton => 'مسجد کا ٹائم ٹیبل اسکین کریں';

  @override
  String get scanTimetableTitle => 'مسجد ٹائم ٹیبل';

  @override
  String get scanTimetableScanning => 'ٹائم ٹیبل پڑھا جا رہا ہے…';

  @override
  String get scanTimetableError =>
      'تصویر نہیں پڑھی گئی۔ اچھی روشنی میں دوبارہ کوشش کریں۔';

  @override
  String scanTimetableFound(int count) {
    return '$count میں سے 5 نمازیں ملیں۔ ترمیم کے لیے قطار پر ٹیپ کریں۔';
  }

  @override
  String get scanTimetableNoneFound =>
      'نماز کے اوقات نہیں ملے۔ واضح تصویر لیں۔';

  @override
  String get scanTimetableHint =>
      'سنہری رنگ میں دکھائے گئے اوقات خودکار ملے ہیں۔ ترمیم کے لیے ٹیپ کریں۔';

  @override
  String get scanTimetableSave => 'جماعت کے اوقات محفوظ کریں';

  @override
  String get scanAutoDetected => 'خودکار پتہ چلا';

  @override
  String get scanTapToAdjust => 'ترمیم کے لیے ٹیپ کریں';

  @override
  String get scanNotDetected => 'نہیں ملا — ٹیپ کر کے سیٹ کریں';

  @override
  String get navKhata => 'کھاتہ';

  @override
  String get khataTitle => 'کھاتہ';

  @override
  String get khataMonthTotal => 'اس ماہ کا کل خرچ';

  @override
  String get khataEmpty => 'ابھی کوئی خرچ نہیں';

  @override
  String get khataEmptyHint => '+ دبائیں پہلا خرچ شامل کریں';

  @override
  String get khataAddTitle => 'خرچ شامل کریں';

  @override
  String get khataTabExpenses => 'خرچ';

  @override
  String get khataEditTitle => 'خرچ تبدیل کریں';

  @override
  String get khataAmount => 'رقم';

  @override
  String get khataAmountInvalid => 'درست رقم درج کریں';

  @override
  String get khataCategory => 'قسم';

  @override
  String get khataNote => 'نوٹ (اختیاری)';

  @override
  String get khataDate => 'تاریخ';

  @override
  String get khataSave => 'محفوظ کریں';

  @override
  String get khataDelete => 'حذف کریں';

  @override
  String get khataToday => 'آج';

  @override
  String get khataYesterday => 'کل';

  @override
  String get khataCatFood => 'کھانا';

  @override
  String get khataCatTransport => 'سفر';

  @override
  String get khataCatRent => 'کرایہ';

  @override
  String get khataCatHealth => 'صحت';

  @override
  String get khataCatBills => 'بل';

  @override
  String get khataCatShopping => 'خریداری';

  @override
  String get khataCatOther => 'دیگر';

  @override
  String get navPrayer => 'نماز';

  @override
  String get dashTools => 'آلات';

  @override
  String get dashComingSoon => 'جلد آ رہا ہے';

  @override
  String get khataChart => 'قسم کے مطابق خرچ';

  @override
  String get khataBudget => 'ماہانہ بجٹ';

  @override
  String get khataBudgetHint => 'حد ہٹانے کے لیے 0 لکھیں';

  @override
  String get khataExport => 'CSV برآمد';

  @override
  String get khataBudgetSaved => 'بجٹ محفوظ ہو گیا';

  @override
  String get khataOverBudget => 'بجٹ سے زیادہ';

  @override
  String get udhaarTitle => 'ادھار بہی کھاتہ';

  @override
  String get udhaarSearch => 'رابطے تلاش کریں…';

  @override
  String get udhaarAddContact => 'نیا رابطہ';

  @override
  String get udhaarEditContact => 'نام تبدیل کریں';

  @override
  String get udhaarDeleteContact => 'رابطہ حذف کریں';

  @override
  String udhaarDeleteContactConfirm(String name) {
    return '$name اور تمام اندراجات حذف کریں؟';
  }

  @override
  String get udhaarContactName => 'نام';

  @override
  String get udhaarSave => 'محفوظ کریں';

  @override
  String get udhaarDelete => 'حذف کریں';

  @override
  String get udhaarEmpty => 'ابھی کوئی رابطہ نہیں';

  @override
  String get udhaarEmptyHint => 'جس سے لین دین ہو اسے شامل کریں';

  @override
  String get udhaarOwedToMe => 'کل لینا';

  @override
  String get udhaarIOwe => 'کل دینا';

  @override
  String get udhaarOwes => 'لینا';

  @override
  String get udhaarYouOwe => 'دینا';

  @override
  String get udhaarSettled => 'برابر';

  @override
  String get udhaarClear => 'برابر';

  @override
  String udhaarOwesYou(String name) {
    return '$name کا لینا';
  }

  @override
  String udhaarYouOweContact(String name) {
    return '$name کا دینا';
  }

  @override
  String get udhaarGave => 'دیا';

  @override
  String get udhaarReceived => 'لیا';

  @override
  String get udhaarAmount => 'رقم';

  @override
  String get udhaarNote => 'نوٹ (اختیاری)';

  @override
  String get udhaarChangeDate => 'تبدیل کریں';

  @override
  String get udhaarNoEntries => 'کوئی اندراج نہیں۔\nدیا یا لیا بٹن دبائیں۔';

  @override
  String get udhaarEditEntry => 'اندراج ترمیم کریں';

  @override
  String get udhaarDeleteEntry => 'یہ اندراج حذف کریں؟';

  @override
  String get udhaarPhone => 'فون (واٹس ایپ کے لیے)';

  @override
  String get udhaarWhatsAppReminder => 'واٹس ایپ یاد دہانی';

  @override
  String udhaarWhatsAppLena(String name, String amount) {
    return 'السلام علیکم $name، آپ کا Rs. $amount مجھے لینا باقی ہے۔ - ساتھی ایپ';
  }

  @override
  String udhaarWhatsAppDena(String name, String amount) {
    return 'السلام علیکم $name، میرا Rs. $amount آپ کو دینا باقی ہے۔ - ساتھی ایپ';
  }

  @override
  String get udhaarWhatsAppNotFound => 'واٹس ایپ نصب نہیں';

  @override
  String get udhaarDueOn => 'آخری تاریخ';

  @override
  String get udhaarNoDueDate => 'کوئی آخری تاریخ نہیں';

  @override
  String get udhaarSetDueDate => 'تاریخ لگائیں';

  @override
  String get udhaarLate => 'تاخیر — ادائیگی باقی ہے';

  @override
  String get udhaarLateTitle => 'تاخیر';

  @override
  String get khataIncome => 'آمدنی';

  @override
  String get khataExpense => 'خرچ';

  @override
  String get khataNet => 'خالص';

  @override
  String get khataAddIncome => 'آمدنی شامل کریں';

  @override
  String get khataAddExpense => 'خرچ شامل کریں';

  @override
  String get khataTotalIncome => 'کل آمدنی';

  @override
  String get khataTotalExpense => 'کل خرچ';

  @override
  String get khataReceiptPhoto => 'رسید تصویر';

  @override
  String get khataAddPhoto => 'تصویر شامل کریں';

  @override
  String get khataViewPhoto => 'رسید دیکھیں';

  @override
  String get khataRemovePhoto => 'تصویر ہٹائیں';

  @override
  String get khataPdfExport => 'PDF برآمد کریں';

  @override
  String get udhaarPdfPassbook => 'اُدھار پاس بک (PDF)';

  @override
  String get incomeSourceSalary => 'تنخواہ';

  @override
  String get incomeSourceFreelance => 'فری لانس';

  @override
  String get incomeSourceBusiness => 'کاروبار';

  @override
  String get incomeSourceGift => 'تحفہ';

  @override
  String get incomeSourceOther => 'دیگر آمدنی';

  @override
  String get navTasks => 'ٹاسکس';

  @override
  String get vaultTitle => 'نجی والٹ';

  @override
  String get undo => 'واپس';

  @override
  String get todayQuickAddHint => 'فوری اندراج — مثلاً 250 چائے';

  @override
  String todayQuickAddPreview(String amount, String category) {
    return 'محفوظ ہوگا: Rs $amount · $category';
  }

  @override
  String get todayQuickAddNeedAmount => 'پہلے رقم لکھیں، مثلاً 250 چائے';

  @override
  String todayQuickAdded(String amount, String category) {
    return 'Rs $amount شامل ہو گیا · $category';
  }

  @override
  String todayQuickAddedIncome(String amount, String category) {
    return 'آمدنی Rs $amount شامل ہو گئی · $category';
  }

  @override
  String get todayPrayers => 'آج کی نمازیں';

  @override
  String get todayNothingDue => 'آج کوئی کام باقی نہیں';

  @override
  String get todaySeeAll => 'سب دیکھیں';

  @override
  String get todayMoney => 'پیسے';

  @override
  String get todaySpentToday => 'آج کا خرچ';

  @override
  String get todaySpentMonth => 'اس مہینے';

  @override
  String get todayBudgetLeft => 'بجٹ باقی';

  @override
  String get todayOverBudget => 'بجٹ سے زیادہ';

  @override
  String get todayComingUp => 'آنے والا';

  @override
  String get todayNothingComing => 'اس ہفتے کچھ نہیں';

  @override
  String todayDueTheyOwe(String name, String amount) {
    return '$name کو آپ کے Rs $amount دینے ہیں';
  }

  @override
  String todayDueYouOwe(String name, String amount) {
    return 'آپ کو $name کو Rs $amount دینے ہیں';
  }

  @override
  String todayDueLate(String days) {
    return '$days دن لیٹ';
  }

  @override
  String get todayDueToday => 'آج واجب';

  @override
  String get todayDueTomorrow => 'کل واجب';

  @override
  String todayDueInDays(String days) {
    return '$days دن میں واجب';
  }

  @override
  String todayRecurring(String what, String amount, String date) {
    return 'بار بار آنے والا $what: Rs $amount، $date کو';
  }

  @override
  String get todayBackupTitle => 'اپنا ڈیٹا بیک اپ کریں';

  @override
  String get todayBackupBody =>
      'ایک کاپی شیئر کریں تاکہ فون کھو جانے پر بھی ڈیٹا محفوظ رہے';

  @override
  String get todayBackupNow => 'ابھی بیک اپ کریں';

  @override
  String get todayLater => 'بعد میں';

  @override
  String get toolRoza => 'روزہ';

  @override
  String get toolGoals => 'بچت کے مقاصد';

  @override
  String get toolAccounts => 'اکاؤنٹس';

  @override
  String get rozaTitle => 'روزہ';

  @override
  String rozaOwed(String count) {
    return 'قضا روزے: $count';
  }

  @override
  String get rozaHint => 'دن پر ٹیپ کر کے رکھا، چھوٹا یا خالی کریں';

  @override
  String get rozaKept => 'رکھا';

  @override
  String get rozaMissed => 'چھوٹا';

  @override
  String get rozaMadeUp => 'قضا ادا';

  @override
  String get rozaMakeUpToday => 'آج قضا روزہ رکھا';

  @override
  String rozaKeptThisYear(String count) {
    return 'اس سال رکھے: $count';
  }

  @override
  String get save => 'محفوظ کریں';

  @override
  String get delete => 'حذف کریں';

  @override
  String get edit => 'ترمیم';

  @override
  String get goalsTitle => 'بچت کے مقاصد';

  @override
  String get goalsEmpty =>
      'ابھی کوئی مقصد نہیں۔ حج، شادی یا گاڑی جیسا کوئی مقصد شامل کریں۔';

  @override
  String get goalAdd => 'نیا مقصد';

  @override
  String get goalName => 'مقصد کا نام';

  @override
  String get goalTarget => 'مطلوبہ رقم';

  @override
  String get goalDeadline => 'آخری تاریخ (اختیاری)';

  @override
  String get goalAddMoney => 'رقم شامل کریں';

  @override
  String get goalTakeOut => 'رقم نکالیں';

  @override
  String get goalAmount => 'رقم';

  @override
  String goalSaved(String saved, String target) {
    return 'Rs $target میں سے Rs $saved';
  }

  @override
  String get goalReached => 'مقصد حاصل!';

  @override
  String goalPerMonth(String amount, String date) {
    return '$date تک پہنچنے کے لیے ہر مہینے تقریباً Rs $amount بچائیں';
  }

  @override
  String get goalDeleteConfirm => 'یہ مقصد حذف کریں؟';

  @override
  String get accountsTitle => 'اکاؤنٹس';

  @override
  String get accountsEmpty =>
      'وہ جگہیں شامل کریں جہاں آپ کے پیسے ہیں: نقد، بینک، والیٹ۔';

  @override
  String get accountAdd => 'نیا اکاؤنٹ';

  @override
  String get accountName => 'اکاؤنٹ کا نام';

  @override
  String get accountCash => 'نقد';

  @override
  String get accountBank => 'بینک';

  @override
  String get accountWallet => 'والیٹ';

  @override
  String get accountOpening => 'ابتدائی رقم';

  @override
  String get accountTotal => 'تمام اکاؤنٹس کا مجموعہ';

  @override
  String get accountDeleteWarn =>
      'اندراجات رہیں گے مگر اس اکاؤنٹ سے جڑے نہیں رہیں گے۔';

  @override
  String get accountPick => 'اکاؤنٹ (اختیاری)';

  @override
  String get accountNone => 'کوئی اکاؤنٹ نہیں';

  @override
  String get add => 'شامل کریں';

  @override
  String get taskRemindBefore => 'پہلے یاد دلائیں';

  @override
  String get taskRemindNone => 'صرف وقت پر';

  @override
  String taskRemindMin(String minutes) {
    return '$minutes منٹ پہلے';
  }

  @override
  String get taskRemindHour => '1 گھنٹہ پہلے';

  @override
  String get taskRemindDay => '1 دن پہلے';

  @override
  String get taskAtTime => 'وقت پر';

  @override
  String get taskAroundPrayer => 'نماز کے حساب سے';

  @override
  String taskOffsetBefore(String minutes) {
    return '$minutes منٹ پہلے';
  }

  @override
  String taskOffsetAfter(String minutes) {
    return '$minutes منٹ بعد';
  }

  @override
  String get taskOffsetAt => 'نماز کے وقت';

  @override
  String get taskBillAmount => 'بل کی رقم (اختیاری)';

  @override
  String get taskAddToKhataTitle => 'کھاتے میں شامل کریں؟';

  @override
  String taskAddToKhataBody(String amount, String title) {
    return '\"$title\" کے Rs $amount کھاتے میں شامل کریں؟';
  }

  @override
  String get taskBillAdded => 'کھاتے میں شامل ہو گیا';

  @override
  String get filterAll => 'سب';

  @override
  String get udhaarSortAmount => 'سب سے بڑی رقم پہلے';

  @override
  String get settingsDataBackup => 'ڈیٹا اور بیک اپ';

  @override
  String get backupExport => 'بیک اپ برآمد کریں';

  @override
  String get backupExportSub => 'اپنا ڈیٹا .saathi فائل کی صورت میں شیئر کریں';

  @override
  String get backupRestore => 'بیک اپ بحال کریں';

  @override
  String get backupRestoreSub => 'موجودہ ڈیٹا .saathi فائل سے بدلیں';

  @override
  String get backupAuto => 'خودکار بیک اپ';

  @override
  String backupAutoSub(String date) {
    return 'ہر ہفتے اس فون میں محفوظ ہوتے ہیں۔ آخری: $date';
  }

  @override
  String get backupAutoNone =>
      'ہر ہفتے اس فون میں محفوظ ہوتے ہیں۔ ابھی کوئی نہیں۔';

  @override
  String get settingsCountBank => 'بینک لین دین کو بجٹ میں شمار کریں';

  @override
  String get settingsCountBankSub =>
      'بینک نوٹیفکیشن سے ملنے والی ادائیگیاں بجٹ اور مجموعے میں شامل ہوں گی';

  @override
  String get trackerMonth => 'پچھلے 30 دن';

  @override
  String trackerCompletion(String percent) {
    return '$percent% نمازیں پڑھیں';
  }

  @override
  String trackerWeakest(String prayer, String done, String days) {
    return 'مشکل ترین نماز: $prayer ($days میں سے $done دن)';
  }

  @override
  String get tasbeehFree => 'آزاد گنتی';

  @override
  String get tasbeehSubhanallah => 'سبحان اللہ';

  @override
  String get tasbeehAlhamdulillah => 'الحمد للہ';

  @override
  String get tasbeehAllahuAkbar => 'اللہ اکبر';

  @override
  String tasbeehToday(String count) {
    return 'آج: $count';
  }

  @override
  String get tasbeehTargetReached => 'ہدف مکمل';

  @override
  String get trendTitle => 'پچھلے مہینے کے مقابلے میں';

  @override
  String trendMore(String amount, String percent) {
    return 'پچھلے مہینے سے Rs $amount زیادہ ($percent%)';
  }

  @override
  String trendLess(String amount, String percent) {
    return 'پچھلے مہینے سے Rs $amount کم ($percent%)';
  }

  @override
  String trendMoreNoPercent(String amount) {
    return 'پچھلے مہینے سے Rs $amount زیادہ';
  }

  @override
  String get trendSame => 'پچھلے مہینے کے برابر';

  @override
  String trendBiggestRise(String category, String amount) {
    return 'سب سے زیادہ اضافہ: $category (+Rs $amount)';
  }

  @override
  String get taskNewList => 'نئی فہرست';

  @override
  String get taskEditList => 'فہرست میں ترمیم';

  @override
  String get taskDeleteList => 'فہرست حذف کریں';

  @override
  String get taskTabToday => 'آج';

  @override
  String get taskTabUpcoming => 'آنے والے';

  @override
  String get taskEmptyUpcoming => 'کوئی آنے والا کام نہیں';

  @override
  String get taskEmptyDone => 'ابھی تک کچھ مکمل نہیں ہوا';

  @override
  String get taskEmptyToday => 'آج کوئی کام نہیں — ماشاءاللہ! 🎉';

  @override
  String get taskNoneToday => 'آج کے لیے کوئی کام نہیں';

  @override
  String taskTomorrowCount(String count) {
    return 'کل ($count)';
  }

  @override
  String taskOverdueCount(String count) {
    return 'تاخیر شدہ ($count)';
  }

  @override
  String get taskNew => 'نیا کام';

  @override
  String get taskEdit => 'کام میں ترمیم';

  @override
  String get taskDeleteConfirm => 'کام حذف کریں؟';

  @override
  String get taskReopen => 'دوبارہ کھولیں';

  @override
  String get taskTitleLabel => 'کام کا عنوان';

  @override
  String get taskNoteLabel => 'نوٹ (اختیاری)';

  @override
  String get taskListLabel => 'فہرست';

  @override
  String get taskNoList => 'کوئی فہرست نہیں';

  @override
  String get taskPriority => 'ترجیح:';

  @override
  String get taskPriorityNormal => 'عام';

  @override
  String get taskPriorityHigh => 'اہم';

  @override
  String get taskRepeat => 'دہرائیں';

  @override
  String get taskRepeatNone => 'نہیں دہرائے گا';

  @override
  String get taskRepeatDaily => 'ہر دن';

  @override
  String get taskRepeatWeekly => 'ہر ہفتے';

  @override
  String get taskRepeatMonthly => 'ہر مہینے';

  @override
  String get taskDailyShort => 'روزانہ';

  @override
  String get taskWeeklyShort => 'ہفتہ وار';

  @override
  String get taskMonthlyShort => 'ماہانہ';

  @override
  String get taskNoDueDate => 'کوئی تاریخ نہیں';

  @override
  String get taskNoTime => 'کوئی وقت نہیں (نوٹیفکیشن نہیں)';

  @override
  String get taskListName => 'فہرست کا نام';

  @override
  String get taskIcon => 'آئیکن';

  @override
  String get taskCreate => 'بنائیں';

  @override
  String get khataIncoming => 'آمد';

  @override
  String get khataOutgoing => 'روانگی';

  @override
  String get khataExportPdf => 'PDF برآمد کریں';

  @override
  String get khataExportCsv => 'CSV برآمد کریں';

  @override
  String get khataBank => 'بینک';

  @override
  String get summaryTitle => 'ماہانہ خلاصہ';

  @override
  String get khataSearchEntries => 'اندراجات تلاش کریں…';

  @override
  String get recurringTitle => 'بار بار آنے والے';

  @override
  String get khataShareWhatsApp => 'واٹس ایپ پر شیئر کریں';

  @override
  String get vaultMove => 'والٹ میں منتقل کریں';

  @override
  String get vaultMoveHint => 'عام فہرست سے چھپائیں';

  @override
  String get vaultMoveUdhaarHint => 'عام ادھار فہرست سے چھپائیں';

  @override
  String get bankSearch => 'بینک اندراجات تلاش کریں…';

  @override
  String get bankIn => 'آمد';

  @override
  String get bankOut => 'روانگی';

  @override
  String get bankAllBanks => 'تمام بینک';

  @override
  String get bankEmpty => 'ابھی کوئی بینک لین دین نہیں';

  @override
  String get bankNoMatch => 'کوئی مماثل لین دین نہیں';

  @override
  String get bankAutoCaptured => 'بینک نوٹیفکیشنز سے خودکار طور پر لیا گیا';

  @override
  String get entryDelete => 'اندراج حذف کریں';

  @override
  String get vaultUnlockReason => 'نجی اندراجات دیکھنے کے لیے والٹ کھولیں';

  @override
  String get vaultUnlock => 'کھولیں';

  @override
  String get vaultLock => 'والٹ بند کریں';

  @override
  String get vaultTabContacts => 'رابطے';

  @override
  String get vaultRemove => 'والٹ سے نکالیں';

  @override
  String get vaultDeleteContact => 'رابطہ حذف کریں';

  @override
  String get vaultDeleteContactQ => 'رابطہ حذف کریں؟';

  @override
  String get freqDaily => 'روزانہ';

  @override
  String get freqWeekly => 'ہفتہ وار';

  @override
  String get freqMonthly => 'ماہانہ';

  @override
  String get freqYearly => 'سالانہ';

  @override
  String get summaryNet => 'خالص بیلنس';

  @override
  String get summaryByCategory => 'زمرے کے لحاظ سے خرچ';

  @override
  String get summaryNoExpenses => 'اس مہینے کوئی خرچ نہیں';

  @override
  String get recurringEmpty => 'کوئی بار بار آنے والا اندراج نہیں';

  @override
  String get recurringEmptyHint =>
      'خرچ یا آمدنی شامل کرتے وقت \"دہرائیں\" آن کریں';

  @override
  String get recurringStopQ => 'دہرانا بند کریں؟';

  @override
  String get recurringStopNote => 'پرانے اندراجات حذف نہیں ہوں گے۔';

  @override
  String get recurringStop => 'بند کریں';

  @override
  String get expensePhotoTake => 'تصویر لیں';

  @override
  String get expensePhotoGallery => 'گیلری سے چنیں';

  @override
  String get expenseSource => 'ذریعہ';

  @override
  String get expenseRepeat => 'دہرائیں';

  @override
  String get bankSyncTitle => 'بینک سنک';

  @override
  String get bankSyncAuto => 'لین دین خودکار طور پر لیں';

  @override
  String get bankSyncChecking => 'جانچ جاری ہے…';

  @override
  String get bankSyncEnableHint =>
      'آن کرنے کے لیے ٹیپ کریں — لاگ اِن نہیں چاہیے، تمام بینک ایپس کے ساتھ کام کرتا ہے';

  @override
  String get bankSyncEnable => 'آن کریں';

  @override
  String get bankSyncPaused =>
      'اینڈرائیڈ نے روک دیا ہے — لین دین نہیں لیے جا رہے';

  @override
  String get bankSyncRestart => 'دوبارہ شروع کریں';

  @override
  String get bankSyncWaiting => 'فعال — پہلے بینک الرٹ کا انتظار';

  @override
  String bankSyncLast(String ago) {
    return 'فعال — آخری بینک الرٹ $ago';
  }

  @override
  String bankSyncPending(String count) {
    return '$count محفوظ ہونے کے منتظر';
  }

  @override
  String get bankSyncRestartHint =>
      'نوٹیفکیشن رسائی میں ساتھی کو بند کر کے دوبارہ آن کریں';

  @override
  String get agoJustNow => 'ابھی';

  @override
  String agoMinutes(String count) {
    return '$count منٹ پہلے';
  }

  @override
  String agoHours(String count) {
    return '$count گھنٹے پہلے';
  }

  @override
  String agoDays(String count) {
    return '$count دن پہلے';
  }

  @override
  String get ramadanMubarak => 'رمضان مبارک';

  @override
  String get ramadanTimetable => 'رمضان ٹائم ٹیبل';

  @override
  String get ramadanLabel => 'رمضان';

  @override
  String get ramadanSehriEnded => 'سحری ختم ہو گئی';

  @override
  String ramadanSehriEndsIn(String time) {
    return 'سحری ختم ہونے میں $time';
  }

  @override
  String get ramadanStopEating => 'فجر سے پہلے کھانا بند کریں';

  @override
  String ramadanIftarIn(String time) {
    return 'افطار میں $time';
  }

  @override
  String get ramadanKeepGoing => 'ہمت رکھیں! 💪';

  @override
  String get ramadanIftarTime => 'افطار کا وقت! 🎉';

  @override
  String ramadanSehriIn(String time) {
    return 'سحری میں $time';
  }

  @override
  String get ramadanEnjoy => 'کھانا نوش فرمائیں';

  @override
  String get ramadanAlhamdulillah => 'الحمد للہ';

  @override
  String get ramadanSehriEndsSuffix => ' · سحری ختم';

  @override
  String get ramadanIftarSuffix => ' · افطار';

  @override
  String get imsakiyaTitle => 'رمضان ٹائم ٹیبل';

  @override
  String get imsakiyaShareFail => 'ٹائم ٹیبل شیئر نہیں ہو سکا';

  @override
  String get imsakiyaNoDates => 'رمضان کی تاریخیں معلوم نہیں ہو سکیں';

  @override
  String get imsakiyaShare => 'تصویر کے طور پر شیئر کریں';

  @override
  String get imsakiyaDay => 'دن';

  @override
  String get imsakiyaDate => 'تاریخ';

  @override
  String get imsakiyaSehri => 'سحری ختم';

  @override
  String get imsakiyaIftar => 'افطار';

  @override
  String backupFailed(String error) {
    return 'بیک اپ ناکام: $error';
  }

  @override
  String get backupNoAccess => 'منتخب فائل تک رسائی نہیں ہو سکی۔';

  @override
  String get backupIncomplete => 'یہ فائل مکمل ساتھی بیک اپ نہیں ہے۔';

  @override
  String get backupNotSaathi => 'یہ فائل ساتھی کا بیک اپ نہیں ہے۔';

  @override
  String get backupNewer =>
      'یہ بیک اپ ساتھی کے نئے ورژن کا ہے۔ پہلے ایپ اپ ڈیٹ کریں۔';

  @override
  String get backupDamaged => 'یہ بیک اپ فائل خراب ہے۔';

  @override
  String get backupOlder => 'ایک پرانا بیک اپ';

  @override
  String get restoreConfirmTitle => 'بیک اپ بحال کریں؟';

  @override
  String restoreConfirmBody(String when) {
    return 'یہ آپ کا تمام موجودہ ڈیٹا $when سے بدل دے گا۔\n\nموجودہ ڈیٹا کی ایک حفاظتی کاپی اس فون میں رکھی جائے گی۔ ساتھی بعد میں بند ہو جائے گا؛ جاری رکھنے کے لیے دوبارہ کھولیں۔';
  }

  @override
  String get restoreButton => 'بحال کریں';

  @override
  String get restoreDoneTitle => 'بیک اپ بحال ہو گیا';

  @override
  String get restoreDoneBody =>
      'ساتھی اب بند ہو جائے گا۔ اپنا ڈیٹا دیکھنے کے لیے دوبارہ کھولیں۔';

  @override
  String restoreFailedKept(String error) {
    return 'بحالی ناکام: $error۔ ساتھی بند کر کے دوبارہ کھولیں؛ آپ کے ڈیٹا کی حفاظتی کاپی رکھی گئی ہے۔';
  }

  @override
  String restoreFailedSafe(String error) {
    return 'بحالی ناکام: $error۔ آپ کا ڈیٹا تبدیل نہیں ہوا۔';
  }

  @override
  String get khataIncludesBank =>
      'مجموعوں میں بینک لین دین شامل ہیں (بینک ٹیب دیکھیں)';
}
