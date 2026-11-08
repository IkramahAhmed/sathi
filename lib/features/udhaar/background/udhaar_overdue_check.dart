import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../core/notifications/local_notification_scheduler.dart';
import '../../../core/notifications/notification_channels.dart';
import '../../../core/storage/app_database.dart';
import '../../../core/utils/logger.dart';
import '../domain/overdue.dart';

const int _kNotifId = 9001;

/// Checks for overdue Udhaar contacts and shows a notification if any exist.
/// Safe to call from both the UI isolate and the WorkManager background isolate.
Future<void> runHeadlessUdhaarCheck() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  try {
    final entries = await db.udhaarDao.getAllEntries();
    final overdue = overdueByContact(entries);
    if (overdue.isEmpty) {
      appLog.info('Udhaar check: no overdue contacts');
      return;
    }

    final contacts = await db.udhaarDao.getAllContacts();
    final names = contacts
        .where((c) => overdue.containsKey(c.id))
        .map((c) => c.name)
        .join(', ');

    final plugin = FlutterLocalNotificationsPlugin();
    await LocalNotificationScheduler.initialize(plugin);
    await plugin.show(
      id: _kNotifId,
      title: 'Udhaar — Pesa wapis nahi hua',
      body: names,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationChannels.udhaarOverdue,
          'Udhaar reminders',
          channelDescription: 'Reminds you when someone has not returned your money',
          icon: NotificationChannels.drawableIcon,
          importance: Importance.high,
          priority: Priority.high,
          category: AndroidNotificationCategory.reminder,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBanner: true,
          presentList: true,
        ),
      ),
      payload: 'udhaar_overdue',
    );
    appLog.info('Udhaar overdue notification shown for: $names');
  } catch (error, stackTrace) {
    appLog.warning('Udhaar overdue check failed', error, stackTrace);
  } finally {
    await db.close();
  }
}
