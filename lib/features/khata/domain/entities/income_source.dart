import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

enum IncomeSource {
  salary,
  freelance,
  business,
  gift,
  other;

  static IncomeSource fromString(String s) =>
      IncomeSource.values.firstWhere((e) => e.name == s, orElse: () => other);

  String label(AppLocalizations l10n) => switch (this) {
        salary => l10n.incomeSourceSalary,
        freelance => l10n.incomeSourceFreelance,
        business => l10n.incomeSourceBusiness,
        gift => l10n.incomeSourceGift,
        other => l10n.incomeSourceOther,
      };

  IconData get icon => switch (this) {
        salary => Icons.work_outline,
        freelance => Icons.laptop_outlined,
        business => Icons.store_outlined,
        gift => Icons.card_giftcard_outlined,
        other => Icons.attach_money,
      };
}
