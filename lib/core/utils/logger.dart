import 'dart:developer' as developer;

import 'package:logging/logging.dart';

/// Application-wide logger. Never use `print()`.
final Logger appLog = Logger('saathi');

bool _configured = false;

/// Routes [Logger] records to `dart:developer` so they show in DevTools/logcat.
void setupLogging() {
  if (_configured) return;
  _configured = true;
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    developer.log(
      record.message,
      name: record.loggerName,
      level: record.level.value,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  });
}
