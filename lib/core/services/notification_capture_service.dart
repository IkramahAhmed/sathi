import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../storage/app_database.dart';
import '../storage/daos.dart';

const _channel = MethodChannel('com.ikramah.saathi/native');
const _eventChannel = EventChannel('com.ikramah.saathi/notifications');
const _capturedIdsKey = 'notification_captured_ids';

/// One notification waiting in the native capture queue.
class QueuedNotification {
  const QueuedNotification({
    required this.id,
    required this.packageName,
    required this.title,
    required this.body,
    required this.timeMs,
  });

  factory QueuedNotification.fromMap(Map<Object?, Object?> m) => QueuedNotification(
        id: m['id'] as String? ?? '',
        packageName: m['package'] as String? ?? '',
        title: m['title'] as String? ?? '',
        body: m['body'] as String? ?? '',
        timeMs: (m['time'] as num?)?.toInt() ?? 0,
      );

  final String id;
  final String packageName;
  final String title;
  final String body;
  final int timeMs;
}

/// Whether the native listener is actually running, not just permitted.
class CaptureHealth {
  const CaptureHealth({
    required this.hasAccess,
    required this.connected,
    required this.lastCandidateAt,
    required this.pending,
  });

  final bool hasAccess;
  final bool connected;
  final DateTime? lastCandidateAt;
  final int pending;
}

class NotificationCaptureService {
  /// Fires whenever the native listener queued something new.
  static Stream<void> get wakeUps => _eventChannel.receiveBroadcastStream().map((_) {});

  static Future<List<QueuedNotification>> peekQueue() async {
    final raw = await _channel.invokeListMethod<Object?>('peekCaptureQueue') ?? const [];
    return [for (final m in raw) QueuedNotification.fromMap(m! as Map<Object?, Object?>)];
  }

  /// Removes items from the native queue. Call only after they are handled.
  static Future<void> ackQueue(List<String> ids) async {
    if (ids.isEmpty) return;
    await _channel.invokeMethod('ackCaptureQueue', {'ids': ids});
  }

  static Future<CaptureHealth> health() async {
    final access = await hasAccess();
    try {
      final m = await _channel.invokeMapMethod<String, Object?>('captureHealth') ?? const {};
      final last = (m['lastCandidateAt'] as num?)?.toInt() ?? 0;
      return CaptureHealth(
        hasAccess: access,
        connected: m['connected'] as bool? ?? false,
        lastCandidateAt: last > 0 ? DateTime.fromMillisecondsSinceEpoch(last) : null,
        pending: (m['pending'] as num?)?.toInt() ?? 0,
      );
    } catch (_) {
      return CaptureHealth(hasAccess: access, connected: false, lastCandidateAt: null, pending: 0);
    }
  }

  /// Asks Android to reconnect the listener (it can drop after app updates).
  static Future<void> rebind() async {
    try {
      await _channel.invokeMethod('rebindCaptureListener');
    } catch (_) {}
  }

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
    if (existing.contains(id)) return;
    final updated = [...existing, id];
    // The DB dedup is the real safety net; this list only skips exact re-posts.
    const maxIds = 500;
    await prefs.setStringList(
      _capturedIdsKey,
      updated.length > maxIds ? updated.sublist(updated.length - maxIds) : updated,
    );
  }

  static Future<bool> alreadyCaptured(String id) async {
    final ids = await _loadCapturedIds();
    return ids.contains(id);
  }
}

/// Saves queued notifications as bank transactions.
///
/// Returns the ids that are fully handled (saved, duplicate, or not a
/// transaction) and so can be removed from the queue. An item whose save threw
/// is left out, so it is retried on the next drain.
Future<List<String>> processQueued(
  List<QueuedNotification> items,
  ExpensesDao dao, {
  void Function(NotificationTransaction tx)? onSaved,
}) async {
  final fmt = DateFormat('yyyy-MM-dd');
  final handled = <String>[];
  for (final item in items) {
    try {
      final tx = parseNotification(
        packageName: item.packageName,
        title: item.title,
        body: item.body,
        timeMs: item.timeMs,
      );
      // Catch-up re-delivers whatever is still in the shade, possibly hours
      // later, so the id check matters beyond the DB's 10-minute window.
      if (tx != null && !await NotificationCaptureService.alreadyCaptured(item.id)) {
        final saved = await dao.addIfNew(ExpensesCompanion.insert(
          amount: tx.amount,
          date: fmt.format(tx.timestamp),
          type: Value(tx.isCredit ? 'income' : 'expense'),
          category: tx.isCredit ? 'salary' : 'other',
          note: Value('${tx.bankName}: ${item.body}'),
          source: const Value('bank'),
          createdAt: tx.timestamp,
        ));
        await NotificationCaptureService.markCaptured(item.id);
        if (saved) onSaved?.call(tx);
      }
      handled.add(item.id);
    } catch (e, st) {
      debugPrint('Bank capture failed for ${item.packageName}: $e\n$st');
    }
  }
  return handled;
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

const _ownPackage = 'com.ikramah.saathi';

/// Parse a raw notification into a transaction (or null if not a transaction).
NotificationTransaction? parseNotification({
  required String packageName,
  required String title,
  required String body,
  required int timeMs,
}) {
  if (packageName == _ownPackage || _ignoredPackages.contains(packageName)) return null;

  final combined = '$title $body';
  final lower = combined.toLowerCase();
  if (_isNotATransaction(lower)) return null;
  // Bank apps only notify about money, but other apps (SMS, email) also carry
  // promos and chats with amounts, so they must name an actual money movement.
  if (!_pkgToBank.containsKey(packageName) && !_hasMoneyVerb(lower)) return null;

  final amount = _extractAmount(combined);
  if (amount == null || amount < 1) return null;

  final baseName = _bankName(packageName, title);
  final suffix = _extractAccountSuffix(body);
  return NotificationTransaction(
    id: '${packageName}_$timeMs',
    packageName: packageName,
    bankName: suffix != null ? '$baseName **$suffix' : baseName,
    title: title,
    body: body,
    amount: amount,
    isCredit: _isCredit(lower),
    timestamp: DateTime.fromMillisecondsSinceEpoch(timeMs),
  );
}

// ── Filters ───────────────────────────────────────────────────────────────────

final _refundRe = RegExp(r'\b(?:refund(?:ed)?|revers(?:ed|al)|cash ?back)\b');
final _otpRe = RegExp(r'\botp\b|one[- ]time (?:password|pin|code)|verification code|security code');
final _failedRe = RegExp(
    r'\b(?:failed|unsuccessful|declined|rejected|could not be processed|insufficient (?:funds|balance))\b');
final _futureRe = RegExp(
    r'will be (?:debited|deducted|charged|credited)|\bis due\b|\bdue (?:on|date)\b|payment reminder|\bupcoming\b');
// Bill-splitting summaries ("You owe PKR 350") are debts, not money movements.
final _debtRe = RegExp(r'\byou owe\b|\bowes you\b|\btotal balance\b');

// Chat, social and debt-tracking apps: amounts there are conversation, not transactions.
const _ignoredPackages = {
  'com.whatsapp',
  'com.whatsapp.w4b',
  'org.telegram.messenger',
  'com.facebook.orca',
  'com.facebook.katana',
  'com.instagram.android',
  'com.snapchat.android',
  'com.Splitwise.SplitwiseMobile',
};

bool _hasMoneyVerb(String lower) =>
    _refundRe.hasMatch(lower) ||
    _strongCreditRe.hasMatch(lower) ||
    _debitRe.hasMatch(lower) ||
    _creditRe.hasMatch(lower) ||
    RegExp(r'\b(?:sent|transferred|transfer)\b').hasMatch(lower);

bool _isNotATransaction(String lower) {
  if (_debtRe.hasMatch(lower)) return true;
  if (_otpRe.hasMatch(lower)) return true;
  if (_futureRe.hasMatch(lower)) return true;
  // "Your failed transaction was reversed" is a real refund, so keep it.
  if (_failedRe.hasMatch(lower) && !_refundRe.hasMatch(lower)) return true;
  return false;
}

// ── Amount ────────────────────────────────────────────────────────────────────

const _cur = r'(?:rs\.?|pkr)';
const _num = r'[0-9][0-9,]*(?:\.[0-9]{1,2})?';

// Balance and fee amounts appear alongside the real amount and must not win.
final _balanceRe = RegExp(
  r'\b(?:avl|avail|available|current|remaining|closing|new)?\.?\s*bal(?:ance)?\.?\s*(?:is|:|=|of)?\s*' +
      _cur + r'\s*' + _num,
  caseSensitive: false,
);
final _feeRe = RegExp(
  r'\b(?:fee|charges?|fed|tax|commission)\s*(?:of|:|=)?\s*' + _cur + r'\s*' + _num,
  caseSensitive: false,
);
final _amountBeforeRe = RegExp(r'\b' + _cur + r'\s*(' + _num + ')', caseSensitive: false);
final _amountAfterRe =
    RegExp(r'(?<![\d.,])(' + _num + r')\s*(?:\brs\b|\bpkr\b|/-)', caseSensitive: false);

double? _extractAmount(String text) {
  final cleaned = text.replaceAll(_balanceRe, ' ').replaceAll(_feeRe, ' ');
  final match = _amountBeforeRe.firstMatch(cleaned) ?? _amountAfterRe.firstMatch(cleaned);
  if (match == null) return null;
  return double.tryParse(match.group(1)!.replaceAll(',', ''));
}

// ── Direction ─────────────────────────────────────────────────────────────────

// Checked in order: refunds, then phrases that name *you* as the receiver,
// then debit verbs, then generic credit words. A transfer alert like
// "debited from your A/C ... credited to Ali" must come out as a debit.
final _strongCreditRe = RegExp(
  r'\b(?:sent you|paid you|transferred (?:to|into) (?:your|ur)|credited (?:to|in|into) (?:your|ur)|received from|you (?:have )?received|you got)\b',
);
final _debitRe = RegExp(
  r'\b(?:debited|withdrawn|withdrawal|deducted|spent|charged|purchased?|paid|sent to|transfer(?:red)? from (?:your|ur)|bill payment|your payment|payment of)\b',
);
final _creditRe = RegExp(r'\b(?:credited|received|deposited|added|incoming|jama|wasool)\b|موصول|جمع');

bool _isCredit(String lower) {
  if (_refundRe.hasMatch(lower)) return true;
  if (_strongCreditRe.hasMatch(lower)) return true;
  if (_debitRe.hasMatch(lower)) return false;
  if (_creditRe.hasMatch(lower)) return true;
  return false;
}

// ── Bank name ─────────────────────────────────────────────────────────────────

const _pkgToBank = {
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
    'com.nayapay.app': 'NayaPay',
    'com.dibpak.android': 'DIB',
    'com.avanza.ambitwizdib': 'DIB',
    'com.askaribank.android': 'Askari',
    'com.jsbl.android': 'JS Bank',
    'com.faysalbank.android': 'Faysal',
    'com.bankalhabib.android': 'Al Habib',
    'com.scb.android': 'SCB',
    'com.abl.android': 'Allied',
};

// SMS shortcodes, so push and SMS of the same transaction show the same bank.
const _smsSenderToBank = {
  '8079': 'Meezan',
};

String _bankName(String packageName, String title) {
  final known = _pkgToBank[packageName];
  if (known != null) return known;
  // SMS-app notifications use the sender as the title ("MEEZAN", "8079").
  final t = title.trim();
  final sender = _smsSenderToBank[t];
  if (sender != null) return sender;
  if (t.isNotEmpty && t.length <= 20) return t;
  return packageName.split('.').last;
}

// ── Account suffix ────────────────────────────────────────────────────────────

// Prefer "your A/C" / "your AC#" (receiver = me) over a bare "A/C" that
// could refer to the sender's account in an IBFT alert.
final _myAccountRe = RegExp(
  r'(?:your|ur)\s+a/?c[#:\s]*(\**[\d*]{4,})',
  caseSensitive: false,
);
// Fallback: "A/C **NNNN" (masked) or "A/C NNNNNNNN" (8+ digit full number).
// The 8-digit lower bound avoids matching "TID:014120" or helpline numbers.
final _anyAccountRe = RegExp(
  r'\ba/?c[#:\s]+(\*+\d{1,4}|\d{8,})',
  caseSensitive: false,
);

/// Returns the last 4 digits of the account number found in [body], or null.
String? _extractAccountSuffix(String body) {
  final m = _myAccountRe.firstMatch(body) ?? _anyAccountRe.firstMatch(body);
  if (m == null) return null;
  final digits = m.group(1)!.replaceAll(RegExp(r'\D'), '');
  if (digits.length < 4) return null;
  return digits.substring(digits.length - 4);
}
