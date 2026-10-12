import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/usecases/schedule_upcoming_azans.dart';

part 'reschedule_controller.g.dart';

/// State of the most recent scheduling run.
class RescheduleState {
  const RescheduleState({this.running = false, this.report, this.error});

  final bool running;
  final ScheduleReport? report;
  final String? error;

  /// True when the OS refused exact alarms and inexact ones are in use.
  bool get exactAlarmsDenied => report != null && !report!.exactAlarms;
}

/// Runs [ScheduleUpcomingAzans] and exposes the outcome (for the banner).
@Riverpod(keepAlive: true)
class RescheduleController extends _$RescheduleController {
  @override
  RescheduleState build() => const RescheduleState();

  Future<void> reschedule() async {
    state = RescheduleState(running: true, report: state.report);
    final result = await ref.read(scheduleUpcomingAzansProvider)();
    state = result.when(
      success: (report) => RescheduleState(report: report),
      failure: (failure) {
        appLog.warning('Reschedule failed: ${failure.message}', failure.cause, failure.stackTrace);
        return RescheduleState(report: state.report, error: failure.message);
      },
    );
  }
}
