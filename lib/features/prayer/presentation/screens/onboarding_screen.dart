import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers.dart';
import '../../../../app/router.dart';
import '../../../../core/notifications/permission_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/oem_provider.dart';
import '../providers/permissions_controller.dart';
import '../providers/prayer_providers.dart';
import '../providers/reschedule_controller.dart';
import '../providers/settings_controller.dart';
import '../widgets/city_picker.dart';

enum _Step { welcome, location, notifications, exactAlarms, oem, done }

/// First-run flow. Every step can be skipped; location falls back to a
/// manual city list when it is denied.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _index = 0;
  bool _busy = false;
  bool _locationDenied = false;

  List<_Step> _steps(OemInfo? oem) => [
        _Step.welcome,
        _Step.location,
        _Step.notifications,
        if (defaultTargetPlatform == TargetPlatform.android) _Step.exactAlarms,
        if (oem?.needsGuide ?? false) _Step.oem,
        _Step.done,
      ];

  Future<void> _finish() async {
    await ref.read(settingsRepositoryProvider).setOnboardingDone(done: true);
    await ref.read(rescheduleControllerProvider.notifier).reschedule();
    if (mounted) context.go(Routes.home);
  }

  void _next(List<_Step> steps) {
    if (_index >= steps.length - 1) {
      _finish();
    } else {
      setState(() => _index++);
    }
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final oem = ref.watch(oemInfoProvider).value;
    final steps = _steps(oem);
    final step = steps[_index.clamp(0, steps.length - 1)];
    final isLast = step == _Step.done;
    final settings = ref.watch(currentSettingsProvider);
    final permissions = ref.watch(permissionsControllerProvider);

    final Widget body = switch (step) {
      _Step.welcome => _StepBody(
          icon: Icons.mosque,
          title: l10n.onbWelcomeTitle,
          body: l10n.onbWelcomeBody,
          extra: Column(
            children: [
              Text(l10n.onbLanguageTitle, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(value: 'en', label: Text(l10n.langEnglish)),
                  ButtonSegment(value: 'ur', label: Text(l10n.langUrdu)),
                  ButtonSegment(value: 'en_PK', label: Text(l10n.langRomanUrdu)),
                ],
                selected: {settings.localeTag},
                onSelectionChanged: (s) =>
                    ref.read(settingsControllerProvider.notifier).setLocale(s.first),
              ),
            ],
          ),
        ),
      _Step.location => _StepBody(
          icon: Icons.location_on_outlined,
          title: l10n.onbLocationTitle,
          body: l10n.onbLocationBody,
          extra: Column(
            children: [
              Text(
                l10n.currentLocation(settings.cityName, settings.countryCode),
                key: const ValueKey('onboarding-city'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                key: const ValueKey('onboarding-use-location'),
                icon: const Icon(Icons.my_location),
                label: Text(l10n.onbLocationAllow),
                onPressed: _busy
                    ? null
                    : () => _run(() async {
                          final result =
                              await ref.read(settingsControllerProvider.notifier).useCurrentLocation();
                          if (result.isSuccess) {
                            if (mounted) _next(steps);
                          } else {
                            setState(() => _locationDenied = true);
                          }
                        }),
              ),
              if (_locationDenied) ...[
                const SizedBox(height: 12),
                Text(l10n.locationFailed, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
              const SizedBox(height: 8),
              OutlinedButton.icon(
                key: const ValueKey('onboarding-choose-city'),
                icon: const Icon(Icons.location_city_outlined),
                label: Text(l10n.onbLocationManual),
                onPressed: () async {
                  final city = await showCityPicker(context);
                  if (city != null) {
                    await ref.read(settingsControllerProvider.notifier).pickCity(city);
                    if (mounted) _next(steps);
                  }
                },
              ),
            ],
          ),
        ),
      _Step.notifications => _StepBody(
          icon: Icons.notifications_active_outlined,
          title: l10n.onbNotifTitle,
          body: l10n.onbNotifBody,
          extra: permissions.notificationsGranted
              ? _Granted(label: l10n.allowed)
              : FilledButton(
                  key: const ValueKey('onboarding-allow-notifications'),
                  onPressed: _busy
                      ? null
                      : () => _run(() async {
                            final outcome =
                                await ref.read(permissionsControllerProvider.notifier).requestNotifications();
                            if (outcome == PermissionOutcome.granted && mounted) _next(steps);
                          }),
                  child: Text(l10n.allow),
                ),
        ),
      _Step.exactAlarms => _StepBody(
          icon: Icons.alarm,
          title: l10n.onbExactTitle,
          body: l10n.onbExactBody,
          extra: permissions.exactAlarmsOk
              ? _Granted(label: l10n.allowed)
              : FilledButton(
                  key: const ValueKey('onboarding-allow-exact'),
                  onPressed: _busy
                      ? null
                      : () => _run(() async {
                            await ref.read(permissionsControllerProvider.notifier).requestExactAlarms();
                          }),
                  child: Text(l10n.allow),
                ),
        ),
      _Step.oem => _StepBody(
          icon: Icons.battery_charging_full,
          title: l10n.onbOemTitle,
          body: l10n.onbOemBody,
          extra: FilledButton(
            key: const ValueKey('onboarding-open-oem'),
            onPressed: () => context.push(Routes.oemGuide),
            child: Text(l10n.onbOemOpen),
          ),
        ),
      _Step.done => _StepBody(
          icon: Icons.check_circle_outline,
          title: l10n.onbDoneTitle,
          body: l10n.onbDoneBody,
        ),
    };

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  Text(l10n.stepOf(_index + 1, steps.length), style: Theme.of(context).textTheme.labelLarge),
                  const Spacer(),
                  if (!isLast)
                    TextButton(
                      key: const ValueKey('onboarding-skip'),
                      onPressed: () => _next(steps),
                      child: Text(l10n.skip),
                    ),
                ],
              ),
              LinearProgressIndicator(value: (_index + 1) / steps.length),
              Expanded(child: SingleChildScrollView(child: body)),
              Row(
                children: [
                  if (_index > 0)
                    OutlinedButton(
                      onPressed: () => setState(() => _index--),
                      child: Text(l10n.back),
                    ),
                  const Spacer(),
                  FilledButton(
                    key: const ValueKey('onboarding-next'),
                    onPressed: () => _next(steps),
                    child: Text(isLast ? l10n.onbStart : l10n.next),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepBody extends StatelessWidget {
  const _StepBody({required this.icon, required this.title, required this.body, this.extra});

  final IconData icon;
  final String title;
  final String body;
  final Widget? extra;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(icon, size: 88, color: scheme.primary),
          const SizedBox(height: 24),
          Text(title, textAlign: TextAlign.center, style: text.headlineMedium),
          const SizedBox(height: 12),
          Text(body, textAlign: TextAlign.center, style: text.bodyLarge),
          if (extra != null) ...[const SizedBox(height: 32), extra!],
        ],
      ),
    );
  }
}

class _Granted extends StatelessWidget {
  const _Granted({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(label, style: Theme.of(context).textTheme.titleMedium),
        ],
      );
}
