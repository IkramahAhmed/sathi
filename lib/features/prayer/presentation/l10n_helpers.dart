import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/tz_utils.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/entities/calc_method.dart';
import '../domain/entities/prayer_name.dart';

/// Maps a settings locale tag (`en`, `ur`, `en_PK`) to a [Locale].
Locale localeFromTag(String tag) => switch (tag) {
      'ur' => const Locale('ur'),
      'en_PK' => const Locale('en', 'PK'),
      _ => const Locale('en'),
    };

/// The `intl` date locale to use. Roman Urdu uses English date symbols.
String dateLocale(Locale locale) => locale.languageCode == 'ur' ? 'ur' : 'en';

String prayerLabel(AppLocalizations l10n, PrayerName prayer, {bool jumma = false}) => switch (prayer) {
      PrayerName.fajr => l10n.prayerFajr,
      PrayerName.sunrise => l10n.prayerSunrise,
      PrayerName.dhuhr => jumma ? l10n.prayerJumma : l10n.prayerDhuhr,
      PrayerName.asr => l10n.prayerAsr,
      PrayerName.maghrib => l10n.prayerMaghrib,
      PrayerName.isha => l10n.prayerIsha,
    };

String soundLabel(AppLocalizations l10n, AzanSound sound) => switch (sound) {
      AzanSound.beep => l10n.soundBeep,
      AzanSound.full => l10n.soundFull,
      AzanSound.short => l10n.soundShort,
      AzanSound.silent => l10n.soundSilent,
    };

String madhabLabel(AppLocalizations l10n, Madhab madhab) =>
    madhab == Madhab.hanafi ? l10n.madhabHanafi : l10n.madhabShafi;

String highLatLabel(AppLocalizations l10n, HighLatitudeRule rule) => switch (rule) {
      HighLatitudeRule.middleOfTheNight => l10n.highLatMiddle,
      HighLatitudeRule.seventhOfTheNight => l10n.highLatSeventh,
      HighLatitudeRule.twilightAngle => l10n.highLatAngle,
    };

/// Wall-clock time such as `5:13 AM` for [instant] in [timezoneId].
String formatClock(DateTime instant, String timezoneId, Locale locale) =>
    DateFormat('h:mm a', dateLocale(locale)).format(toZoned(instant, timezoneId));

/// A short human duration: `1 h 05 min`, `23 min` or `40 s`.
String humanDuration(AppLocalizations l10n, Duration d) {
  final total = d.isNegative ? Duration.zero : d;
  if (total.inHours >= 1) {
    return l10n.durationHoursMinutes(total.inHours, total.inMinutes % 60);
  }
  if (total.inMinutes >= 1) return l10n.durationMinutes(total.inMinutes);
  return l10n.durationSeconds(total.inSeconds);
}

/// `HH:MM:SS` for the big countdown.
String clockDuration(Duration d) {
  final total = d.isNegative ? Duration.zero : d;
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(total.inHours)}:${two(total.inMinutes % 60)}:${two(total.inSeconds % 60)}';
}
