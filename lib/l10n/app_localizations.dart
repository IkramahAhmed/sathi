import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('en', 'PK'),
    Locale('ur'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Saathi'**
  String get appName;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navTimetable.
  ///
  /// In en, this message translates to:
  /// **'Timetable'**
  String get navTimetable;

  /// No description provided for @navQibla.
  ///
  /// In en, this message translates to:
  /// **'Qibla'**
  String get navQibla;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @allowed.
  ///
  /// In en, this message translates to:
  /// **'Allowed'**
  String get allowed;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get genericError;

  /// No description provided for @prayerFajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get prayerFajr;

  /// No description provided for @prayerSunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get prayerSunrise;

  /// No description provided for @prayerDhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get prayerDhuhr;

  /// No description provided for @prayerAsr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get prayerAsr;

  /// No description provided for @prayerMaghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get prayerMaghrib;

  /// No description provided for @prayerIsha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get prayerIsha;

  /// No description provided for @prayerJumma.
  ///
  /// In en, this message translates to:
  /// **'Jumma'**
  String get prayerJumma;

  /// No description provided for @prayerTimesTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer times'**
  String get prayerTimesTitle;

  /// No description provided for @nextPrayer.
  ///
  /// In en, this message translates to:
  /// **'Next: {prayer} in {duration}'**
  String nextPrayer(String prayer, String duration);

  /// No description provided for @sunriseAt.
  ///
  /// In en, this message translates to:
  /// **'Sunrise {time}'**
  String sunriseAt(String time);

  /// No description provided for @prayedLabel.
  ///
  /// In en, this message translates to:
  /// **'Prayed'**
  String get prayedLabel;

  /// No description provided for @markPrayed.
  ///
  /// In en, this message translates to:
  /// **'Mark {prayer} as prayed'**
  String markPrayed(String prayer);

  /// No description provided for @azanToggle.
  ///
  /// In en, this message translates to:
  /// **'Azan for {prayer}'**
  String azanToggle(String prayer);

  /// No description provided for @hijriDate.
  ///
  /// In en, this message translates to:
  /// **'{day} {month} {year} AH'**
  String hijriDate(int day, String month, int year);

  /// No description provided for @locationRefresh.
  ///
  /// In en, this message translates to:
  /// **'Update my location'**
  String get locationRefresh;

  /// No description provided for @locationUpdated.
  ///
  /// In en, this message translates to:
  /// **'Location set to {city}'**
  String locationUpdated(String city);

  /// No description provided for @locationFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not get your location'**
  String get locationFailed;

  /// No description provided for @durationHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String durationHoursMinutes(int hours, int minutes);

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String durationMinutes(int minutes);

  /// No description provided for @durationSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds} s'**
  String durationSeconds(int seconds);

  /// No description provided for @bannerExactTitle.
  ///
  /// In en, this message translates to:
  /// **'Exact alarms are off'**
  String get bannerExactTitle;

  /// No description provided for @bannerExactBody.
  ///
  /// In en, this message translates to:
  /// **'Azan may arrive a few minutes late. Allow “Alarms & reminders” for on-time azan.'**
  String get bannerExactBody;

  /// No description provided for @bannerExactAction.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get bannerExactAction;

  /// No description provided for @bannerNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off'**
  String get bannerNotifTitle;

  /// No description provided for @bannerNotifBody.
  ///
  /// In en, this message translates to:
  /// **'Turn notifications on to hear the azan.'**
  String get bannerNotifBody;

  /// No description provided for @tasbeehTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasbeeh'**
  String get tasbeehTitle;

  /// No description provided for @tasbeehTapHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to count'**
  String get tasbeehTapHint;

  /// No description provided for @tasbeehReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get tasbeehReset;

  /// No description provided for @timetableTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly timetable'**
  String get timetableTitle;

  /// No description provided for @shareImage.
  ///
  /// In en, this message translates to:
  /// **'Share as image'**
  String get shareImage;

  /// No description provided for @shareFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not share the timetable'**
  String get shareFailed;

  /// No description provided for @colDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get colDate;

  /// No description provided for @previousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get previousMonth;

  /// No description provided for @nextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get nextMonth;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @secLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get secLocation;

  /// No description provided for @useMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my location'**
  String get useMyLocation;

  /// No description provided for @chooseCity.
  ///
  /// In en, this message translates to:
  /// **'Choose a city'**
  String get chooseCity;

  /// No description provided for @searchCity.
  ///
  /// In en, this message translates to:
  /// **'Search city'**
  String get searchCity;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'{city}, {country}'**
  String currentLocation(String city, String country);

  /// No description provided for @followMe.
  ///
  /// In en, this message translates to:
  /// **'Update when I travel'**
  String get followMe;

  /// No description provided for @followMeHint.
  ///
  /// In en, this message translates to:
  /// **'Recalculates when you move more than 50 km'**
  String get followMeHint;

  /// No description provided for @secCalculation.
  ///
  /// In en, this message translates to:
  /// **'Calculation'**
  String get secCalculation;

  /// No description provided for @method.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get method;

  /// No description provided for @madhab.
  ///
  /// In en, this message translates to:
  /// **'Asr (madhab)'**
  String get madhab;

  /// No description provided for @madhabHanafi.
  ///
  /// In en, this message translates to:
  /// **'Hanafi'**
  String get madhabHanafi;

  /// No description provided for @madhabShafi.
  ///
  /// In en, this message translates to:
  /// **'Shafi’i / Maliki / Hanbali'**
  String get madhabShafi;

  /// No description provided for @highLatRule.
  ///
  /// In en, this message translates to:
  /// **'High-latitude rule'**
  String get highLatRule;

  /// No description provided for @highLatMiddle.
  ///
  /// In en, this message translates to:
  /// **'Middle of the night'**
  String get highLatMiddle;

  /// No description provided for @highLatSeventh.
  ///
  /// In en, this message translates to:
  /// **'One-seventh of the night'**
  String get highLatSeventh;

  /// No description provided for @highLatAngle.
  ///
  /// In en, this message translates to:
  /// **'Twilight angle'**
  String get highLatAngle;

  /// No description provided for @autoMethod.
  ///
  /// In en, this message translates to:
  /// **'Auto: {method}'**
  String autoMethod(String method);

  /// No description provided for @useCountryDefaults.
  ///
  /// In en, this message translates to:
  /// **'Use country defaults'**
  String get useCountryDefaults;

  /// No description provided for @secPrayers.
  ///
  /// In en, this message translates to:
  /// **'Prayers'**
  String get secPrayers;

  /// No description provided for @masjidAdjust.
  ///
  /// In en, this message translates to:
  /// **'Masjid time (± minutes)'**
  String get masjidAdjust;

  /// No description provided for @minutesValue.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesValue(int minutes);

  /// No description provided for @preReminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder before prayer'**
  String get preReminder;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @azanSound.
  ///
  /// In en, this message translates to:
  /// **'Azan sound'**
  String get azanSound;

  /// No description provided for @soundBeep.
  ///
  /// In en, this message translates to:
  /// **'Beep'**
  String get soundBeep;

  /// No description provided for @soundFull.
  ///
  /// In en, this message translates to:
  /// **'Azan (full)'**
  String get soundFull;

  /// No description provided for @soundShort.
  ///
  /// In en, this message translates to:
  /// **'Azan (short)'**
  String get soundShort;

  /// No description provided for @soundSilent.
  ///
  /// In en, this message translates to:
  /// **'Silent'**
  String get soundSilent;

  /// No description provided for @audioCredits.
  ///
  /// In en, this message translates to:
  /// **'Audio credits'**
  String get audioCredits;

  /// No description provided for @audioCreditsBody.
  ///
  /// In en, this message translates to:
  /// **'Azan recording: “The Adhan - Muslim Call to Prayer - Aaqib Azeez”, shared on Wikimedia Commons by Atcovi under CC BY-SA 4.0. The short version is a trimmed copy with a fade-out. Source: commons.wikimedia.org (File:The Adhan - Muslim Call to Prayer - Aaqib Azeez.mp3). License: creativecommons.org/licenses/by-sa/4.0'**
  String get audioCreditsBody;

  /// No description provided for @previewSound.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get previewSound;

  /// No description provided for @secHijri.
  ///
  /// In en, this message translates to:
  /// **'Hijri date'**
  String get secHijri;

  /// No description provided for @hijriAdjust.
  ///
  /// In en, this message translates to:
  /// **'Moon-sighting correction'**
  String get hijriAdjust;

  /// No description provided for @hijriNoChange.
  ///
  /// In en, this message translates to:
  /// **'No change'**
  String get hijriNoChange;

  /// No description provided for @hijriPlusOne.
  ///
  /// In en, this message translates to:
  /// **'+1 day'**
  String get hijriPlusOne;

  /// No description provided for @hijriMinusOne.
  ///
  /// In en, this message translates to:
  /// **'−1 day'**
  String get hijriMinusOne;

  /// No description provided for @syncSection.
  ///
  /// In en, this message translates to:
  /// **'Cloud backup'**
  String get syncSection;

  /// No description provided for @syncTitle.
  ///
  /// In en, this message translates to:
  /// **'Back up my prayed log'**
  String get syncTitle;

  /// No description provided for @syncSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keeps your ticked prayers safe and the same on all your phones'**
  String get syncSubtitle;

  /// No description provided for @syncServer.
  ///
  /// In en, this message translates to:
  /// **'Server address'**
  String get syncServer;

  /// No description provided for @syncServerNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get syncServerNotSet;

  /// No description provided for @syncServerHint.
  ///
  /// In en, this message translates to:
  /// **'https://your-server.workers.dev'**
  String get syncServerHint;

  /// No description provided for @syncServerInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter an https:// address'**
  String get syncServerInvalid;

  /// No description provided for @syncKey.
  ///
  /// In en, this message translates to:
  /// **'Sync key'**
  String get syncKey;

  /// No description provided for @syncKeyHelp.
  ///
  /// In en, this message translates to:
  /// **'Keep this secret. Anyone with it can see your prayed log. You need it to restore your log on a new phone.'**
  String get syncKeyHelp;

  /// No description provided for @syncKeyCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy key'**
  String get syncKeyCopy;

  /// No description provided for @syncKeyCopied.
  ///
  /// In en, this message translates to:
  /// **'Key copied'**
  String get syncKeyCopied;

  /// No description provided for @syncKeyShow.
  ///
  /// In en, this message translates to:
  /// **'Show key'**
  String get syncKeyShow;

  /// No description provided for @syncKeyHide.
  ///
  /// In en, this message translates to:
  /// **'Hide key'**
  String get syncKeyHide;

  /// No description provided for @syncUseKey.
  ///
  /// In en, this message translates to:
  /// **'Use a key from another phone'**
  String get syncUseKey;

  /// No description provided for @syncUseKeyHelp.
  ///
  /// In en, this message translates to:
  /// **'Paste the key from your other phone. This phone\'s log is merged with the cloud copy.'**
  String get syncUseKeyHelp;

  /// No description provided for @syncKeyInvalid.
  ///
  /// In en, this message translates to:
  /// **'That does not look like a valid key'**
  String get syncKeyInvalid;

  /// No description provided for @syncUse.
  ///
  /// In en, this message translates to:
  /// **'Use this key'**
  String get syncUse;

  /// No description provided for @syncSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get syncSave;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNow;

  /// No description provided for @syncRunning.
  ///
  /// In en, this message translates to:
  /// **'Syncing…'**
  String get syncRunning;

  /// No description provided for @syncLastSynced.
  ///
  /// In en, this message translates to:
  /// **'Last synced {time}'**
  String syncLastSynced(String time);

  /// No description provided for @syncNever.
  ///
  /// In en, this message translates to:
  /// **'Not synced yet'**
  String get syncNever;

  /// No description provided for @syncPending.
  ///
  /// In en, this message translates to:
  /// **'{count} waiting to upload'**
  String syncPending(int count);

  /// No description provided for @syncProblemSetup.
  ///
  /// In en, this message translates to:
  /// **'Set the server address first'**
  String get syncProblemSetup;

  /// No description provided for @syncProblemOffline.
  ///
  /// In en, this message translates to:
  /// **'No connection. It will try again later.'**
  String get syncProblemOffline;

  /// No description provided for @syncProblemServer.
  ///
  /// In en, this message translates to:
  /// **'The server had a problem. It will try again later.'**
  String get syncProblemServer;

  /// No description provided for @syncProblemKey.
  ///
  /// In en, this message translates to:
  /// **'The server did not accept this key.'**
  String get syncProblemKey;

  /// No description provided for @syncProblemOther.
  ///
  /// In en, this message translates to:
  /// **'Sync did not work. It will try again later.'**
  String get syncProblemOther;

  /// No description provided for @syncDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete my cloud data'**
  String get syncDelete;

  /// No description provided for @syncDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This erases your backup from the cloud. The prayed log on this phone is not touched.'**
  String get syncDeleteBody;

  /// No description provided for @syncDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get syncDeleteConfirm;

  /// No description provided for @syncDeleted.
  ///
  /// In en, this message translates to:
  /// **'Cloud data deleted'**
  String get syncDeleted;

  /// No description provided for @navTracker.
  ///
  /// In en, this message translates to:
  /// **'Tracker'**
  String get navTracker;

  /// No description provided for @trackerTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer tracker'**
  String get trackerTitle;

  /// No description provided for @streakCurrent.
  ///
  /// In en, this message translates to:
  /// **'{days}-day streak'**
  String streakCurrent(int days);

  /// No description provided for @streakBest.
  ///
  /// In en, this message translates to:
  /// **'Best: {days}'**
  String streakBest(int days);

  /// No description provided for @streakNone.
  ///
  /// In en, this message translates to:
  /// **'Pray all five today to start a streak'**
  String get streakNone;

  /// No description provided for @trackerToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get trackerToday;

  /// No description provided for @trackerPrevDay.
  ///
  /// In en, this message translates to:
  /// **'Previous day'**
  String get trackerPrevDay;

  /// No description provided for @trackerNextDay.
  ///
  /// In en, this message translates to:
  /// **'Next day'**
  String get trackerNextDay;

  /// No description provided for @trackerFuture.
  ///
  /// In en, this message translates to:
  /// **'You cannot tick a day that has not happened yet'**
  String get trackerFuture;

  /// No description provided for @trackerPausedDay.
  ///
  /// In en, this message translates to:
  /// **'Paused: prayers on this day are not counted as missed'**
  String get trackerPausedDay;

  /// No description provided for @dayComplete.
  ///
  /// In en, this message translates to:
  /// **'All five prayed'**
  String get dayComplete;

  /// No description provided for @pauseTitle.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pauseTitle;

  /// No description provided for @pauseHelp.
  ///
  /// In en, this message translates to:
  /// **'For illness or a woman\'s period. Paused days do not break your streak or count as missed. This stays on this phone only and is never uploaded.'**
  String get pauseHelp;

  /// No description provided for @pauseStart.
  ///
  /// In en, this message translates to:
  /// **'Start a pause today'**
  String get pauseStart;

  /// No description provided for @pauseEnd.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get pauseEnd;

  /// No description provided for @pauseSince.
  ///
  /// In en, this message translates to:
  /// **'Paused since {date}'**
  String pauseSince(String date);

  /// No description provided for @pauseAddPast.
  ///
  /// In en, this message translates to:
  /// **'Add past days'**
  String get pauseAddPast;

  /// No description provided for @pauseRange.
  ///
  /// In en, this message translates to:
  /// **'{start} to {end}'**
  String pauseRange(String start, String end);

  /// No description provided for @pauseRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get pauseRemove;

  /// No description provided for @pauseNone.
  ///
  /// In en, this message translates to:
  /// **'No pauses'**
  String get pauseNone;

  /// No description provided for @qazaTitle.
  ///
  /// In en, this message translates to:
  /// **'Qaza (missed prayers)'**
  String get qazaTitle;

  /// No description provided for @qazaCardOwed.
  ///
  /// In en, this message translates to:
  /// **'{count} to make up'**
  String qazaCardOwed(int count);

  /// No description provided for @qazaCardNone.
  ///
  /// In en, this message translates to:
  /// **'Nothing owed'**
  String get qazaCardNone;

  /// No description provided for @qazaMadeUp.
  ///
  /// In en, this message translates to:
  /// **'Made up one'**
  String get qazaMadeUp;

  /// No description provided for @qazaAddOne.
  ///
  /// In en, this message translates to:
  /// **'Add one missed'**
  String get qazaAddOne;

  /// No description provided for @qazaSetBalance.
  ///
  /// In en, this message translates to:
  /// **'Set starting balance'**
  String get qazaSetBalance;

  /// No description provided for @qazaBalanceHelp.
  ///
  /// In en, this message translates to:
  /// **'How many of each prayer do you owe? Leave a prayer at 0 if none.'**
  String get qazaBalanceHelp;

  /// No description provided for @qazaEstimate.
  ///
  /// In en, this message translates to:
  /// **'Estimate from years'**
  String get qazaEstimate;

  /// No description provided for @qazaYears.
  ///
  /// In en, this message translates to:
  /// **'Years of missed prayers'**
  String get qazaYears;

  /// No description provided for @qazaYearsHelp.
  ///
  /// In en, this message translates to:
  /// **'Fills every prayer with years × 365. You can adjust each one after.'**
  String get qazaYearsHelp;

  /// No description provided for @qazaApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get qazaApply;

  /// No description provided for @qazaAuto.
  ///
  /// In en, this message translates to:
  /// **'Count missed prayers automatically'**
  String get qazaAuto;

  /// No description provided for @qazaAutoHelp.
  ///
  /// In en, this message translates to:
  /// **'Adds a missed prayer when its time ends without a tick. Starts from today. It is taken back if you tick it later, and paused days are skipped.'**
  String get qazaAutoHelp;

  /// No description provided for @qazaHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get qazaHistory;

  /// No description provided for @qazaHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing yet'**
  String get qazaHistoryEmpty;

  /// No description provided for @qazaSourceInitial.
  ///
  /// In en, this message translates to:
  /// **'Starting balance'**
  String get qazaSourceInitial;

  /// No description provided for @qazaSourceAdded.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get qazaSourceAdded;

  /// No description provided for @qazaSourceMadeUp.
  ///
  /// In en, this message translates to:
  /// **'Made up'**
  String get qazaSourceMadeUp;

  /// No description provided for @qazaSourceAuto.
  ///
  /// In en, this message translates to:
  /// **'Counted automatically'**
  String get qazaSourceAuto;

  /// No description provided for @qazaTotal.
  ///
  /// In en, this message translates to:
  /// **'{count} prayers to make up'**
  String qazaTotal(int count);

  /// No description provided for @jamaatSection.
  ///
  /// In en, this message translates to:
  /// **'Jama\'at (mosque)'**
  String get jamaatSection;

  /// No description provided for @jamaatHelp.
  ///
  /// In en, this message translates to:
  /// **'Set your mosque\'s jama\'at times to see them next to each prayer, and to be reminded to leave. Use minutes after the azan, or a fixed time.'**
  String get jamaatHelp;

  /// No description provided for @jamaatNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get jamaatNotSet;

  /// No description provided for @jamaatAfter.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min after azan'**
  String jamaatAfter(int minutes);

  /// No description provided for @jamaatFixed.
  ///
  /// In en, this message translates to:
  /// **'At {time}'**
  String jamaatFixed(String time);

  /// No description provided for @jamaatAt.
  ///
  /// In en, this message translates to:
  /// **'Jama\'at {time}'**
  String jamaatAt(String time);

  /// No description provided for @jamaatEdit.
  ///
  /// In en, this message translates to:
  /// **'Jama\'at time'**
  String get jamaatEdit;

  /// No description provided for @jamaatModeAfter.
  ///
  /// In en, this message translates to:
  /// **'Minutes after azan'**
  String get jamaatModeAfter;

  /// No description provided for @jamaatModeFixed.
  ///
  /// In en, this message translates to:
  /// **'Fixed time'**
  String get jamaatModeFixed;

  /// No description provided for @jamaatPickTime.
  ///
  /// In en, this message translates to:
  /// **'Pick time'**
  String get jamaatPickTime;

  /// No description provided for @jamaatClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get jamaatClear;

  /// No description provided for @jummaTime.
  ///
  /// In en, this message translates to:
  /// **'Jumma time'**
  String get jummaTime;

  /// No description provided for @leaveReminder.
  ///
  /// In en, this message translates to:
  /// **'Remind me to leave'**
  String get leaveReminder;

  /// No description provided for @leaveMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min before jama\'at'**
  String leaveMinutes(int minutes);

  /// No description provided for @silentDuring.
  ///
  /// In en, this message translates to:
  /// **'Silence my phone during jama\'at'**
  String get silentDuring;

  /// No description provided for @silentHelp.
  ///
  /// In en, this message translates to:
  /// **'Needs Do Not Disturb access. The phone returns to normal afterwards.'**
  String get silentHelp;

  /// No description provided for @silentLength.
  ///
  /// In en, this message translates to:
  /// **'Stay silent for'**
  String get silentLength;

  /// No description provided for @silentGrantAccess.
  ///
  /// In en, this message translates to:
  /// **'Allow Do Not Disturb access'**
  String get silentGrantAccess;

  /// No description provided for @azanAlarmVolume.
  ///
  /// In en, this message translates to:
  /// **'Play azan on the alarm volume'**
  String get azanAlarmVolume;

  /// No description provided for @azanAlarmHelp.
  ///
  /// In en, this message translates to:
  /// **'Heard even in silent mode, and not affected by the media volume.'**
  String get azanAlarmHelp;

  /// No description provided for @checkSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Check my setup'**
  String get checkSetupTitle;

  /// No description provided for @checkSetupIntro.
  ///
  /// In en, this message translates to:
  /// **'Make sure the azan will really sound. Fix anything marked in red.'**
  String get checkSetupIntro;

  /// No description provided for @checkNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications allowed'**
  String get checkNotifications;

  /// No description provided for @checkExact.
  ///
  /// In en, this message translates to:
  /// **'Alarms and reminders allowed'**
  String get checkExact;

  /// No description provided for @checkExactHelp.
  ///
  /// In en, this message translates to:
  /// **'Lets the azan fire at the exact minute.'**
  String get checkExactHelp;

  /// No description provided for @checkBattery.
  ///
  /// In en, this message translates to:
  /// **'Battery: unrestricted'**
  String get checkBattery;

  /// No description provided for @checkBatteryHelp.
  ///
  /// In en, this message translates to:
  /// **'Open app settings, then Battery, and choose No restrictions.'**
  String get checkBatteryHelp;

  /// No description provided for @checkChannel.
  ///
  /// In en, this message translates to:
  /// **'Azan sound turned on in system settings'**
  String get checkChannel;

  /// No description provided for @checkChannelHelp.
  ///
  /// In en, this message translates to:
  /// **'The azan sound is muted for this app. Turn it on in the notification settings.'**
  String get checkChannelHelp;

  /// No description provided for @checkScheduled.
  ///
  /// In en, this message translates to:
  /// **'{count} alerts scheduled'**
  String checkScheduled(int count);

  /// No description provided for @checkNoneScheduled.
  ///
  /// In en, this message translates to:
  /// **'No alerts are scheduled'**
  String get checkNoneScheduled;

  /// No description provided for @checkOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get checkOk;

  /// No description provided for @checkFix.
  ///
  /// In en, this message translates to:
  /// **'Fix'**
  String get checkFix;

  /// No description provided for @checkTestNow.
  ///
  /// In en, this message translates to:
  /// **'Play a test azan now'**
  String get checkTestNow;

  /// No description provided for @checkReplan.
  ///
  /// In en, this message translates to:
  /// **'Re-plan all alerts'**
  String get checkReplan;

  /// No description provided for @checkReplanned.
  ///
  /// In en, this message translates to:
  /// **'Alerts re-planned'**
  String get checkReplanned;

  /// No description provided for @endSection.
  ///
  /// In en, this message translates to:
  /// **'Prayer time ending'**
  String get endSection;

  /// No description provided for @endHelp.
  ///
  /// In en, this message translates to:
  /// **'Get reminded before a prayer\'s time ends, and again until you have prayed. If a prayer is missed it goes to your qaza list.'**
  String get endHelp;

  /// No description provided for @endEnable.
  ///
  /// In en, this message translates to:
  /// **'Remind me before a prayer ends'**
  String get endEnable;

  /// No description provided for @endLead.
  ///
  /// In en, this message translates to:
  /// **'First reminder'**
  String get endLead;

  /// No description provided for @endLeadValue.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min before the end'**
  String endLeadValue(int minutes);

  /// No description provided for @endRepeat.
  ///
  /// In en, this message translates to:
  /// **'Then repeat every'**
  String get endRepeat;

  /// No description provided for @endRepeatValue.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String endRepeatValue(int minutes);

  /// No description provided for @endPrayers.
  ///
  /// In en, this message translates to:
  /// **'Which prayers'**
  String get endPrayers;

  /// No description provided for @endRequirePhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo proof'**
  String get endRequirePhoto;

  /// No description provided for @endRequirePhotoHelp.
  ///
  /// In en, this message translates to:
  /// **'Keep reminding until you take a photo of your prayer place, such as your prayer mat or the mosque. The photo is checked on this phone and is never saved or sent anywhere.'**
  String get endRequirePhotoHelp;

  /// No description provided for @endTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Try the ending reminder'**
  String get endTestTitle;

  /// No description provided for @endTestHelp.
  ///
  /// In en, this message translates to:
  /// **'Sends 3 test notifications spaced 1 minute apart so you can experience the full flow.'**
  String get endTestHelp;

  /// No description provided for @endTestSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get endTestSend;

  /// No description provided for @endTestScheduled.
  ///
  /// In en, this message translates to:
  /// **'3 test reminders sent — first arrives in 10 seconds.'**
  String get endTestScheduled;

  /// No description provided for @verifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer photo check'**
  String get verifyTitle;

  /// No description provided for @verifyIntro.
  ///
  /// In en, this message translates to:
  /// **'After you pray, take a photo of your prayer place, such as your prayer mat or the mosque. It is checked on this phone only and is never saved.'**
  String get verifyIntro;

  /// No description provided for @verifyPrayer.
  ///
  /// In en, this message translates to:
  /// **'{prayer} · {date}'**
  String verifyPrayer(String prayer, String date);

  /// No description provided for @verifyTake.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get verifyTake;

  /// No description provided for @verifyChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get verifyChecking;

  /// No description provided for @verifySuccess.
  ///
  /// In en, this message translates to:
  /// **'Verified. May Allah accept your prayer.'**
  String get verifySuccess;

  /// No description provided for @verifyTestNote.
  ///
  /// In en, this message translates to:
  /// **'This was a test reminder — your prayer log was not changed.'**
  String get verifyTestNote;

  /// No description provided for @verifyFail.
  ///
  /// In en, this message translates to:
  /// **'That does not look like a prayer place. Try again with your prayer mat or the mosque in view.'**
  String get verifyFail;

  /// No description provided for @verifyTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get verifyTryAgain;

  /// No description provided for @verifyStop.
  ///
  /// In en, this message translates to:
  /// **'Stop reminding me'**
  String get verifyStop;

  /// No description provided for @verifyStopHelp.
  ///
  /// In en, this message translates to:
  /// **'Use this if you cannot pray now. The prayer is not marked as prayed.'**
  String get verifyStopHelp;

  /// No description provided for @verifySaw.
  ///
  /// In en, this message translates to:
  /// **'The phone saw: {labels}'**
  String verifySaw(String labels);

  /// No description provided for @verifyEnded.
  ///
  /// In en, this message translates to:
  /// **'This prayer\'s time has ended. You can still tick it in the tracker.'**
  String get verifyEnded;

  /// No description provided for @verifyProofNeeded.
  ///
  /// In en, this message translates to:
  /// **'Photo proof is on for this prayer'**
  String get verifyProofNeeded;

  /// No description provided for @verifyNoCamera.
  ///
  /// In en, this message translates to:
  /// **'The camera could not be opened'**
  String get verifyNoCamera;

  /// No description provided for @verifyChecklistHint.
  ///
  /// In en, this message translates to:
  /// **'Tip: make sure the prayer mat or the mosque fills most of the picture.'**
  String get verifyChecklistHint;

  /// No description provided for @secLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get secLanguage;

  /// No description provided for @langEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @langUrdu.
  ///
  /// In en, this message translates to:
  /// **'اردو'**
  String get langUrdu;

  /// No description provided for @langRomanUrdu.
  ///
  /// In en, this message translates to:
  /// **'Roman Urdu'**
  String get langRomanUrdu;

  /// No description provided for @testNotification.
  ///
  /// In en, this message translates to:
  /// **'Test notification in 10 s'**
  String get testNotification;

  /// No description provided for @testScheduled.
  ///
  /// In en, this message translates to:
  /// **'A test notification will arrive in 10 seconds'**
  String get testScheduled;

  /// No description provided for @testTitle.
  ///
  /// In en, this message translates to:
  /// **'Saathi test'**
  String get testTitle;

  /// No description provided for @testBody.
  ///
  /// In en, this message translates to:
  /// **'If you can hear this, the azan will work'**
  String get testBody;

  /// No description provided for @batteryHelp.
  ///
  /// In en, this message translates to:
  /// **'Battery & background help'**
  String get batteryHelp;

  /// No description provided for @pendingCount.
  ///
  /// In en, this message translates to:
  /// **'{count} azan alerts scheduled'**
  String pendingCount(int count);

  /// No description provided for @qiblaTitle.
  ///
  /// In en, this message translates to:
  /// **'Qibla'**
  String get qiblaTitle;

  /// No description provided for @qiblaBearing.
  ///
  /// In en, this message translates to:
  /// **'Qibla is {degrees}° from north'**
  String qiblaBearing(int degrees);

  /// No description provided for @qiblaNoSensor.
  ///
  /// In en, this message translates to:
  /// **'This phone has no compass sensor. Use the bearing above with a compass.'**
  String get qiblaNoSensor;

  /// No description provided for @qiblaTurnRight.
  ///
  /// In en, this message translates to:
  /// **'Turn right {degrees}°'**
  String qiblaTurnRight(int degrees);

  /// No description provided for @qiblaTurnLeft.
  ///
  /// In en, this message translates to:
  /// **'Turn left {degrees}°'**
  String qiblaTurnLeft(int degrees);

  /// No description provided for @qiblaFacing.
  ///
  /// In en, this message translates to:
  /// **'You are facing the Qibla'**
  String get qiblaFacing;

  /// No description provided for @qiblaHeading.
  ///
  /// In en, this message translates to:
  /// **'Phone points {degrees}°'**
  String qiblaHeading(int degrees);

  /// No description provided for @qiblaDistance.
  ///
  /// In en, this message translates to:
  /// **'{km} km to the Kaaba'**
  String qiblaDistance(String km);

  /// No description provided for @qiblaCalibrate.
  ///
  /// In en, this message translates to:
  /// **'Compass needs calibrating. Move the phone in a figure 8, away from metal and magnets.'**
  String get qiblaCalibrate;

  /// No description provided for @qiblaFace.
  ///
  /// In en, this message translates to:
  /// **'Turn until the arrow points up'**
  String get qiblaFace;

  /// No description provided for @stepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String stepOf(int current, int total);

  /// No description provided for @onbWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Assalamu alaikum'**
  String get onbWelcomeTitle;

  /// No description provided for @onbWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Saathi tells you prayer times and plays the azan, even with no internet.'**
  String get onbWelcomeBody;

  /// No description provided for @onbLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get onbLanguageTitle;

  /// No description provided for @onbLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Your location'**
  String get onbLocationTitle;

  /// No description provided for @onbLocationBody.
  ///
  /// In en, this message translates to:
  /// **'Used to calculate accurate prayer times. It stays on your phone.'**
  String get onbLocationBody;

  /// No description provided for @onbLocationAllow.
  ///
  /// In en, this message translates to:
  /// **'Use my location'**
  String get onbLocationAllow;

  /// No description provided for @onbLocationManual.
  ///
  /// In en, this message translates to:
  /// **'Or choose a city'**
  String get onbLocationManual;

  /// No description provided for @onbNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'Azan notifications'**
  String get onbNotifTitle;

  /// No description provided for @onbNotifBody.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications so Saathi can call you to prayer.'**
  String get onbNotifBody;

  /// No description provided for @onbExactTitle.
  ///
  /// In en, this message translates to:
  /// **'On-time alarms'**
  String get onbExactTitle;

  /// No description provided for @onbExactBody.
  ///
  /// In en, this message translates to:
  /// **'Allow “Alarms & reminders” so the azan fires at the exact minute.'**
  String get onbExactBody;

  /// No description provided for @onbOemTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep Saathi running'**
  String get onbOemTitle;

  /// No description provided for @onbOemBody.
  ///
  /// In en, this message translates to:
  /// **'Your phone may stop apps in the background. A few settings keep the azan reliable.'**
  String get onbOemBody;

  /// No description provided for @onbOemOpen.
  ///
  /// In en, this message translates to:
  /// **'See the steps'**
  String get onbOemOpen;

  /// No description provided for @onbDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'All set'**
  String get onbDoneTitle;

  /// No description provided for @onbDoneBody.
  ///
  /// In en, this message translates to:
  /// **'Saathi will call you at every prayer.'**
  String get onbDoneBody;

  /// No description provided for @onbStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get onbStart;

  /// No description provided for @oemTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow background azan'**
  String get oemTitle;

  /// No description provided for @oemIntro.
  ///
  /// In en, this message translates to:
  /// **'{brand} phones often stop background apps to save battery. Do these steps once:'**
  String oemIntro(String brand);

  /// No description provided for @oemStep1.
  ///
  /// In en, this message translates to:
  /// **'Open App info, then Battery, and choose “No restrictions” (or “Unrestricted”).'**
  String get oemStep1;

  /// No description provided for @oemStep2.
  ///
  /// In en, this message translates to:
  /// **'Turn on “Autostart” or “Auto-launch” for Saathi.'**
  String get oemStep2;

  /// No description provided for @oemStep3.
  ///
  /// In en, this message translates to:
  /// **'In Recent apps, lock Saathi (pull its card down or long-press, then choose Lock).'**
  String get oemStep3;

  /// No description provided for @oemStep4.
  ///
  /// In en, this message translates to:
  /// **'Keep notifications and notification sound switched on.'**
  String get oemStep4;

  /// No description provided for @oemOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open app settings'**
  String get oemOpenSettings;

  /// No description provided for @oemDontShow.
  ///
  /// In en, this message translates to:
  /// **'Don’t show again'**
  String get oemDontShow;

  /// No description provided for @oemGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get oemGotIt;

  /// No description provided for @scanTimetableButton.
  ///
  /// In en, this message translates to:
  /// **'Scan mosque timetable'**
  String get scanTimetableButton;

  /// No description provided for @scanTimetableTitle.
  ///
  /// In en, this message translates to:
  /// **'Mosque timetable'**
  String get scanTimetableTitle;

  /// No description provided for @scanTimetableScanning.
  ///
  /// In en, this message translates to:
  /// **'Reading timetable…'**
  String get scanTimetableScanning;

  /// No description provided for @scanTimetableError.
  ///
  /// In en, this message translates to:
  /// **'Could not read the photo. Try again in better lighting.'**
  String get scanTimetableError;

  /// No description provided for @scanTimetableFound.
  ///
  /// In en, this message translates to:
  /// **'{count} of 5 prayers detected. Tap any row to adjust.'**
  String scanTimetableFound(int count);

  /// No description provided for @scanTimetableNoneFound.
  ///
  /// In en, this message translates to:
  /// **'No prayer times found. Try a clearer photo.'**
  String get scanTimetableNoneFound;

  /// No description provided for @scanTimetableHint.
  ///
  /// In en, this message translates to:
  /// **'Detected times are highlighted in gold. Tap any row to correct a time.'**
  String get scanTimetableHint;

  /// No description provided for @scanTimetableSave.
  ///
  /// In en, this message translates to:
  /// **'Save jama\'at times'**
  String get scanTimetableSave;

  /// No description provided for @scanAutoDetected.
  ///
  /// In en, this message translates to:
  /// **'Auto-detected'**
  String get scanAutoDetected;

  /// No description provided for @scanTapToAdjust.
  ///
  /// In en, this message translates to:
  /// **'Tap to adjust'**
  String get scanTapToAdjust;

  /// No description provided for @scanNotDetected.
  ///
  /// In en, this message translates to:
  /// **'Not detected — tap to set'**
  String get scanNotDetected;

  /// No description provided for @navKhata.
  ///
  /// In en, this message translates to:
  /// **'Khata'**
  String get navKhata;

  /// No description provided for @khataTitle.
  ///
  /// In en, this message translates to:
  /// **'Khata'**
  String get khataTitle;

  /// No description provided for @khataMonthTotal.
  ///
  /// In en, this message translates to:
  /// **'Total this month'**
  String get khataMonthTotal;

  /// No description provided for @khataEmpty.
  ///
  /// In en, this message translates to:
  /// **'No expenses yet'**
  String get khataEmpty;

  /// No description provided for @khataEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Tap + to record your first expense'**
  String get khataEmptyHint;

  /// No description provided for @khataAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get khataAddTitle;

  /// No description provided for @khataTabExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get khataTabExpenses;

  /// No description provided for @khataEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Expense'**
  String get khataEditTitle;

  /// No description provided for @khataAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get khataAmount;

  /// No description provided for @khataAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount greater than zero'**
  String get khataAmountInvalid;

  /// No description provided for @khataCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get khataCategory;

  /// No description provided for @khataNote.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get khataNote;

  /// No description provided for @khataDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get khataDate;

  /// No description provided for @khataSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get khataSave;

  /// No description provided for @khataDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get khataDelete;

  /// No description provided for @khataToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get khataToday;

  /// No description provided for @khataYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get khataYesterday;

  /// No description provided for @khataCatFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get khataCatFood;

  /// No description provided for @khataCatTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get khataCatTransport;

  /// No description provided for @khataCatRent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get khataCatRent;

  /// No description provided for @khataCatHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get khataCatHealth;

  /// No description provided for @khataCatBills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get khataCatBills;

  /// No description provided for @khataCatShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get khataCatShopping;

  /// No description provided for @khataCatOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get khataCatOther;

  /// No description provided for @navPrayer.
  ///
  /// In en, this message translates to:
  /// **'Prayer'**
  String get navPrayer;

  /// No description provided for @dashTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get dashTools;

  /// No description provided for @dashComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get dashComingSoon;

  /// No description provided for @khataChart.
  ///
  /// In en, this message translates to:
  /// **'Spending by category'**
  String get khataChart;

  /// No description provided for @khataBudget.
  ///
  /// In en, this message translates to:
  /// **'Monthly budgets'**
  String get khataBudget;

  /// No description provided for @khataBudgetHint.
  ///
  /// In en, this message translates to:
  /// **'Set 0 to remove a limit'**
  String get khataBudgetHint;

  /// No description provided for @khataExport.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get khataExport;

  /// No description provided for @khataBudgetSaved.
  ///
  /// In en, this message translates to:
  /// **'Budgets saved'**
  String get khataBudgetSaved;

  /// No description provided for @khataOverBudget.
  ///
  /// In en, this message translates to:
  /// **'Over budget'**
  String get khataOverBudget;

  /// No description provided for @udhaarTitle.
  ///
  /// In en, this message translates to:
  /// **'Udhaar Ledger'**
  String get udhaarTitle;

  /// No description provided for @udhaarSearch.
  ///
  /// In en, this message translates to:
  /// **'Search contacts…'**
  String get udhaarSearch;

  /// No description provided for @udhaarAddContact.
  ///
  /// In en, this message translates to:
  /// **'Add Contact'**
  String get udhaarAddContact;

  /// No description provided for @udhaarEditContact.
  ///
  /// In en, this message translates to:
  /// **'Edit Contact'**
  String get udhaarEditContact;

  /// No description provided for @udhaarDeleteContact.
  ///
  /// In en, this message translates to:
  /// **'Delete Contact'**
  String get udhaarDeleteContact;

  /// No description provided for @udhaarDeleteContactConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete {name} and all their entries?'**
  String udhaarDeleteContactConfirm(String name);

  /// No description provided for @udhaarContactName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get udhaarContactName;

  /// No description provided for @udhaarSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get udhaarSave;

  /// No description provided for @udhaarDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get udhaarDelete;

  /// No description provided for @udhaarEmpty.
  ///
  /// In en, this message translates to:
  /// **'No contacts yet'**
  String get udhaarEmpty;

  /// No description provided for @udhaarEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Add someone you gave or took money from'**
  String get udhaarEmptyHint;

  /// No description provided for @udhaarOwedToMe.
  ///
  /// In en, this message translates to:
  /// **'Total Lena'**
  String get udhaarOwedToMe;

  /// No description provided for @udhaarIOwe.
  ///
  /// In en, this message translates to:
  /// **'Total Dena'**
  String get udhaarIOwe;

  /// No description provided for @udhaarOwes.
  ///
  /// In en, this message translates to:
  /// **'Lena'**
  String get udhaarOwes;

  /// No description provided for @udhaarYouOwe.
  ///
  /// In en, this message translates to:
  /// **'Dena'**
  String get udhaarYouOwe;

  /// No description provided for @udhaarSettled.
  ///
  /// In en, this message translates to:
  /// **'Barabar'**
  String get udhaarSettled;

  /// No description provided for @udhaarClear.
  ///
  /// In en, this message translates to:
  /// **'Barabar'**
  String get udhaarClear;

  /// No description provided for @udhaarOwesYou.
  ///
  /// In en, this message translates to:
  /// **'{name} ka Lena'**
  String udhaarOwesYou(String name);

  /// No description provided for @udhaarYouOweContact.
  ///
  /// In en, this message translates to:
  /// **'{name} ka Dena'**
  String udhaarYouOweContact(String name);

  /// No description provided for @udhaarGave.
  ///
  /// In en, this message translates to:
  /// **'Diya'**
  String get udhaarGave;

  /// No description provided for @udhaarReceived.
  ///
  /// In en, this message translates to:
  /// **'Liya'**
  String get udhaarReceived;

  /// No description provided for @udhaarAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get udhaarAmount;

  /// No description provided for @udhaarNote.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get udhaarNote;

  /// No description provided for @udhaarChangeDate.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get udhaarChangeDate;

  /// No description provided for @udhaarNoEntries.
  ///
  /// In en, this message translates to:
  /// **'No entries yet.\nTap Diya or Liya to record.'**
  String get udhaarNoEntries;

  /// No description provided for @udhaarEditEntry.
  ///
  /// In en, this message translates to:
  /// **'Edit entry'**
  String get udhaarEditEntry;

  /// No description provided for @udhaarDeleteEntry.
  ///
  /// In en, this message translates to:
  /// **'Delete this entry?'**
  String get udhaarDeleteEntry;

  /// No description provided for @udhaarPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone (for WhatsApp)'**
  String get udhaarPhone;

  /// No description provided for @udhaarWhatsAppReminder.
  ///
  /// In en, this message translates to:
  /// **'Send WhatsApp reminder'**
  String get udhaarWhatsAppReminder;

  /// No description provided for @udhaarWhatsAppLena.
  ///
  /// In en, this message translates to:
  /// **'Assalamu Alaikum {name}, aapka Rs. {amount} mujhe lena baqi hai. - Saathi App'**
  String udhaarWhatsAppLena(String name, String amount);

  /// No description provided for @udhaarWhatsAppDena.
  ///
  /// In en, this message translates to:
  /// **'Assalamu Alaikum {name}, mera Rs. {amount} aapko dena baqi hai. - Saathi App'**
  String udhaarWhatsAppDena(String name, String amount);

  /// No description provided for @udhaarWhatsAppNotFound.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp not installed'**
  String get udhaarWhatsAppNotFound;

  /// No description provided for @udhaarDueOn.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get udhaarDueOn;

  /// No description provided for @udhaarNoDueDate.
  ///
  /// In en, this message translates to:
  /// **'No due date'**
  String get udhaarNoDueDate;

  /// No description provided for @udhaarSetDueDate.
  ///
  /// In en, this message translates to:
  /// **'Set date'**
  String get udhaarSetDueDate;

  /// No description provided for @udhaarLate.
  ///
  /// In en, this message translates to:
  /// **'Late — payment overdue'**
  String get udhaarLate;

  /// No description provided for @udhaarLateTitle.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get udhaarLateTitle;

  /// No description provided for @khataIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get khataIncome;

  /// No description provided for @khataExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get khataExpense;

  /// No description provided for @khataNet.
  ///
  /// In en, this message translates to:
  /// **'Net'**
  String get khataNet;

  /// No description provided for @khataAddIncome.
  ///
  /// In en, this message translates to:
  /// **'Add income'**
  String get khataAddIncome;

  /// No description provided for @khataAddExpense.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get khataAddExpense;

  /// No description provided for @khataTotalIncome.
  ///
  /// In en, this message translates to:
  /// **'Total income'**
  String get khataTotalIncome;

  /// No description provided for @khataTotalExpense.
  ///
  /// In en, this message translates to:
  /// **'Total expense'**
  String get khataTotalExpense;

  /// No description provided for @khataReceiptPhoto.
  ///
  /// In en, this message translates to:
  /// **'Receipt photo'**
  String get khataReceiptPhoto;

  /// No description provided for @khataAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get khataAddPhoto;

  /// No description provided for @khataViewPhoto.
  ///
  /// In en, this message translates to:
  /// **'View receipt'**
  String get khataViewPhoto;

  /// No description provided for @khataRemovePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get khataRemovePhoto;

  /// No description provided for @khataPdfExport.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get khataPdfExport;

  /// No description provided for @udhaarPdfPassbook.
  ///
  /// In en, this message translates to:
  /// **'Udhaar passbook (PDF)'**
  String get udhaarPdfPassbook;

  /// No description provided for @incomeSourceSalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get incomeSourceSalary;

  /// No description provided for @incomeSourceFreelance.
  ///
  /// In en, this message translates to:
  /// **'Freelance'**
  String get incomeSourceFreelance;

  /// No description provided for @incomeSourceBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get incomeSourceBusiness;

  /// No description provided for @incomeSourceGift.
  ///
  /// In en, this message translates to:
  /// **'Gift'**
  String get incomeSourceGift;

  /// No description provided for @incomeSourceOther.
  ///
  /// In en, this message translates to:
  /// **'Other income'**
  String get incomeSourceOther;

  /// No description provided for @navTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get navTasks;

  /// No description provided for @vaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Private vault'**
  String get vaultTitle;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @todayQuickAddHint.
  ///
  /// In en, this message translates to:
  /// **'Quick add — e.g. 250 chai'**
  String get todayQuickAddHint;

  /// No description provided for @todayQuickAddPreview.
  ///
  /// In en, this message translates to:
  /// **'Will save: Rs {amount} · {category}'**
  String todayQuickAddPreview(String amount, String category);

  /// No description provided for @todayQuickAddNeedAmount.
  ///
  /// In en, this message translates to:
  /// **'Type an amount first, for example 250 chai'**
  String get todayQuickAddNeedAmount;

  /// No description provided for @todayQuickAdded.
  ///
  /// In en, this message translates to:
  /// **'Added Rs {amount} · {category}'**
  String todayQuickAdded(String amount, String category);

  /// No description provided for @todayQuickAddedIncome.
  ///
  /// In en, this message translates to:
  /// **'Income Rs {amount} added · {category}'**
  String todayQuickAddedIncome(String amount, String category);

  /// No description provided for @todayPrayers.
  ///
  /// In en, this message translates to:
  /// **'Today\'s prayers'**
  String get todayPrayers;

  /// No description provided for @todayNothingDue.
  ///
  /// In en, this message translates to:
  /// **'Nothing due today'**
  String get todayNothingDue;

  /// No description provided for @todaySeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get todaySeeAll;

  /// No description provided for @todayMoney.
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get todayMoney;

  /// No description provided for @todaySpentToday.
  ///
  /// In en, this message translates to:
  /// **'Spent today'**
  String get todaySpentToday;

  /// No description provided for @todaySpentMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get todaySpentMonth;

  /// No description provided for @todayBudgetLeft.
  ///
  /// In en, this message translates to:
  /// **'Budget left'**
  String get todayBudgetLeft;

  /// No description provided for @todayOverBudget.
  ///
  /// In en, this message translates to:
  /// **'Over budget'**
  String get todayOverBudget;

  /// No description provided for @todayComingUp.
  ///
  /// In en, this message translates to:
  /// **'Coming up'**
  String get todayComingUp;

  /// No description provided for @todayNothingComing.
  ///
  /// In en, this message translates to:
  /// **'Nothing coming up this week'**
  String get todayNothingComing;

  /// No description provided for @todayDueTheyOwe.
  ///
  /// In en, this message translates to:
  /// **'{name} owes you Rs {amount}'**
  String todayDueTheyOwe(String name, String amount);

  /// No description provided for @todayDueYouOwe.
  ///
  /// In en, this message translates to:
  /// **'You owe {name} Rs {amount}'**
  String todayDueYouOwe(String name, String amount);

  /// No description provided for @todayDueLate.
  ///
  /// In en, this message translates to:
  /// **'{days} days late'**
  String todayDueLate(String days);

  /// No description provided for @todayDueToday.
  ///
  /// In en, this message translates to:
  /// **'due today'**
  String get todayDueToday;

  /// No description provided for @todayDueTomorrow.
  ///
  /// In en, this message translates to:
  /// **'due tomorrow'**
  String get todayDueTomorrow;

  /// No description provided for @todayDueInDays.
  ///
  /// In en, this message translates to:
  /// **'due in {days} days'**
  String todayDueInDays(String days);

  /// No description provided for @todayRecurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring {what}: Rs {amount} on {date}'**
  String todayRecurring(String what, String amount, String date);

  /// No description provided for @todayBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Back up your data'**
  String get todayBackupTitle;

  /// No description provided for @todayBackupBody.
  ///
  /// In en, this message translates to:
  /// **'Share a copy so your data is safe if this phone is lost'**
  String get todayBackupBody;

  /// No description provided for @todayBackupNow.
  ///
  /// In en, this message translates to:
  /// **'Back up now'**
  String get todayBackupNow;

  /// No description provided for @todayLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get todayLater;

  /// No description provided for @toolRoza.
  ///
  /// In en, this message translates to:
  /// **'Roza'**
  String get toolRoza;

  /// No description provided for @toolGoals.
  ///
  /// In en, this message translates to:
  /// **'Savings goals'**
  String get toolGoals;

  /// No description provided for @toolAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get toolAccounts;

  /// No description provided for @rozaTitle.
  ///
  /// In en, this message translates to:
  /// **'Roza'**
  String get rozaTitle;

  /// No description provided for @rozaOwed.
  ///
  /// In en, this message translates to:
  /// **'Fasts to make up: {count}'**
  String rozaOwed(String count);

  /// No description provided for @rozaHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a day to mark it kept, missed, or clear it'**
  String get rozaHint;

  /// No description provided for @rozaKept.
  ///
  /// In en, this message translates to:
  /// **'Kept'**
  String get rozaKept;

  /// No description provided for @rozaMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get rozaMissed;

  /// No description provided for @rozaMadeUp.
  ///
  /// In en, this message translates to:
  /// **'Made up'**
  String get rozaMadeUp;

  /// No description provided for @rozaMakeUpToday.
  ///
  /// In en, this message translates to:
  /// **'I fasted today to make up one'**
  String get rozaMakeUpToday;

  /// No description provided for @rozaKeptThisYear.
  ///
  /// In en, this message translates to:
  /// **'Kept this year: {count}'**
  String rozaKeptThisYear(String count);

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @goalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Savings goals'**
  String get goalsTitle;

  /// No description provided for @goalsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No goals yet. Add one, like Hajj, a wedding or a car.'**
  String get goalsEmpty;

  /// No description provided for @goalAdd.
  ///
  /// In en, this message translates to:
  /// **'New goal'**
  String get goalAdd;

  /// No description provided for @goalName.
  ///
  /// In en, this message translates to:
  /// **'Goal name'**
  String get goalName;

  /// No description provided for @goalTarget.
  ///
  /// In en, this message translates to:
  /// **'Target amount'**
  String get goalTarget;

  /// No description provided for @goalDeadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline (optional)'**
  String get goalDeadline;

  /// No description provided for @goalAddMoney.
  ///
  /// In en, this message translates to:
  /// **'Add money'**
  String get goalAddMoney;

  /// No description provided for @goalTakeOut.
  ///
  /// In en, this message translates to:
  /// **'Take money out'**
  String get goalTakeOut;

  /// No description provided for @goalAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get goalAmount;

  /// No description provided for @goalSaved.
  ///
  /// In en, this message translates to:
  /// **'Rs {saved} of Rs {target}'**
  String goalSaved(String saved, String target);

  /// No description provided for @goalReached.
  ///
  /// In en, this message translates to:
  /// **'Goal reached!'**
  String get goalReached;

  /// No description provided for @goalPerMonth.
  ///
  /// In en, this message translates to:
  /// **'Save about Rs {amount} a month to reach it by {date}'**
  String goalPerMonth(String amount, String date);

  /// No description provided for @goalDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this goal?'**
  String get goalDeleteConfirm;

  /// No description provided for @accountsTitle.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accountsTitle;

  /// No description provided for @accountsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add the places your money is kept: cash, bank, wallet.'**
  String get accountsEmpty;

  /// No description provided for @accountAdd.
  ///
  /// In en, this message translates to:
  /// **'New account'**
  String get accountAdd;

  /// No description provided for @accountName.
  ///
  /// In en, this message translates to:
  /// **'Account name'**
  String get accountName;

  /// No description provided for @accountCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get accountCash;

  /// No description provided for @accountBank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get accountBank;

  /// No description provided for @accountWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get accountWallet;

  /// No description provided for @accountOpening.
  ///
  /// In en, this message translates to:
  /// **'Opening balance'**
  String get accountOpening;

  /// No description provided for @accountTotal.
  ///
  /// In en, this message translates to:
  /// **'Total across accounts'**
  String get accountTotal;

  /// No description provided for @accountDeleteWarn.
  ///
  /// In en, this message translates to:
  /// **'Entries stay, but are no longer linked to this account.'**
  String get accountDeleteWarn;

  /// No description provided for @accountPick.
  ///
  /// In en, this message translates to:
  /// **'Account (optional)'**
  String get accountPick;

  /// No description provided for @accountNone.
  ///
  /// In en, this message translates to:
  /// **'No account'**
  String get accountNone;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @taskRemindBefore.
  ///
  /// In en, this message translates to:
  /// **'Remind me before'**
  String get taskRemindBefore;

  /// No description provided for @taskRemindNone.
  ///
  /// In en, this message translates to:
  /// **'Only at the time'**
  String get taskRemindNone;

  /// No description provided for @taskRemindMin.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes before'**
  String taskRemindMin(String minutes);

  /// No description provided for @taskRemindHour.
  ///
  /// In en, this message translates to:
  /// **'1 hour before'**
  String get taskRemindHour;

  /// No description provided for @taskRemindDay.
  ///
  /// In en, this message translates to:
  /// **'1 day before'**
  String get taskRemindDay;

  /// No description provided for @taskAtTime.
  ///
  /// In en, this message translates to:
  /// **'At a time'**
  String get taskAtTime;

  /// No description provided for @taskAroundPrayer.
  ///
  /// In en, this message translates to:
  /// **'Around a prayer'**
  String get taskAroundPrayer;

  /// No description provided for @taskOffsetBefore.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min before'**
  String taskOffsetBefore(String minutes);

  /// No description provided for @taskOffsetAfter.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min after'**
  String taskOffsetAfter(String minutes);

  /// No description provided for @taskOffsetAt.
  ///
  /// In en, this message translates to:
  /// **'At prayer time'**
  String get taskOffsetAt;

  /// No description provided for @taskBillAmount.
  ///
  /// In en, this message translates to:
  /// **'Bill amount (optional)'**
  String get taskBillAmount;

  /// No description provided for @taskAddToKhataTitle.
  ///
  /// In en, this message translates to:
  /// **'Add to Khata?'**
  String get taskAddToKhataTitle;

  /// No description provided for @taskAddToKhataBody.
  ///
  /// In en, this message translates to:
  /// **'Add Rs {amount} for \"{title}\" to your Khata?'**
  String taskAddToKhataBody(String amount, String title);

  /// No description provided for @taskBillAdded.
  ///
  /// In en, this message translates to:
  /// **'Added to Khata'**
  String get taskBillAdded;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @udhaarSortAmount.
  ///
  /// In en, this message translates to:
  /// **'Biggest amount first'**
  String get udhaarSortAmount;

  /// No description provided for @settingsDataBackup.
  ///
  /// In en, this message translates to:
  /// **'Data & Backup'**
  String get settingsDataBackup;

  /// No description provided for @backupExport.
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get backupExport;

  /// No description provided for @backupExportSub.
  ///
  /// In en, this message translates to:
  /// **'Share your data as a .saathi file'**
  String get backupExportSub;

  /// No description provided for @backupRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore backup'**
  String get backupRestore;

  /// No description provided for @backupRestoreSub.
  ///
  /// In en, this message translates to:
  /// **'Replace current data from a .saathi file'**
  String get backupRestoreSub;

  /// No description provided for @backupAuto.
  ///
  /// In en, this message translates to:
  /// **'Automatic backups'**
  String get backupAuto;

  /// No description provided for @backupAutoSub.
  ///
  /// In en, this message translates to:
  /// **'Saved on this phone every week. Last: {date}'**
  String backupAutoSub(String date);

  /// No description provided for @backupAutoNone.
  ///
  /// In en, this message translates to:
  /// **'Saved on this phone every week. None yet.'**
  String get backupAutoNone;

  /// No description provided for @settingsCountBank.
  ///
  /// In en, this message translates to:
  /// **'Count bank transactions in budgets'**
  String get settingsCountBank;

  /// No description provided for @settingsCountBankSub.
  ///
  /// In en, this message translates to:
  /// **'Payments caught from bank notifications count towards your budgets and totals'**
  String get settingsCountBankSub;

  /// No description provided for @trackerMonth.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get trackerMonth;

  /// No description provided for @trackerCompletion.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of prayers prayed'**
  String trackerCompletion(String percent);

  /// No description provided for @trackerWeakest.
  ///
  /// In en, this message translates to:
  /// **'Hardest prayer: {prayer} ({done} of {days} days)'**
  String trackerWeakest(String prayer, String done, String days);

  /// No description provided for @tasbeehFree.
  ///
  /// In en, this message translates to:
  /// **'Free count'**
  String get tasbeehFree;

  /// No description provided for @tasbeehSubhanallah.
  ///
  /// In en, this message translates to:
  /// **'SubhanAllah'**
  String get tasbeehSubhanallah;

  /// No description provided for @tasbeehAlhamdulillah.
  ///
  /// In en, this message translates to:
  /// **'Alhamdulillah'**
  String get tasbeehAlhamdulillah;

  /// No description provided for @tasbeehAllahuAkbar.
  ///
  /// In en, this message translates to:
  /// **'Allahu Akbar'**
  String get tasbeehAllahuAkbar;

  /// No description provided for @tasbeehToday.
  ///
  /// In en, this message translates to:
  /// **'Today: {count}'**
  String tasbeehToday(String count);

  /// No description provided for @tasbeehTargetReached.
  ///
  /// In en, this message translates to:
  /// **'Target reached'**
  String get tasbeehTargetReached;

  /// No description provided for @trendTitle.
  ///
  /// In en, this message translates to:
  /// **'Compared with last month'**
  String get trendTitle;

  /// No description provided for @trendMore.
  ///
  /// In en, this message translates to:
  /// **'Rs {amount} more than last month ({percent}%)'**
  String trendMore(String amount, String percent);

  /// No description provided for @trendLess.
  ///
  /// In en, this message translates to:
  /// **'Rs {amount} less than last month ({percent}%)'**
  String trendLess(String amount, String percent);

  /// No description provided for @trendMoreNoPercent.
  ///
  /// In en, this message translates to:
  /// **'Rs {amount} more than last month'**
  String trendMoreNoPercent(String amount);

  /// No description provided for @trendSame.
  ///
  /// In en, this message translates to:
  /// **'Same as last month'**
  String get trendSame;

  /// No description provided for @trendBiggestRise.
  ///
  /// In en, this message translates to:
  /// **'Biggest rise: {category} (+Rs {amount})'**
  String trendBiggestRise(String category, String amount);

  /// No description provided for @taskNewList.
  ///
  /// In en, this message translates to:
  /// **'New list'**
  String get taskNewList;

  /// No description provided for @taskEditList.
  ///
  /// In en, this message translates to:
  /// **'Edit list'**
  String get taskEditList;

  /// No description provided for @taskDeleteList.
  ///
  /// In en, this message translates to:
  /// **'Delete list'**
  String get taskDeleteList;

  /// No description provided for @taskTabToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get taskTabToday;

  /// No description provided for @taskTabUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get taskTabUpcoming;

  /// No description provided for @taskEmptyUpcoming.
  ///
  /// In en, this message translates to:
  /// **'No upcoming tasks'**
  String get taskEmptyUpcoming;

  /// No description provided for @taskEmptyDone.
  ///
  /// In en, this message translates to:
  /// **'Nothing completed yet'**
  String get taskEmptyDone;

  /// No description provided for @taskEmptyToday.
  ///
  /// In en, this message translates to:
  /// **'Nothing to do today — MashaAllah! 🎉'**
  String get taskEmptyToday;

  /// No description provided for @taskNoneToday.
  ///
  /// In en, this message translates to:
  /// **'No tasks for today'**
  String get taskNoneToday;

  /// No description provided for @taskTomorrowCount.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow ({count})'**
  String taskTomorrowCount(String count);

  /// No description provided for @taskOverdueCount.
  ///
  /// In en, this message translates to:
  /// **'Overdue ({count})'**
  String taskOverdueCount(String count);

  /// No description provided for @taskNew.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get taskNew;

  /// No description provided for @taskEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get taskEdit;

  /// No description provided for @taskDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete task?'**
  String get taskDeleteConfirm;

  /// No description provided for @taskReopen.
  ///
  /// In en, this message translates to:
  /// **'Reopen'**
  String get taskReopen;

  /// No description provided for @taskTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Task title'**
  String get taskTitleLabel;

  /// No description provided for @taskNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get taskNoteLabel;

  /// No description provided for @taskListLabel.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get taskListLabel;

  /// No description provided for @taskNoList.
  ///
  /// In en, this message translates to:
  /// **'No list'**
  String get taskNoList;

  /// No description provided for @taskPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority:'**
  String get taskPriority;

  /// No description provided for @taskPriorityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get taskPriorityNormal;

  /// No description provided for @taskPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get taskPriorityHigh;

  /// No description provided for @taskRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get taskRepeat;

  /// No description provided for @taskRepeatNone.
  ///
  /// In en, this message translates to:
  /// **'Does not repeat'**
  String get taskRepeatNone;

  /// No description provided for @taskRepeatDaily.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get taskRepeatDaily;

  /// No description provided for @taskRepeatWeekly.
  ///
  /// In en, this message translates to:
  /// **'Every week'**
  String get taskRepeatWeekly;

  /// No description provided for @taskRepeatMonthly.
  ///
  /// In en, this message translates to:
  /// **'Every month'**
  String get taskRepeatMonthly;

  /// No description provided for @taskDailyShort.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get taskDailyShort;

  /// No description provided for @taskWeeklyShort.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get taskWeeklyShort;

  /// No description provided for @taskMonthlyShort.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get taskMonthlyShort;

  /// No description provided for @taskNoDueDate.
  ///
  /// In en, this message translates to:
  /// **'No due date'**
  String get taskNoDueDate;

  /// No description provided for @taskNoTime.
  ///
  /// In en, this message translates to:
  /// **'No time (no notification)'**
  String get taskNoTime;

  /// No description provided for @taskListName.
  ///
  /// In en, this message translates to:
  /// **'List name'**
  String get taskListName;

  /// No description provided for @taskIcon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get taskIcon;

  /// No description provided for @taskCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get taskCreate;

  /// No description provided for @khataIncoming.
  ///
  /// In en, this message translates to:
  /// **'Incoming'**
  String get khataIncoming;

  /// No description provided for @khataOutgoing.
  ///
  /// In en, this message translates to:
  /// **'Outgoing'**
  String get khataOutgoing;

  /// No description provided for @khataExportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get khataExportPdf;

  /// No description provided for @khataExportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get khataExportCsv;

  /// No description provided for @khataBank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get khataBank;

  /// No description provided for @summaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly summary'**
  String get summaryTitle;

  /// No description provided for @khataSearchEntries.
  ///
  /// In en, this message translates to:
  /// **'Search entries…'**
  String get khataSearchEntries;

  /// No description provided for @recurringTitle.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get recurringTitle;

  /// No description provided for @khataShareWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Share via WhatsApp'**
  String get khataShareWhatsApp;

  /// No description provided for @vaultMove.
  ///
  /// In en, this message translates to:
  /// **'Move to Vault'**
  String get vaultMove;

  /// No description provided for @vaultMoveHint.
  ///
  /// In en, this message translates to:
  /// **'Hide from normal view'**
  String get vaultMoveHint;

  /// No description provided for @vaultMoveUdhaarHint.
  ///
  /// In en, this message translates to:
  /// **'Hide from normal Udhaar view'**
  String get vaultMoveUdhaarHint;

  /// No description provided for @bankSearch.
  ///
  /// In en, this message translates to:
  /// **'Search bank entries…'**
  String get bankSearch;

  /// No description provided for @bankIn.
  ///
  /// In en, this message translates to:
  /// **'In'**
  String get bankIn;

  /// No description provided for @bankOut.
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get bankOut;

  /// No description provided for @bankAllBanks.
  ///
  /// In en, this message translates to:
  /// **'All banks'**
  String get bankAllBanks;

  /// No description provided for @bankEmpty.
  ///
  /// In en, this message translates to:
  /// **'No bank transactions yet'**
  String get bankEmpty;

  /// No description provided for @bankNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No matching transactions'**
  String get bankNoMatch;

  /// No description provided for @bankAutoCaptured.
  ///
  /// In en, this message translates to:
  /// **'Auto-captured from bank notifications'**
  String get bankAutoCaptured;

  /// No description provided for @entryDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete entry'**
  String get entryDelete;

  /// No description provided for @vaultUnlockReason.
  ///
  /// In en, this message translates to:
  /// **'Unlock your Vault to view private entries'**
  String get vaultUnlockReason;

  /// No description provided for @vaultUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get vaultUnlock;

  /// No description provided for @vaultLock.
  ///
  /// In en, this message translates to:
  /// **'Lock vault'**
  String get vaultLock;

  /// No description provided for @vaultTabContacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get vaultTabContacts;

  /// No description provided for @vaultRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove from Vault'**
  String get vaultRemove;

  /// No description provided for @vaultDeleteContact.
  ///
  /// In en, this message translates to:
  /// **'Delete contact'**
  String get vaultDeleteContact;

  /// No description provided for @vaultDeleteContactQ.
  ///
  /// In en, this message translates to:
  /// **'Delete contact?'**
  String get vaultDeleteContactQ;

  /// No description provided for @freqDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get freqDaily;

  /// No description provided for @freqWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get freqWeekly;

  /// No description provided for @freqMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get freqMonthly;

  /// No description provided for @freqYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get freqYearly;

  /// No description provided for @summaryNet.
  ///
  /// In en, this message translates to:
  /// **'Net balance'**
  String get summaryNet;

  /// No description provided for @summaryByCategory.
  ///
  /// In en, this message translates to:
  /// **'Spending by category'**
  String get summaryByCategory;

  /// No description provided for @summaryNoExpenses.
  ///
  /// In en, this message translates to:
  /// **'No expenses this month'**
  String get summaryNoExpenses;

  /// No description provided for @recurringEmpty.
  ///
  /// In en, this message translates to:
  /// **'No recurring entries'**
  String get recurringEmpty;

  /// No description provided for @recurringEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Turn on \"Repeat\" when adding an expense or income'**
  String get recurringEmptyHint;

  /// No description provided for @recurringStopQ.
  ///
  /// In en, this message translates to:
  /// **'Stop recurring?'**
  String get recurringStopQ;

  /// No description provided for @recurringStopNote.
  ///
  /// In en, this message translates to:
  /// **'This will not delete past entries.'**
  String get recurringStopNote;

  /// No description provided for @recurringStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get recurringStop;

  /// No description provided for @expensePhotoTake.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get expensePhotoTake;

  /// No description provided for @expensePhotoGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get expensePhotoGallery;

  /// No description provided for @expenseSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get expenseSource;

  /// No description provided for @expenseRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get expenseRepeat;

  /// No description provided for @bankSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'Bank sync'**
  String get bankSyncTitle;

  /// No description provided for @bankSyncAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto-capture transactions'**
  String get bankSyncAuto;

  /// No description provided for @bankSyncChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get bankSyncChecking;

  /// No description provided for @bankSyncEnableHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to enable — no login needed, works with all bank apps'**
  String get bankSyncEnableHint;

  /// No description provided for @bankSyncEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get bankSyncEnable;

  /// No description provided for @bankSyncPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused by Android — transactions are not being captured'**
  String get bankSyncPaused;

  /// No description provided for @bankSyncRestart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get bankSyncRestart;

  /// No description provided for @bankSyncWaiting.
  ///
  /// In en, this message translates to:
  /// **'Active — waiting for the first bank alert'**
  String get bankSyncWaiting;

  /// No description provided for @bankSyncLast.
  ///
  /// In en, this message translates to:
  /// **'Active — last bank alert {ago}'**
  String bankSyncLast(String ago);

  /// No description provided for @bankSyncPending.
  ///
  /// In en, this message translates to:
  /// **'{count} waiting to be saved'**
  String bankSyncPending(String count);

  /// No description provided for @bankSyncRestartHint.
  ///
  /// In en, this message translates to:
  /// **'Turn Saathi off and on again in Notification access'**
  String get bankSyncRestartHint;

  /// No description provided for @agoJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get agoJustNow;

  /// No description provided for @agoMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String agoMinutes(String count);

  /// No description provided for @agoHours.
  ///
  /// In en, this message translates to:
  /// **'{count} h ago'**
  String agoHours(String count);

  /// No description provided for @agoDays.
  ///
  /// In en, this message translates to:
  /// **'{count} d ago'**
  String agoDays(String count);

  /// No description provided for @ramadanMubarak.
  ///
  /// In en, this message translates to:
  /// **'Ramadan Mubarak'**
  String get ramadanMubarak;

  /// No description provided for @ramadanTimetable.
  ///
  /// In en, this message translates to:
  /// **'Ramadan timetable'**
  String get ramadanTimetable;

  /// No description provided for @ramadanLabel.
  ///
  /// In en, this message translates to:
  /// **'Ramadan'**
  String get ramadanLabel;

  /// No description provided for @ramadanSehriEnded.
  ///
  /// In en, this message translates to:
  /// **'Sehri has ended'**
  String get ramadanSehriEnded;

  /// No description provided for @ramadanSehriEndsIn.
  ///
  /// In en, this message translates to:
  /// **'Sehri ends in {time}'**
  String ramadanSehriEndsIn(String time);

  /// No description provided for @ramadanStopEating.
  ///
  /// In en, this message translates to:
  /// **'Stop eating before Fajr'**
  String get ramadanStopEating;

  /// No description provided for @ramadanIftarIn.
  ///
  /// In en, this message translates to:
  /// **'Iftar in {time}'**
  String ramadanIftarIn(String time);

  /// No description provided for @ramadanKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep going! 💪'**
  String get ramadanKeepGoing;

  /// No description provided for @ramadanIftarTime.
  ///
  /// In en, this message translates to:
  /// **'Iftar time! 🎉'**
  String get ramadanIftarTime;

  /// No description provided for @ramadanSehriIn.
  ///
  /// In en, this message translates to:
  /// **'Sehri in {time}'**
  String ramadanSehriIn(String time);

  /// No description provided for @ramadanEnjoy.
  ///
  /// In en, this message translates to:
  /// **'Enjoy your meal'**
  String get ramadanEnjoy;

  /// No description provided for @ramadanAlhamdulillah.
  ///
  /// In en, this message translates to:
  /// **'Alhamdulillah'**
  String get ramadanAlhamdulillah;

  /// No description provided for @ramadanSehriEndsSuffix.
  ///
  /// In en, this message translates to:
  /// **' · Sehri ends'**
  String get ramadanSehriEndsSuffix;

  /// No description provided for @ramadanIftarSuffix.
  ///
  /// In en, this message translates to:
  /// **' · Iftar'**
  String get ramadanIftarSuffix;

  /// No description provided for @imsakiyaTitle.
  ///
  /// In en, this message translates to:
  /// **'Ramadan timetable'**
  String get imsakiyaTitle;

  /// No description provided for @imsakiyaShareFail.
  ///
  /// In en, this message translates to:
  /// **'Could not share the timetable'**
  String get imsakiyaShareFail;

  /// No description provided for @imsakiyaNoDates.
  ///
  /// In en, this message translates to:
  /// **'Could not compute Ramadan dates'**
  String get imsakiyaNoDates;

  /// No description provided for @imsakiyaShare.
  ///
  /// In en, this message translates to:
  /// **'Share as image'**
  String get imsakiyaShare;

  /// No description provided for @imsakiyaDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get imsakiyaDay;

  /// No description provided for @imsakiyaDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get imsakiyaDate;

  /// No description provided for @imsakiyaSehri.
  ///
  /// In en, this message translates to:
  /// **'Sehri ends'**
  String get imsakiyaSehri;

  /// No description provided for @imsakiyaIftar.
  ///
  /// In en, this message translates to:
  /// **'Iftar'**
  String get imsakiyaIftar;

  /// No description provided for @backupFailed.
  ///
  /// In en, this message translates to:
  /// **'Backup failed: {error}'**
  String backupFailed(String error);

  /// No description provided for @backupNoAccess.
  ///
  /// In en, this message translates to:
  /// **'Could not access the selected file.'**
  String get backupNoAccess;

  /// No description provided for @backupIncomplete.
  ///
  /// In en, this message translates to:
  /// **'This file is not a complete Saathi backup.'**
  String get backupIncomplete;

  /// No description provided for @backupNotSaathi.
  ///
  /// In en, this message translates to:
  /// **'This file is not a Saathi backup.'**
  String get backupNotSaathi;

  /// No description provided for @backupNewer.
  ///
  /// In en, this message translates to:
  /// **'This backup is from a newer version of Saathi. Update the app first.'**
  String get backupNewer;

  /// No description provided for @backupDamaged.
  ///
  /// In en, this message translates to:
  /// **'This backup file is damaged.'**
  String get backupDamaged;

  /// No description provided for @backupOlder.
  ///
  /// In en, this message translates to:
  /// **'an older backup'**
  String get backupOlder;

  /// No description provided for @restoreConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore backup?'**
  String get restoreConfirmTitle;

  /// No description provided for @restoreConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This replaces ALL current data with {when}.\n\nA safety copy of your current data is kept on this phone. Saathi will close afterwards; open it again to continue.'**
  String restoreConfirmBody(String when);

  /// No description provided for @restoreButton.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restoreButton;

  /// No description provided for @restoreDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup restored'**
  String get restoreDoneTitle;

  /// No description provided for @restoreDoneBody.
  ///
  /// In en, this message translates to:
  /// **'Saathi will close now. Open it again to see your data.'**
  String get restoreDoneBody;

  /// No description provided for @restoreFailedKept.
  ///
  /// In en, this message translates to:
  /// **'Restore failed: {error}. Close and reopen Saathi; a safety copy of your data was kept.'**
  String restoreFailedKept(String error);

  /// No description provided for @restoreFailedSafe.
  ///
  /// In en, this message translates to:
  /// **'Restore failed: {error}. Your data was not changed.'**
  String restoreFailedSafe(String error);

  /// No description provided for @khataIncludesBank.
  ///
  /// In en, this message translates to:
  /// **'Totals include bank transactions (see the Bank tab)'**
  String get khataIncludesBank;

  /// No description provided for @categoryNew.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get categoryNew;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryName;

  /// No description provided for @categoryPickIcon.
  ///
  /// In en, this message translates to:
  /// **'Pick an icon'**
  String get categoryPickIcon;

  /// No description provided for @categoryNameTaken.
  ///
  /// In en, this message translates to:
  /// **'That name is already used'**
  String get categoryNameTaken;

  /// No description provided for @categoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'My categories'**
  String get categoriesTitle;

  /// No description provided for @categoriesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No categories of your own yet. Add one, like Groceries or Mobile load.'**
  String get categoriesEmpty;

  /// No description provided for @categoryDeleteQ.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String categoryDeleteQ(String name);

  /// No description provided for @categoryDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Entries in this category move to Other. No amount is lost.'**
  String get categoryDeleteBody;

  /// No description provided for @categoriesManage.
  ///
  /// In en, this message translates to:
  /// **'Manage categories'**
  String get categoriesManage;

  /// No description provided for @reviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly review'**
  String get reviewTitle;

  /// No description provided for @reviewRange.
  ///
  /// In en, this message translates to:
  /// **'{from} – {to}'**
  String reviewRange(String from, String to);

  /// No description provided for @reviewSpent.
  ///
  /// In en, this message translates to:
  /// **'Spent Rs {amount}'**
  String reviewSpent(String amount);

  /// No description provided for @reviewMoreThanBefore.
  ///
  /// In en, this message translates to:
  /// **'Rs {amount} more than the week before ({percent}%)'**
  String reviewMoreThanBefore(String amount, String percent);

  /// No description provided for @reviewLessThanBefore.
  ///
  /// In en, this message translates to:
  /// **'Rs {amount} less than the week before ({percent}%)'**
  String reviewLessThanBefore(String amount, String percent);

  /// No description provided for @reviewMoreNoPercent.
  ///
  /// In en, this message translates to:
  /// **'Rs {amount} more than the week before'**
  String reviewMoreNoPercent(String amount);

  /// No description provided for @reviewSameAsBefore.
  ///
  /// In en, this message translates to:
  /// **'Same as the week before'**
  String get reviewSameAsBefore;

  /// No description provided for @reviewPrayers.
  ///
  /// In en, this message translates to:
  /// **'Prayers'**
  String get reviewPrayers;

  /// No description provided for @reviewPrayed.
  ///
  /// In en, this message translates to:
  /// **'Prayed {done} of {total}'**
  String reviewPrayed(String done, String total);

  /// No description provided for @reviewTasksDone.
  ///
  /// In en, this message translates to:
  /// **'{count} finished'**
  String reviewTasksDone(String count);

  /// No description provided for @reviewTasksOverdue.
  ///
  /// In en, this message translates to:
  /// **'{count} overdue'**
  String reviewTasksOverdue(String count);

  /// No description provided for @reviewNoOverdue.
  ///
  /// In en, this message translates to:
  /// **'Nothing overdue 🎉'**
  String get reviewNoOverdue;

  /// No description provided for @reviewFastsKept.
  ///
  /// In en, this message translates to:
  /// **'Kept {kept}, missed {missed}'**
  String reviewFastsKept(String kept, String missed);

  /// No description provided for @reviewDebts.
  ///
  /// In en, this message translates to:
  /// **'Money lent and owed'**
  String get reviewDebts;

  /// No description provided for @reviewOwedToMe.
  ///
  /// In en, this message translates to:
  /// **'Owed to you: Rs {amount}'**
  String reviewOwedToMe(String amount);

  /// No description provided for @reviewIOwe.
  ///
  /// In en, this message translates to:
  /// **'You owe: Rs {amount}'**
  String reviewIOwe(String amount);

  /// No description provided for @reviewEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing recorded in this period yet. Use Saathi for a week and come back.'**
  String get reviewEmpty;

  /// No description provided for @reviewNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'Your weekly review is ready'**
  String get reviewNotifTitle;

  /// No description provided for @reviewNotifBody.
  ///
  /// In en, this message translates to:
  /// **'Tap to see how your week went'**
  String get reviewNotifBody;

  /// No description provided for @reviewSettingSub.
  ///
  /// In en, this message translates to:
  /// **'A reminder to look back at your week'**
  String get reviewSettingSub;

  /// No description provided for @reviewSettingOn.
  ///
  /// In en, this message translates to:
  /// **'{day} at {time}'**
  String reviewSettingOn(String day, String time);

  /// No description provided for @reviewDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get reviewDay;

  /// No description provided for @reviewTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get reviewTime;

  /// No description provided for @reviewOpen.
  ///
  /// In en, this message translates to:
  /// **'Open the review'**
  String get reviewOpen;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'en':
      {
        switch (locale.countryCode) {
          case 'PK':
            return AppLocalizationsEnPk();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
