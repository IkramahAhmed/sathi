import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers.dart';
import '../../../../app/router.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/oem_provider.dart';
import '../providers/permissions_controller.dart';

/// Steps for phones (Xiaomi, Infinix, Tecno, Oppo, Vivo...) that kill
/// background apps. Shown once; never blocks the UI.
class PermissionGuideScreen extends ConsumerWidget {
  const PermissionGuideScreen({super.key});

  void _leave(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final oem = ref.watch(oemInfoProvider).value;
    final brand = (oem == null || oem.brand.isEmpty) ? 'Android' : oem.brand;
    final steps = [l10n.oemStep1, l10n.oemStep2, l10n.oemStep3, l10n.oemStep4];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.oemTitle)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(l10n.oemIntro(brand), style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          for (var i = 0; i < steps.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 14, child: Text('${i + 1}')),
                  const SizedBox(width: 12),
                  Expanded(child: Text(steps[i], style: Theme.of(context).textTheme.bodyLarge)),
                ],
              ),
            ),
          const SizedBox(height: 16),
          FilledButton.icon(
            key: const ValueKey('open-app-settings'),
            icon: const Icon(Icons.settings_applications_outlined),
            label: Text(l10n.oemOpenSettings),
            onPressed: () => ref.read(permissionsControllerProvider.notifier).openSettings(),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () async {
              await ref.read(settingsRepositoryProvider).setOemGuideShown(shown: true);
              if (context.mounted) _leave(context);
            },
            child: Text(l10n.oemDontShow),
          ),
          TextButton(onPressed: () => _leave(context), child: Text(l10n.oemGotIt)),
        ],
      ),
    );
  }
}
