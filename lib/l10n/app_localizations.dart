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
