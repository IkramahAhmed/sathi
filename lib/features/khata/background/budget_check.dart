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

  final entries = await db.expensesDao.getMonth(yearMonth);
  final total = entries
      .where((e) => e.type != 'income' && e.category == category.name)
      .fold(0.0, (s, e) => s + e.amount);

  final previousTotal = total - addedAmount;
  if (previousTotal >= budget || total < budget) return;

  final fmt = NumberFormat('#,##0', 'en');
  final plugin = FlutterLocalNotificationsPlugin();
  await LocalNotificationScheduler.initialize(plugin);
  await plugin.show(
    id: 8800 + category.index,
    title: 'Budget exceeded — ${_catLabel(category)}',
    body: 'Rs ${fmt.format(total.round())} spent / Rs ${fmt.format(budget.round())} budget',
    notificationDetails: NotificationDetails(
      android: AndroidNotificationDetails(
        NotificationChannels.khataAlert,
        'Budget alerts',
        channelDescription: 'Notifies when a spending category exceeds its budget',
        icon: NotificationChannels.drawableIcon,
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
  );
}

String _catLabel(ExpenseCategory cat) => switch (cat) {
      ExpenseCategory.food => 'Food',
      ExpenseCategory.transport => 'Transport',
      ExpenseCategory.rent => 'Rent',
      ExpenseCategory.health => 'Health',
      ExpenseCategory.bills => 'Bills',
      ExpenseCategory.shopping => 'Shopping',
      ExpenseCategory.other => 'Other',
    };
