import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/notifications/local_notification_scheduler.dart';
import '../../../core/notifications/notification_channels.dart';
import '../../../core/storage/app_database.dart';
import '../../../core/utils/logger.dart';
import '../domain/overdue.dart';

/// Action ID for the "Send WhatsApp reminder" button on overdue notifications.
const String kUdhaarWaActionId = 'udhaar_wa';

/// Payload type tag used to route notification taps in saathi_app.dart.
const String kUdhaarOverdueType = 'udhaar_overdue';

// SharedPreferences key prefixes for recurring reminder state.
const _kSincePrefix = 'udhaar_overdue_since_';
const _kLastDayPrefix = 'udhaar_last_notif_day_';

/// Returns the notification milestone (in days) for the current overdue count.
/// Schedule: day 1, 3, 7, then every 7 days (14, 21, 28 …).
int _currentMilestone(int daysOverdue) {
  if (daysOverdue < 1) return 0;
  if (daysOverdue < 3) return 1;
  if (daysOverdue < 7) return 3;
  return 7 + ((daysOverdue - 7) ~/ 7) * 7;
}

/// Human-readable overdue label used in the notification body.
String _overdueLabel(int days) {
  if (days <= 1) return 'aaj';
  if (days < 7) return '$days din se';
  if (days == 7) return 'ek hafte se';
  final weeks = days ~/ 7;
  return '$weeks hafte se';
}

/// Checks for overdue Udhaar contacts and fires graduated follow-up reminders.
///
/// Reminder schedule per contact (from first overdue detection):
///   Day 1 → gentle nudge
///   Day 3 → follow-up
///   Day 7 → weekly alert
///   Day 14, 21, 28 … → continues weekly until settled
///
/// Set [ignoreDate] to skip the date check — useful for the Settings test button.
Future<void> runHeadlessUdhaarCheck({bool ignoreDate = false}) async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  try {
    final entries = await db.udhaarDao.getAllEntries();
    final overdue = ignoreDate
        ? _overdueIgnoringDate(entries)
        : overdueByContact(entries);

    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayStr =
        '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    // Clean up tracking for contacts that are no longer overdue (settled/deleted).
    final trackedIds = prefs.getKeys()
        .where((k) => k.startsWith(_kSincePrefix))
        .map((k) => int.tryParse(k.substring(_kSincePrefix.length)))
        .whereType<int>()
        .toSet();
    for (final id in trackedIds) {
      if (!overdue.containsKey(id)) {
        await prefs.remove('$_kSincePrefix$id');
        await prefs.remove('$_kLastDayPrefix$id');
      }
    }

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
      final sinceKey = '$_kSincePrefix${contact.id}';
      final lastDayKey = '$_kLastDayPrefix${contact.id}';

      // Record the first day this contact became overdue (never overwrite).
      final sinceStr = prefs.getString(sinceKey) ?? todayStr;
      if (!prefs.containsKey(sinceKey)) {
        await prefs.setString(sinceKey, sinceStr);
      }

      final since = DateTime.tryParse(sinceStr) ?? today;
      final daysOverdue = today.difference(DateTime(since.year, since.month, since.day)).inDays;
      final milestone = _currentMilestone(daysOverdue);
      final lastNotifiedDay = prefs.getInt(lastDayKey) ?? -1;

      // Skip if we already fired a notification at this milestone.
      if (milestone == 0 || milestone <= lastNotifiedDay) {
        appLog.info(
            'Udhaar check: ${contact.name} at day $daysOverdue (milestone $milestone) — skipping, last notified at $lastNotifiedDay');
        continue;
      }

      final amountStr = 'Rs ${fmt.format(balance)}';
      final label = _overdueLabel(daysOverdue);

      final payload = jsonEncode({
        'type': kUdhaarOverdueType,
        'contact_id': contact.id,
        'name': contact.name,
        'phone': contact.phone,
        'balance': balance,
      });

      // Unique notification ID per contact (offset 9100 to avoid clashes).
      final notifId = 9100 + contact.id;

      await plugin.show(
        id: notifId,
        title: '${contact.name} — $amountStr wapis nahi hua',
        body: '${contact.name} $label pesa wapis nahi kiya — reminder bhejein?',
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

      await prefs.setInt(lastDayKey, milestone);
      appLog.info(
          'Udhaar overdue notification shown for: ${contact.name} (day $daysOverdue, milestone $milestone)');
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
