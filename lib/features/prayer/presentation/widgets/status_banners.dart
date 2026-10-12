import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/notifications/permission_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/permissions_controller.dart';
import '../providers/reschedule_controller.dart';

/// Banners for the two permissions that make azan unreliable when missing.
class StatusBanners extends ConsumerWidget {
  const StatusBanners({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final permissions = ref.watch(permissionsControllerProvider);
    final reschedule = ref.watch(rescheduleControllerProvider);
    final controller = ref.read(permissionsControllerProvider.notifier);

    final banners = <Widget>[];

    if (permissions.loaded && !permissions.notificationsGranted) {
      banners.add(_Banner(
        key: const ValueKey('banner-notifications'),
        icon: Icons.notifications_off_outlined,
        title: l10n.bannerNotifTitle,
        body: l10n.bannerNotifBody,
        action: l10n.allow,
        onAction: () async {
          final outcome = await controller.requestNotifications();
          if (outcome == PermissionOutcome.permanentlyDenied) await controller.openSettings();
        },
      ));
    }

    final exactMissing = (permissions.loaded && !permissions.exactAlarmsOk) || reschedule.exactAlarmsDenied;
    if (exactMissing) {
      banners.add(_Banner(
        key: const ValueKey('banner-exact-alarm'),
        icon: Icons.alarm_off_outlined,
        title: l10n.bannerExactTitle,
        body: l10n.bannerExactBody,
        action: l10n.bannerExactAction,
        onAction: controller.requestExactAlarms,
      ));
    }

    if (banners.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        for (final b in banners) Padding(padding: const EdgeInsets.only(bottom: 12), child: b),
      ],
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.icon,
    required this.title,
    required this.body,
    required this.action,
    required this.onAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final String body;
  final String action;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.errorContainer,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: scheme.onErrorContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: scheme.onErrorContainer, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(body,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: scheme.onErrorContainer)),
                  const SizedBox(height: 8),
                  FilledButton.tonal(onPressed: onAction, child: Text(action)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
