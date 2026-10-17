# Play Console: Data safety answers

Fill these in under App content, then Data safety. They match version 0.3.0.

**Does the app collect or share user data?** Yes (collects). It does not share data with third parties.

**Is all data encrypted in transit?** Yes (HTTPS).

**Can users request data deletion?** Yes. In the app (Settings, Cloud backup, Delete my cloud data) and by
email. Give the privacy policy URL as the deletion page, since it explains both.

| Data type | Collected | Shared | Optional | Purpose | Notes |
| --- | --- | --- | --- | --- | --- |
| Approximate location | Yes | No | Yes | App functionality | Processed on the device to pick the city and method. Not sent to the developer. |
| Precise location | Yes | No | Yes | App functionality | Same as above. |
| App activity, other user-generated content | Yes | No | Yes | App functionality | Prayer ticks (date, prayer, done). Only when cloud backup is on. |
| Device or other IDs | Yes | No | Yes | App functionality, account management | The random sync key (stored as a hash). Only when cloud backup is on. |
| Photos | No | No | n/a | n/a | Photo proof is checked on the device and deleted. Never leaves it. |
| Health info | No | No | n/a | n/a | Pause dates stay on the device. |

Declare "processed ephemerally on the device" data as not collected, where Play's wording allows it.
Location is the one to think about: if you keep the answer as collected, state it as optional and
for app functionality only.

**Security practices:** data encrypted in transit; users can request deletion.

Before you submit, check that the Google ML Kit SDK's own data practices still match this answer
(see developers.google.com/ml-kit/android-data-disclosure) and update the table if they differ.

## Permission and policy declarations

- **Exact alarms (SCHEDULE_EXACT_ALARM).** Play asks why. Suggested text:
  "Saathi is a prayer times app. Muslims pray at five set times a day, and the azan must sound at the
  exact minute prayer begins. A reminder a few minutes late defeats the purpose. The app uses exact
  alarms only to fire the azan and prayer reminders the user turned on." Be ready for Play to say the
  core use does not qualify. If so, the fallback is inexact alarms, which can drift by minutes.
- **Do Not Disturb access (ACCESS_NOTIFICATION_POLICY).** Not a Play-restricted permission. The user
  grants it in system settings. Mention it in the listing so it is not a surprise.
- **Foreground service and boot receiver.** Pulled in by libraries. No declaration unless Play asks.
- **Location.** Foreground only, no background location, so no special declaration.
- **Content rating questionnaire:** no violence, no user-generated content shared with others, no ads.
  Expect "Everyone". Category: Lifestyle (or Books and Reference).
- **Target audience:** 13 and over is a safe choice. Not designed for children.
