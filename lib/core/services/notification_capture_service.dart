import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _channel = MethodChannel('com.ikramah.saathi/native');
const _eventChannel = EventChannel('com.ikramah.saathi/notifications');
const _capturedIdsKey = 'notification_captured_ids';

class NotificationCaptureService {
  /// Stream of raw notification events from the native side.
  static Stream<Map<String, dynamic>> get notificationStream =>
      _eventChannel.receiveBroadcastStream().map((e) => Map<String, dynamic>.from(e as Map));
  /// True if the user has granted notification listener access.
  static Future<bool> hasAccess() async {
    try {
      return await _channel.invokeMethod<bool>('hasNotificationAccess') ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Opens Android Settings → Notification Access so user can enable it.
  static Future<void> openSettings() async {
    await _channel.invokeMethod('openNotificationAccessSettings');
  }

  // ── Deduplication ───────────────────────────────────────────────────────────

  static Future<Set<String>> _loadCapturedIds() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_capturedIdsKey) ?? []).toSet();
  }

  static Future<void> markCaptured(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_capturedIdsKey) ?? [];
    if (!existing.contains(id)) {
      await prefs.setStringList(_capturedIdsKey, [...existing, id]);
    }
  }

  static Future<bool> alreadyCaptured(String id) async {
    final ids = await _loadCapturedIds();
    return ids.contains(id);
  }
}

/// Represents a transaction parsed from a notification.
class NotificationTransaction {
  const NotificationTransaction({
    required this.id,
    required this.packageName,
    required this.bankName,
    required this.title,
    required this.body,
    required this.amount,
    required this.isCredit,
    required this.timestamp,
  });

  final String id;
  final String packageName;
  final String bankName;
  final String title;
  final String body;
  final double amount;
  final bool isCredit;
  final DateTime timestamp;
}

/// Parse a raw notification into a transaction (or null if not a transaction).
NotificationTransaction? parseNotification({
  required String packageName,
  required String title,
  required String body,
  required int timeMs,
}) {
  final combined = '$title $body';
  final amount = _extractAmount(combined);
  if (amount == null || amount <= 0) return null;

  final isCredit = _isCredit(combined);
  final bankName = _bankName(packageName, title);
  final id = '${packageName}_${timeMs}';
  final timestamp = DateTime.fromMillisecondsSinceEpoch(timeMs);

  return NotificationTransaction(
    id: id,
    packageName: packageName,
    bankName: bankName,
    title: title,
    body: body,
    amount: amount,
    isCredit: isCredit,
    timestamp: timestamp,
  );
}

double? _extractAmount(String text) {
  // Matches: Rs. 5,000 / PKR 5000 / Rs 1,500.00 / 5,000 PKR
  final patterns = [
    RegExp(r'(?:Rs\.?|PKR)\s*([0-9,]+(?:\.[0-9]{1,2})?)', caseSensitive: false),
    RegExp(r'([0-9,]+(?:\.[0-9]{1,2})?)\s*(?:Rs\.?|PKR)', caseSensitive: false),
  ];
  for (final pattern in patterns) {
    final match = pattern.firstMatch(text);
    if (match != null) {
      final raw = match.group(1)!.replaceAll(',', '');
      return double.tryParse(raw);
    }
  }
  return null;
}

bool _isCredit(String text) {
  final lower = text.toLowerCase();
  final creditWords = ['credited', 'received', 'credit', 'deposited', 'added', 'transfer in'];
  final debitWords = ['debited', 'debit', 'withdrawn', 'paid', 'sent', 'transfer out', 'payment'];
  if (creditWords.any(lower.contains)) return true;
  if (debitWords.any(lower.contains)) return false;
  return false; // default to debit if ambiguous
}

String _bankName(String packageName, String title) {
  const pkgToBank = {
    'com.hbl.android': 'HBL',
    'com.meezan.internetbanking': 'Meezan',
    'invo8.meezan.mb': 'Meezan',
    'com.ubl.ubldirectapp': 'UBL',
    'com.mcb.android': 'MCB',
    'com.alfalahbankapp': 'Alfalah',
    'com.jazzcash.android': 'JazzCash',
    'com.easypaisa.app': 'EasyPaisa',
    'com.sadapay.app': 'SadaPay',
    'com.nayapay.android': 'NayaPay',
    'com.dibpak.android': 'DIB',
    'com.askaribank.android': 'Askari',
    'com.jsbl.android': 'JS Bank',
    'com.faysalbank.android': 'Faysal',
    'com.bankalhabib.android': 'Al Habib',
    'com.scb.android': 'SCB',
    'com.abl.android': 'Allied',
  };
  return pkgToBank[packageName] ?? title.split(' ').first;
}
