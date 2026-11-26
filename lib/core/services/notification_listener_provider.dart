import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/providers.dart';
import '../notifications/local_notification_scheduler.dart';
import '../notifications/notification_channels.dart';
import '../storage/app_database.dart';
import '../../features/khata/background/budget_check.dart';
import '../../features/khata/domain/entities/expense_category.dart';
import 'notification_capture_service.dart';

part 'notification_listener_provider.g.dart';

/// Drains the native capture queue on start and whenever the listener pings.
@Riverpod(keepAlive: true)
Stream<void> notificationListenerStream(Ref ref) async* {
  final db = ref.read(appDatabaseProvider);
  await drainCaptureQueue(db);
  await for (final _ in NotificationCaptureService.wakeUps) {
    await drainCaptureQueue(db);
  }
}

Future<void> _lastDrain = Future.value();

/// Saves everything waiting in the native queue. Calls are chained so two
/// drains never run at once (that could insert the same transaction twice).
Future<void> drainCaptureQueue(AppDatabase db) {
  return _lastDrain = _lastDrain.then((_) => _drainOnce(db)).catchError((Object e, StackTrace st) {
    debugPrint('Capture drain failed: $e\n$st');
  });
}

Future<void> _drainOnce(AppDatabase db) async {
  final items = await NotificationCaptureService.peekQueue();
  if (items.isEmpty) return;
  final handled = await processQueued(items, db.expensesDao, onSaved: (tx, category) {
    unawaited(_announce(tx));
    if (!tx.isCredit) {
      final ym = DateFormat('yyyy-MM').format(tx.timestamp);
      unawaited(checkBudgetAndNotify(
        db: db,
        yearMonth: ym,
        category: ExpenseCategory.fromString(category),
        addedAmount: tx.amount,
      ));
    }
  });
  await NotificationCaptureService.ackQueue(handled);
}

/// On resume: drain, and if Android dropped the listener, ask it to reconnect.
Future<void> refreshCapture(AppDatabase db) async {
  final health = await NotificationCaptureService.health();
  if (health.hasAccess && !health.connected) await NotificationCaptureService.rebind();
  await drainCaptureQueue(db);
}

Future<void> _announce(NotificationTransaction tx) async {
  try {
    final amtFmt = NumberFormat('#,##0', 'en');
    final sign = tx.isCredit ? '+' : '-';
    final plugin = FlutterLocalNotificationsPlugin();
    await LocalNotificationScheduler.initialize(plugin);
    await LocalNotificationScheduler(plugin).showNow(
      id: tx.id.hashCode & 0x7fffffff,
      title: '${tx.bankName} transaction saved',
      body: '${sign}Rs ${amtFmt.format(tx.amount)} added to your Bank tab',
      channelId: NotificationChannels.khataAlert,
    );
  } catch (e) {
    debugPrint('Capture announcement failed: $e');
  }
}
