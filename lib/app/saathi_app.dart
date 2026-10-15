import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/notifications/notification_tap_bus.dart';
import '../core/utils/logger.dart';
import '../features/prayer/presentation/l10n_helpers.dart';
import '../features/prayer/presentation/providers/permissions_controller.dart';
import '../features/prayer/presentation/providers/prayer_providers.dart';
import '../features/prayer/presentation/providers/reschedule_controller.dart';
import '../features/prayer/presentation/providers/settings_controller.dart';
import '../features/prayer/presentation/providers/sync_controller.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    notificationTapBus.stream.listen(_openFromPayload);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openFromPayload(widget.launchPayload);
      _refreshEverything();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ref.read(appLifecycleProvider.notifier).update(state);
    if (state == AppLifecycleState.resumed) _refreshEverything();
  }

  /// Re-schedules on start and on every resume, so the azans stay current
  /// even if the background task never ran.
  Future<void> _refreshEverything() async {
    await ref.read(settingsControllerProvider.future);
    await ref.read(permissionsControllerProvider.notifier).refresh();
    await ref.read(rescheduleControllerProvider.notifier).reschedule();
    try {
      await ref.read(settingsControllerProvider.notifier).followIfMoved();
    } catch (error, stackTrace) {
      appLog.warning('Follow-me check failed', error, stackTrace);
    }
    // Last, and never awaited for anything else: offline just means "later".
    unawaited(ref.read(syncStatusControllerProvider.notifier).syncNow());
  }

  void _openFromPayload(String? payload) {
    if (payload == null || payload.isEmpty) return;
    try {
      final json = jsonDecode(payload) as Map<String, dynamic>;
      final prayer = json['prayer'] as String?;
      if (prayer == null) return;
      ref.read(routerProvider).go('${Routes.home}?highlight=$prayer');
    } catch (error) {
      appLog.info('Ignoring notification payload: $error');
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
