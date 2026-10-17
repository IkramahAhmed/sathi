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
}
