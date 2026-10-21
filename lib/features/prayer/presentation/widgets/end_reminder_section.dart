import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/end_reminder.dart';
import '../../domain/entities/prayer_name.dart';
import '../l10n_helpers.dart';
import '../providers/prayer_providers.dart';
import '../providers/settings_controller.dart';

const List<int> _leadChoices = [kLeadAtPrayerTime, 15, 30, 45, 60];
const List<int> _repeatChoices = [5, 10, 15];

/// "Prayer time is ending" reminders, with an optional photo proof, in Settings.
class EndReminderSection extends ConsumerWidget {
  const EndReminderSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final end = ref.watch(currentSettingsProvider).endReminder;
    final controller = ref.read(settingsControllerProvider.notifier);
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 4),
          child: Text(
            l10n.endSection,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: scheme.primary, fontWeight: FontWeight.w700),
          ),
        ),
        SwitchListTile(
          key: const ValueKey('end-enable'),
          secondary: const Icon(Icons.hourglass_bottom),
          title: Text(l10n.endEnable),
          subtitle: Text(l10n.endHelp),
          value: end.enabled,
          onChanged: (v) => controller.setEndReminder(enabled: v),
        ),
        if (end.enabled) ...[
          ListTile(
            key: const ValueKey('end-lead'),
            leading: const Icon(Icons.timer_outlined),
            title: Text(l10n.endLead),
            trailing: DropdownButton<int>(
              key: const ValueKey('end-lead-dropdown'),
              value: _leadChoices.contains(end.leadMin) ? end.leadMin : kLeadAtPrayerTime,
              underline: const SizedBox.shrink(),
              items: [
                for (final m in _leadChoices)
                  DropdownMenuItem(
                    value: m,
                    child: Text(m == kLeadAtPrayerTime ? 'At prayer time' : l10n.endLeadValue(m)),
                  ),
              ],
              onChanged: (m) {
                if (m != null) controller.setEndReminder(leadMin: m);
              },
            ),
          ),
          ListTile(
            key: const ValueKey('end-repeat'),
            leading: const Icon(Icons.repeat),
            title: Text(l10n.endRepeat),
            trailing: DropdownButton<int>(
              key: const ValueKey('end-repeat-dropdown'),
              value: _repeatChoices.contains(end.repeatMin) ? end.repeatMin : 10,
              underline: const SizedBox.shrink(),
              items: [for (final m in _repeatChoices) DropdownMenuItem(value: m, child: Text(l10n.endRepeatValue(m)))],
              onChanged: (m) {
                if (m != null) controller.setEndReminder(repeatMin: m);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
            child: Text(l10n.endPrayers, style: Theme.of(context).textTheme.bodyLarge),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 8,
              children: [
                for (final prayer in PrayerName.obligatory)
                  FilterChip(
                    key: ValueKey('end-prayer-${prayer.name}'),
                    label: Text(prayerLabel(l10n, prayer)),
                    selected: end.prayers[prayer] ?? true,
                    onSelected: (v) => controller.setEndReminderPrayer(prayer, enabled: v),
                  ),
              ],
            ),
          ),
          SwitchListTile(
            key: const ValueKey('end-photo'),
            secondary: const Icon(Icons.photo_camera_outlined),
            title: Text(l10n.endRequirePhoto),
            subtitle: Text(l10n.endRequirePhotoHelp),
            value: end.requirePhoto,
            onChanged: (v) => controller.setEndReminder(requirePhoto: v),
          ),
          const _TestReminderTile(),
        ],
      ],
    );
  }
}

/// A tile that fires 3 test "prayer ending" notifications so the user can
/// experience the flow without waiting for a real prayer window.
class _TestReminderTile extends ConsumerStatefulWidget {
  const _TestReminderTile();

  @override
  ConsumerState<_TestReminderTile> createState() => _TestReminderTileState();
}

class _TestReminderTileState extends ConsumerState<_TestReminderTile> {
  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      key: const ValueKey('end-test'),
      leading: const Icon(Icons.send_outlined),
      title: Text(l10n.endTestTitle),
      subtitle: Text(l10n.endTestHelp),
      trailing: _sending
          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
          : FilledButton.tonal(
              key: const ValueKey('end-test-send'),
              onPressed: _send,
              child: Text(l10n.endTestSend),
            ),
    );
  }

  Future<void> _send() async {
    setState(() => _sending = true);
    try {
      await ref.read(scheduleTestEndRemindersProvider)();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).endTestScheduled)),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }
}
