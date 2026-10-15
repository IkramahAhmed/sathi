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
