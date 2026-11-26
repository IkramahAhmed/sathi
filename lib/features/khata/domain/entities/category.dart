import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import 'expense_category.dart';

const _customColors = [
  Color(0xFF3949AB),
  Color(0xFF00897B),
  Color(0xFFF4511E),
  Color(0xFF8E24AA),
  Color(0xFF7CB342),
  Color(0xFFD81B60),
  Color(0xFF039BE5),
  Color(0xFFFFB300),
];

/// What an entry's category can be: one of the built-in ones, or one the user made.
/// Entries store [key]: the built-in name (`food`) or `c<id>` for a custom one.
class Category {
  Category.builtIn(ExpenseCategory value)
      : key = value.name,
        builtIn = value,
        customName = null,
        emoji = null,
        _colorSeed = 0;

  Category.custom({required int id, required String name, required String this.emoji})
      : key = 'c$id',
        builtIn = null,
        customName = name,
        _colorSeed = id;

  final String key;
  final ExpenseCategory? builtIn;
  final String? customName;
  final String? emoji;
  final int _colorSeed;

  bool get isCustom => builtIn == null;

  String label(AppLocalizations l10n) => builtIn?.label(l10n) ?? customName ?? '';

  /// A name that needs no translations, for PDF and CSV exports.
  String get plainName => builtIn?.name ?? customName ?? ExpenseCategory.other.name;

  Widget iconWidget({double size = 20, Color? color}) => builtIn != null
      ? Icon(builtIn!.icon, size: size, color: color)
      : Text(emoji ?? '🏷️', style: TextStyle(fontSize: size * 0.9));

  Color get color => switch (builtIn) {
        ExpenseCategory.food => const Color(0xFFFF8F00),
        ExpenseCategory.transport => const Color(0xFF1565C0),
        ExpenseCategory.rent => const Color(0xFF00695C),
        ExpenseCategory.health => const Color(0xFFC62828),
        ExpenseCategory.bills => const Color(0xFF6A1B9A),
        ExpenseCategory.shopping => const Color(0xFFAD1457),
        ExpenseCategory.other => const Color(0xFF546E7A),
        null => _customColors[_colorSeed % _customColors.length],
      };

  @override
  bool operator ==(Object other) => other is Category && other.key == key;

  @override
  int get hashCode => key.hashCode;
}

/// Every category available right now: the built-in ones, the user's own, and Other last.
class CategoryCatalog {
  CategoryCatalog(List<Category> custom)
      : custom = List.unmodifiable(custom),
        all = List.unmodifiable([
          for (final c in ExpenseCategory.values)
            if (c != ExpenseCategory.other) Category.builtIn(c),
          ...custom,
          Category.builtIn(ExpenseCategory.other),
        ]);

  final List<Category> custom;
  final List<Category> all;

  /// The category for a stored key. Unknown keys (for example a deleted category)
  /// show as Other.
  Category resolve(String key) =>
      all.firstWhere((c) => c.key == key, orElse: () => Category.builtIn(ExpenseCategory.other));
}
