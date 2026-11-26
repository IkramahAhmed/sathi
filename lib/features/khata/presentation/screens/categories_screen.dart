import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../core/storage/app_database.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/khata_providers.dart';
import 'category_dialog.dart';

/// The categories the user made: add, rename, change the icon, delete.
class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final rows = ref.watch(customCategoriesProvider).value ?? const <CustomCategory>[];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.categoriesTitle)),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: Text(l10n.categoryNew),
        onPressed: () => showCategoryEditor(context, ref),
      ),
      body: rows.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  l10n.categoriesEmpty,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              children: [
                for (final c in rows)
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: scheme.secondaryContainer,
                        child: Text(c.emoji, style: const TextStyle(fontSize: 20)),
                      ),
                      title: Text(c.name),
                      onTap: () => showCategoryEditor(context, ref, existing: c),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_outline, color: scheme.error),
                        tooltip: l10n.delete,
                        onPressed: () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(l10n.categoryDeleteQ(c.name)),
                              content: Text(l10n.categoryDeleteBody),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
                                FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.delete)),
                              ],
                            ),
                          );
                          if (ok == true) await ref.read(appDatabaseProvider).customCategoriesDao.remove(c.id);
                        },
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
