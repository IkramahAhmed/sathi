# saathi_native

Android implementation of the `com.ikramah.saathi/native` channel:

- **Do Not Disturb during jama'at.** The app sends a list of time windows. Each
  start and end is an exact alarm. At the start the phone goes to "alarms only";
  at the end it goes back, but only if the app changed it and it is still in that
  state. A phone already in Do Not Disturb is never touched. After a reboot the
  windows are re-armed.
- **Home-screen widget.** The app sends the next prayers; the widget counts down
  to the next one by itself and redraws at each prayer time.

Needs the user to grant "Do Not Disturb access" once. No other permission.
