import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../core/notifications/notification_channels.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/permissions_controller.dart';
import '../providers/prayer_providers.dart';
import '../providers/reschedule_controller.dart';

/// One line of the checklist. [ok] is null while it cannot be known.
class _Check {
  const _Check({required this.key, required this.title, required this.ok, this.help, this.onFix});

  final String key;
  final String title;
  final bool? ok;
  final String? help;
  final Future<void> Function()? onFix;
}

/// Tells the user whether the azan will really sound, and fixes what it can.
class SetupCheckScreen extends ConsumerStatefulWidget {
  const SetupCheckScreen({super.key});

  @override
  ConsumerState<SetupCheckScreen> createState() => _SetupCheckScreenState();
}

class _SetupCheckScreenState extends ConsumerState<SetupCheckScreen> with WidgetsBindingObserver {
  bool? _battery;
  bool? _channel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Coming back from the system settings page re-reads everything.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  Future<void> _refresh() async {
    await ref.read(permissionsControllerProvider.notifier).refresh();
    final probe = ref.read(setupProbeProvider);
    final settings = ref.read(currentSettingsProvider);
    final channelId = NotificationChannels.azanChannelFor(settings.sound, alarm: settings.azanOnAlarm);
    final battery = await probe.batteryUnrestricted();
    final channel = settings.sound.isSilent ? true : await probe.channelAudible(channelId);
    if (!mounted) return;
    setState(() {
      _battery = battery;
      _channel = channel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final perms = ref.watch(permissionsControllerProvider);
    final pending = ref.watch(rescheduleControllerProvider).report?.scheduledCount ?? 0;
    final permissions = ref.read(permissionsControllerProvider.notifier);

    final checks = [
      _Check(
        key: 'check-notifications',
        title: l10n.checkNotifications,
        ok: perms.notificationsGranted,
        onFix: () async {
          await permissions.requestNotifications();
          if (!ref.read(permissionsControllerProvider).notificationsGranted) await permissions.openSettings();
        },
      ),
      _Check(
        key: 'check-exact',
        title: l10n.checkExact,
        help: l10n.checkExactHelp,
        ok: perms.exactAlarmsOk,
        onFix: () async {
          await permissions.requestExactAlarms();
        },
      ),
      _Check(
        key: 'check-battery',
        title: l10n.checkBattery,
        help: l10n.checkBatteryHelp,
        ok: _battery,
        onFix: () async {
          await permissions.openSettings();
        },
      ),
      _Check(
        key: 'check-channel',
        title: l10n.checkChannel,
        help: l10n.checkChannelHelp,
        ok: _channel,
        onFix: () async {
          await permissions.openSettings();
        },
      ),
      _Check(
        key: 'check-scheduled',
        title: pending > 0 ? l10n.checkScheduled(pending) : l10n.checkNoneScheduled,
        ok: pending > 0,
        onFix: () async {
          await ref.read(rescheduleControllerProvider.notifier).reschedule();
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.checkSetupTitle)),
      body: ListView(
        children: [
          Padding(padding: const EdgeInsets.all(16), child: Text(l10n.checkSetupIntro)),
          for (final c in checks)
            ListTile(
              key: ValueKey(c.key),
              leading: Icon(
                switch (c.ok) {
                  true => Icons.check_circle,
                  false => Icons.cancel,
                  null => Icons.help_outline,
                },
                color: switch (c.ok) {
                  true => scheme.primary,
                  false => scheme.error,
                  null => scheme.onSurfaceVariant,
                },
              ),
              title: Text(c.title),
              subtitle: c.ok == false && c.help != null ? Text(c.help!) : null,
              trailing: c.ok == false && c.onFix != null
                  ? FilledButton.tonal(
                      key: ValueKey('${c.key}-fix'),
                      onPressed: () async {
                        await c.onFix!();
                        await _refresh();
                      },
                      child: Text(l10n.checkFix),
                    )
                  : null,
            ),
          const Divider(),
          ListTile(
            key: const ValueKey('check-test'),
            leading: const Icon(Icons.notifications_active_outlined),
            title: Text(l10n.checkTestNow),
            onTap: () async {
              final settings = ref.read(currentSettingsProvider);
              await ref.read(localNotificationsProvider).scheduleTest(
                    id: 9002,
                    title: l10n.testTitle,
                    body: l10n.testBody,
                    channelId: NotificationChannels.azanChannelFor(settings.sound, alarm: settings.azanOnAlarm),
                  );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.testScheduled)));
              }
            },
          ),
          ListTile(
            key: const ValueKey('check-replan'),
            leading: const Icon(Icons.refresh),
            title: Text(l10n.checkReplan),
            onTap: () async {
              await ref.read(rescheduleControllerProvider.notifier).reschedule();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.checkReplanned)));
              }
            },
          ),
        ],
      ),
    );
  }
}
