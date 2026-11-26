import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../l10n/app_localizations.dart';

const String _tasbeehKey = 'tasbeeh_count';
const String _presetKey = 'tasbeeh_preset';
const String _dayKey = 'tasbeeh_day';
const String _dayTotalKey = 'tasbeeh_day_total';

/// Target of each preset: free, 33, 33, 34 and 100.
const List<int> _targets = [0, 33, 33, 34, 100];

/// A simple tap-to-count tasbeeh shown in a bottom sheet. The count survives
/// app restarts.
class TasbeehCounter extends ConsumerStatefulWidget {
  const TasbeehCounter({super.key});

  /// Opens the counter as a modal bottom sheet.
  static Future<void> show(BuildContext context) => showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (_) => const TasbeehCounter(),
      );

  @override
  ConsumerState<TasbeehCounter> createState() => _TasbeehCounterState();
}

class _TasbeehCounterState extends ConsumerState<TasbeehCounter> {
  late int _count = ref.read(sharedPreferencesProvider).getInt(_tasbeehKey) ?? 0;
  late int _preset = (ref.read(sharedPreferencesProvider).getInt(_presetKey) ?? 0).clamp(0, _targets.length - 1);
  late int _dayTotal = _loadDayTotal();

  static String _today() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  int _loadDayTotal() {
    final prefs = ref.read(sharedPreferencesProvider);
    return prefs.getString(_dayKey) == _today() ? (prefs.getInt(_dayTotalKey) ?? 0) : 0;
  }

  Future<void> _set(int value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final target = _targets[_preset];
    final added = value > _count ? value - _count : 0;
    setState(() {
      _count = value;
      _dayTotal += added;
    });
    if (added > 0 && target > 0 && value == target) HapticFeedback.heavyImpact();
    await prefs.setInt(_tasbeehKey, value);
    await prefs.setString(_dayKey, _today());
    await prefs.setInt(_dayTotalKey, _dayTotal);
  }

  Future<void> _choose(int preset) async {
    setState(() => _preset = preset);
    await ref.read(sharedPreferencesProvider).setInt(_presetKey, preset);
    await _set(0);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.tasbeehTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                for (var i = 0; i < _targets.length; i++)
                  ChoiceChip(
                    key: ValueKey('tasbeeh-preset-$i'),
                    label: Text(switch (i) {
                      0 => l10n.tasbeehFree,
                      1 => '${l10n.tasbeehSubhanallah} 33',
                      2 => '${l10n.tasbeehAlhamdulillah} 33',
                      3 => '${l10n.tasbeehAllahuAkbar} 34',
                      _ => '100',
                    }),
                    selected: _preset == i,
                    onSelected: (_) => _choose(i),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Semantics(
              button: true,
              label: l10n.tasbeehTapHint,
              child: GestureDetector(
                key: const ValueKey('tasbeeh-tap'),
                onTap: () {
                  HapticFeedback.selectionClick();
                  _set(_count + 1);
                },
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: scheme.primaryContainer),
                  alignment: Alignment.center,
                  child: Text(
                    _targets[_preset] > 0 ? '$_count/${_targets[_preset]}' : '$_count',
                    key: const ValueKey('tasbeeh-count'),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: scheme.onPrimaryContainer,
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _targets[_preset] > 0 && _count >= _targets[_preset]
                  ? l10n.tasbeehTargetReached
                  : l10n.tasbeehTapHint,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(l10n.tasbeehToday('$_dayTotal'), style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _count == 0 ? null : () => _set(0),
              icon: const Icon(Icons.restart_alt),
              label: Text(l10n.tasbeehReset),
            ),
          ],
        ),
      ),
    );
  }
}
