import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'logger.dart';

/// Loads the timezone database and points `tz.local` at the device timezone.
/// Safe to call more than once and from background isolates.
Future<String> initializeTimezones() async {
  tzdata.initializeTimeZones();
  var id = 'UTC';
  try {
    id = (await FlutterTimezone.getLocalTimezone()).identifier;
    tz.setLocalLocation(tz.getLocation(id));
  } catch (error, stackTrace) {
    appLog.warning('Could not resolve device timezone ($id); using UTC', error, stackTrace);
    id = 'UTC';
    tz.setLocalLocation(tz.UTC);
  }
  return id;
}
