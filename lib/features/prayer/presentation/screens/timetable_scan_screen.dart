import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/verification/mosque_timetable_scanner.dart';
import '../../domain/entities/prayer_name.dart';
import '../l10n_helpers.dart';
import '../providers/settings_controller.dart';

/// Shown after OCR finishes. Displays detected jama'at times, lets the user
/// correct any, then saves all at once.
class TimetableScanScreen extends ConsumerStatefulWidget {
  const TimetableScanScreen({required this.scan, super.key});

  final TimetableScan scan;

  @override
  ConsumerState<TimetableScanScreen> createState() => _TimetableScanScreenState();
}

class _TimetableScanScreenState extends ConsumerState<TimetableScanScreen> {
  late final Map<PrayerName, int?> _times;

  @override
  void initState() {
    super.initState();
    _times = Map.of(widget.scan);
  }

  Future<void> _pickTime(BuildContext context, PrayerName prayer) async {
    final current = _times[prayer];
    final initial = current != null
        ? TimeOfDay(hour: current ~/ 60, minute: current % 60)
        : const TimeOfDay(hour: 13, minute: 0);

    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null && mounted) {
      setState(() => _times[prayer] = picked.hour * 60 + picked.minute);
    }
  }

  Future<void> _saveAll() async {
    final controller = ref.read(settingsControllerProvider.notifier);
    for (final entry in _times.entries) {
      final minutes = entry.value;
      if (minutes != null) {
        await controller.setJamaat(entry.key, fixedMinuteOfDay: minutes);
      }
    }
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final detected = _times.values.where((v) => v != null).length;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.scanTimetableTitle)),
      body: Column(
        children: [
          // Header banner
          Container(
            width: double.infinity,
            color: detected > 0 ? scheme.primaryContainer : scheme.errorContainer,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                Icon(
                  detected > 0 ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                  color: detected > 0 ? scheme.onPrimaryContainer : scheme.onErrorContainer,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    detected > 0
                        ? l10n.scanTimetableFound(detected)
                        : l10n.scanTimetableNoneFound,
                    style: text.bodyMedium?.copyWith(
                      color: detected > 0 ? scheme.onPrimaryContainer : scheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              l10n.scanTimetableHint,
              style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                for (final prayer in PrayerName.obligatory)
                  _PrayerTimeRow(
                    prayer: prayer,
                    name: prayerLabel(l10n, prayer),
                    minuteOfDay: _times[prayer],
                    detected: widget.scan[prayer] != null,
                    onTap: () => _pickTime(context, prayer),
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: FilledButton.icon(
            key: const ValueKey('scan-save'),
            icon: const Icon(Icons.save_outlined),
            label: Text(l10n.scanTimetableSave),
            onPressed: _times.values.any((v) => v != null) ? _saveAll : null,
          ),
        ),
      ),
    );
  }
}

class _PrayerTimeRow extends StatelessWidget {
  const _PrayerTimeRow({
    required this.prayer,
    required this.name,
    required this.minuteOfDay,
    required this.detected,
    required this.onTap,
  });

  final PrayerName prayer;
  final String name;
  final int? minuteOfDay;
  final bool detected;
  final VoidCallback onTap;

  static String _clock(int? m) {
    if (m == null) return '—';
    final h = m ~/ 60, min = m % 60;
    final h12 = h % 12 == 0 ? 12 : h % 12;
    return '$h12:${min.toString().padLeft(2, '0')} ${h < 12 ? 'AM' : 'PM'}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);
    final hasTime = minuteOfDay != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 8, 12, 8),
        leading: Icon(
          _iconForPrayer(prayer),
          color: hasTime ? scheme.primary : scheme.outline,
        ),
        title: Text(name, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        subtitle: hasTime && detected
            ? Row(
                children: [
                  Icon(Icons.auto_awesome, size: 12, color: AppTheme.gold),
                  const SizedBox(width: 4),
                  Text(
                    l10n.scanAutoDetected,
                    style: text.bodySmall?.copyWith(color: AppTheme.gold),
                  ),
                ],
              )
            : Text(
                hasTime ? l10n.scanTapToAdjust : l10n.scanNotDetected,
                style: text.bodySmall?.copyWith(
                  color: hasTime ? scheme.onSurfaceVariant : scheme.error,
                ),
              ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _clock(minuteOfDay),
              style: text.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontFeatures: const [FontFeature.tabularFigures()],
                color: hasTime ? (detected ? AppTheme.gold : scheme.onSurface) : scheme.outline,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.edit_outlined, size: 16, color: scheme.outline),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

IconData _iconForPrayer(PrayerName prayer) => switch (prayer) {
      PrayerName.fajr => Icons.nights_stay_outlined,
      PrayerName.sunrise => Icons.wb_twilight,
      PrayerName.dhuhr => Icons.wb_sunny_outlined,
      PrayerName.asr => Icons.wb_cloudy_outlined,
      PrayerName.maghrib => Icons.wb_twilight,
      PrayerName.isha => Icons.dark_mode_outlined,
    };
