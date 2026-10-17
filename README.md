# Saathi

A personal daily-life assistant for Pakistani users. **v0.1.0 ships the Azan
feature**: accurate prayer times, an azan notification at every prayer, a
monthly timetable, a Qibla compass and a tasbeeh counter. It works fully
offline after the first location is chosen. No ads, no analytics.

- Package id: `com.ikramah.saathi`
- Android first (min SDK 24, target SDK 35), written to be iOS-safe
- Flutter (stable) and Dart 3, null-safe
- Languages: English, Urdu (RTL) and Roman Urdu

## Setup

```bash
flutter pub get
flutter run
```

Generated files (freezed, drift, riverpod, localisations) are committed. After you
change annotated code or the translations, regenerate them:

```bash
dart run build_runner build --delete-conflicting-outputs
python3 tool/gen_arb.py && flutter gen-l10n   # edit strings in tool/gen_arb.py
```

Run the checks:

```bash
flutter analyze   # must stay at zero issues
flutter test
```

Build requirements: JDK 17, Android SDK platform 35 and 36, and an emulator or a
phone. `flutter doctor` tells you what is missing.

## How it works

Clean architecture with Riverpod. `domain/` is pure Dart with no Flutter imports.

```
lib/
  app/                 MaterialApp, router, theme, dependency wiring, headless reschedule
  core/
    notifications/     NotificationScheduler interface + flutter_local_notifications impl
    location/          LocationService, bundled city list
    background/        WorkManager daily re-schedule
    storage/           Drift database (prayer logs, settings history)
    utils/             Result<T>, logger, timezone helpers
  features/prayer/
    domain/            entities, repository interfaces, use cases
    data/              AdhanCalculator (adhan_dart), settings storage, repositories
    presentation/      providers, screens, widgets
```

Every use case returns `Result<T>` and never throws to the UI.

### The scheduling algorithm

`ScheduleUpcomingAzans` cancels everything, then schedules the next days of azans.
It counts notifications per day (azans plus pre-reminders) and schedules
`min(10, 60 / perDay)` days, so the total never exceeds 60 pending (iOS keeps 64).
Ids are deterministic: `(dayOfYear * 10 + prayerIndex) * 2 + (pre ? 1 : 0)`.

It runs on app start, on every resume, when settings or location change, after a
reboot (the plugin's boot receiver) and daily through WorkManager. The background
run is best effort; the foreground triggers are what keep it reliable.

Without the exact-alarm permission it falls back to inexact alarms and the Home
screen shows a banner.

## Release signing and the app icon

- The upload keystore is `~/Documents/saathi-keys/saathi-upload.jks`, outside the repository. Its
  passwords are in `android/key.properties`, which git ignores. Without that file the release build
  falls back to the debug key.
- **Back up the keystore and `key.properties` somewhere safe.** Enrol in Play App Signing when you
  create the app, so Google holds the real signing key and a lost upload key can be reset.
- Build for the Play Store with `flutter build appbundle --release`. For sharing with friends,
  `flutter build apk --release --split-per-abi` gives a 40 MB arm64 file.
- The icon is drawn by `tool/make_icon.py` (Pillow). Run it to rewrite the Android adaptive icon,
  the themed (monochrome) icon, the iOS set, `assets/icon/icon.png` and `store/play-icon-512.png`.

## Habit tools

- **Tracker, Qaza, pauses, streaks:** `features/prayer/domain/entities/streaks.dart`,
  `pause_range.dart`, `data/qaza/qaza_service.dart`. Missed prayers are counted by an idempotent
  reconcile that runs on start and after edits.
- **Ending reminders:** `entities/end_reminder.dart` plans the times; `schedule_upcoming_azans.dart`
  schedules today and tomorrow only. Notification buttons are handled by
  `usecases/handle_reminder_action.dart`, in the app and in a background isolate.
- **Photo proof:** `presentation/screens/verify_screen.dart`. `domain/repositories/photo_verifier.dart`
  holds the label rule (one strong label such as mosque, or two supporting ones such as carpet and
  pattern). `data/verification/mlkit_photo_verifier.dart` runs ML Kit on the phone.
- **Silent during jama'at and the widget:** `usecases/sync_native_state.dart` plans windows and the
  widget data and sends them over a channel to `packages/saathi_native` (Kotlin).

## Azan sounds

| Option | File | Notes |
|---|---|---|
| Beep | `azan_beep.wav` | A generated three-beep tone (`tool/generate_beep.py`). |
| Azan (full) | `azan_full.mp3` | A real azan recording, 86 seconds, **unchanged**. Android only. |
| Azan (short) | `azan_short.wav` / `.caf` | The opening 27 seconds of the same recording, cut at a natural pause with a fade-out. iOS plays this one, because iOS limits notification sounds to 30 seconds. |
| Silent | none | |

The recording is **CC BY-SA 4.0** and must be credited. The credit is in
`AZAN_AUDIO_LICENSE.md` and in the app under Settings, "Audio credits". The short
version is an adaptation, so it is shared under the same license.

**No Makkah or Madinah Haram recording is bundled**, because those are not freely
licensed. If you add your own recordings:

1. Make sure you have the rights, then add them to `AZAN_AUDIO_LICENSE.md`.
2. Put the file in `android/app/src/main/res/raw/` (`.mp3`, `.wav` or `.ogg`;
   lowercase letters, digits and `_` only). For iOS, convert to `.caf`
   (`afconvert -f caff -d LEI16 in.wav out.caf`), keep it under 30 seconds and add it
   to the Runner target in Xcode.
3. **Android caches a channel's sound for good.** Never change a sound on an existing
   channel. Add a new `AzanSound` value (which creates a new channel id) and list the
   old id in `NotificationChannels.legacyChannelIds` so it is deleted on start.
4. Add the label in `l10n_helpers.dart` and the strings in `tool/gen_arb.py`.

To rebuild the short clip from the full one: `python3 tool/make_short_azan.py azan_full.mp3`.

## Cloud backup (optional)

The prayed log can be backed up to the cloud and shared between your phones. It is
**off by default**, and the app works fully without it.

- **Where it goes:** a small API ([`saathi-api`](../saathi-api), its own project) that stores
  the data in a free Neon Postgres database. The app never connects to the database itself,
  so no database password is ever inside the app.
- **No account:** turning it on creates a random 256-bit **sync key**, kept in the Android
  Keystore. Type the same key into a second phone (Settings, Cloud backup, "Use a key from
  another phone") and both phones share one log. Anyone with the key can read that log.
- **Offline first:** Drift stays the source of truth. Ticks are saved locally and queued;
  they upload a few seconds after you tick, on app start and resume, or with "Sync now".
  Offline simply means "later", and nothing is lost.
- **Conflicts:** the newest edit wins. Un-ticking is kept as a marker so it syncs too.
- **Privacy:** only the date, the prayer, ticked or not, and the time of the change are sent.
  Location and settings never leave the phone. "Delete my cloud data" erases the cloud copy.

To use it, deploy the API and enter its address in the app. The steps are in
`../saathi-api/README.md`. You can also bake the address in at build time:

```bash
flutter run --release --dart-define=SAATHI_API_URL=https://saathi-api.you.workers.dev
```

Release builds only talk to `https://` addresses. Debug builds also allow `http://`, so you can
try it against the local dev server (`npm run dev` in `saathi-api`; the emulator reaches it at
`http://10.0.2.2:8787`).

The sync tests run against fakes by default. To also test against a real running server:

```bash
SAATHI_E2E_URL=http://localhost:8787 flutter test test/e2e
```

## Testing notifications

- **In the app:** Settings, then "Test notification in 10 s". With exact alarms
  allowed it uses the real alarm pipeline; without them it uses an in-app timer.
- **Pending count:** Settings shows how many azans are scheduled. From a shell:

  ```bash
  adb shell dumpsys alarm | grep -c ScheduledNotificationReceiver
  ```

- **Travel test on an emulator:** pick a city in Settings. Note that an emulator's
  network location provider may report its own default place regardless of
  `adb emu geo fix`; choosing a city is the reliable way.
- **Reboot test:** `adb reboot`, wait about a minute, then run the command above.
  The alarms come back without opening the app.
- **Emulator tip:** start it with `-crash-report-mode never -no-metrics`, otherwise a
  crash-consent dialog can block startup after the emulator was force-killed.

## Phones that kill background apps (OEM notes)

Xiaomi, Redmi, Poco, Infinix, Tecno, itel, Oppo, Realme, Vivo, OnePlus and Huawei
often stop apps in the background, which can silence the azan. Saathi detects these
makers with `device_info_plus` and shows a one-time guide (also under Settings,
"Battery & background help") with these steps:

1. App info, Battery, choose "No restrictions".
2. Turn on "Autostart" / "Auto-launch".
3. Lock the app in Recent apps.
4. Keep notifications and their sound on.

The guide never blocks the UI. Real Xiaomi/Infinix testing is still on your list.

## Vendored packages

`packages/flutter_qiblah` and `packages/flutter_compass_v2` are copies of the
published packages with only their `android/build.gradle` changed, because the
published versions do not build with Gradle 9 (`jcenter()` is gone) and current
AndroidX. See `PATCHES.md` in each folder. Remove them once upstream is fixed.

## Differences from the original spec

| Spec | Built | Why |
|---|---|---|
| compile SDK 35 | compile SDK 36, target SDK 35 | current plugins require compiling against 36 |
| `permission_handler` latest | pinned to 12.0.3 | 13.x needs `compileSdk = 37`, which this Gradle setup cannot resolve |
| Qibla via `flutter_qiblah` stream | heading from the sensor, bearing from the saved city | the package's stream opens a GPS stream and triggers a system dialog; this way it works offline |
| Makkah and Madina azan sounds | one real recording as "full" and "short" | the Haram recordings are not freely licensed; the bundled one is CC BY-SA 4.0 |
| `workmanager` on iOS | Android only for now | iOS needs BGTaskScheduler setup in Xcode |

## Known limits

- iOS compiles in principle but has **not been built or run** (no Xcode on the dev machine).
- Sound previews play through a notification, not an in-app audio player. The full
  azan (86 seconds) plays to the end unless the notification is dismissed.
- Offline, the city name comes from a bundled list of 38 cities; elsewhere it shows
  "My location" and keeps the previous country defaults.
- Urdu text relies on the device's Urdu font.
