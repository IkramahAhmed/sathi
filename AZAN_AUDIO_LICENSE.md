# Azan audio: license and attribution

The azan sounds bundled with Saathi are based on one third-party recording.

| | |
|---|---|
| Work | "The Adhan - Muslim Call to Prayer - Aaqib Azeez" |
| Shared by | Atcovi, on Wikimedia Commons |
| Source | https://commons.wikimedia.org/wiki/File:The_Adhan_-_Muslim_Call_to_Prayer_-_Aaqib_Azeez.mp3 |
| License | Creative Commons Attribution-ShareAlike 4.0 (CC BY-SA 4.0), https://creativecommons.org/licenses/by-sa/4.0/ |
| Retrieved | 2026-10-13, 1,448,294 bytes, MP3, 86.5 seconds |

## What is in the app

- `android/app/src/main/res/raw/azan_full.mp3`: the original file, **unchanged**.
- `android/app/src/main/res/raw/azan_short.wav` and `ios/Runner/Sounds/azan_short.caf`:
  **modified**. The first 27.4 seconds (cut inside a natural pause), converted to mono
  22.05 kHz, with a 0.6 second fade-out. Made with `tool/make_short_azan.py`.

These modified files are adaptations, so under CC BY-SA 4.0 they are shared under the
same license. The app's own source code is not covered by this license.

The in-app credit is under Settings, "Audio credits".

## Not included

No recording of the Makkah or Madinah Haram azan is bundled. Those recordings are not
freely licensed. If you add one, make sure you have the rights first, and update this
file.
