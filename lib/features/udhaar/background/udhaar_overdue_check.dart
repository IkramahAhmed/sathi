import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

import '../../../core/notifications/local_notification_scheduler.dart';
import '../../../core/notifications/notification_channels.dart';
import '../../../core/storage/app_database.dart';
import '../../../core/utils/logger.dart';
import '../domain/overdue.dart';

/// Action ID for the "Send WhatsApp reminder" button on overdue notifications.
const String kUdhaarWaActionId = 'udhaar_wa';

/// Payload type tag used to route notification taps in saathi_app.dart.
const String kUdhaarOverdueType = 'udhaar_overdue';

/// Checks for overdue Udhaar contacts and fires one notification per contact.
/// Each notification has a "Send reminder" action that opens WhatsApp.
/// Set [ignoreDate] to skip the date check — useful for the Settings test button.
Future<void> runHeadlessUdhaarCheck({bool ignoreDate = false}) async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  try {
    final entries = await db.udhaarDao.getAllEntries();
    final overdue = ignoreDate
        ? _overdueIgnoringDate(entries)
        : overdueByContact(entries);
    if (overdue.isEmpty) {
      appLog.info('Udhaar check: no overdue contacts');
      return;
    }

    final contacts = await db.udhaarDao.getAllContacts();
    final plugin = FlutterLocalNotificationsPlugin();
    await LocalNotificationScheduler.initialize(plugin);

    final fmt = NumberFormat('#,##0', 'en');

    for (final contact in contacts.where((c) => overdue.containsKey(c.id))) {
      final balance = overdue[contact.id]!;
      final amountStr = 'Rs ${fmt.format(balance)}';
      final payload = jsonEncode({
        'type': kUdhaarOverdueType,
        'contact_id': contact.id,
        'name': contact.name,
        'phone': contact.phone,
        'balance': balance,
      });

      // Unique notification ID per contact (offset from 9100 to avoid clashing with other notif IDs).
      final notifId = 9100 + contact.id;

      await plugin.show(
        id: notifId,
        title: '${contact.name} — Pesa wapis nahi hua',
        body: '$amountStr abhi tak wapis nahi aaya',
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            NotificationChannels.udhaarOverdue,
            'Udhaar reminders',
            channelDescription: 'Reminds you when someone has not returned your money',
            icon: NotificationChannels.drawableIcon,
            importance: Importance.high,
            priority: Priority.high,
            category: AndroidNotificationCategory.reminder,
            actions: [
              const AndroidNotificationAction(
                kUdhaarWaActionId,
                'Send reminder',
                showsUserInterface: true,
                cancelNotification: true,
              ),
            ],
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBanner: true,
            presentList: true,
          ),
        ),
        payload: payload,
      );
      appLog.info('Udhaar overdue notification shown for: ${contact.name}');
    }
  } catch (error, stackTrace) {
    appLog.warning('Udhaar overdue check failed', error, stackTrace);
  } finally {
    await db.close();
  }
}

/// Returns all contacts who have a positive balance and at least one `gave`
/// entry with a due date — ignoring whether that date has passed.
/// Used for the Settings test button only.
Map<int, double> _overdueIgnoringDate(List<UdhaarEntry> entries) {
  final balance = <int, double>{};
  final hasDue = <int, bool>{};
  for (final e in entries) {
    balance[e.contactId] = (balance[e.contactId] ?? 0) +
        (e.type == 'gave' ? e.amount : -e.amount);
    if (e.type == 'gave' && e.dueDate != null) {
      hasDue[e.contactId] = true;
    }
  }
  return {
    for (final id in hasDue.keys)
      if ((balance[id] ?? 0) > 0) id: balance[id]!,
  };
}
