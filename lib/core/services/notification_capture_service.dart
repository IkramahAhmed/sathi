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

  return NotificationTransaction(
    id: '${packageName}_$timeMs',
    packageName: packageName,
    bankName: _bankName(packageName, title),
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
