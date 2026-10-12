# Changelog

## v0.1.0 — Azan feature

First release.

### Added
- Prayer times for Fajr, Sunrise, Dhuhr (Jumma on Fridays), Asr, Maghrib and Isha,
  calculated offline with `adhan_dart`. Checked against AlAdhan within one minute
  for Karachi, Makkah and high-latitude London.
- Calculation methods and madhab chosen automatically per country, with a manual
  override that always wins. High-latitude rule, per-prayer "masjid time" adjustment
  and a Hijri moon-sighting correction.
- Azan notifications scheduled for the next days (never more than 60 pending), with
  one notification channel per sound, optional pre-prayer reminders, exact alarms
  with an inexact fallback and a banner, and re-scheduling on start, resume,
  settings change, location change, reboot and daily in the background.
- Home screen with Hijri and Gregorian dates, a live next-prayer countdown that
  pauses when the app is hidden, a prayed checkbox per prayer, per-prayer azan
  switches and a tasbeeh counter.
- Monthly timetable with share-as-image.
- Qibla compass with a text bearing fallback when there is no compass sensor.
- Settings for location, method, madhab, sound with preview, reminders, Hijri
  adjustment, language and a 10-second test notification.
- First-run onboarding for language, location, notifications and exact alarms, with
  a manual city list when location is denied.
- Battery guide for phones that kill background apps.
- English, Urdu (right to left) and Roman Urdu.
- Follow-me location: recalculates when you move more than 50 km.
- Local storage with Drift for the prayed log and the settings history.

### Notes
- The azan sounds are placeholder tones; see the README to add real recordings.
- `flutter_qiblah` and `flutter_compass_v2` are vendored with a Gradle fix.
- `permission_handler` is pinned to 12.0.3.
