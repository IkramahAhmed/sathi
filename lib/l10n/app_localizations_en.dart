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

  @override
  String get navKhata => 'Khata';

  @override
  String get khataTitle => 'Khata';

  @override
  String get khataMonthTotal => 'Total this month';

  @override
  String get khataEmpty => 'No expenses yet';

  @override
  String get khataEmptyHint => 'Tap + to record your first expense';

  @override
  String get khataAddTitle => 'Add Expense';

  @override
  String get khataTabExpenses => 'Expenses';

  @override
  String get khataEditTitle => 'Edit Expense';

  @override
  String get khataAmount => 'Amount';

  @override
  String get khataAmountInvalid => 'Enter a valid amount greater than zero';

  @override
  String get khataCategory => 'Category';

  @override
  String get khataNote => 'Note (optional)';

  @override
  String get khataDate => 'Date';

  @override
  String get khataSave => 'Save';

  @override
  String get khataDelete => 'Delete';

  @override
  String get khataToday => 'Today';

  @override
  String get khataYesterday => 'Yesterday';

  @override
  String get khataCatFood => 'Food';

  @override
  String get khataCatTransport => 'Transport';

  @override
  String get khataCatRent => 'Rent';

  @override
  String get khataCatHealth => 'Health';

  @override
  String get khataCatBills => 'Bills';

  @override
  String get khataCatShopping => 'Shopping';

  @override
  String get khataCatOther => 'Other';

  @override
  String get navPrayer => 'Prayer';

  @override
  String get dashTools => 'Tools';

  @override
  String get dashComingSoon => 'Coming soon';

  @override
  String get khataChart => 'Spending by category';

  @override
  String get khataBudget => 'Monthly budgets';

  @override
  String get khataBudgetHint => 'Set 0 to remove a limit';

  @override
  String get khataExport => 'Export CSV';

  @override
  String get khataBudgetSaved => 'Budgets saved';

  @override
  String get khataOverBudget => 'Over budget';

  @override
  String get udhaarTitle => 'Udhaar Ledger';

  @override
  String get udhaarSearch => 'Search contacts…';

  @override
  String get udhaarAddContact => 'Add Contact';

  @override
  String get udhaarEditContact => 'Edit Contact';

  @override
  String get udhaarDeleteContact => 'Delete Contact';

  @override
  String udhaarDeleteContactConfirm(String name) {
    return 'Delete $name and all their entries?';
  }

  @override
  String get udhaarContactName => 'Name';

  @override
  String get udhaarSave => 'Save';

  @override
  String get udhaarDelete => 'Delete';

  @override
  String get udhaarEmpty => 'No contacts yet';

  @override
  String get udhaarEmptyHint => 'Add someone you gave or took money from';

  @override
  String get udhaarOwedToMe => 'Total Lena';

  @override
  String get udhaarIOwe => 'Total Dena';

  @override
  String get udhaarOwes => 'Lena';

  @override
  String get udhaarYouOwe => 'Dena';

  @override
  String get udhaarSettled => 'Barabar';

  @override
  String get udhaarClear => 'Barabar';

  @override
  String udhaarOwesYou(String name) {
    return '$name ka Lena';
  }

  @override
  String udhaarYouOweContact(String name) {
    return '$name ka Dena';
  }

  @override
  String get udhaarGave => 'Diya';

  @override
  String get udhaarReceived => 'Liya';

  @override
  String get udhaarAmount => 'Amount';

  @override
  String get udhaarNote => 'Note (optional)';

  @override
  String get udhaarChangeDate => 'Change';

  @override
  String get udhaarNoEntries => 'No entries yet.\nTap Diya or Liya to record.';

  @override
  String get udhaarEditEntry => 'Edit entry';

  @override
  String get udhaarDeleteEntry => 'Delete this entry?';

  @override
  String get udhaarPhone => 'Phone (for WhatsApp)';

  @override
  String get udhaarWhatsAppReminder => 'Send WhatsApp reminder';

  @override
  String udhaarWhatsAppLena(String name, String amount) {
    return 'Assalamu Alaikum $name, aapka Rs. $amount mujhe lena baqi hai. - Saathi App';
  }

  @override
  String udhaarWhatsAppDena(String name, String amount) {
    return 'Assalamu Alaikum $name, mera Rs. $amount aapko dena baqi hai. - Saathi App';
  }

  @override
  String get udhaarWhatsAppNotFound => 'WhatsApp not installed';

  @override
  String get udhaarDueOn => 'Due';

  @override
  String get udhaarNoDueDate => 'No due date';

  @override
  String get udhaarSetDueDate => 'Set date';

  @override
  String get udhaarLate => 'Late — payment overdue';

  @override
  String get udhaarLateTitle => 'Late';

  @override
  String get khataIncome => 'Income';

  @override
  String get khataExpense => 'Expense';

  @override
  String get khataNet => 'Net';

  @override
  String get khataAddIncome => 'Add income';

  @override
  String get khataAddExpense => 'Add expense';

  @override
  String get khataTotalIncome => 'Total income';

  @override
  String get khataTotalExpense => 'Total expense';

  @override
  String get khataReceiptPhoto => 'Receipt photo';

  @override
  String get khataAddPhoto => 'Add photo';

  @override
  String get khataViewPhoto => 'View receipt';

  @override
  String get khataRemovePhoto => 'Remove photo';

  @override
  String get khataPdfExport => 'Export PDF';

  @override
  String get udhaarPdfPassbook => 'Udhaar passbook (PDF)';

  @override
  String get incomeSourceSalary => 'Salary';

  @override
  String get incomeSourceFreelance => 'Freelance';

  @override
  String get incomeSourceBusiness => 'Business';

  @override
  String get incomeSourceGift => 'Gift';

  @override
  String get incomeSourceOther => 'Other income';

  @override
  String get navTasks => 'Tasks';

  @override
  String get vaultTitle => 'Private vault';

  @override
  String get undo => 'Undo';

  @override
  String get todayQuickAddHint => 'Quick add — e.g. 250 chai';

  @override
  String todayQuickAddPreview(String amount, String category) {
    return 'Will save: Rs $amount · $category';
  }

  @override
  String get todayQuickAddNeedAmount =>
      'Type an amount first, for example 250 chai';

  @override
  String todayQuickAdded(String amount, String category) {
    return 'Added Rs $amount · $category';
  }

  @override
  String todayQuickAddedIncome(String amount, String category) {
    return 'Income Rs $amount added · $category';
  }

  @override
  String get todayPrayers => 'Today\'s prayers';

  @override
  String get todayNothingDue => 'Nothing due today';

  @override
  String get todaySeeAll => 'See all';

  @override
  String get todayMoney => 'Money';

  @override
  String get todaySpentToday => 'Spent today';

  @override
  String get todaySpentMonth => 'This month';

  @override
  String get todayBudgetLeft => 'Budget left';

  @override
  String get todayOverBudget => 'Over budget';

  @override
  String get todayComingUp => 'Coming up';

  @override
  String get todayNothingComing => 'Nothing coming up this week';

  @override
  String todayDueTheyOwe(String name, String amount) {
    return '$name owes you Rs $amount';
  }

  @override
  String todayDueYouOwe(String name, String amount) {
    return 'You owe $name Rs $amount';
  }

  @override
  String todayDueLate(String days) {
    return '$days days late';
  }

  @override
  String get todayDueToday => 'due today';

  @override
  String get todayDueTomorrow => 'due tomorrow';

  @override
  String todayDueInDays(String days) {
    return 'due in $days days';
  }

  @override
  String todayRecurring(String what, String amount, String date) {
    return 'Recurring $what: Rs $amount on $date';
  }

  @override
  String get todayBackupTitle => 'Back up your data';

  @override
  String get todayBackupBody =>
      'Share a copy so your data is safe if this phone is lost';

  @override
  String get todayBackupNow => 'Back up now';

  @override
  String get todayLater => 'Later';

  @override
  String get toolRoza => 'Roza';

  @override
  String get toolGoals => 'Savings goals';

  @override
  String get toolAccounts => 'Accounts';

  @override
  String get rozaTitle => 'Roza';

  @override
  String rozaOwed(String count) {
    return 'Fasts to make up: $count';
  }

  @override
  String get rozaHint => 'Tap a day to mark it kept, missed, or clear it';

  @override
  String get rozaKept => 'Kept';

  @override
  String get rozaMissed => 'Missed';

  @override
  String get rozaMadeUp => 'Made up';

  @override
  String get rozaMakeUpToday => 'I fasted today to make up one';

  @override
  String rozaKeptThisYear(String count) {
    return 'Kept this year: $count';
  }

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get goalsTitle => 'Savings goals';

  @override
  String get goalsEmpty =>
      'No goals yet. Add one, like Hajj, a wedding or a car.';

  @override
  String get goalAdd => 'New goal';

  @override
  String get goalName => 'Goal name';

  @override
  String get goalTarget => 'Target amount';

  @override
  String get goalDeadline => 'Deadline (optional)';

  @override
  String get goalAddMoney => 'Add money';

  @override
  String get goalTakeOut => 'Take money out';

  @override
  String get goalAmount => 'Amount';

  @override
  String goalSaved(String saved, String target) {
    return 'Rs $saved of Rs $target';
  }

  @override
  String get goalReached => 'Goal reached!';

  @override
  String goalPerMonth(String amount, String date) {
    return 'Save about Rs $amount a month to reach it by $date';
  }

  @override
  String get goalDeleteConfirm => 'Delete this goal?';

  @override
  String get accountsTitle => 'Accounts';

  @override
  String get accountsEmpty =>
      'Add the places your money is kept: cash, bank, wallet.';

  @override
  String get accountAdd => 'New account';

  @override
  String get accountName => 'Account name';

  @override
  String get accountCash => 'Cash';

  @override
  String get accountBank => 'Bank';

  @override
  String get accountWallet => 'Wallet';

  @override
  String get accountOpening => 'Opening balance';

  @override
  String get accountTotal => 'Total across accounts';

  @override
  String get accountDeleteWarn =>
      'Entries stay, but are no longer linked to this account.';

  @override
  String get accountPick => 'Account (optional)';

  @override
  String get accountNone => 'No account';

  @override
  String get add => 'Add';

  @override
  String get taskRemindBefore => 'Remind me before';

  @override
  String get taskRemindNone => 'Only at the time';

  @override
  String taskRemindMin(String minutes) {
    return '$minutes minutes before';
  }

  @override
  String get taskRemindHour => '1 hour before';

  @override
  String get taskRemindDay => '1 day before';

  @override
  String get taskAtTime => 'At a time';

  @override
  String get taskAroundPrayer => 'Around a prayer';

  @override
  String taskOffsetBefore(String minutes) {
    return '$minutes min before';
  }

  @override
  String taskOffsetAfter(String minutes) {
    return '$minutes min after';
  }

  @override
  String get taskOffsetAt => 'At prayer time';

  @override
  String get taskBillAmount => 'Bill amount (optional)';

  @override
  String get taskAddToKhataTitle => 'Add to Khata?';

  @override
  String taskAddToKhataBody(String amount, String title) {
    return 'Add Rs $amount for \"$title\" to your Khata?';
  }

  @override
  String get taskBillAdded => 'Added to Khata';

  @override
  String get filterAll => 'All';

  @override
  String get udhaarSortAmount => 'Biggest amount first';

  @override
  String get settingsDataBackup => 'Data & Backup';

  @override
  String get backupExport => 'Export backup';

  @override
  String get backupExportSub => 'Share your data as a .saathi file';

  @override
  String get backupRestore => 'Restore backup';

  @override
  String get backupRestoreSub => 'Replace current data from a .saathi file';

  @override
  String get backupAuto => 'Automatic backups';

  @override
  String backupAutoSub(String date) {
    return 'Saved on this phone every week. Last: $date';
  }

  @override
  String get backupAutoNone => 'Saved on this phone every week. None yet.';

  @override
  String get settingsCountBank => 'Count bank transactions in budgets';

  @override
  String get settingsCountBankSub =>
      'Payments caught from bank notifications count towards your budgets and totals';

  @override
  String get trackerMonth => 'Last 30 days';

  @override
  String trackerCompletion(String percent) {
    return '$percent% of prayers prayed';
  }

  @override
  String trackerWeakest(String prayer, String done, String days) {
    return 'Hardest prayer: $prayer ($done of $days days)';
  }

  @override
  String get tasbeehFree => 'Free count';

  @override
  String get tasbeehSubhanallah => 'SubhanAllah';

  @override
  String get tasbeehAlhamdulillah => 'Alhamdulillah';

  @override
  String get tasbeehAllahuAkbar => 'Allahu Akbar';

  @override
  String tasbeehToday(String count) {
    return 'Today: $count';
  }

  @override
  String get tasbeehTargetReached => 'Target reached';

  @override
  String get trendTitle => 'Compared with last month';

  @override
  String trendMore(String amount, String percent) {
    return 'Rs $amount more than last month ($percent%)';
  }

  @override
  String trendLess(String amount, String percent) {
    return 'Rs $amount less than last month ($percent%)';
  }

  @override
  String trendMoreNoPercent(String amount) {
    return 'Rs $amount more than last month';
  }

  @override
  String get trendSame => 'Same as last month';

  @override
  String trendBiggestRise(String category, String amount) {
    return 'Biggest rise: $category (+Rs $amount)';
  }

  @override
  String get taskNewList => 'New list';

  @override
  String get taskEditList => 'Edit list';

  @override
  String get taskDeleteList => 'Delete list';

  @override
  String get taskTabToday => 'Today';

  @override
  String get taskTabUpcoming => 'Upcoming';

  @override
  String get taskEmptyUpcoming => 'No upcoming tasks';

  @override
  String get taskEmptyDone => 'Nothing completed yet';

  @override
  String get taskEmptyToday => 'Nothing to do today — MashaAllah! 🎉';

  @override
  String get taskNoneToday => 'No tasks for today';

  @override
  String taskTomorrowCount(String count) {
    return 'Tomorrow ($count)';
  }

  @override
  String taskOverdueCount(String count) {
    return 'Overdue ($count)';
  }

  @override
  String get taskNew => 'New task';

  @override
  String get taskEdit => 'Edit task';

  @override
  String get taskDeleteConfirm => 'Delete task?';

  @override
  String get taskReopen => 'Reopen';

  @override
  String get taskTitleLabel => 'Task title';

  @override
  String get taskNoteLabel => 'Note (optional)';

  @override
  String get taskListLabel => 'List';

  @override
  String get taskNoList => 'No list';

  @override
  String get taskPriority => 'Priority:';

  @override
  String get taskPriorityNormal => 'Normal';

  @override
  String get taskPriorityHigh => 'High';

  @override
  String get taskRepeat => 'Repeat';

  @override
  String get taskRepeatNone => 'Does not repeat';

  @override
  String get taskRepeatDaily => 'Every day';

  @override
  String get taskRepeatWeekly => 'Every week';

  @override
  String get taskRepeatMonthly => 'Every month';

  @override
  String get taskDailyShort => 'Daily';

  @override
  String get taskWeeklyShort => 'Weekly';

  @override
  String get taskMonthlyShort => 'Monthly';

  @override
  String get taskNoDueDate => 'No due date';

  @override
  String get taskNoTime => 'No time (no notification)';

  @override
  String get taskListName => 'List name';

  @override
  String get taskIcon => 'Icon';

  @override
  String get taskCreate => 'Create';

  @override
  String get khataIncoming => 'Incoming';

  @override
  String get khataOutgoing => 'Outgoing';

  @override
  String get khataExportPdf => 'Export PDF';

  @override
  String get khataExportCsv => 'Export CSV';

  @override
  String get khataBank => 'Bank';

  @override
  String get summaryTitle => 'Monthly summary';

  @override
  String get khataSearchEntries => 'Search entries…';

  @override
  String get recurringTitle => 'Recurring';

  @override
  String get khataShareWhatsApp => 'Share via WhatsApp';

  @override
  String get vaultMove => 'Move to Vault';

  @override
  String get vaultMoveHint => 'Hide from normal view';

  @override
  String get vaultMoveUdhaarHint => 'Hide from normal Udhaar view';

  @override
  String get bankSearch => 'Search bank entries…';

  @override
  String get bankIn => 'In';

  @override
  String get bankOut => 'Out';

  @override
  String get bankAllBanks => 'All banks';

  @override
  String get bankEmpty => 'No bank transactions yet';

  @override
  String get bankNoMatch => 'No matching transactions';

  @override
  String get bankAutoCaptured => 'Auto-captured from bank notifications';

  @override
  String get entryDelete => 'Delete entry';

  @override
  String get vaultUnlockReason => 'Unlock your Vault to view private entries';

  @override
  String get vaultUnlock => 'Unlock';

  @override
  String get vaultLock => 'Lock vault';

  @override
  String get vaultTabContacts => 'Contacts';

  @override
  String get vaultRemove => 'Remove from Vault';

  @override
  String get vaultDeleteContact => 'Delete contact';

  @override
  String get vaultDeleteContactQ => 'Delete contact?';

  @override
  String get freqDaily => 'Daily';

  @override
  String get freqWeekly => 'Weekly';

  @override
  String get freqMonthly => 'Monthly';

  @override
  String get freqYearly => 'Yearly';

  @override
  String get summaryNet => 'Net balance';

  @override
  String get summaryByCategory => 'Spending by category';

  @override
  String get summaryNoExpenses => 'No expenses this month';

  @override
  String get recurringEmpty => 'No recurring entries';

  @override
  String get recurringEmptyHint =>
      'Turn on \"Repeat\" when adding an expense or income';

  @override
  String get recurringStopQ => 'Stop recurring?';

  @override
  String get recurringStopNote => 'This will not delete past entries.';

  @override
  String get recurringStop => 'Stop';

  @override
  String get expensePhotoTake => 'Take a photo';

  @override
  String get expensePhotoGallery => 'Choose from gallery';

  @override
  String get expenseSource => 'Source';

  @override
  String get expenseRepeat => 'Repeat';

  @override
  String get bankSyncTitle => 'Bank sync';

  @override
  String get bankSyncAuto => 'Auto-capture transactions';

  @override
  String get bankSyncChecking => 'Checking…';

  @override
  String get bankSyncEnableHint =>
      'Tap to enable — no login needed, works with all bank apps';

  @override
  String get bankSyncEnable => 'Enable';

  @override
  String get bankSyncPaused =>
      'Paused by Android — transactions are not being captured';

  @override
  String get bankSyncRestart => 'Restart';

  @override
  String get bankSyncWaiting => 'Active — waiting for the first bank alert';

  @override
  String bankSyncLast(String ago) {
    return 'Active — last bank alert $ago';
  }

  @override
  String bankSyncPending(String count) {
    return '$count waiting to be saved';
  }

  @override
  String get bankSyncRestartHint =>
      'Turn Saathi off and on again in Notification access';

  @override
  String get agoJustNow => 'just now';

  @override
  String agoMinutes(String count) {
    return '$count min ago';
  }

  @override
  String agoHours(String count) {
    return '$count h ago';
  }

  @override
  String agoDays(String count) {
    return '$count d ago';
  }

  @override
  String get ramadanMubarak => 'Ramadan Mubarak';

  @override
  String get ramadanTimetable => 'Ramadan timetable';

  @override
  String get ramadanLabel => 'Ramadan';

  @override
  String get ramadanSehriEnded => 'Sehri has ended';

  @override
  String ramadanSehriEndsIn(String time) {
    return 'Sehri ends in $time';
  }

  @override
  String get ramadanStopEating => 'Stop eating before Fajr';

  @override
  String ramadanIftarIn(String time) {
    return 'Iftar in $time';
  }

  @override
  String get ramadanKeepGoing => 'Keep going! 💪';

  @override
  String get ramadanIftarTime => 'Iftar time! 🎉';

  @override
  String ramadanSehriIn(String time) {
    return 'Sehri in $time';
  }

  @override
  String get ramadanEnjoy => 'Enjoy your meal';

  @override
  String get ramadanAlhamdulillah => 'Alhamdulillah';

  @override
  String get ramadanSehriEndsSuffix => ' · Sehri ends';

  @override
  String get ramadanIftarSuffix => ' · Iftar';

  @override
  String get imsakiyaTitle => 'Ramadan timetable';

  @override
  String get imsakiyaShareFail => 'Could not share the timetable';

  @override
  String get imsakiyaNoDates => 'Could not compute Ramadan dates';

  @override
  String get imsakiyaShare => 'Share as image';

  @override
  String get imsakiyaDay => 'Day';

  @override
  String get imsakiyaDate => 'Date';

  @override
  String get imsakiyaSehri => 'Sehri ends';

  @override
  String get imsakiyaIftar => 'Iftar';

  @override
  String backupFailed(String error) {
    return 'Backup failed: $error';
  }

  @override
  String get backupNoAccess => 'Could not access the selected file.';

  @override
  String get backupIncomplete => 'This file is not a complete Saathi backup.';

  @override
  String get backupNotSaathi => 'This file is not a Saathi backup.';

  @override
  String get backupNewer =>
      'This backup is from a newer version of Saathi. Update the app first.';

  @override
  String get backupDamaged => 'This backup file is damaged.';

  @override
  String get backupOlder => 'an older backup';

  @override
  String get restoreConfirmTitle => 'Restore backup?';

  @override
  String restoreConfirmBody(String when) {
    return 'This replaces ALL current data with $when.\n\nA safety copy of your current data is kept on this phone. Saathi will close afterwards; open it again to continue.';
  }

  @override
  String get restoreButton => 'Restore';

  @override
  String get restoreDoneTitle => 'Backup restored';

  @override
  String get restoreDoneBody =>
      'Saathi will close now. Open it again to see your data.';

  @override
  String restoreFailedKept(String error) {
    return 'Restore failed: $error. Close and reopen Saathi; a safety copy of your data was kept.';
  }

  @override
  String restoreFailedSafe(String error) {
    return 'Restore failed: $error. Your data was not changed.';
  }

  @override
  String get khataIncludesBank =>
      'Totals include bank transactions (see the Bank tab)';

  @override
  String get categoryNew => 'New category';

  @override
  String get categoryName => 'Category name';

  @override
  String get categoryPickIcon => 'Pick an icon';

  @override
  String get categoryNameTaken => 'That name is already used';

  @override
  String get categoriesTitle => 'My categories';

  @override
  String get categoriesEmpty =>
      'No categories of your own yet. Add one, like Groceries or Mobile load.';

  @override
  String categoryDeleteQ(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get categoryDeleteBody =>
      'Entries in this category move to Other. No amount is lost.';

  @override
  String get categoriesManage => 'Manage categories';

  @override
  String get reviewTitle => 'Weekly review';

  @override
  String reviewRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String reviewSpent(String amount) {
    return 'Spent Rs $amount';
  }

  @override
  String reviewMoreThanBefore(String amount, String percent) {
    return 'Rs $amount more than the week before ($percent%)';
  }

  @override
  String reviewLessThanBefore(String amount, String percent) {
    return 'Rs $amount less than the week before ($percent%)';
  }

  @override
  String reviewMoreNoPercent(String amount) {
    return 'Rs $amount more than the week before';
  }

  @override
  String get reviewSameAsBefore => 'Same as the week before';

  @override
  String get reviewPrayers => 'Prayers';

  @override
  String reviewPrayed(String done, String total) {
    return 'Prayed $done of $total';
  }

  @override
  String reviewTasksDone(String count) {
    return '$count finished';
  }

  @override
  String reviewTasksOverdue(String count) {
    return '$count overdue';
  }

  @override
  String get reviewNoOverdue => 'Nothing overdue 🎉';

  @override
  String reviewFastsKept(String kept, String missed) {
    return 'Kept $kept, missed $missed';
  }

  @override
  String get reviewDebts => 'Money lent and owed';

  @override
  String reviewOwedToMe(String amount) {
    return 'Owed to you: Rs $amount';
  }

  @override
  String reviewIOwe(String amount) {
    return 'You owe: Rs $amount';
  }

  @override
  String get reviewEmpty =>
      'Nothing recorded in this period yet. Use Saathi for a week and come back.';

  @override
  String get reviewNotifTitle => 'Your weekly review is ready';

  @override
  String get reviewNotifBody => 'Tap to see how your week went';

  @override
  String get reviewSettingSub => 'A reminder to look back at your week';

  @override
  String reviewSettingOn(String day, String time) {
    return '$day at $time';
  }

  @override
  String get reviewDay => 'Day';

  @override
  String get reviewTime => 'Time';

  @override
  String get reviewOpen => 'Open the review';
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

  @override
  String get navKhata => 'Khata';

  @override
  String get khataTitle => 'Khata';

  @override
  String get khataMonthTotal => 'Is mahine ka kharcha';

  @override
  String get khataEmpty => 'Abhi koi kharcha nahi';

  @override
  String get khataEmptyHint => '+ dabayein pehla kharcha likhne ke liye';

  @override
  String get khataAddTitle => 'Kharcha Shamil Karein';

  @override
  String get khataTabExpenses => 'Kharcha';

  @override
  String get khataEditTitle => 'Kharcha Edit Karein';

  @override
  String get khataAmount => 'Raqam';

  @override
  String get khataAmountInvalid => 'Sahi raqam likhein';

  @override
  String get khataCategory => 'Qism';

  @override
  String get khataNote => 'Note (ikhtiyari)';

  @override
  String get khataDate => 'Tareekh';

  @override
  String get khataSave => 'Save';

  @override
  String get khataDelete => 'Mitayein';

  @override
  String get khataToday => 'Aaj';

  @override
  String get khataYesterday => 'Kal';

  @override
  String get khataCatFood => 'Khana';

  @override
  String get khataCatTransport => 'Safar';

  @override
  String get khataCatRent => 'Kiraya';

  @override
  String get khataCatHealth => 'Sehat';

  @override
  String get khataCatBills => 'Bill';

  @override
  String get khataCatShopping => 'Shopping';

  @override
  String get khataCatOther => 'Aur';

  @override
  String get navPrayer => 'Namaz';

  @override
  String get dashTools => 'Auzaar';

  @override
  String get dashComingSoon => 'Jald aa raha hai';

  @override
  String get khataChart => 'Qism ke mutabiq kharcha';

  @override
  String get khataBudget => 'Mahana budget';

  @override
  String get khataBudgetHint => 'Hadd hatane ke liye 0 likhein';

  @override
  String get khataExport => 'CSV Export';

  @override
  String get khataBudgetSaved => 'Budget save ho gaya';

  @override
  String get khataOverBudget => 'Budget se zyada';

  @override
  String get udhaarTitle => 'Udhaar Bahi Khata';

  @override
  String get udhaarSearch => 'Contact dhundein…';

  @override
  String get udhaarAddContact => 'Contact Shamil Karein';

  @override
  String get udhaarEditContact => 'Naam Badlein';

  @override
  String get udhaarDeleteContact => 'Contact Mitaein';

  @override
  String udhaarDeleteContactConfirm(String name) {
    return '$name aur tamam entries mitaein?';
  }

  @override
  String get udhaarContactName => 'Naam';

  @override
  String get udhaarSave => 'Save Karein';

  @override
  String get udhaarDelete => 'Mitaein';

  @override
  String get udhaarEmpty => 'Abhi koi contact nahi';

  @override
  String get udhaarEmptyHint => 'Jis se len den ho use shamil karein';

  @override
  String get udhaarOwedToMe => 'Total Lena';

  @override
  String get udhaarIOwe => 'Total Dena';

  @override
  String get udhaarOwes => 'Lena';

  @override
  String get udhaarYouOwe => 'Dena';

  @override
  String get udhaarSettled => 'Barabar';

  @override
  String get udhaarClear => 'Barabar';

  @override
  String udhaarOwesYou(String name) {
    return '$name ka Lena';
  }

  @override
  String udhaarYouOweContact(String name) {
    return '$name ka Dena';
  }

  @override
  String get udhaarGave => 'Diya';

  @override
  String get udhaarReceived => 'Liya';

  @override
  String get udhaarAmount => 'Raqam';

  @override
  String get udhaarNote => 'Note (ikhtiyari)';

  @override
  String get udhaarChangeDate => 'Badlein';

  @override
  String get udhaarNoEntries => 'Koi entry nahi.\nDiya ya Liya dabain.';

  @override
  String get udhaarEditEntry => 'Entry edit karein';

  @override
  String get udhaarDeleteEntry => 'Yeh entry mitaein?';

  @override
  String get udhaarPhone => 'Phone (WhatsApp ke liye)';

  @override
  String get udhaarWhatsAppReminder => 'WhatsApp reminder bhejein';

  @override
  String udhaarWhatsAppLena(String name, String amount) {
    return 'Assalamu Alaikum $name, aapka Rs. $amount mujhe lena baqi hai. - Saathi App';
  }

  @override
  String udhaarWhatsAppDena(String name, String amount) {
    return 'Assalamu Alaikum $name, mera Rs. $amount aapko dena baqi hai. - Saathi App';
  }

  @override
  String get udhaarWhatsAppNotFound => 'WhatsApp install nahi hai';

  @override
  String get udhaarDueOn => 'Due';

  @override
  String get udhaarNoDueDate => 'Due date nahi';

  @override
  String get udhaarSetDueDate => 'Date lagayein';

  @override
  String get udhaarLate => 'Late — payment baqi hai';

  @override
  String get udhaarLateTitle => 'Late';

  @override
  String get khataIncome => 'Income';

  @override
  String get khataExpense => 'Kharch';

  @override
  String get khataNet => 'Net';

  @override
  String get khataAddIncome => 'Income daalen';

  @override
  String get khataAddExpense => 'Kharch daalen';

  @override
  String get khataTotalIncome => 'Kul income';

  @override
  String get khataTotalExpense => 'Kul kharch';

  @override
  String get khataReceiptPhoto => 'Receipt ki tasveer';

  @override
  String get khataAddPhoto => 'Tasveer lagayen';

  @override
  String get khataViewPhoto => 'Receipt dekhen';

  @override
  String get khataRemovePhoto => 'Tasveer hatayein';

  @override
  String get khataPdfExport => 'PDF export karein';

  @override
  String get udhaarPdfPassbook => 'Udhaar passbook (PDF)';

  @override
  String get incomeSourceSalary => 'Tankhwah';

  @override
  String get incomeSourceFreelance => 'Freelance';

  @override
  String get incomeSourceBusiness => 'Business';

  @override
  String get incomeSourceGift => 'Tohfa';

  @override
  String get incomeSourceOther => 'Doosri income';

  @override
  String get navTasks => 'Tasks';

  @override
  String get vaultTitle => 'Private vault';

  @override
  String get undo => 'Undo';

  @override
  String get todayQuickAddHint => 'Jaldi likhein — jaise 250 chai';

  @override
  String todayQuickAddPreview(String amount, String category) {
    return 'Save hoga: Rs $amount · $category';
  }

  @override
  String get todayQuickAddNeedAmount => 'Pehle raqam likhein, jaise 250 chai';

  @override
  String todayQuickAdded(String amount, String category) {
    return 'Rs $amount add ho gaya · $category';
  }

  @override
  String todayQuickAddedIncome(String amount, String category) {
    return 'Aamdani Rs $amount add ho gayi · $category';
  }

  @override
  String get todayPrayers => 'Aaj ki namazein';

  @override
  String get todayNothingDue => 'Aaj koi kaam baqi nahi';

  @override
  String get todaySeeAll => 'Sab dekhein';

  @override
  String get todayMoney => 'Paisay';

  @override
  String get todaySpentToday => 'Aaj ka kharcha';

  @override
  String get todaySpentMonth => 'Is mahine';

  @override
  String get todayBudgetLeft => 'Budget baqi';

  @override
  String get todayOverBudget => 'Budget se zyada';

  @override
  String get todayComingUp => 'Aane wala';

  @override
  String get todayNothingComing => 'Is hafte kuch nahi';

  @override
  String todayDueTheyOwe(String name, String amount) {
    return '$name ko aap ke Rs $amount dene hain';
  }

  @override
  String todayDueYouOwe(String name, String amount) {
    return 'Aap ko $name ko Rs $amount dene hain';
  }

  @override
  String todayDueLate(String days) {
    return '$days din late';
  }

  @override
  String get todayDueToday => 'aaj due';

  @override
  String get todayDueTomorrow => 'kal due';

  @override
  String todayDueInDays(String days) {
    return '$days din mein due';
  }

  @override
  String todayRecurring(String what, String amount, String date) {
    return 'Baar baar $what: Rs $amount, $date ko';
  }

  @override
  String get todayBackupTitle => 'Apna data backup karein';

  @override
  String get todayBackupBody =>
      'Ek copy share karein taake phone kho jaye to bhi data mehfooz rahe';

  @override
  String get todayBackupNow => 'Abhi backup karein';

  @override
  String get todayLater => 'Baad mein';

  @override
  String get toolRoza => 'Roza';

  @override
  String get toolGoals => 'Bachat ke goals';

  @override
  String get toolAccounts => 'Accounts';

  @override
  String get rozaTitle => 'Roza';

  @override
  String rozaOwed(String count) {
    return 'Qaza roze: $count';
  }

  @override
  String get rozaHint => 'Din par tap karke rakha, chhoota ya khali karein';

  @override
  String get rozaKept => 'Rakha';

  @override
  String get rozaMissed => 'Chhoota';

  @override
  String get rozaMadeUp => 'Qaza ada';

  @override
  String get rozaMakeUpToday => 'Aaj qaza roza rakha';

  @override
  String rozaKeptThisYear(String count) {
    return 'Is saal rakhe: $count';
  }

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get goalsTitle => 'Bachat ke goals';

  @override
  String get goalsEmpty =>
      'Abhi koi goal nahi. Hajj, shaadi ya gaari jaisa goal add karein.';

  @override
  String get goalAdd => 'Naya goal';

  @override
  String get goalName => 'Goal ka naam';

  @override
  String get goalTarget => 'Target raqam';

  @override
  String get goalDeadline => 'Akhri tareekh (ikhtiyari)';

  @override
  String get goalAddMoney => 'Raqam add karein';

  @override
  String get goalTakeOut => 'Raqam nikalein';

  @override
  String get goalAmount => 'Raqam';

  @override
  String goalSaved(String saved, String target) {
    return 'Rs $target mein se Rs $saved';
  }

  @override
  String get goalReached => 'Goal poora!';

  @override
  String goalPerMonth(String amount, String date) {
    return '$date tak pohanchne ke liye har mahine taqreeban Rs $amount bachayein';
  }

  @override
  String get goalDeleteConfirm => 'Ye goal delete karein?';

  @override
  String get accountsTitle => 'Accounts';

  @override
  String get accountsEmpty =>
      'Wo jagahein add karein jahan aap ke paisay hain: cash, bank, wallet.';

  @override
  String get accountAdd => 'Naya account';

  @override
  String get accountName => 'Account ka naam';

  @override
  String get accountCash => 'Cash';

  @override
  String get accountBank => 'Bank';

  @override
  String get accountWallet => 'Wallet';

  @override
  String get accountOpening => 'Shuru ki raqam';

  @override
  String get accountTotal => 'Tamam accounts ka total';

  @override
  String get accountDeleteWarn =>
      'Entries rahengi, magar is account se juri nahi rahengi.';

  @override
  String get accountPick => 'Account (ikhtiyari)';

  @override
  String get accountNone => 'Koi account nahi';

  @override
  String get add => 'Add';

  @override
  String get taskRemindBefore => 'Pehle yaad dilayein';

  @override
  String get taskRemindNone => 'Sirf waqt par';

  @override
  String taskRemindMin(String minutes) {
    return '$minutes minute pehle';
  }

  @override
  String get taskRemindHour => '1 ghanta pehle';

  @override
  String get taskRemindDay => '1 din pehle';

  @override
  String get taskAtTime => 'Waqt par';

  @override
  String get taskAroundPrayer => 'Namaz ke hisab se';

  @override
  String taskOffsetBefore(String minutes) {
    return '$minutes min pehle';
  }

  @override
  String taskOffsetAfter(String minutes) {
    return '$minutes min baad';
  }

  @override
  String get taskOffsetAt => 'Namaz ke waqt';

  @override
  String get taskBillAmount => 'Bill ki raqam (ikhtiyari)';

  @override
  String get taskAddToKhataTitle => 'Khata mein add karein?';

  @override
  String taskAddToKhataBody(String amount, String title) {
    return '\"$title\" ke Rs $amount Khata mein add karein?';
  }

  @override
  String get taskBillAdded => 'Khata mein add ho gaya';

  @override
  String get filterAll => 'Sab';

  @override
  String get udhaarSortAmount => 'Sab se bari raqam pehle';

  @override
  String get settingsDataBackup => 'Data aur Backup';

  @override
  String get backupExport => 'Backup export karein';

  @override
  String get backupExportSub =>
      'Apna data .saathi file ki surat mein share karein';

  @override
  String get backupRestore => 'Backup restore karein';

  @override
  String get backupRestoreSub => 'Maujooda data .saathi file se badlein';

  @override
  String get backupAuto => 'Khud-kar backups';

  @override
  String backupAutoSub(String date) {
    return 'Har hafte is phone mein save hote hain. Akhri: $date';
  }

  @override
  String get backupAutoNone =>
      'Har hafte is phone mein save hote hain. Abhi koi nahi.';

  @override
  String get settingsCountBank =>
      'Bank transactions ko budget mein shamil karein';

  @override
  String get settingsCountBankSub =>
      'Bank notification se milne wali adaigiyan budget aur totals mein shamil hongi';

  @override
  String get trackerMonth => 'Pichle 30 din';

  @override
  String trackerCompletion(String percent) {
    return '$percent% namazein parhein';
  }

  @override
  String trackerWeakest(String prayer, String done, String days) {
    return 'Mushkil namaz: $prayer ($days mein se $done din)';
  }

  @override
  String get tasbeehFree => 'Free count';

  @override
  String get tasbeehSubhanallah => 'SubhanAllah';

  @override
  String get tasbeehAlhamdulillah => 'Alhamdulillah';

  @override
  String get tasbeehAllahuAkbar => 'Allahu Akbar';

  @override
  String tasbeehToday(String count) {
    return 'Aaj: $count';
  }

  @override
  String get tasbeehTargetReached => 'Target poora';

  @override
  String get trendTitle => 'Pichle mahine ke muqable mein';

  @override
  String trendMore(String amount, String percent) {
    return 'Pichle mahine se Rs $amount zyada ($percent%)';
  }

  @override
  String trendLess(String amount, String percent) {
    return 'Pichle mahine se Rs $amount kam ($percent%)';
  }

  @override
  String trendMoreNoPercent(String amount) {
    return 'Pichle mahine se Rs $amount zyada';
  }

  @override
  String get trendSame => 'Pichle mahine ke barabar';

  @override
  String trendBiggestRise(String category, String amount) {
    return 'Sab se zyada izafa: $category (+Rs $amount)';
  }

  @override
  String get taskNewList => 'Nayi list';

  @override
  String get taskEditList => 'List edit karein';

  @override
  String get taskDeleteList => 'List delete karein';

  @override
  String get taskTabToday => 'Aaj';

  @override
  String get taskTabUpcoming => 'Baad Mein';

  @override
  String get taskEmptyUpcoming => 'Koi upcoming task nahi';

  @override
  String get taskEmptyDone => 'Abhi tak kuch complete nahi hua';

  @override
  String get taskEmptyToday => 'Aaj koi kaam nahi — MashaAllah! 🎉';

  @override
  String get taskNoneToday => 'Aaj ke liye koi task nahi';

  @override
  String taskTomorrowCount(String count) {
    return 'Kal ($count)';
  }

  @override
  String taskOverdueCount(String count) {
    return 'Overdue ($count)';
  }

  @override
  String get taskNew => 'Naya task';

  @override
  String get taskEdit => 'Task edit karein';

  @override
  String get taskDeleteConfirm => 'Task delete karein?';

  @override
  String get taskReopen => 'Dobara kholein';

  @override
  String get taskTitleLabel => 'Task ka title';

  @override
  String get taskNoteLabel => 'Note (ikhtiyari)';

  @override
  String get taskListLabel => 'List';

  @override
  String get taskNoList => 'Koi list nahi';

  @override
  String get taskPriority => 'Tarjeeh:';

  @override
  String get taskPriorityNormal => 'Normal';

  @override
  String get taskPriorityHigh => 'High';

  @override
  String get taskRepeat => 'Repeat';

  @override
  String get taskRepeatNone => 'Repeat nahi hoga';

  @override
  String get taskRepeatDaily => 'Har din';

  @override
  String get taskRepeatWeekly => 'Har hafte';

  @override
  String get taskRepeatMonthly => 'Har mahine';

  @override
  String get taskDailyShort => 'Rozana';

  @override
  String get taskWeeklyShort => 'Haftawar';

  @override
  String get taskMonthlyShort => 'Mahana';

  @override
  String get taskNoDueDate => 'Koi tareekh nahi';

  @override
  String get taskNoTime => 'Koi waqt nahi (notification nahi)';

  @override
  String get taskListName => 'List ka naam';

  @override
  String get taskIcon => 'Icon';

  @override
  String get taskCreate => 'Banayein';

  @override
  String get khataIncoming => 'Incoming';

  @override
  String get khataOutgoing => 'Outgoing';

  @override
  String get khataExportPdf => 'PDF export karein';

  @override
  String get khataExportCsv => 'CSV export karein';

  @override
  String get khataBank => 'Bank';

  @override
  String get summaryTitle => 'Mahana khulasa';

  @override
  String get khataSearchEntries => 'Entries talash karein…';

  @override
  String get recurringTitle => 'Baar baar aane wale';

  @override
  String get khataShareWhatsApp => 'WhatsApp par share karein';

  @override
  String get vaultMove => 'Vault mein muntaqil karein';

  @override
  String get vaultMoveHint => 'Aam list se chhupayein';

  @override
  String get vaultMoveUdhaarHint => 'Aam Udhaar list se chhupayein';

  @override
  String get bankSearch => 'Bank entries talash karein…';

  @override
  String get bankIn => 'In';

  @override
  String get bankOut => 'Out';

  @override
  String get bankAllBanks => 'Tamam bank';

  @override
  String get bankEmpty => 'Abhi koi bank transaction nahi';

  @override
  String get bankNoMatch => 'Koi matching transaction nahi';

  @override
  String get bankAutoCaptured => 'Bank notifications se khud-kar liya gaya';

  @override
  String get entryDelete => 'Entry delete karein';

  @override
  String get vaultUnlockReason =>
      'Private entries dekhne ke liye Vault kholein';

  @override
  String get vaultUnlock => 'Kholein';

  @override
  String get vaultLock => 'Vault band karein';

  @override
  String get vaultTabContacts => 'Contacts';

  @override
  String get vaultRemove => 'Vault se nikalein';

  @override
  String get vaultDeleteContact => 'Contact delete karein';

  @override
  String get vaultDeleteContactQ => 'Contact delete karein?';

  @override
  String get freqDaily => 'Rozana';

  @override
  String get freqWeekly => 'Haftawar';

  @override
  String get freqMonthly => 'Mahana';

  @override
  String get freqYearly => 'Salana';

  @override
  String get summaryNet => 'Net balance';

  @override
  String get summaryByCategory => 'Category ke hisab se kharcha';

  @override
  String get summaryNoExpenses => 'Is mahine koi kharcha nahi';

  @override
  String get recurringEmpty => 'Koi baar baar aane wali entry nahi';

  @override
  String get recurringEmptyHint =>
      'Kharcha ya aamdani add karte waqt \"Repeat\" on karein';

  @override
  String get recurringStopQ => 'Repeat band karein?';

  @override
  String get recurringStopNote => 'Purani entries delete nahi hongi.';

  @override
  String get recurringStop => 'Band karein';

  @override
  String get expensePhotoTake => 'Photo lein';

  @override
  String get expensePhotoGallery => 'Gallery se chunein';

  @override
  String get expenseSource => 'Source';

  @override
  String get expenseRepeat => 'Repeat';

  @override
  String get bankSyncTitle => 'Bank sync';

  @override
  String get bankSyncAuto => 'Transactions khud-kar lein';

  @override
  String get bankSyncChecking => 'Check ho raha hai…';

  @override
  String get bankSyncEnableHint =>
      'Enable karne ke liye tap karein — login nahi chahiye, sab bank apps ke saath chalta hai';

  @override
  String get bankSyncEnable => 'Enable';

  @override
  String get bankSyncPaused =>
      'Android ne rok diya hai — transactions nahi liye ja rahe';

  @override
  String get bankSyncRestart => 'Restart';

  @override
  String get bankSyncWaiting => 'Active — pehle bank alert ka intezar';

  @override
  String bankSyncLast(String ago) {
    return 'Active — akhri bank alert $ago';
  }

  @override
  String bankSyncPending(String count) {
    return '$count save hone ka intezar';
  }

  @override
  String get bankSyncRestartHint =>
      'Notification access mein Saathi ko band karke dobara on karein';

  @override
  String get agoJustNow => 'abhi';

  @override
  String agoMinutes(String count) {
    return '$count min pehle';
  }

  @override
  String agoHours(String count) {
    return '$count ghante pehle';
  }

  @override
  String agoDays(String count) {
    return '$count din pehle';
  }

  @override
  String get ramadanMubarak => 'Ramadan Mubarak';

  @override
  String get ramadanTimetable => 'Ramadan timetable';

  @override
  String get ramadanLabel => 'Ramadan';

  @override
  String get ramadanSehriEnded => 'Sehri khatam ho gayi';

  @override
  String ramadanSehriEndsIn(String time) {
    return 'Sehri khatam hone mein $time';
  }

  @override
  String get ramadanStopEating => 'Fajr se pehle khana band karein';

  @override
  String ramadanIftarIn(String time) {
    return 'Iftar mein $time';
  }

  @override
  String get ramadanKeepGoing => 'Himmat rakhein! 💪';

  @override
  String get ramadanIftarTime => 'Iftar ka waqt! 🎉';

  @override
  String ramadanSehriIn(String time) {
    return 'Sehri mein $time';
  }

  @override
  String get ramadanEnjoy => 'Khana nosh farmayein';

  @override
  String get ramadanAlhamdulillah => 'Alhamdulillah';

  @override
  String get ramadanSehriEndsSuffix => ' · Sehri khatam';

  @override
  String get ramadanIftarSuffix => ' · Iftar';

  @override
  String get imsakiyaTitle => 'Ramadan timetable';

  @override
  String get imsakiyaShareFail => 'Timetable share nahi ho saka';

  @override
  String get imsakiyaNoDates => 'Ramadan ki tareekhein maloom nahi ho sakein';

  @override
  String get imsakiyaShare => 'Image ke taur par share karein';

  @override
  String get imsakiyaDay => 'Din';

  @override
  String get imsakiyaDate => 'Tareekh';

  @override
  String get imsakiyaSehri => 'Sehri khatam';

  @override
  String get imsakiyaIftar => 'Iftar';

  @override
  String backupFailed(String error) {
    return 'Backup nakam: $error';
  }

  @override
  String get backupNoAccess => 'Chuni hui file tak rasai nahi ho saki.';

  @override
  String get backupIncomplete => 'Ye file mukammal Saathi backup nahi hai.';

  @override
  String get backupNotSaathi => 'Ye file Saathi ka backup nahi hai.';

  @override
  String get backupNewer =>
      'Ye backup Saathi ke naye version ka hai. Pehle app update karein.';

  @override
  String get backupDamaged => 'Ye backup file kharab hai.';

  @override
  String get backupOlder => 'ek purana backup';

  @override
  String get restoreConfirmTitle => 'Backup restore karein?';

  @override
  String restoreConfirmBody(String when) {
    return 'Ye aap ka tamam maujooda data $when se badal dega.\n\nMaujooda data ki ek hifazati copy is phone mein rakhi jayegi. Saathi baad mein band ho jayega; jari rakhne ke liye dobara kholein.';
  }

  @override
  String get restoreButton => 'Restore';

  @override
  String get restoreDoneTitle => 'Backup restore ho gaya';

  @override
  String get restoreDoneBody =>
      'Saathi ab band ho jayega. Apna data dekhne ke liye dobara kholein.';

  @override
  String restoreFailedKept(String error) {
    return 'Restore nakam: $error. Saathi band karke dobara kholein; aap ke data ki hifazati copy rakhi gayi hai.';
  }

  @override
  String restoreFailedSafe(String error) {
    return 'Restore nakam: $error. Aap ka data tabdeel nahi hua.';
  }

  @override
  String get khataIncludesBank =>
      'Totals mein bank transactions shamil hain (Bank tab dekhein)';

  @override
  String get categoryNew => 'Nayi category';

  @override
  String get categoryName => 'Category ka naam';

  @override
  String get categoryPickIcon => 'Icon chunein';

  @override
  String get categoryNameTaken => 'Ye naam pehle se istemal ho raha hai';

  @override
  String get categoriesTitle => 'Meri categories';

  @override
  String get categoriesEmpty =>
      'Abhi aap ki apni koi category nahi. Ek add karein, jaise Raashan ya Mobile load.';

  @override
  String categoryDeleteQ(String name) {
    return '\"$name\" delete karein?';
  }

  @override
  String get categoryDeleteBody =>
      'Is category ki entries \"Other\" mein chali jayengi. Koi raqam zaya nahi hogi.';

  @override
  String get categoriesManage => 'Categories manage karein';

  @override
  String get reviewTitle => 'Haftawar jaiza';

  @override
  String reviewRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String reviewSpent(String amount) {
    return 'Rs $amount kharch hue';
  }

  @override
  String reviewMoreThanBefore(String amount, String percent) {
    return 'Pichle hafte se Rs $amount zyada ($percent%)';
  }

  @override
  String reviewLessThanBefore(String amount, String percent) {
    return 'Pichle hafte se Rs $amount kam ($percent%)';
  }

  @override
  String reviewMoreNoPercent(String amount) {
    return 'Pichle hafte se Rs $amount zyada';
  }

  @override
  String get reviewSameAsBefore => 'Pichle hafte ke barabar';

  @override
  String get reviewPrayers => 'Namazein';

  @override
  String reviewPrayed(String done, String total) {
    return '$total mein se $done parhein';
  }

  @override
  String reviewTasksDone(String count) {
    return '$count mukammal';
  }

  @override
  String reviewTasksOverdue(String count) {
    return '$count overdue';
  }

  @override
  String get reviewNoOverdue => 'Kuch overdue nahi 🎉';

  @override
  String reviewFastsKept(String kept, String missed) {
    return 'Rakhe $kept, chhoote $missed';
  }

  @override
  String get reviewDebts => 'Udhaar diya aur liya';

  @override
  String reviewOwedToMe(String amount) {
    return 'Aap ko milne hain: Rs $amount';
  }

  @override
  String reviewIOwe(String amount) {
    return 'Aap ko dene hain: Rs $amount';
  }

  @override
  String get reviewEmpty =>
      'Is muddat mein abhi kuch darj nahi. Ek hafta Saathi istemal karein aur wapas aayein.';

  @override
  String get reviewNotifTitle => 'Aap ka haftawar jaiza tayar hai';

  @override
  String get reviewNotifBody =>
      'Dekhne ke liye tap karein ke aap ka hafta kaisa guzra';

  @override
  String get reviewSettingSub => 'Apne hafte ko dekhne ki yaad dehani';

  @override
  String reviewSettingOn(String day, String time) {
    return '$day, $time baje';
  }

  @override
  String get reviewDay => 'Din';

  @override
  String get reviewTime => 'Waqt';

  @override
  String get reviewOpen => 'Jaiza kholein';
}
