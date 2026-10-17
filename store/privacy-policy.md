# Saathi Privacy Policy

Last updated: 17 October 2026

Saathi is a prayer times and azan app. This page explains what it does with your information.
The short version: **your data stays on your phone unless you turn on cloud backup, and we do not
run ads, analytics or tracking.**

Developer: [YOUR NAME]
Contact: [YOUR EMAIL]

## What stays on your phone

Saathi works fully offline. These are stored only on your phone:

- **Your settings:** city, calculation method, language, azan sound, reminder choices.
- **Your location.** Saathi asks for location once to choose your city and calculation method, and
  again if you turn on "follow me" to notice when you travel. The coordinates are used to work out
  prayer times on the phone. They are not sent to us. To turn coordinates into a city name, Android's
  built-in geocoder may contact Google, as it does for any app that uses it. You can skip location
  and choose a city by hand.
- **Your prayer log:** which prayers you ticked on which days, your streaks, your qaza (missed
  prayers) balance and history, and any pause you set for illness or a woman's period. Pauses
  can reveal health information, so they are kept on your phone only and are never uploaded.
- **Jama'at times** you enter for your mosque.

Uninstalling the app deletes all of this.

## Photo proof (optional)

If you turn on "Photo proof" under prayer-ending reminders, the app asks you to take a picture of your
prayer place. The picture is checked on your phone by Google ML Kit's on-device image labelling. It is
**never uploaded, shared or kept**: the app deletes the file after the check. The check is only a
friendly nudge. It cannot know whether you prayed. You can always choose "Stop reminding me".

## Cloud backup (optional, off by default)

If you turn on cloud backup, Saathi uploads **only your prayer ticks**: the date, the prayer name,
whether it is ticked, and when you changed it. Nothing else is uploaded: no location, no settings, no
qaza, no pauses and no photos.

- There is no account, email or name. The phone creates a random **sync key** and keeps it in the
  Android Keystore. The server stores only a one-way hash of the key, never the key itself.
- The data is held in a database at Neon (a hosted PostgreSQL service) behind a small server run by
  the developer. Data travels over HTTPS.
- Anyone who has your sync key can read and change your prayer ticks, so keep it private. Entering
  the same key on a second phone shares your log between the two.
- You can delete your cloud data at any time with **Settings, Cloud backup, Delete my cloud data**.
  This removes your ticks and your key hash from the server.

## Permissions and why

| Permission | Why |
| --- | --- |
| Notifications | Azan, reminders and prayer-ending alerts |
| Alarms and reminders (exact alarms) | So the azan sounds at the exact minute |
| Location (approximate and precise) | Choose your city and the calculation method; optional "follow me" |
| Do Not Disturb access | Optional: silence the phone during jama'at and restore it afterwards |
| Camera (through the phone's camera app) | Optional photo proof |
| Run after restart | Put your azans back after the phone restarts |
| Internet | Optional cloud backup and city names |
| Vibrate, keep awake | Azan alerts |

You can turn any of these off in the phone's settings. The app keeps working with whatever you allow.

## What we do not do

- No ads. No analytics. No crash-reporting service. No third-party trackers.
- We do not sell or share your data.
- We do not collect your name, email, phone number or contacts.

## Children

Saathi is a general-audience app and does not knowingly collect personal information from children.

## Your choices

You can delete cloud data in the app, clear the app's storage or uninstall to remove everything on
the phone, and withdraw any permission in system settings.

## Changes

If this policy changes, the new version will be posted at this address with a new date.

## Contact

Questions or deletion help: [YOUR EMAIL]
