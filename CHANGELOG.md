# Changelog

## v0.3.0 - Daily habit tools

### Added
- **Tracker tab.** Tick prayers for today or edit past days. Current and best streaks, a week
  strip, and a pause for illness or a woman's period so those days never count as missed.
- **Qaza tracker.** Missed prayers are counted per prayer, with a starting balance (or an
  estimate from years), make-up buttons, a history, and optional automatic counting from today.
- **Jama'at times.** Set minutes after the azan or a fixed time per prayer, plus a Friday time.
  Shown on Home. Optional "time to leave" reminder before jama'at.
- **Silent during jama'at (Android).** The phone goes to alarms only for the chosen minutes and
  returns afterwards. Needs Do Not Disturb access, which the app asks for. A phone already in
  Do Not Disturb is never touched.
- **Prayer time ending reminders.** Before a prayer's time ends, and repeated until it is done.
  Choose the first reminder, the repeat gap and which prayers. Buttons on the notification:
  Prayed or Take photo, and Stop reminders.
- **Photo proof (optional).** With it on, only a photo of the prayer place stops the reminders.
  The photo is checked on the phone with Google ML Kit, is never saved or sent, and a
  "Stop reminding me" button is always there. This is a nudge, not proof that a prayer happened.
- **Azan on the alarm volume.** Heard in silent mode and not tied to the media volume.
- **Check my setup** screen: notifications, exact alarms, battery, azan sound and the number of
  scheduled alerts, each with a fix button, plus a test azan.
- **Home-screen widget** with the next prayer and a live countdown.

### Changed
- A new app icon: a mosque with a gold crescent on green, with an Android adaptive and themed version.
- Release builds are signed with a proper upload key. Phones that have an earlier Saathi build
  must uninstall it first, because the signature changed.
- The local database is now version 3 (pauses and qaza tables). Existing data is kept.
- Android gains a small local plugin, `packages/saathi_native`, for Do Not Disturb and the widget.

## v0.2.0 - Cloud backup

### Added
- Optional cloud backup of the prayed log to a free Neon database through the new
  `saathi-api` service. Off by default; the app is unchanged without it.
- Sync key created on the phone and stored in the Android Keystore. Use the same key on a
  second phone to share the log. Settings has the key (hidden until shown), copy, restore
  from another phone, server address, "Sync now" with plain-language status, and
  "Delete my cloud data".
- Last-write-wins merging. Un-ticking is kept as a marker so it reaches other phones.
- Uploads a few seconds after a tick, on start and on resume. Works offline: changes queue.
- The local database is upgraded to version 2 automatically; existing ticks upload on the
  first sync.

### Fixed
- Release builds showed a blank screen: the resource shrinker removed the notification icon,
  which the app only references by name. The icon and sounds are now kept, and a
  notification problem can no longer stop the app from opening.
- Release builds had no internet permission.

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
- Real azan audio: one CC BY-SA 4.0 recording, as a full version (Android) and a
  short version under 30 seconds (also used on iOS). See `AZAN_AUDIO_LICENSE.md`.
  The sound options are Beep, Azan (full), Azan (short) and Silent.
- Settings saved with the earlier placeholder sound names are migrated; the old
  notification channels are deleted on start.
- `flutter_qiblah` and `flutter_compass_v2` are vendored with a Gradle fix.
- `permission_handler` is pinned to 12.0.3.
