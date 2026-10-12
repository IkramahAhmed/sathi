// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Saathi';

  @override
  String get navHome => 'Home';

  @override
  String get navTimetable => 'Timetable';

  @override
  String get navQibla => 'Qibla';

  @override
  String get navSettings => 'Settings';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get done => 'Done';

  @override
  String get retry => 'Try again';

  @override
  String get close => 'Close';

  @override
  String get allow => 'Allow';

  @override
  String get allowed => 'Allowed';

  @override
  String get genericError => 'Something went wrong';

  @override
  String get prayerFajr => 'Fajr';

  @override
  String get prayerSunrise => 'Sunrise';

  @override
  String get prayerDhuhr => 'Dhuhr';

  @override
  String get prayerAsr => 'Asr';

  @override
  String get prayerMaghrib => 'Maghrib';

  @override
  String get prayerIsha => 'Isha';

  @override
  String get prayerJumma => 'Jumma';

  @override
  String get prayerTimesTitle => 'Prayer times';

  @override
  String nextPrayer(String prayer, String duration) {
    return 'Next: $prayer in $duration';
  }

  @override
  String sunriseAt(String time) {
    return 'Sunrise $time';
  }

  @override
  String get prayedLabel => 'Prayed';

  @override
  String markPrayed(String prayer) {
    return 'Mark $prayer as prayed';
  }

  @override
  String azanToggle(String prayer) {
    return 'Azan for $prayer';
  }

  @override
  String hijriDate(int day, String month, int year) {
    return '$day $month $year AH';
  }

  @override
  String get locationRefresh => 'Update my location';

  @override
  String locationUpdated(String city) {
    return 'Location set to $city';
  }

  @override
  String get locationFailed => 'Could not get your location';

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String durationSeconds(int seconds) {
    return '$seconds s';
  }

  @override
  String get bannerExactTitle => 'Exact alarms are off';

  @override
  String get bannerExactBody =>
      'Azan may arrive a few minutes late. Allow “Alarms & reminders” for on-time azan.';

  @override
  String get bannerExactAction => 'Allow';

  @override
  String get bannerNotifTitle => 'Notifications are off';

  @override
  String get bannerNotifBody => 'Turn notifications on to hear the azan.';

  @override
  String get tasbeehTitle => 'Tasbeeh';

  @override
  String get tasbeehTapHint => 'Tap to count';

  @override
  String get tasbeehReset => 'Reset';

  @override
  String get timetableTitle => 'Monthly timetable';

  @override
  String get shareImage => 'Share as image';

  @override
  String get shareFailed => 'Could not share the timetable';

  @override
  String get colDate => 'Date';

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get secLocation => 'Location';

  @override
  String get useMyLocation => 'Use my location';

  @override
  String get chooseCity => 'Choose a city';

  @override
  String get searchCity => 'Search city';

  @override
  String currentLocation(String city, String country) {
    return '$city, $country';
  }

  @override
  String get followMe => 'Update when I travel';

  @override
  String get followMeHint => 'Recalculates when you move more than 50 km';

  @override
  String get secCalculation => 'Calculation';

  @override
  String get method => 'Method';

  @override
  String get madhab => 'Asr (madhab)';

  @override
  String get madhabHanafi => 'Hanafi';

  @override
  String get madhabShafi => 'Shafi’i / Maliki / Hanbali';

  @override
  String get highLatRule => 'High-latitude rule';

  @override
  String get highLatMiddle => 'Middle of the night';

  @override
  String get highLatSeventh => 'One-seventh of the night';

  @override
  String get highLatAngle => 'Twilight angle';

  @override
  String autoMethod(String method) {
    return 'Auto: $method';
  }

  @override
  String get useCountryDefaults => 'Use country defaults';

  @override
  String get secPrayers => 'Prayers';

  @override
  String get masjidAdjust => 'Masjid time (± minutes)';

  @override
  String minutesValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get preReminder => 'Reminder before prayer';

  @override
  String get off => 'Off';

  @override
  String get azanSound => 'Azan sound';

  @override
  String get soundBeep => 'Beep';

  @override
  String get soundMakkah => 'Makkah';

  @override
  String get soundMadina => 'Madina';

  @override
  String get soundSilent => 'Silent';

  @override
  String get previewSound => 'Preview';

  @override
  String get secHijri => 'Hijri date';

  @override
  String get hijriAdjust => 'Moon-sighting correction';

  @override
  String get hijriNoChange => 'No change';

  @override
  String get hijriPlusOne => '+1 day';

  @override
  String get hijriMinusOne => '−1 day';

  @override
  String get secLanguage => 'Language';

  @override
  String get langEnglish => 'English';

  @override
  String get langUrdu => 'اردو';

  @override
  String get langRomanUrdu => 'Roman Urdu';

  @override
  String get testNotification => 'Test notification in 10 s';

  @override
  String get testScheduled => 'A test notification will arrive in 10 seconds';

  @override
  String get testTitle => 'Saathi test';

  @override
  String get testBody => 'If you can hear this, the azan will work';

  @override
  String get batteryHelp => 'Battery & background help';

  @override
  String pendingCount(int count) {
    return '$count azan alerts scheduled';
  }

  @override
  String get qiblaTitle => 'Qibla';

  @override
  String qiblaBearing(int degrees) {
    return 'Qibla is $degrees° from north';
  }

  @override
  String get qiblaNoSensor =>
      'This phone has no compass sensor. Use the bearing above with a compass.';

  @override
  String get qiblaFace => 'Turn until the arrow points up';

  @override
  String stepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get onbWelcomeTitle => 'Assalamu alaikum';

  @override
  String get onbWelcomeBody =>
      'Saathi tells you prayer times and plays the azan, even with no internet.';

  @override
  String get onbLanguageTitle => 'Choose your language';

  @override
  String get onbLocationTitle => 'Your location';

  @override
  String get onbLocationBody =>
      'Used to calculate accurate prayer times. It stays on your phone.';

  @override
  String get onbLocationAllow => 'Use my location';

  @override
  String get onbLocationManual => 'Or choose a city';

  @override
  String get onbNotifTitle => 'Azan notifications';

  @override
  String get onbNotifBody =>
      'Allow notifications so Saathi can call you to prayer.';

  @override
  String get onbExactTitle => 'On-time alarms';

  @override
  String get onbExactBody =>
      'Allow “Alarms & reminders” so the azan fires at the exact minute.';

  @override
  String get onbOemTitle => 'Keep Saathi running';

  @override
  String get onbOemBody =>
      'Your phone may stop apps in the background. A few settings keep the azan reliable.';

  @override
  String get onbOemOpen => 'See the steps';

  @override
  String get onbDoneTitle => 'All set';

  @override
  String get onbDoneBody => 'Saathi will call you at every prayer.';

  @override
  String get onbStart => 'Start';

  @override
  String get oemTitle => 'Allow background azan';

  @override
  String oemIntro(String brand) {
    return '$brand phones often stop background apps to save battery. Do these steps once:';
  }

  @override
  String get oemStep1 =>
      'Open App info, then Battery, and choose “No restrictions” (or “Unrestricted”).';

  @override
  String get oemStep2 => 'Turn on “Autostart” or “Auto-launch” for Saathi.';

  @override
  String get oemStep3 =>
      'In Recent apps, lock Saathi (pull its card down or long-press, then choose Lock).';

  @override
  String get oemStep4 =>
      'Keep notifications and notification sound switched on.';

  @override
  String get oemOpenSettings => 'Open app settings';

  @override
  String get oemDontShow => 'Don’t show again';

  @override
  String get oemGotIt => 'Got it';
}

/// The translations for English, as used in Pakistan (`en_PK`).
class AppLocalizationsEnPk extends AppLocalizationsEn {
  AppLocalizationsEnPk() : super('en_PK');

  @override
  String get appName => 'Saathi';

  @override
  String get navHome => 'Home';

  @override
  String get navTimetable => 'Timetable';

  @override
  String get navQibla => 'Qibla';

  @override
  String get navSettings => 'Settings';

  @override
  String get ok => 'Theek hai';

  @override
  String get cancel => 'Cancel';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Aagay';

  @override
  String get back => 'Wapas';

  @override
  String get done => 'Mukammal';

  @override
  String get retry => 'Dobara koshish karein';

  @override
  String get close => 'Band karein';

  @override
  String get allow => 'Ijazat dein';

  @override
  String get allowed => 'Ijazat mil gayi';

  @override
  String get genericError => 'Kuch ghalat ho gaya';

  @override
  String get prayerFajr => 'Fajr';

  @override
  String get prayerSunrise => 'Tuloo-e-Aftab';

  @override
  String get prayerDhuhr => 'Zuhr';

  @override
  String get prayerAsr => 'Asr';

  @override
  String get prayerMaghrib => 'Maghrib';

  @override
  String get prayerIsha => 'Isha';

  @override
  String get prayerJumma => 'Jumma';

  @override
  String get prayerTimesTitle => 'Namaz ka waqt';

  @override
  String nextPrayer(String prayer, String duration) {
    return 'Agli namaz: $prayer, $duration mein';
  }

  @override
  String sunriseAt(String time) {
    return 'Tuloo-e-Aftab $time';
  }

  @override
  String get prayedLabel => 'Ada ki';

  @override
  String markPrayed(String prayer) {
    return '$prayer ada ki mark karein';
  }

  @override
  String azanToggle(String prayer) {
    return '$prayer ki azan';
  }

  @override
  String hijriDate(int day, String month, int year) {
    return '$day $month $year AH';
  }

  @override
  String get locationRefresh => 'Meri location update karein';

  @override
  String locationUpdated(String city) {
    return 'Location $city set ho gayi';
  }

  @override
  String get locationFailed => 'Aap ki location nahi mil saki';

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours ghanta $minutes min';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String durationSeconds(int seconds) {
    return '$seconds sec';
  }

  @override
  String get bannerExactTitle => 'Exact alarms band hain';

  @override
  String get bannerExactBody =>
      'Azan kuch minute late aa sakti hai. Waqt par azan ke liye “Alarms & reminders” ki ijazat dein.';

  @override
  String get bannerExactAction => 'Ijazat dein';

  @override
  String get bannerNotifTitle => 'Notifications band hain';

  @override
  String get bannerNotifBody => 'Azan sunne ke liye notifications on karein.';

  @override
  String get tasbeehTitle => 'Tasbeeh';

  @override
  String get tasbeehTapHint => 'Ginnay ke liye tap karein';

  @override
  String get tasbeehReset => 'Reset';

  @override
  String get timetableTitle => 'Mahana timetable';

  @override
  String get shareImage => 'Image ki soorat mein share karein';

  @override
  String get shareFailed => 'Timetable share nahi ho saka';

  @override
  String get colDate => 'Tareekh';

  @override
  String get previousMonth => 'Pichla mahina';

  @override
  String get nextMonth => 'Agla mahina';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get secLocation => 'Maqam';

  @override
  String get useMyLocation => 'Meri location istemal karein';

  @override
  String get chooseCity => 'Shehar chunein';

  @override
  String get searchCity => 'Shehar talash karein';

  @override
  String currentLocation(String city, String country) {
    return '$city, $country';
  }

  @override
  String get followMe => 'Safar par khud update karein';

  @override
  String get followMeHint => '50 km se ziyada safar par dobara hisab hoga';

  @override
  String get secCalculation => 'Hisab ka tareeqa';

  @override
  String get method => 'Tareeqa';

  @override
  String get madhab => 'Asr (madhab)';

  @override
  String get madhabHanafi => 'Hanafi';

  @override
  String get madhabShafi => 'Shafi’i / Maliki / Hanbali';

  @override
  String get highLatRule => 'High-latitude rule';

  @override
  String get highLatMiddle => 'Aadhi raat';

  @override
  String get highLatSeventh => 'Raat ka satwan hissa';

  @override
  String get highLatAngle => 'Shafaq ka zaawiya';

  @override
  String autoMethod(String method) {
    return 'Auto: $method';
  }

  @override
  String get useCountryDefaults => 'Mulk ke mutabiq default';

  @override
  String get secPrayers => 'Namazein';

  @override
  String get masjidAdjust => 'Masjid ka waqt (± minute)';

  @override
  String minutesValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get preReminder => 'Namaz se pehle yaad-dehani';

  @override
  String get off => 'Band';

  @override
  String get azanSound => 'Azan ki awaz';

  @override
  String get soundBeep => 'Beep';

  @override
  String get soundMakkah => 'Makkah';

  @override
  String get soundMadina => 'Madina';

  @override
  String get soundSilent => 'Khamosh';

  @override
  String get previewSound => 'Suniye';

  @override
  String get secHijri => 'Hijri tareekh';

  @override
  String get hijriAdjust => 'Chand dekhne ki tasheeh';

  @override
  String get hijriNoChange => 'Koi tabdeeli nahi';

  @override
  String get hijriPlusOne => '+1 din';

  @override
  String get hijriMinusOne => '−1 din';

  @override
  String get secLanguage => 'Zubaan';

  @override
  String get langEnglish => 'English';

  @override
  String get langUrdu => 'اردو';

  @override
  String get langRomanUrdu => 'Roman Urdu';

  @override
  String get testNotification => '10 second mein test notification';

  @override
  String get testScheduled => '10 second mein test notification aayegi';

  @override
  String get testTitle => 'Saathi test';

  @override
  String get testBody => 'Agar aap yeh sun rahe hain to azan theek kaam karegi';

  @override
  String get batteryHelp => 'Battery aur background madad';

  @override
  String pendingCount(int count) {
    return '$count azan alerts set hain';
  }

  @override
  String get qiblaTitle => 'Qibla';

  @override
  String qiblaBearing(int degrees) {
    return 'Qibla shimal se $degrees° par hai';
  }

  @override
  String get qiblaNoSensor =>
      'Is phone mein compass sensor nahi. Upar di gayi degree compass ke saath istemal karein.';

  @override
  String get qiblaFace => 'Teer ke upar ki taraf hone tak ghumayein';

  @override
  String stepOf(int current, int total) {
    return 'Marhala $current / $total';
  }

  @override
  String get onbWelcomeTitle => 'Assalamu alaikum';

  @override
  String get onbWelcomeBody =>
      'Saathi aap ko namaz ke auqaat batata hai aur azan sunata hai, internet ke baghair bhi.';

  @override
  String get onbLanguageTitle => 'Apni zubaan chunein';

  @override
  String get onbLocationTitle => 'Aap ka maqam';

  @override
  String get onbLocationBody =>
      'Durust auqaat ke hisab ke liye istemal hoti hai. Yeh aap ke phone hi mein rehti hai.';

  @override
  String get onbLocationAllow => 'Meri location istemal karein';

  @override
  String get onbLocationManual => 'Ya shehar chunein';

  @override
  String get onbNotifTitle => 'Azan ke notifications';

  @override
  String get onbNotifBody =>
      'Notifications ki ijazat dein taake Saathi aap ko namaz ke liye bula sake.';

  @override
  String get onbExactTitle => 'Waqt par alarms';

  @override
  String get onbExactBody =>
      'Azan ain waqt par bajne ke liye “Alarms & reminders” ki ijazat dein.';

  @override
  String get onbOemTitle => 'Saathi ko chaalu rakhein';

  @override
  String get onbOemBody =>
      'Aap ka phone background apps band kar sakta hai. Chand settings azan ko qabil-e-aitmaad rakhti hain.';

  @override
  String get onbOemOpen => 'Marahil dekhein';

  @override
  String get onbDoneTitle => 'Sab tayyar hai';

  @override
  String get onbDoneBody => 'Saathi har namaz par aap ko bulayega.';

  @override
  String get onbStart => 'Shuru karein';

  @override
  String get oemTitle => 'Background azan ki ijazat';

  @override
  String oemIntro(String brand) {
    return '$brand phones aksar battery bachane ke liye background apps band kar dete hain. Yeh steps ek baar karein:';
  }

  @override
  String get oemStep1 =>
      'App info kholein, phir Battery, aur “No restrictions” (ya “Unrestricted”) chunein.';

  @override
  String get oemStep2 =>
      'Saathi ke liye “Autostart” ya “Auto-launch” on karein.';

  @override
  String get oemStep3 =>
      'Recent apps mein Saathi ko lock karein (card neeche khainchein ya dabaye rakhein, phir Lock chunein).';

  @override
  String get oemStep4 => 'Notifications aur notification ki awaz on rakhein.';

  @override
  String get oemOpenSettings => 'App settings kholein';

  @override
  String get oemDontShow => 'Dobara na dikhayein';

  @override
  String get oemGotIt => 'Samajh gaya';
}
