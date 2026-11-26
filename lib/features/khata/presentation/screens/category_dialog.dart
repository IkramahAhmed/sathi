import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../core/storage/app_database.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/expense_category.dart';
import '../providers/khata_providers.dart';

const _emojis = [
  '🛒', '📱', '🎓', '🎁', '🐄', '⛽', '🧴', '💊', '🍽️', '☕', '🎮', '✈️',
  '🧾', '🔧', '👶', '🏠', '🚗', '📚', '💇', '🕌', '🧺', '🪙', '🎉', '🏷️',
];

/// Asks for a name and an icon, saves the category, and returns its key (`c<id>`),
/// or null when cancelled. With [existing] it edits that category instead.
Future<String?> showCategoryEditor(
  BuildContext context,
  WidgetRef ref, {
  CustomCategory? existing,
}) async {
  final l10n = AppLocalizations.of(context);
  final name = TextEditingController(text: existing?.name ?? '');
  var emoji = existing?.emoji ?? _emojis.first;
  String? error;
  final dao = ref.read(appDatabaseProvider).customCategoriesDao;
  final taken = ref
      .read(categoryCatalogProvider)
      .all
      .where((c) => c.key != 'c${existing?.id}')
      .map((c) => c.label(l10n).toLowerCase())
      .toSet()
    // The built-in names in English too, whatever language the app is in.
    ..addAll(ExpenseCategory.values.map((c) => c.name));

  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: Text(existing == null ? l10n.categoryNew : l10n.edit),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: name,
                autofocus: true,
                maxLength: 24,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(labelText: l10n.categoryName, errorText: error),
              ),
              const SizedBox(height: 8),
              Text(l10n.categoryPickIcon, style: Theme.of(ctx).textTheme.labelMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final e in _emojis)
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => setState(() => emoji = e),
                      child: Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: emoji == e ? Theme.of(ctx).colorScheme.primaryContainer : null,
                        ),
                        child: Text(e, style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () {
              final value = name.text.trim();
              if (value.isEmpty) return;
              if (taken.contains(value.toLowerCase())) {
                setState(() => error = l10n.categoryNameTaken);
                return;
              }
              Navigator.pop(ctx, true);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    ),
  );

  final value = name.text.trim();
  name.dispose();
  if (ok != true || value.isEmpty) return null;

  if (existing != null) {
    await dao.updateCategory(existing.id, name: value, emoji: emoji);
    return 'c${existing.id}';
  }
  final id = await dao.add(CustomCategoriesCompanion.insert(
    name: value,
    emoji: Value(emoji),
    createdAt: DateTime.now().toUtc(),
  ));
  return 'c$id';
}
