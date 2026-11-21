import 'package:drift/drift.dart' show Value;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/providers.dart';
import '../notifications/local_notification_scheduler.dart';
import '../notifications/notification_channels.dart';
import '../storage/app_database.dart';
import 'notification_capture_service.dart';

part 'notification_listener_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<void> notificationListenerStream(Ref ref) async* {
  final db = ref.read(appDatabaseProvider);
  final dao = db.expensesDao;
  final fmt = DateFormat('yyyy-MM-dd');

  await for (final event in NotificationCaptureService.notificationStream) {
    try {
      final pkg = event['package'] as String? ?? '';
      final title = event['title'] as String? ?? '';
      final body = event['body'] as String? ?? '';
      final timeMs = (event['time'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch;

      final tx = parseNotification(
        packageName: pkg,
        title: title,
        body: body,
        timeMs: timeMs,
      );
      if (tx == null) continue;

      if (await NotificationCaptureService.alreadyCaptured(tx.id)) continue;

      final date = fmt.format(tx.timestamp);
      final note = '${tx.bankName}: $body';

      final saved = await dao.addIfNew(ExpensesCompanion.insert(
        amount: tx.amount,
        date: date,
        type: Value(tx.isCredit ? 'income' : 'expense'),
        category: tx.isCredit ? 'salary' : 'other',
        note: Value(note),
        source: const Value('bank'),
        createdAt: tx.timestamp,
      ));
      await NotificationCaptureService.markCaptured(tx.id);

      if (saved) {
        final amtFmt = NumberFormat('#,##0', 'en');
        final sign = tx.isCredit ? '+' : '-';
        final plugin = FlutterLocalNotificationsPlugin();
        await LocalNotificationScheduler.initialize(plugin);
        final scheduler = LocalNotificationScheduler(plugin);
        await scheduler.showNow(
          id: tx.id.hashCode & 0x7fffffff,
          title: '${tx.bankName} transaction saved',
          body: '${sign}Rs ${amtFmt.format(tx.amount)} added to your Bank tab',
          channelId: NotificationChannels.khataAlert,
        );
      }
    } catch (_) {}
  }
}
