import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../../l10n/app_localizations.dart';
import '../l10n_helpers.dart';
import '../providers/sync_controller.dart';

/// The "Cloud backup" block in Settings.
class CloudSyncSection extends ConsumerStatefulWidget {
  const CloudSyncSection({super.key});

  @override
  ConsumerState<CloudSyncSection> createState() => _CloudSyncSectionState();
}

class _CloudSyncSectionState extends ConsumerState<CloudSyncSection> {
  bool _showKey = false;

  String _problemText(AppLocalizations l10n, SyncProblem problem) => switch (problem) {
        SyncProblem.notConfigured => l10n.syncProblemSetup,
        SyncProblem.offline => l10n.syncProblemOffline,
        SyncProblem.serverError => l10n.syncProblemServer,
        SyncProblem.keyRejected => l10n.syncProblemKey,
        SyncProblem.other => l10n.syncProblemOther,
      };

  /// A one-line description of where sync stands.
  String _statusText(AppLocalizations l10n, SyncStatus status, Locale locale) {
    final parts = <String>[];
    if (status.running) {
      parts.add(l10n.syncRunning);
    } else if (status.problem != null) {
      parts.add(_problemText(l10n, status.problem!));
    } else if (status.lastSyncAt != null) {
      final time = DateFormat('d MMM, h:mm a', dateLocale(locale)).format(status.lastSyncAt!.toLocal());
      parts.add(l10n.syncLastSynced(time));
    } else {
      parts.add(l10n.syncNever);
    }
    if (status.pending > 0 && !status.running) parts.add(l10n.syncPending(status.pending));
    return parts.join(' · ');
  }

  Future<String?> _askText(
    BuildContext context, {
    required String title,
    required String help,
    required String label,
    String initial = '',
    String? hint,
    required String action,
    required Future<String?> Function(String value) submit,
    TextInputType keyboard = TextInputType.text,
  }) {
    final controller = TextEditingController(text: initial);
    String? error;
    return showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (help.isNotEmpty) Text(help),
              if (help.isNotEmpty) const SizedBox(height: 12),
              TextField(
                controller: controller,
                autofocus: true,
                keyboardType: keyboard,
                autocorrect: false,
                enableSuggestions: false,
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(
                  labelText: label,
                  hintText: hint,
                  errorText: error,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context).cancel),
            ),
            FilledButton(
              onPressed: () async {
                final problem = await submit(controller.text);
                if (problem == null) {
                  if (context.mounted) Navigator.of(context).pop(controller.text);
                } else {
                  setState(() => error = problem);
                }
              },
              child: Text(action),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final config = ref.watch(syncSettingsProvider).value;
    final status = ref.watch(syncStatusControllerProvider);
    final settings = ref.read(syncSettingsProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final enabled = config?.enabled ?? false;
    final key = config?.key;
    final address = config?.baseUrl ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 8),
          child: Text(
            l10n.syncSection,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: scheme.primary, fontWeight: FontWeight.w700),
          ),
        ),
        SwitchListTile(
          key: const ValueKey('sync-switch'),
          secondary: const Icon(Icons.cloud_sync_outlined),
          title: Text(l10n.syncTitle),
          subtitle: Text(l10n.syncSubtitle),
          value: enabled,
          onChanged: (on) => on ? settings.enable() : settings.disable(),
        ),
        ListTile(
          key: const ValueKey('sync-server'),
          leading: const Icon(Icons.dns_outlined),
          title: Text(l10n.syncServer),
          subtitle: Text(address.isEmpty ? l10n.syncServerNotSet : address, textDirection: TextDirection.ltr),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _askText(
            context,
            title: l10n.syncServer,
            help: '',
            label: l10n.syncServer,
            initial: address,
            hint: l10n.syncServerHint,
            action: l10n.syncSave,
            keyboard: TextInputType.url,
            submit: (value) async =>
                (await settings.setServerAddress(value)) == null ? null : l10n.syncServerInvalid,
          ),
        ),
        if (enabled && key != null) ...[
          ListTile(
            key: const ValueKey('sync-key'),
            leading: const Icon(Icons.key_outlined),
            title: Text(l10n.syncKey),
            subtitle: Text(
              _showKey ? key : '${'•' * 12}${key.substring(key.length - 4)}',
              textDirection: TextDirection.ltr,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  key: const ValueKey('sync-key-toggle'),
                  tooltip: _showKey ? l10n.syncKeyHide : l10n.syncKeyShow,
                  icon: Icon(_showKey ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                  onPressed: () => setState(() => _showKey = !_showKey),
                ),
                IconButton(
                  key: const ValueKey('sync-key-copy'),
                  tooltip: l10n.syncKeyCopy,
                  icon: const Icon(Icons.copy_outlined),
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await Clipboard.setData(ClipboardData(text: key));
                    messenger.showSnackBar(SnackBar(content: Text(l10n.syncKeyCopied)));
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(72, 0, 16, 8),
            child: Text(
              l10n.syncKeyHelp,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
          ListTile(
            key: const ValueKey('sync-use-key'),
            leading: const Icon(Icons.phonelink_setup_outlined),
            title: Text(l10n.syncUseKey),
            onTap: () => _askText(
              context,
              title: l10n.syncUseKey,
              help: l10n.syncUseKeyHelp,
              label: l10n.syncKey,
              action: l10n.syncUse,
              submit: (value) async =>
                  (await settings.useExistingKey(value)) == null ? null : l10n.syncKeyInvalid,
            ),
          ),
          ListTile(
            key: const ValueKey('sync-now'),
            leading: status.running
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5))
                : const Icon(Icons.sync),
            title: Text(l10n.syncNow),
            subtitle: Text(
              _statusText(l10n, status, locale),
              key: const ValueKey('sync-status'),
              style: status.problem != null && !status.running ? TextStyle(color: scheme.error) : null,
            ),
            onTap: status.running ? null : () => ref.read(syncStatusControllerProvider.notifier).syncNow(),
          ),
          ListTile(
            key: const ValueKey('sync-delete'),
            leading: Icon(Icons.delete_outline, color: scheme.error),
            title: Text(l10n.syncDelete, style: TextStyle(color: scheme.error)),
            onTap: () async {
              final messenger = ScaffoldMessenger.of(context);
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l10n.syncDelete),
                  content: Text(l10n.syncDeleteBody),
                  actions: [
                    TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancel)),
                    FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: scheme.error, foregroundColor: scheme.onError),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(l10n.syncDeleteConfirm),
                    ),
                  ],
                ),
              );
              if (confirmed != true) return;
              final result = await settings.deleteCloudData();
              messenger.showSnackBar(SnackBar(
                content: Text(result.isSuccess ? l10n.syncDeleted : l10n.syncProblemOffline),
              ));
            },
          ),
        ],
      ],
    );
  }
}
