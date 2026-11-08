# Saathi — Project Rules

## Never lose existing data
- Always install with `adb install -r` — never `adb uninstall` + fresh install.
- Database migrations must be **additive only** (add columns/tables, never drop or truncate).
- Never clear app data or reset the database unless the user explicitly asks.
- When adding test data, warn the user and offer to remove it after testing.

## Keep the APK small
- Prefer lightweight solutions. Avoid heavy packages.
- Current arm64 APK target: under 42 MB.
- Check the size impact of any new package before adding it.

## Check reference apps before building a feature
- Before implementing a new feature, research how other Khata/finance/prayer apps handle it (MobiKhata, Easy Khata, etc.).
- Mention what you found before writing code.

## Act as a senior PM for product questions
- When the user asks what to build next, or asks about priority, respond as a senior product manager — give a clear recommendation with reasoning, not just a list of options.

## Install & build
- Build APK: `flutter build apk --split-per-abi` (use arm64-v8a for install).
- Install: `~/Library/Android/sdk/platform-tools/adb -s 0O64C11G31100F9C install -r <apk>`.
- After schema changes, run: `dart run build_runner build --delete-conflicting-outputs`.
- After ARB changes, run: `flutter gen-l10n`.

## Separate projects
- This repo is `/Users/ikramah/Documents/saathi`. Do not touch any other project.
