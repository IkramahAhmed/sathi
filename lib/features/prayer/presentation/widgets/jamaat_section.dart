import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/prayer_name.dart';
import '../l10n_helpers.dart';
import '../providers/prayer_providers.dart';
import '../providers/settings_controller.dart';

const List<int> _leaveChoices = [0, 5, 10, 15, 20, 30];
const List<int> _silentChoices = [10, 15, 20, 30, 45];

/// Mosque jama'at times and the "time to leave" reminder, in Settings.
class JamaatSection extends ConsumerWidget {
  const JamaatSection({super.key});

  static String _clock(int minuteOfDay) {
    final h = minuteOfDay ~/ 60;
    final m = minuteOfDay % 60;
    final h12 = h % 12 == 0 ? 12 : h % 12;
    return '$h12:${m.toString().padLeft(2, '0')} ${h < 12 ? 'AM' : 'PM'}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(currentSettingsProvider);
    final jamaat = settings.jamaat;
    final controller = ref.read(settingsControllerProvider.notifier);
    final scheme = Theme.of(context).colorScheme;

    String ruleText(PrayerName p) {
      final fixed = jamaat.fixedMin[p];
      if (fixed != null) return l10n.jamaatFixed(_clock(fixed));
      final offset = jamaat.offsetMin[p] ?? 0;
      return offset > 0 ? l10n.jamaatAfter(offset) : l10n.jamaatNotSet;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 4),
          child: Text(
            l10n.jamaatSection,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: scheme.primary, fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
          child: Text(
            l10n.jamaatHelp,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ),
        for (final prayer in PrayerName.obligatory)
          ListTile(
            key: ValueKey('jamaat-${prayer.name}'),
            leading: const Icon(Icons.groups_outlined),
            title: Text(prayerLabel(l10n, prayer)),
            subtitle: Text(ruleText(prayer)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _editRule(context, ref, controller, prayer, l10n),
          ),
        ListTile(
          key: const ValueKey('jamaat-jumma'),
          leading: const Icon(Icons.mosque_outlined),
          title: Text(l10n.jummaTime),
          subtitle: Text(jamaat.jummaFixedMin == null ? l10n.jamaatNotSet : l10n.jamaatFixed(_clock(jamaat.jummaFixedMin!))),
          trailing: jamaat.jummaFixedMin == null
              ? const Icon(Icons.chevron_right)
              : IconButton(
                  key: const ValueKey('jamaat-jumma-clear'),
                  tooltip: l10n.jamaatClear,
                  icon: const Icon(Icons.close),
                  onPressed: () => controller.setJummaTime(null),
                ),
          onTap: () async {
            final initial = jamaat.jummaFixedMin ?? 13 * 60;
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(hour: initial ~/ 60, minute: initial % 60),
            );
            if (picked != null) await controller.setJummaTime(picked.hour * 60 + picked.minute);
          },
        ),
        if (jamaat.isConfigured)
          ListTile(
            key: const ValueKey('jamaat-leave'),
            leading: const Icon(Icons.directions_walk),
            title: Text(l10n.leaveReminder),
            trailing: DropdownButton<int>(
              key: const ValueKey('jamaat-leave-dropdown'),
              value: _leaveChoices.contains(jamaat.leaveReminderMin) ? jamaat.leaveReminderMin : 0,
              underline: const SizedBox.shrink(),
              items: [
                for (final m in _leaveChoices)
                  DropdownMenuItem(value: m, child: Text(m == 0 ? l10n.off : l10n.minutesValue(m))),
              ],
              onChanged: (m) {
                if (m != null) controller.setLeaveReminder(m);
              },
            ),
          ),
        if (jamaat.isConfigured) ...[
          SwitchListTile(
            key: const ValueKey('jamaat-silent'),
            secondary: const Icon(Icons.volume_off_outlined),
            title: Text(l10n.silentDuring),
            subtitle: Text(l10n.silentHelp),
            value: jamaat.silentDuringJamaat,
            onChanged: (v) => controller.setSilentJamaat(enabled: v),
          ),
          if (jamaat.silentDuringJamaat) ...[
            ListTile(
              key: const ValueKey('jamaat-silent-length'),
              leading: const Icon(Icons.timelapse),
              title: Text(l10n.silentLength),
              trailing: DropdownButton<int>(
                key: const ValueKey('jamaat-silent-minutes'),
                value: _silentChoices.contains(jamaat.silentMinutes) ? jamaat.silentMinutes : 15,
                underline: const SizedBox.shrink(),
                items: [for (final m in _silentChoices) DropdownMenuItem(value: m, child: Text(l10n.minutesValue(m)))],
                onChanged: (m) {
                  if (m != null) controller.setSilentMinutes(m);
                },
              ),
            ),
            const _SilentAccessTile(),
          ],
        ],
      ],
    );
  }

  Future<void> _editRule(
    BuildContext context,
    WidgetRef ref,
    SettingsController controller,
    PrayerName prayer,
    AppLocalizations l10n,
  ) async {
    final settings = ref.read(currentSettingsProvider);
    final jamaat = settings.jamaat;
    var fixed = jamaat.fixedMin.containsKey(prayer);
    final minutes = TextEditingController(text: '${jamaat.offsetMin[prayer] ?? 10}');
    var time = jamaat.fixedMin[prayer] ?? 13 * 60;

    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('${l10n.jamaatEdit}: ${prayerLabel(l10n, prayer)}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SegmentedButton<bool>(
                key: const ValueKey('jamaat-mode'),
                segments: [
                  ButtonSegment(value: false, label: Text(l10n.jamaatModeAfter)),
                  ButtonSegment(value: true, label: Text(l10n.jamaatModeFixed)),
                ],
                selected: {fixed},
                onSelectionChanged: (s) => setState(() => fixed = s.first),
              ),
              const SizedBox(height: 16),
              if (!fixed)
                TextField(
                  key: const ValueKey('jamaat-minutes'),
                  controller: minutes,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(labelText: l10n.jamaatModeAfter, border: const OutlineInputBorder()),
                )
              else
                OutlinedButton.icon(
                  key: const ValueKey('jamaat-pick-time'),
                  icon: const Icon(Icons.schedule),
                  label: Text('${l10n.jamaatPickTime}: ${_clock(time)}'),
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: time ~/ 60, minute: time % 60),
                    );
                    if (picked != null) setState(() => time = picked.hour * 60 + picked.minute);
                  },
                ),
            ],
          ),
          actions: [
            TextButton(
              key: const ValueKey('jamaat-clear'),
              onPressed: () async {
                await controller.setJamaat(prayer);
                if (context.mounted) Navigator.of(context).pop();
              },
              child: Text(l10n.jamaatClear),
            ),
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
            FilledButton(
              key: const ValueKey('jamaat-save'),
              onPressed: () async {
                if (fixed) {
                  await controller.setJamaat(prayer, fixedMinuteOfDay: time);
                } else {
                  await controller.setJamaat(prayer, offsetMin: int.tryParse(minutes.text.trim()) ?? 0);
                }
                if (context.mounted) Navigator.of(context).pop();
              },
              child: Text(l10n.syncSave),
            ),
          ],
        ),
      ),
    );
  }
}

/// Asks for Do Not Disturb access until it is granted. Checks again when the user
/// comes back from the system page.
class _SilentAccessTile extends ConsumerStatefulWidget {
  const _SilentAccessTile();

  @override
  ConsumerState<_SilentAccessTile> createState() => _SilentAccessTileState();
}

class _SilentAccessTileState extends ConsumerState<_SilentAccessTile> with WidgetsBindingObserver {
  bool? _granted;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _check();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _check();
  }

  Future<void> _check() async {
    final granted = await ref.read(nativeBridgeProvider).silentAccessGranted();
    if (!mounted) return;
    setState(() => _granted = granted);
    // Access just arrived: arm the silent windows now rather than at the next start.
    if (granted) await ref.read(syncNativeStateProvider)();
  }

  @override
  Widget build(BuildContext context) {
    if (_granted != false) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    return ListTile(
      key: const ValueKey('jamaat-silent-access'),
      leading: Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.error),
      title: Text(l10n.silentGrantAccess),
      trailing: FilledButton.tonal(
        key: const ValueKey('jamaat-silent-grant'),
        onPressed: () => ref.read(nativeBridgeProvider).openSilentAccessSettings(),
        child: Text(l10n.checkFix),
      ),
    );
  }
}
