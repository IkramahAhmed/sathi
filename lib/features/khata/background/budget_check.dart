import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/notifications/local_notification_scheduler.dart';
import '../../../core/notifications/notification_channels.dart';
import '../../../core/storage/app_database.dart';
import '../domain/entities/expense_category.dart';

/// Call after every expense save. Fires a notification if the category just
/// crossed its budget threshold (previous total was under, new total is over).
Future<void> checkBudgetAndNotify({
  required AppDatabase db,
  required String yearMonth,
  required ExpenseCategory category,
  required double addedAmount,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final budget = prefs.getDouble('khata_budget_${category.name}') ?? 0;
  if (budget <= 0) return;

  final includeBank = prefs.getBool('khata_count_bank') ?? true;
  final entries = await db.expensesDao
      .getMonthFrom(yearMonth, includeBank ? ['manual', 'bank'] : ['manual']);
  final total = entries
      .where((e) => e.type != 'income' && e.category == category.name)
      .fold(0.0, (s, e) => s + e.amount);

  final previousTotal = total - addedAmount;
  final pct = total / budget;
  final prevPct = previousTotal / budget;

  // Fire at 80% crossing and at 100% crossing — one notification each.
  final crossed80 = prevPct < 0.8 && pct >= 0.8 && pct < 1.0;
  final crossed100 = prevPct < 1.0 && pct >= 1.0;
  if (!crossed80 && !crossed100) return;

  final fmt = NumberFormat('#,##0', 'en');
  final plugin = FlutterLocalNotificationsPlugin();
  await LocalNotificationScheduler.initialize(plugin);

  final label = _catLabel(category);
  final body = 'Rs ${fmt.format(total.round())} of Rs ${fmt.format(budget.round())} used';

  if (crossed80) {
    await plugin.show(
      id: 8780 + category.index,
      title: '80% budget used — $label',
      body: body,
      notificationDetails: _details(),
    );
  } else {
    await plugin.show(
      id: 8800 + category.index,
      title: 'Budget exceeded — $label',
      body: body,
      notificationDetails: _details(),
    );
  }
}

NotificationDetails _details() => const NotificationDetails(
      android: AndroidNotificationDetails(
        NotificationChannels.khataAlert,
        'Budget alerts',
        channelDescription: 'Notifies when a spending category exceeds its budget',
        icon: NotificationChannels.drawableIcon,
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

String _catLabel(ExpenseCategory cat) => switch (cat) {
      ExpenseCategory.food => 'Food',
      ExpenseCategory.transport => 'Transport',
      ExpenseCategory.rent => 'Rent',
      ExpenseCategory.health => 'Health',
      ExpenseCategory.bills => 'Bills',
      ExpenseCategory.shopping => 'Shopping',
      ExpenseCategory.other => 'Other',
    };
