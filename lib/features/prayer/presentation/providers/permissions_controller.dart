import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers.dart';
import '../../../../core/notifications/permission_service.dart';
import 'reschedule_controller.dart';

part 'permissions_controller.g.dart';

class PermissionsState {
  const PermissionsState({
    this.notifications = PermissionOutcome.denied,
    this.exactAlarms = PermissionOutcome.denied,
    this.loaded = false,
  });

  final PermissionOutcome notifications;
  final PermissionOutcome exactAlarms;
  final bool loaded;

  bool get notificationsGranted => notifications == PermissionOutcome.granted;
  bool get exactAlarmsOk =>
      exactAlarms == PermissionOutcome.granted || exactAlarms == PermissionOutcome.notNeeded;
}

@Riverpod(keepAlive: true)
class PermissionsController extends _$PermissionsController {
  @override
  PermissionsState build() => const PermissionsState();

  /// Re-reads the current permission state (call on app resume).
  Future<void> refresh() async {
    final service = ref.read(permissionServiceProvider);
    final before = state;
    state = PermissionsState(
      notifications: await service.notificationStatus(),
      exactAlarms: await service.exactAlarmStatus(),
      loaded: true,
    );
    // Permission changed in system settings: schedule again with the new mode.
    if (before.loaded &&
        (before.exactAlarmsOk != state.exactAlarmsOk ||
            before.notificationsGranted != state.notificationsGranted)) {
      await ref.read(rescheduleControllerProvider.notifier).reschedule();
    }
  }

  Future<PermissionOutcome> requestNotifications() async {
    final outcome = await ref.read(permissionServiceProvider).requestNotifications();
    await refresh();
    return outcome;
  }

  Future<PermissionOutcome> requestExactAlarms() async {
    final outcome = await ref.read(permissionServiceProvider).requestExactAlarms();
    await refresh();
    return outcome;
  }

  Future<bool> openSettings() => ref.read(permissionServiceProvider).openSettings();
}
