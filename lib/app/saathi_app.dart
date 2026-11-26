import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/backup/backup_restore_service.dart';
import '../core/notifications/notification_tap_bus.dart';
import '../core/services/notification_listener_provider.dart';
import '../features/prayer/domain/usecases/handle_reminder_action.dart';
import '../features/tasks/data/task_reminders.dart';
import '../features/tasks/presentation/task_providers.dart';
import '../features/udhaar/background/udhaar_overdue_check.dart';
import '../features/udhaar/domain/phone.dart';
import '../core/utils/logger.dart';
import '../features/prayer/presentation/l10n_helpers.dart';
import '../features/prayer/presentation/providers/permissions_controller.dart';
import '../features/prayer/presentation/providers/prayer_providers.dart';
import '../features/prayer/presentation/providers/reschedule_controller.dart';
import '../features/prayer/presentation/providers/settings_controller.dart';
import '../features/prayer/presentation/providers/sync_controller.dart';
import '../features/prayer/presentation/providers/tracker_providers.dart';
import '../l10n/app_localizations.dart';
import 'providers.dart';
import 'router.dart';
import 'theme.dart';

class SaathiApp extends ConsumerStatefulWidget {
  const SaathiApp({this.launchPayload, super.key});

  /// Payload of the notification that cold-started the app, if any.
  final String? launchPayload;

  @override
  ConsumerState<SaathiApp> createState() => _SaathiAppState();
}

class _SaathiAppState extends ConsumerState<SaathiApp> with WidgetsBindingObserver {
  ProviderSubscription<AsyncValue<void>>? _notificationSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    notificationTapBus.stream.listen(_onTap);
    // Keep the notification-capture stream alive for the app's lifetime.
    _notificationSub = ref.listenManual(notificationListenerStreamProvider, (_, __) {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.launchPayload != null) _onTap(NotificationTap(widget.launchPayload));
      _refreshEverything();
    });
  }

  @override
  void dispose() {
    _notificationSub?.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ref.read(appLifecycleProvider.notifier).update(state);
    if (state == AppLifecycleState.resumed) {
      unawaited(refreshCapture(ref.read(appDatabaseProvider)));
      _refreshEverything();
    }
  }

  /// Re-schedules on start and on every resume, so the azans stay current
  /// even if the background task never ran.
  Future<void> _refreshEverything() async {
    await ref.read(settingsControllerProvider.future);
    await ref.read(permissionsControllerProvider.notifier).refresh();
    await ref.read(rescheduleControllerProvider.notifier).reschedule();
    final db = ref.read(appDatabaseProvider);
    // A button tapped while the app was closed was handled in another isolate.
    db.markTablesUpdated([db.tasks]);
    unawaited(rescheduleAllTaskReminders(db, prayerTime: ref.read(prayerTimeResolverProvider)));
    unawaited(BackupRestoreService.autoBackupIfDue(db, ref.read(sharedPreferencesProvider)));
    unawaited(ref.read(prayerActionsProvider).reconcileQaza());
    try {
      await ref.read(settingsControllerProvider.notifier).followIfMoved();
    } catch (error, stackTrace) {
      appLog.warning('Follow-me check failed', error, stackTrace);
    }
    // Last, and never awaited for anything else: offline just means "later".
    unawaited(ref.read(syncStatusControllerProvider.notifier).syncNow());
  }

  /// Handles a tap on a notification or one of its buttons.
  Future<void> _onTap(NotificationTap tap) async {
    // Task reminders: Done / Snooze buttons, or a tap that opens the task list.
    if (taskIdFromPayload(tap.payload) != null) {
      await handleTaskNotificationAction(ref.read(appDatabaseProvider),
          actionId: tap.actionId,
          payload: tap.payload,
          prayerTime: ref.read(prayerTimeResolverProvider));
      if (tap.actionId == null) ref.read(routerProvider).go(Routes.tasks);
      return;
    }

    // Handle "Send reminder" WhatsApp action from Udhaar overdue notifications.
    if (tap.actionId == kUdhaarWaActionId) {
      await _openWhatsAppFromPayload(tap.payload);
      return;
    }

    final outcome = await ref.read(handleReminderActionProvider)(actionId: tap.actionId, payload: tap.payload);
    switch (outcome) {
      case ReminderOutcome.needsPhoto:
        final info = HandleReminderAction.parse(tap.payload);
        if (info != null) {
          final date = '${info.date.year}-${info.date.month.toString().padLeft(2, '0')}-${info.date.day.toString().padLeft(2, '0')}';
          ref
              .read(routerProvider)
              .go('${Routes.verify}?prayer=${info.prayer.name}&date=$date${info.test ? '&test=1' : ''}');
        }
      case ReminderOutcome.stopped || ReminderOutcome.prayed:
        // The prayed log or the mute list changed: plan again from the new state.
        unawaited(ref.read(rescheduleControllerProvider.notifier).reschedule());
        unawaited(ref.read(syncStatusControllerProvider.notifier).syncNow());
      case ReminderOutcome.ignored:
        _openFromPayload(tap.payload);
    }
  }

  void _openFromPayload(String? payload) {
    if (payload == null || payload.isEmpty) return;
    try {
      final json = jsonDecode(payload) as Map<String, dynamic>;
      // Udhaar overdue tap → open the Khata (ledger) tab.
      if (json['type'] == kUdhaarOverdueType) {
        ref.read(routerProvider).go(Routes.khata);
        return;
      }
      final prayer = json['prayer'] as String?;
      if (prayer == null) return;
      ref.read(routerProvider).go('${Routes.prayer}?highlight=$prayer');
    } catch (error) {
      appLog.info('Ignoring notification payload: $error');
    }
  }

  Future<void> _openWhatsAppFromPayload(String? payload) async {
    if (payload == null) return;
    try {
      final json = jsonDecode(payload) as Map<String, dynamic>;
      final name = json['name'] as String? ?? '';
      final phone = (json['phone'] as String? ?? '').trim();
      final balance = (json['balance'] as num?)?.toDouble() ?? 0;
      if (balance <= 0) return;

      final amountStr = balance.toStringAsFixed(0);
      final message = 'Assalam o Alaikum $name, $amountStr Rs wapis karne ka waqt aa gaya hai. Shukriya!';

      final number = whatsAppNumber(phone);
      if (number != null) {
        final uri = Uri.parse('https://wa.me/$number?text=${Uri.encodeComponent(message)}');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          return;
        }
      }
      // Fallback: open WhatsApp without a contact (user picks manually).
      final fallback = Uri.parse('whatsapp://send?text=${Uri.encodeComponent(message)}');
      await launchUrl(fallback, mode: LaunchMode.externalApplication);
    } catch (error) {
      appLog.warning('WhatsApp launch from notification failed: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(currentSettingsProvider);
    return MaterialApp.router(
      title: 'Saathi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: ref.watch(routerProvider),
      locale: localeFromTag(settings.localeTag),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
