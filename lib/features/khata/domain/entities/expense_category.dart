import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

enum ExpenseCategory {
  food,
  transport,
  rent,
  health,
  bills,
  shopping,
  other;

  static ExpenseCategory fromString(String s) =>
      ExpenseCategory.values.firstWhere((e) => e.name == s, orElse: () => other);

  String label(AppLocalizations l10n) => switch (this) {
        food => l10n.khataCatFood,
        transport => l10n.khataCatTransport,
        rent => l10n.khataCatRent,
        health => l10n.khataCatHealth,
        bills => l10n.khataCatBills,
        shopping => l10n.khataCatShopping,
        other => l10n.khataCatOther,
      };

  IconData get icon => switch (this) {
        food => Icons.restaurant_outlined,
        transport => Icons.directions_car_outlined,
        rent => Icons.home_outlined,
        health => Icons.medication_outlined,
        bills => Icons.receipt_outlined,
        shopping => Icons.shopping_bag_outlined,
        other => Icons.more_horiz,
      };
}
