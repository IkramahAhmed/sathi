import 'package:drift/drift.dart' show Value;
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/providers.dart';
import '../storage/app_database.dart';
import 'notification_capture_service.dart';

part 'notification_listener_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<void> notificationListenerStream(Ref ref) async* {
  final db = ref.read(appDatabaseProvider);
  final dao = db.expensesDao;
  final fmt = DateFormat('yyyy-MM-dd');

  await for (final event in NotificationCaptureService.notificationStream) {
    // ignore: avoid_print
    print('[Saathi] notificationListenerStream: got event $event');
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

      await dao.addIfNew(ExpensesCompanion.insert(
        amount: tx.amount,
        date: date,
        type: Value(tx.isCredit ? 'income' : 'expense'),
        category: tx.isCredit ? 'salary' : 'other',
        note: Value(note),
        createdAt: tx.timestamp,
      ));
      await NotificationCaptureService.markCaptured(tx.id);
    } catch (_) {}
  }
}
