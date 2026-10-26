import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../khata/presentation/providers/khata_providers.dart';
import '../../../prayer/presentation/l10n_helpers.dart';
import '../../../prayer/presentation/providers/prayer_providers.dart';
import '../../../prayer/presentation/providers/settings_controller.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final settings = ref.watch(currentSettingsProvider);
    final next = ref.watch(nextPrayerProvider);
    final now = DateTime.now();
    final expensesAsync = ref.watch(monthExpensesProvider((now.year, now.month)));
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.navSettings,
            onPressed: () => context.go(Routes.settings),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          // Prayer quick-access card
          _DashCard(
            onTap: () => context.go(Routes.prayer),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: scheme.primaryContainer,
                  child: Icon(Icons.mosque_outlined, size: 24, color: scheme.onPrimaryContainer),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: next == null
                      ? Text(l10n.prayerTimesTitle, style: text.titleMedium)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              prayerLabel(l10n, next.prayer),
                              style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              formatClock(next.at, settings.timezoneId, locale),
                              style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                ),
                Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Khata quick-access card
          _DashCard(
            onTap: () => context.go(Routes.khata),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: scheme.secondaryContainer,
                  child: Icon(Icons.account_balance_wallet_outlined, size: 24, color: scheme.onSecondaryContainer),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.navKhata, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                      expensesAsync.when(
                        loading: () => const SizedBox(height: 14, width: 14, child: CircularProgressIndicator(strokeWidth: 2)),
                        error: (_, __) => const SizedBox.shrink(),
                        data: (expenses) {
                          final total = expenses.fold(0.0, (s, e) => s + e.amount);
                          final formatted = NumberFormat('#,##0.##', 'en').format(total);
                          return Text(
                            'Rs. $formatted',
                            style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Tools grid
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              l10n.dashTools,
              style: text.labelLarge?.copyWith(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600),
            ),
          ),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.05,
            children: [
              _ToolTile(
                icon: Icons.local_fire_department_outlined,
                label: l10n.navTracker,
                onTap: () => context.push(Routes.tracker),
              ),
              _ToolTile(
                icon: Icons.calendar_month_outlined,
                label: l10n.navTimetable,
                onTap: () => context.push(Routes.monthly),
              ),
              _ToolTile(
                icon: Icons.explore_outlined,
                label: l10n.navQibla,
                onTap: () => context.push(Routes.qibla),
              ),
              _ToolTile(
                icon: Icons.calculate_outlined,
                label: 'Zakat',
                comingSoon: true,
                onTap: () => _showComingSoon(context, l10n),
              ),
              _ToolTile(
                icon: Icons.currency_exchange_outlined,
                label: 'Currency',
                comingSoon: true,
                onTap: () => _showComingSoon(context, l10n),
              ),
              _ToolTile(
                icon: Icons.smart_toy_outlined,
                label: 'AI Tools',
                comingSoon: true,
                onTap: () => _showComingSoon(context, l10n),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, AppLocalizations l10n) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.dashComingSoon), duration: const Duration(seconds: 2)),
    );
  }
}

class _DashCard extends StatelessWidget {
  const _DashCard({required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: child,
        ),
      ),
    );
  }
}

class _ToolTile extends StatelessWidget {
  const _ToolTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.comingSoon = false,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool comingSoon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 28,
                color: comingSoon ? scheme.onSurfaceVariant.withAlpha(120) : scheme.primary,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: text.labelSmall?.copyWith(
                  color: comingSoon ? scheme.onSurfaceVariant.withAlpha(150) : scheme.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (comingSoon) ...[
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Soon',
                    style: TextStyle(fontSize: 9, color: scheme.onSurfaceVariant),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
