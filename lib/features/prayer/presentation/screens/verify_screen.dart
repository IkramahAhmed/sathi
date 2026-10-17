import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers.dart';
import '../../../../app/router.dart';
import '../../../../core/utils/logger.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/prayer_name.dart';
import '../../domain/repositories/photo_verifier.dart';
import '../../domain/usecases/schedule_upcoming_azans.dart';
import '../l10n_helpers.dart';
import '../providers/tracker_providers.dart';

enum _Phase { idle, checking, rejected, accepted, cameraFailed }

/// Photo proof for a prayer: take a picture of the prayer place, it is checked
/// on the phone, and the prayer is ticked when it looks right.
class VerifyScreen extends ConsumerStatefulWidget {
  const VerifyScreen({super.key, required this.prayer, required this.date, this.isTest = false});

  final PrayerName prayer;
  final DateTime date;

  /// A test reminder: the check runs for real but nothing is ticked or muted.
  final bool isTest;

  @override
  ConsumerState<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends ConsumerState<VerifyScreen> {
  _Phase _phase = _Phase.idle;
  List<PhotoLabel> _labels = const [];

  Future<void> _take() async {
    final source = ref.read(photoSourceProvider);
    String? path;
    try {
      path = await source.takePhoto();
    } catch (error, stackTrace) {
      appLog.warning('Camera failed', error, stackTrace);
      if (mounted) setState(() => _phase = _Phase.cameraFailed);
      return;
    }
    if (path == null || !mounted) return;

    setState(() => _phase = _Phase.checking);
    try {
      final verdict = await ref.read(photoVerifierProvider).check(path);
      if (!mounted) return;
      if (verdict.accepted) {
        if (widget.isTest) {
          await ref.read(notificationSchedulerProvider).cancel(testEndReminderIds);
        } else {
          await ref.read(prayerActionsProvider).markVerified(widget.date, widget.prayer);
        }
        if (mounted) setState(() => _phase = _Phase.accepted);
      } else {
        setState(() {
          _labels = verdict.labels;
          _phase = _Phase.rejected;
        });
      }
    } catch (error, stackTrace) {
      appLog.warning('Photo check failed', error, stackTrace);
      if (mounted) setState(() => _phase = _Phase.cameraFailed);
    } finally {
      // The picture is never kept.
      await source.discard(path);
    }
  }

  Future<void> _stopReminding() async {
    if (widget.isTest) {
      await ref.read(notificationSchedulerProvider).cancel(testEndReminderIds);
    } else {
      final now = ref.read(clockProvider)();
      await ref.read(reminderMuteStoreProvider).mute(widget.date, widget.prayer, today: now);
      await ref.read(notificationSchedulerProvider).cancel(endReminderIds(widget.date, widget.prayer));
    }
    if (mounted) _leave();
  }

  void _leave() {
    final router = GoRouter.of(context);
    if (router.canPop()) {
      router.pop();
    } else {
      router.go(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final busy = _phase == _Phase.checking;
    final accepted = _phase == _Phase.accepted;
    final dateText = MaterialLocalizations.of(context).formatMediumDate(widget.date);

    final (IconData icon, Color color) = switch (_phase) {
      _Phase.accepted => (Icons.check_circle, scheme.primary),
      _Phase.rejected || _Phase.cameraFailed => (Icons.error_outline, scheme.error),
      _ => (Icons.photo_camera_outlined, scheme.primary),
    };

    return Scaffold(
      appBar: AppBar(title: Text(l10n.verifyTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Center(child: Icon(icon, size: 72, color: color)),
            const SizedBox(height: 12),
            Text(
              l10n.verifyPrayer(prayerLabel(l10n, widget.prayer), dateText),
              key: const ValueKey('verify-prayer'),
              textAlign: TextAlign.center,
              style: text.titleLarge,
            ),
            const SizedBox(height: 16),
            if (accepted)
              Text(l10n.verifySuccess, key: const ValueKey('verify-success'), textAlign: TextAlign.center, style: text.titleMedium),
            if (accepted && widget.isTest) ...[
              const SizedBox(height: 8),
              Text(l10n.verifyTestNote, key: const ValueKey('verify-test-note'), textAlign: TextAlign.center),
            ] else if (!accepted) ...[
              Text(l10n.verifyIntro, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(l10n.verifyChecklistHint,
                  textAlign: TextAlign.center, style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
            ],
            if (_phase == _Phase.rejected) ...[
              const SizedBox(height: 16),
              Text(l10n.verifyFail, key: const ValueKey('verify-fail'), textAlign: TextAlign.center, style: TextStyle(color: scheme.error)),
              if (_labels.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.verifySaw(_labels.take(4).map((l) => l.text).join(', ')),
                  key: const ValueKey('verify-saw'),
                  textAlign: TextAlign.center,
                  style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ],
            if (_phase == _Phase.cameraFailed) ...[
              const SizedBox(height: 16),
              Text(l10n.verifyNoCamera, key: const ValueKey('verify-no-camera'), textAlign: TextAlign.center, style: TextStyle(color: scheme.error)),
            ],
            const SizedBox(height: 24),
            if (accepted)
              FilledButton(key: const ValueKey('verify-done'), onPressed: _leave, child: Text(l10n.done))
            else ...[
              FilledButton.icon(
                key: const ValueKey('verify-take'),
                onPressed: busy ? null : _take,
                icon: busy
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.photo_camera),
                label: Text(busy
                    ? l10n.verifyChecking
                    : (_phase == _Phase.rejected || _phase == _Phase.cameraFailed ? l10n.verifyTryAgain : l10n.verifyTake)),
              ),
              const SizedBox(height: 32),
              OutlinedButton(
                key: const ValueKey('verify-stop'),
                onPressed: busy ? null : _stopReminding,
                child: Text(l10n.verifyStop),
              ),
              const SizedBox(height: 8),
              Text(l10n.verifyStopHelp,
                  textAlign: TextAlign.center, style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
            ],
          ],
        ),
      ),
    );
  }
}
