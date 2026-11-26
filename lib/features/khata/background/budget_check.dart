import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/notifications/local_notification_scheduler.dart';
import '../../../core/notifications/notification_channels.dart';
import '../../../core/storage/app_database.dart';

/// Call after every expense save. Fires a notification if the category just
/// crossed its budget threshold (previous total was under, new total is over).
Future<void> checkBudgetAndNotify({
  required AppDatabase db,
  required String yearMonth,
  required String categoryKey,
  required double addedAmount,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final budget = prefs.getDouble('khata_budget_$categoryKey') ?? 0;
  if (budget <= 0) return;

  final includeBank = prefs.getBool('khata_count_bank') ?? true;
  final entries = await db.expensesDao
      .getMonthFrom(yearMonth, includeBank ? ['manual', 'bank'] : ['manual']);
  final total = entries
      .where((e) => e.type != 'income' && e.category == categoryKey)
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

  final label = await _catLabel(db, categoryKey);
  final ids = _notificationIds(categoryKey);
  final body = 'Rs ${fmt.format(total.round())} of Rs ${fmt.format(budget.round())} used';

  if (crossed80) {
    await plugin.show(
      id: ids.warn,
      title: '80% budget used — $label',
      body: body,
      notificationDetails: _details(),
    );
  } else {
    await plugin.show(
      id: ids.over,
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

/// The category's name for the alert. Built-in names are English here because the
/// alert can fire while the app is closed; a custom category shows the name the user gave it.
Future<String> _catLabel(AppDatabase db, String key) async {
  if (key.startsWith('c')) {
    final id = int.tryParse(key.substring(1));
    if (id != null) {
      final row = await (db.select(db.customCategories)..where((t) => t.id.equals(id))).getSingleOrNull();
      if (row != null) return row.name;
    }
    return 'Other';
  }
  return switch (key) {
    'food' => 'Food',
    'transport' => 'Transport',
    'rent' => 'Rent',
    'health' => 'Health',
    'bills' => 'Bills',
    'shopping' => 'Shopping',
    _ => 'Other',
  };
}

/// One 80% alert and one 100% alert per category. Built-in categories keep the ids
/// they always had; custom ones use their own range, clear of prayer reminders.
({int warn, int over}) _notificationIds(String key) {
  const builtIn = ['food', 'transport', 'rent', 'health', 'bills', 'shopping', 'other'];
  final i = builtIn.indexOf(key);
  if (i >= 0) return (warn: 8780 + i, over: 8800 + i);
  final id = int.tryParse(key.startsWith('c') ? key.substring(1) : '') ?? 0;
  return (warn: 120000 + id * 2, over: 120000 + id * 2 + 1);
}
