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
  String get soundFull => 'Azan (full)';

  @override
  String get soundShort => 'Azan (short)';

  @override
  String get soundSilent => 'Silent';

  @override
  String get audioCredits => 'Audio credits';

  @override
  String get audioCreditsBody =>
      'Azan recording: “The Adhan - Muslim Call to Prayer - Aaqib Azeez”, shared on Wikimedia Commons by Atcovi under CC BY-SA 4.0. The short version is a trimmed copy with a fade-out. Source: commons.wikimedia.org (File:The Adhan - Muslim Call to Prayer - Aaqib Azeez.mp3). License: creativecommons.org/licenses/by-sa/4.0';

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
  String get syncSection => 'Cloud backup';

  @override
  String get syncTitle => 'Back up my prayed log';

  @override
  String get syncSubtitle =>
      'Keeps your ticked prayers safe and the same on all your phones';

  @override
  String get syncServer => 'Server address';

  @override
  String get syncServerNotSet => 'Not set';

  @override
  String get syncServerHint => 'https://your-server.workers.dev';

  @override
  String get syncServerInvalid => 'Enter an https:// address';

  @override
  String get syncKey => 'Sync key';

  @override
  String get syncKeyHelp =>
      'Keep this secret. Anyone with it can see your prayed log. You need it to restore your log on a new phone.';

  @override
  String get syncKeyCopy => 'Copy key';

  @override
  String get syncKeyCopied => 'Key copied';

  @override
  String get syncKeyShow => 'Show key';

  @override
  String get syncKeyHide => 'Hide key';

  @override
  String get syncUseKey => 'Use a key from another phone';

  @override
  String get syncUseKeyHelp =>
      'Paste the key from your other phone. This phone\'s log is merged with the cloud copy.';

  @override
  String get syncKeyInvalid => 'That does not look like a valid key';

  @override
  String get syncUse => 'Use this key';

  @override
  String get syncSave => 'Save';

  @override
  String get syncNow => 'Sync now';

  @override
  String get syncRunning => 'Syncing…';

  @override
  String syncLastSynced(String time) {
    return 'Last synced $time';
  }

  @override
  String get syncNever => 'Not synced yet';

  @override
  String syncPending(int count) {
    return '$count waiting to upload';
  }

  @override
  String get syncProblemSetup => 'Set the server address first';

  @override
  String get syncProblemOffline => 'No connection. It will try again later.';

  @override
  String get syncProblemServer =>
      'The server had a problem. It will try again later.';

  @override
  String get syncProblemKey => 'The server did not accept this key.';

  @override
  String get syncProblemOther => 'Sync did not work. It will try again later.';

  @override
  String get syncDelete => 'Delete my cloud data';

  @override
  String get syncDeleteBody =>
      'This erases your backup from the cloud. The prayed log on this phone is not touched.';

  @override
  String get syncDeleteConfirm => 'Delete';

  @override
  String get syncDeleted => 'Cloud data deleted';

  @override
  String get navTracker => 'Tracker';

  @override
  String get trackerTitle => 'Prayer tracker';

  @override
  String streakCurrent(int days) {
    return '$days-day streak';
  }

  @override
  String streakBest(int days) {
    return 'Best: $days';
  }

  @override
  String get streakNone => 'Pray all five today to start a streak';

  @override
  String get trackerToday => 'Today';

  @override
  String get trackerPrevDay => 'Previous day';

  @override
  String get trackerNextDay => 'Next day';

  @override
  String get trackerFuture => 'You cannot tick a day that has not happened yet';

  @override
  String get trackerPausedDay =>
      'Paused: prayers on this day are not counted as missed';

  @override
  String get dayComplete => 'All five prayed';

  @override
  String get pauseTitle => 'Pause';

  @override
  String get pauseHelp =>
      'For illness or a woman\'s period. Paused days do not break your streak or count as missed. This stays on this phone only and is never uploaded.';

  @override
  String get pauseStart => 'Start a pause today';

  @override
  String get pauseEnd => 'Resume';

  @override
  String pauseSince(String date) {
    return 'Paused since $date';
  }

  @override
  String get pauseAddPast => 'Add past days';

  @override
  String pauseRange(String start, String end) {
    return '$start to $end';
  }

  @override
  String get pauseRemove => 'Remove';

  @override
  String get pauseNone => 'No pauses';

  @override
  String get qazaTitle => 'Qaza (missed prayers)';

  @override
  String qazaCardOwed(int count) {
    return '$count to make up';
  }

  @override
  String get qazaCardNone => 'Nothing owed';

  @override
  String get qazaMadeUp => 'Made up one';

  @override
  String get qazaAddOne => 'Add one missed';

  @override
  String get qazaSetBalance => 'Set starting balance';

  @override
  String get qazaBalanceHelp =>
      'How many of each prayer do you owe? Leave a prayer at 0 if none.';

  @override
  String get qazaEstimate => 'Estimate from years';

  @override
  String get qazaYears => 'Years of missed prayers';

  @override
  String get qazaYearsHelp =>
      'Fills every prayer with years × 365. You can adjust each one after.';

  @override
  String get qazaApply => 'Apply';

  @override
  String get qazaAuto => 'Count missed prayers automatically';

  @override
  String get qazaAutoHelp =>
      'Adds a missed prayer when its time ends without a tick. Starts from today. It is taken back if you tick it later, and paused days are skipped.';

  @override
  String get qazaHistory => 'History';

  @override
  String get qazaHistoryEmpty => 'Nothing yet';

  @override
  String get qazaSourceInitial => 'Starting balance';

  @override
  String get qazaSourceAdded => 'Added';

  @override
  String get qazaSourceMadeUp => 'Made up';

  @override
  String get qazaSourceAuto => 'Counted automatically';

  @override
  String qazaTotal(int count) {
    return '$count prayers to make up';
  }

  @override
  String get jamaatSection => 'Jama\'at (mosque)';

  @override
  String get jamaatHelp =>
      'Set your mosque\'s jama\'at times to see them next to each prayer, and to be reminded to leave. Use minutes after the azan, or a fixed time.';

  @override
  String get jamaatNotSet => 'Not set';

  @override
  String jamaatAfter(int minutes) {
    return '$minutes min after azan';
  }

  @override
  String jamaatFixed(String time) {
    return 'At $time';
  }

  @override
  String jamaatAt(String time) {
    return 'Jama\'at $time';
  }

  @override
  String get jamaatEdit => 'Jama\'at time';

  @override
  String get jamaatModeAfter => 'Minutes after azan';

  @override
  String get jamaatModeFixed => 'Fixed time';

  @override
  String get jamaatPickTime => 'Pick time';

  @override
  String get jamaatClear => 'Clear';

  @override
  String get jummaTime => 'Jumma time';

  @override
  String get leaveReminder => 'Remind me to leave';

  @override
  String leaveMinutes(int minutes) {
    return '$minutes min before jama\'at';
  }

  @override
  String get silentDuring => 'Silence my phone during jama\'at';

  @override
  String get silentHelp =>
      'Needs Do Not Disturb access. The phone returns to normal afterwards.';

  @override
  String get silentLength => 'Stay silent for';

  @override
  String get silentGrantAccess => 'Allow Do Not Disturb access';

  @override
  String get azanAlarmVolume => 'Play azan on the alarm volume';

  @override
  String get azanAlarmHelp =>
      'Heard even in silent mode, and not affected by the media volume.';

  @override
  String get checkSetupTitle => 'Check my setup';

  @override
  String get checkSetupIntro =>
      'Make sure the azan will really sound. Fix anything marked in red.';

  @override
  String get checkNotifications => 'Notifications allowed';

  @override
  String get checkExact => 'Alarms and reminders allowed';

  @override
  String get checkExactHelp => 'Lets the azan fire at the exact minute.';

  @override
  String get checkBattery => 'Battery: unrestricted';

  @override
  String get checkBatteryHelp =>
      'Open app settings, then Battery, and choose No restrictions.';

  @override
  String get checkChannel => 'Azan sound turned on in system settings';

  @override
  String get checkChannelHelp =>
      'The azan sound is muted for this app. Turn it on in the notification settings.';

  @override
  String checkScheduled(int count) {
    return '$count alerts scheduled';
  }

  @override
  String get checkNoneScheduled => 'No alerts are scheduled';

  @override
  String get checkOk => 'OK';

  @override
  String get checkFix => 'Fix';

  @override
  String get checkTestNow => 'Play a test azan now';

  @override
  String get checkReplan => 'Re-plan all alerts';

  @override
  String get checkReplanned => 'Alerts re-planned';

  @override
  String get endSection => 'Prayer time ending';

  @override
  String get endHelp =>
      'Get reminded before a prayer\'s time ends, and again until you have prayed. If a prayer is missed it goes to your qaza list.';

  @override
  String get endEnable => 'Remind me before a prayer ends';

  @override
  String get endLead => 'First reminder';

  @override
  String endLeadValue(int minutes) {
    return '$minutes min before the end';
  }

  @override
  String get endRepeat => 'Then repeat every';

  @override
  String endRepeatValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get endPrayers => 'Which prayers';

  @override
  String get endRequirePhoto => 'Photo proof';

  @override
  String get endRequirePhotoHelp =>
      'Keep reminding until you take a photo of your prayer place, such as your prayer mat or the mosque. The photo is checked on this phone and is never saved or sent anywhere.';

  @override
  String get endTestTitle => 'Try the ending reminder';

  @override
  String get endTestHelp =>
      'Sends 3 test notifications spaced 1 minute apart so you can experience the full flow.';

  @override
  String get endTestSend => 'Send';

  @override
  String get endTestScheduled =>
      '3 test reminders sent — first arrives in 10 seconds.';

  @override
  String get verifyTitle => 'Prayer photo check';

  @override
  String get verifyIntro =>
      'After you pray, take a photo of your prayer place, such as your prayer mat or the mosque. It is checked on this phone only and is never saved.';

  @override
  String verifyPrayer(String prayer, String date) {
    return '$prayer · $date';
  }

  @override
  String get verifyTake => 'Take photo';

  @override
  String get verifyChecking => 'Checking…';

  @override
  String get verifySuccess => 'Verified. May Allah accept your prayer.';

  @override
  String get verifyTestNote =>
      'This was a test reminder — your prayer log was not changed.';

  @override
  String get verifyFail =>
      'That does not look like a prayer place. Try again with your prayer mat or the mosque in view.';

  @override
  String get verifyTryAgain => 'Try again';

  @override
  String get verifyStop => 'Stop reminding me';

  @override
  String get verifyStopHelp =>
      'Use this if you cannot pray now. The prayer is not marked as prayed.';

  @override
  String verifySaw(String labels) {
    return 'The phone saw: $labels';
  }

  @override
  String get verifyEnded =>
      'This prayer\'s time has ended. You can still tick it in the tracker.';

  @override
  String get verifyProofNeeded => 'Photo proof is on for this prayer';

  @override
  String get verifyNoCamera => 'The camera could not be opened';

  @override
  String get verifyChecklistHint =>
      'Tip: make sure the prayer mat or the mosque fills most of the picture.';

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
  String qiblaTurnRight(int degrees) {
    return 'Turn right $degrees°';
  }

  @override
  String qiblaTurnLeft(int degrees) {
    return 'Turn left $degrees°';
  }

  @override
  String get qiblaFacing => 'You are facing the Qibla';

  @override
  String qiblaHeading(int degrees) {
    return 'Phone points $degrees°';
  }

  @override
  String qiblaDistance(String km) {
    return '$km km to the Kaaba';
  }

  @override
  String get qiblaCalibrate =>
      'Compass needs calibrating. Move the phone in a figure 8, away from metal and magnets.';

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

  @override
  String get scanTimetableButton => 'Scan mosque timetable';

  @override
  String get scanTimetableTitle => 'Mosque timetable';

  @override
  String get scanTimetableScanning => 'Reading timetable…';

  @override
  String get scanTimetableError =>
      'Could not read the photo. Try again in better lighting.';

  @override
  String scanTimetableFound(int count) {
    return '$count of 5 prayers detected. Tap any row to adjust.';
  }

  @override
  String get scanTimetableNoneFound =>
      'No prayer times found. Try a clearer photo.';

  @override
  String get scanTimetableHint =>
      'Detected times are highlighted in gold. Tap any row to correct a time.';

  @override
  String get scanTimetableSave => 'Save jama\'at times';

  @override
  String get scanAutoDetected => 'Auto-detected';

  @override
  String get scanTapToAdjust => 'Tap to adjust';

  @override
  String get scanNotDetected => 'Not detected — tap to set';
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
  String get soundFull => 'Azan (mukammal)';

  @override
  String get soundShort => 'Azan (mukhtasar)';

  @override
  String get soundSilent => 'Khamosh';

  @override
  String get audioCredits => 'Audio ka hawala';

  @override
  String get audioCreditsBody =>
      'Azan ki recording: “The Adhan - Muslim Call to Prayer - Aaqib Azeez”, jo Atcovi ne Wikimedia Commons par CC BY-SA 4.0 ke tahat share ki. Mukhtasar version usi ki kati hui copy hai jis ke aakhir mein awaz dheemi hoti hai. Source: commons.wikimedia.org (File:The Adhan - Muslim Call to Prayer - Aaqib Azeez.mp3). License: creativecommons.org/licenses/by-sa/4.0';

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
  String get syncSection => 'Cloud backup';

  @override
  String get syncTitle => 'Meri ada ki gayi namazon ka backup';

  @override
  String get syncSubtitle =>
      'Aap ki nishan zad namazein mehfooz rehti hain aur aap ke tamam phones par yaksan';

  @override
  String get syncServer => 'Server ka pata';

  @override
  String get syncServerNotSet => 'Muqarrar nahi';

  @override
  String get syncServerHint => 'https://your-server.workers.dev';

  @override
  String get syncServerInvalid => 'https:// wala pata darj karein';

  @override
  String get syncKey => 'Sync key';

  @override
  String get syncKeyHelp =>
      'Isay khufiya rakhein. Jis ke paas yeh ho woh aap ki ada ki gayi namazein dekh sakta hai. Naye phone par log bahal karne ke liye yeh zaroori hai.';

  @override
  String get syncKeyCopy => 'Key copy karein';

  @override
  String get syncKeyCopied => 'Key copy ho gayi';

  @override
  String get syncKeyShow => 'Key dikhayein';

  @override
  String get syncKeyHide => 'Key chhupayein';

  @override
  String get syncUseKey => 'Doosre phone ki key istemal karein';

  @override
  String get syncUseKeyHelp =>
      'Apne doosre phone ki key yahan paste karein. Is phone ka log cloud copy ke saath mil jayega.';

  @override
  String get syncKeyInvalid => 'Yeh durust key nahi lagti';

  @override
  String get syncUse => 'Yeh key istemal karein';

  @override
  String get syncSave => 'Save';

  @override
  String get syncNow => 'Abhi sync karein';

  @override
  String get syncRunning => 'Sync ho raha hai…';

  @override
  String syncLastSynced(String time) {
    return 'Aakhri sync $time';
  }

  @override
  String get syncNever => 'Abhi tak sync nahi hua';

  @override
  String syncPending(int count) {
    return '$count upload ke muntazir';
  }

  @override
  String get syncProblemSetup => 'Pehle server ka pata muqarrar karein';

  @override
  String get syncProblemOffline => 'Rabta nahi. Baad mein dobara koshish hogi.';

  @override
  String get syncProblemServer =>
      'Server mein masla tha. Baad mein dobara koshish hogi.';

  @override
  String get syncProblemKey => 'Server ne yeh key qabool nahi ki.';

  @override
  String get syncProblemOther =>
      'Sync nahi ho saka. Baad mein dobara koshish hogi.';

  @override
  String get syncDelete => 'Mera cloud data delete karein';

  @override
  String get syncDeleteBody =>
      'Yeh cloud se aap ka backup mita dega. Is phone ka log mehfooz rahega.';

  @override
  String get syncDeleteConfirm => 'Delete';

  @override
  String get syncDeleted => 'Cloud data delete ho gaya';

  @override
  String get navTracker => 'Tracker';

  @override
  String get trackerTitle => 'Namaz tracker';

  @override
  String streakCurrent(int days) {
    return '$days din ka silsila';
  }

  @override
  String streakBest(int days) {
    return 'Behtareen: $days';
  }

  @override
  String get streakNone =>
      'Silsila shuru karne ke liye aaj paanchon namazein parhein';

  @override
  String get trackerToday => 'Aaj';

  @override
  String get trackerPrevDay => 'Pichla din';

  @override
  String get trackerNextDay => 'Agla din';

  @override
  String get trackerFuture =>
      'Aanay wale din ki namaz nishan zad nahi ho sakti';

  @override
  String get trackerPausedDay =>
      'Waqfa: is din ki namazein chhooti hui shumar nahi hongi';

  @override
  String get dayComplete => 'Paanchon parhein';

  @override
  String get pauseTitle => 'Waqfa';

  @override
  String get pauseHelp =>
      'Bimari ya khawateen ke makhsoos ayyam ke liye. Waqfe ke din silsila nahi torte aur chhooti namazon mein shumar nahi hote. Yeh sirf isi phone par rehta hai, kabhi upload nahi hota.';

  @override
  String get pauseStart => 'Aaj se waqfa shuru karein';

  @override
  String get pauseEnd => 'Dobara shuru karein';

  @override
  String pauseSince(String date) {
    return '$date se waqfe mein';
  }

  @override
  String get pauseAddPast => 'Pichhle din shamil karein';

  @override
  String pauseRange(String start, String end) {
    return '$start se $end tak';
  }

  @override
  String get pauseRemove => 'Hatayein';

  @override
  String get pauseNone => 'Koi waqfa nahi';

  @override
  String get qazaTitle => 'Qaza namazein';

  @override
  String qazaCardOwed(int count) {
    return '$count ada karni hain';
  }

  @override
  String get qazaCardNone => 'Koi qaza nahi';

  @override
  String get qazaMadeUp => 'Ek ada ki';

  @override
  String get qazaAddOne => 'Ek chhooti hui shamil karein';

  @override
  String get qazaSetBalance => 'Ibtidai tadaad muqarrar karein';

  @override
  String get qazaBalanceHelp =>
      'Har namaz ki kitni qaza hai? Na ho to 0 rehne dein.';

  @override
  String get qazaEstimate => 'Barson se andaza lagayein';

  @override
  String get qazaYears => 'Chhooti namazon ke saal';

  @override
  String get qazaYearsHelp =>
      'Har namaz mein saal × 365 bhar deta hai. Baad mein har ek badal sakte hain.';

  @override
  String get qazaApply => 'Lagu karein';

  @override
  String get qazaAuto => 'Chhooti namazein khud ginein';

  @override
  String get qazaAutoHelp =>
      'Namaz ka waqt bagair nishan zad hue khatam ho to qaza mein shamil kar deta hai. Aaj se shuru hota hai. Baad mein nishan zad karein to wapas ho jati hai, aur waqfe ke din chhor diye jate hain.';

  @override
  String get qazaHistory => 'Tareekh';

  @override
  String get qazaHistoryEmpty => 'Abhi kuch nahi';

  @override
  String get qazaSourceInitial => 'Ibtidai tadaad';

  @override
  String get qazaSourceAdded => 'Shamil ki';

  @override
  String get qazaSourceMadeUp => 'Ada ki';

  @override
  String get qazaSourceAuto => 'Khud shumar hui';

  @override
  String qazaTotal(int count) {
    return '$count namazein ada karni hain';
  }

  @override
  String get jamaatSection => 'Jamaat (masjid)';

  @override
  String get jamaatHelp =>
      'Apni masjid ki jamaat ke auqaat muqarrar karein taake har namaz ke saath nazar aayein aur rawangi ki yaad-dehani milay. Azan ke baad minute ya muqarrara waqt istemal karein.';

  @override
  String get jamaatNotSet => 'Muqarrar nahi';

  @override
  String jamaatAfter(int minutes) {
    return 'Azan ke $minutes minute baad';
  }

  @override
  String jamaatFixed(String time) {
    return '$time par';
  }

  @override
  String jamaatAt(String time) {
    return 'Jamaat $time';
  }

  @override
  String get jamaatEdit => 'Jamaat ka waqt';

  @override
  String get jamaatModeAfter => 'Azan ke baad minute';

  @override
  String get jamaatModeFixed => 'Muqarrara waqt';

  @override
  String get jamaatPickTime => 'Waqt chunein';

  @override
  String get jamaatClear => 'Hatayein';

  @override
  String get jummaTime => 'Jumma ka waqt';

  @override
  String get leaveReminder => 'Rawangi ki yaad-dehani';

  @override
  String leaveMinutes(int minutes) {
    return 'Jamaat se $minutes minute pehle';
  }

  @override
  String get silentDuring => 'Jamaat ke dauran phone khamosh karein';

  @override
  String get silentHelp =>
      'Disturb na karein ki rasai darkar hai. Baad mein phone pehle jaisa ho jata hai.';

  @override
  String get silentLength => 'Khamosh rahe';

  @override
  String get silentGrantAccess => 'Disturb na karein ki rasai dein';

  @override
  String get azanAlarmVolume => 'Azan alarm ki awaz par chalayein';

  @override
  String get azanAlarmHelp =>
      'Khamosh mode mein bhi sunai deti hai aur media volume se mutasir nahi hoti.';

  @override
  String get checkSetupTitle => 'Meri tarteeb janchein';

  @override
  String get checkSetupIntro =>
      'Yaqeeni banayein ke azan waqai sunai degi. Surkh nishan wali cheez durust karein.';

  @override
  String get checkNotifications => 'Notifications ki ijazat';

  @override
  String get checkExact => 'Alarms aur reminders ki ijazat';

  @override
  String get checkExactHelp => 'Azan theek minute par bajne deti hai.';

  @override
  String get checkBattery => 'Battery: bagair pabandi';

  @override
  String get checkBatteryHelp =>
      'App settings kholein, phir Battery, aur bagair pabandi chunein.';

  @override
  String get checkChannel => 'System settings mein azan ki awaz on hai';

  @override
  String get checkChannelHelp =>
      'Is app ke liye azan ki awaz band hai. Notification settings mein on karein.';

  @override
  String checkScheduled(int count) {
    return '$count alerts muqarrar hain';
  }

  @override
  String get checkNoneScheduled => 'Koi alert muqarrar nahi';

  @override
  String get checkOk => 'Theek';

  @override
  String get checkFix => 'Durust karein';

  @override
  String get checkTestNow => 'Abhi azmaishi azan chalayein';

  @override
  String get checkReplan => 'Tamam alerts dobara tarteeb dein';

  @override
  String get checkReplanned => 'Alerts dobara tarteeb diye gaye';

  @override
  String get endSection => 'Namaz ka waqt khatam hone wala hai';

  @override
  String get endHelp =>
      'Namaz ka waqt khatam hone se pehle yaad-dehani milegi, aur namaz parhne tak baar baar. Namaz chhoot jaye to qaza fehrist mein chali jati hai.';

  @override
  String get endEnable => 'Namaz khatam hone se pehle yaad dilayein';

  @override
  String get endLead => 'Pehli yaad-dehani';

  @override
  String endLeadValue(int minutes) {
    return 'Khatam hone se $minutes minute pehle';
  }

  @override
  String get endRepeat => 'Phir har';

  @override
  String endRepeatValue(int minutes) {
    return '$minutes minute';
  }

  @override
  String get endPrayers => 'Kaun si namazein';

  @override
  String get endRequirePhoto => 'Tasveeri saboot';

  @override
  String get endRequirePhotoHelp =>
      'Jab tak aap apni namaz ki jagah, jaise jaye-namaz ya masjid, ki tasveer na lein yaad-dehani jari rahegi. Tasveer isi phone par janchi jati hai aur kahin mehfooz ya irsal nahi hoti.';

  @override
  String get endTestTitle => 'Yaad-dehani aazmayen';

  @override
  String get endTestHelp =>
      '3 aazmaishi ittila\'at bhejta hai jo 1 minute ke waqfe se aati hain taake aap poora amal dekh sakein.';

  @override
  String get endTestSend => 'Bhejein';

  @override
  String get endTestScheduled =>
      '3 aazmaishi yaad-dehaniyan bheji gayin — pehli 10 seconds mein aaye gi.';

  @override
  String get verifyTitle => 'Namaz ki tasveer ki janch';

  @override
  String get verifyIntro =>
      'Namaz ke baad apni namaz ki jagah, jaise jaye-namaz ya masjid, ki tasveer lein. Yeh sirf isi phone par janchi jati hai aur mehfooz nahi hoti.';

  @override
  String verifyPrayer(String prayer, String date) {
    return '$prayer · $date';
  }

  @override
  String get verifyTake => 'Tasveer lein';

  @override
  String get verifyChecking => 'Janch ho rahi hai…';

  @override
  String get verifySuccess =>
      'Tasdeeq ho gayi. Allah aap ki namaz qabool farmaye.';

  @override
  String get verifyTestNote =>
      'Yeh aik aazmaishi yaad-dehani thi — aap ka namaz log tabdeel nahi kiya gaya.';

  @override
  String get verifyFail =>
      'Yeh namaz ki jagah nahi lagti. Jaye-namaz ya masjid nazar aate hue dobara koshish karein.';

  @override
  String get verifyTryAgain => 'Dobara koshish karein';

  @override
  String get verifyStop => 'Yaad-dehani band karein';

  @override
  String get verifyStopHelp =>
      'Agar abhi namaz nahi parh sakte to yeh istemal karein. Namaz parhi hui nishan zad nahi hogi.';

  @override
  String verifySaw(String labels) {
    return 'Phone ne dekha: $labels';
  }

  @override
  String get verifyEnded =>
      'Is namaz ka waqt khatam ho chuka hai. Aap ise tracker mein nishan zad kar sakte hain.';

  @override
  String get verifyProofNeeded => 'Is namaz ke liye tasveeri saboot lazmi hai';

  @override
  String get verifyNoCamera => 'Camera nahi khul saka';

  @override
  String get verifyChecklistHint =>
      'Mashwara: yaqeeni banayein ke jaye-namaz ya masjid tasveer ka bara hissa ho.';

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
  String qiblaTurnRight(int degrees) {
    return 'Daayen $degrees° ghoomein';
  }

  @override
  String qiblaTurnLeft(int degrees) {
    return 'Baayen $degrees° ghoomein';
  }

  @override
  String get qiblaFacing => 'Aap ka rukh Qibla ki taraf hai';

  @override
  String qiblaHeading(int degrees) {
    return 'Phone ka rukh $degrees°';
  }

  @override
  String qiblaDistance(String km) {
    return 'Kaaba tak $km km';
  }

  @override
  String get qiblaCalibrate =>
      'Compass ki calibration zaroori hai. Phone ko dhaat aur maqnatees se door 8 ki shakal mein ghumayein.';

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
