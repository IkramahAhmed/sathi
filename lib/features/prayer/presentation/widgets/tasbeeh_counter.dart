import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../l10n/app_localizations.dart';

const String _tasbeehKey = 'tasbeeh_count';

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

  Future<void> _set(int value) async {
    setState(() => _count = value);
    await ref.read(sharedPreferencesProvider).setInt(_tasbeehKey, value);
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
                    '$_count',
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
            Text(l10n.tasbeehTapHint, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
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
