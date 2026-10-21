import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/prayer_name.dart';

/// One of the five prayer rows on the Home screen.
///
/// Stateless and driven entirely by its arguments so it is easy to test.
class PrayerRow extends StatelessWidget {
  const PrayerRow({
    required this.prayer,
    required this.name,
    required this.time,
    required this.azanEnabled,
    required this.prayed,
    required this.onToggleAzan,
    required this.onTogglePrayed,
    this.isNext = false,
    this.isHighlighted = false,
    this.isPast = false,
    this.jamaatText,
    super.key,
  });

  final PrayerName prayer;
  final String name;
  final String time;
  final bool azanEnabled;
  final bool prayed;
  final bool isNext;
  final bool isHighlighted;
  final bool isPast;

  /// For example "Jama'at 1:20 PM". Shown under the name when set.
  final String? jamaatText;
  final ValueChanged<bool> onToggleAzan;
  final ValueChanged<bool> onTogglePrayed;

  static IconData iconFor(PrayerName prayer) => switch (prayer) {
        PrayerName.fajr => Icons.nights_stay_outlined,
        PrayerName.sunrise => Icons.wb_twilight,
        PrayerName.dhuhr => Icons.wb_sunny_outlined,
        PrayerName.asr => Icons.wb_cloudy_outlined,
        PrayerName.maghrib => Icons.wb_twilight,
        PrayerName.isha => Icons.dark_mode_outlined,
      };

  Border? _border(ColorScheme scheme) {
    if (isHighlighted) return Border.all(color: scheme.primary, width: 2);
    if (isNext) return Border(left: BorderSide(color: AppTheme.gold, width: 3));
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final emphasised = isNext || isHighlighted;
    final fade = isPast && !emphasised ? 0.55 : 1.0;

    return Semantics(
      container: true,
      label: '$name $time',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: emphasised ? scheme.primaryContainer : scheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(20),
          border: _border(scheme),
        ),
        padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 4, 4),
        constraints: const BoxConstraints(minHeight: 64),
        child: Opacity(
          opacity: fade,
          child: Row(
            children: [
              Icon(iconFor(prayer), color: emphasised ? scheme.onPrimaryContainer : scheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: text.titleMedium?.copyWith(
                        fontWeight: emphasised ? FontWeight.w700 : FontWeight.w600,
                        color: emphasised ? scheme.onPrimaryContainer : null,
                      ),
                    ),
                    if (jamaatText != null)
                      Text(
                        jamaatText!,
                        key: ValueKey('jamaat-text-${prayer.name}'),
                        style: text.bodySmall?.copyWith(
                          color: emphasised ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                time,
                key: ValueKey('prayer-time-${prayer.name}'),
                style: text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  color: isNext ? AppTheme.gold : (emphasised ? scheme.onPrimaryContainer : null),
                ),
              ),
              IconButton(
                key: ValueKey('azan-toggle-${prayer.name}'),
                tooltip: l10n.azanToggle(name),
                constraints: const BoxConstraints.tightFor(width: 48, height: 48),
                isSelected: azanEnabled,
                icon: const Icon(Icons.notifications_off_outlined),
                selectedIcon: const Icon(Icons.notifications_active),
                onPressed: () => onToggleAzan(!azanEnabled),
              ),
              SizedBox(
                width: 48,
                height: 48,
                child: Checkbox(
                  key: ValueKey('prayed-${prayer.name}'),
                  value: prayed,
                  semanticLabel: l10n.markPrayed(name),
                  onChanged: (v) => onTogglePrayed(v ?? false),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
