import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

import '../../app/headless.dart';
import '../utils/logger.dart';

const String kRescheduleTaskName = 'saathi.rescheduleAzans';
const String kRescheduleUniqueName = 'saathi.dailyReschedule';

/// Entry point run by WorkManager in a background isolate. Best-effort: if the
/// OS never runs it, the app still re-schedules on every start and resume.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      final result = await runHeadlessReschedule();
      return result.isSuccess;
    } catch (error, stackTrace) {
      appLog.severe('Background task crashed', error, stackTrace);
      return false;
    }
  });
}

/// Registers the daily background re-schedule (Android).
abstract final class WorkmanagerBootstrap {
  static Future<void> init() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      // iOS needs BGTaskScheduler setup in the Runner; foreground rescheduling
      // on start/resume covers it until that is configured.
      return;
    }
    try {
      await Workmanager().initialize(callbackDispatcher);
      await Workmanager().registerPeriodicTask(
        kRescheduleUniqueName,
        kRescheduleTaskName,
        frequency: const Duration(hours: 24),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
        constraints: Constraints(
          networkType: NetworkType.notRequired,
          requiresBatteryNotLow: false,
        ),
      );
    } catch (error, stackTrace) {
      appLog.warning('Could not register the daily background task', error, stackTrace);
    }
  }
}
