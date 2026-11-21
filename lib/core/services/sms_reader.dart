import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/khata/domain/entities/gmail_transaction.dart';
import 'transaction_parser.dart';

const _smsImportedKey = 'sms_imported_ids';
const _channel = MethodChannel('com.ikramah.saathi/native');

// Maps SMS sender short-codes to bank names (Pakistan + common international).
const _senderNames = {
  // HBL
  'hbl': 'HBL',
  'hblalert': 'HBL',
  'hbl-ibank': 'HBL',
  'hblpak': 'HBL',
  'hbl-alert': 'HBL',
  // Meezan
  'meezan': 'Meezan Bank',
  'meezanbk': 'Meezan Bank',
  'meezanbank': 'Meezan Bank',
  'meezan-bank': 'Meezan Bank',
  // UBL
  'ubl': 'UBL',
  'ublalert': 'UBL',
  'ubl-alert': 'UBL',
  // MCB
  'mcb': 'MCB',
  'mcbalert': 'MCB',
  'mcb-alert': 'MCB',
  // Bank Alfalah
  'alfalah': 'Bank Alfalah',
  'bankalfalah': 'Bank Alfalah',
  'alfalah-alert': 'Bank Alfalah',
  // NayaPay
  'nayapay': 'NayaPay',
  'naya-pay': 'NayaPay',
  // SadaPay
  'sadapay': 'SadaPay',
  'sada-pay': 'SadaPay',
  // JazzCash
  'jazzcash': 'JazzCash',
  'jazz': 'JazzCash',
  'jazz-cash': 'JazzCash',
  // EasyPaisa
  'easypaisa': 'EasyPaisa',
  'ep': 'EasyPaisa',
  'easy-paisa': 'EasyPaisa',
  // DIB Pakistan
  'dibpak': 'Dubai Islamic Bank',
  'dib': 'Dubai Islamic Bank',
  // Allied Bank
  'abl': 'Allied Bank',
  'ablbank': 'Allied Bank',
  // Faysal Bank
  'faysalbank': 'Faysal Bank',
  'faysal': 'Faysal Bank',
  // Askari Bank
  'askaribank': 'Askari Bank',
  'askari': 'Askari Bank',
  // JS Bank
  'jsbank': 'JS Bank',
  'jsbl': 'JS Bank',
  // Bank Al Habib
  'bankalhabib': 'Bank Al Habib',
  'alhabib': 'Bank Al Habib',
  // Telenor Microfinance
  'tmb': 'Telenor Microfinance',
  'tmbl': 'Telenor Microfinance',
  // Standard Chartered
  'scbank': 'Standard Chartered',
  'sc-pk': 'Standard Chartered',
};

String _bankFromAddress(String address) {
  final lower = address.toLowerCase().replaceAll(RegExp(r'[-_\s]'), '');
  for (final entry in _senderNames.entries) {
    if (lower == entry.key || lower.contains(entry.key)) return entry.value;
  }
  // Fallback: capitalise the sender code
  return address.isNotEmpty
      ? address[0].toUpperCase() + address.substring(1).toLowerCase()
      : 'SMS';
}

class SmsReader {
  static Future<bool> requestPermission() async {
    final status = await Permission.sms.status;
    if (status.isGranted) return true;
    final result = await Permission.sms.request();
    return result.isGranted;
  }

  static Future<bool> get hasPermission => Permission.sms.status.then((s) => s.isGranted);

  // ── Deduplication ───────────────────────────────────────────────────────────

  static Future<Set<String>> _loadImportedIds() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_smsImportedKey) ?? []).toSet();
  }

  static Future<void> markImported(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_smsImportedKey) ?? [];
    await prefs.setStringList(_smsImportedKey, {...existing, ...ids}.toList());
  }

  // ── Main fetch ──────────────────────────────────────────────────────────────

  Future<List<GmailTransaction>> fetchTransactions({int monthsBack = 3}) async {
    final granted = await requestPermission();
    if (!granted) return [];

    final List<dynamic> raw = await _channel.invokeMethod(
      'readSmsInbox',
      {'monthsBack': monthsBack},
    );

    final importedIds = await _loadImportedIds();
    final transactions = <GmailTransaction>[];

    for (final msg in raw) {
      final address = (msg['address'] as String? ?? '').trim();
      final body = (msg['body'] as String? ?? '').trim();
      final dateMs = (msg['date'] as num).toInt();
      final date = DateTime.fromMillisecondsSinceEpoch(dateMs);

      // Unique ID: address + exact millisecond timestamp
      final id = '${address}_$dateMs';
      if (importedIds.contains(id)) continue;

      final tx = _parseSms(id: id, address: address, body: body, date: date);
      if (tx != null) transactions.add(tx);
    }

    return transactions;
  }

  // ── Parsing ─────────────────────────────────────────────────────────────────

  GmailTransaction? _parseSms({
    required String id,
    required String address,
    required String body,
    required DateTime date,
  }) {
    // Only process messages from known bank senders
    final bankName = _isBankSms(address) ? _bankFromAddress(address) : null;
    if (bankName == null) return null;

    // Must contain an amount
    final parsed = extractAmount(body);
    if (parsed == null) return null;
    final (amount, currency) = parsed;

    final lower = body.toLowerCase();
    final type = detectTxType(lower);

    // Build a short description from the SMS body
    final desc = _descriptionFromBody(body, lower, type);

    return GmailTransaction(
      messageId: id,
      date: date,
      amount: amount,
      currency: currency,
      type: type,
      source: GmailTxSource.generic,
      description: desc,
      customSourceName: bankName,
    );
  }

  bool _isBankSms(String address) {
    final lower = address.toLowerCase().replaceAll(RegExp(r'[-_\s]'), '');
    // Numeric phone numbers are personal — skip unless you want to allow them
    if (RegExp(r'^\+?\d{7,15}$').hasMatch(address.trim())) return false;
    // Check known senders
    for (final key in _senderNames.keys) {
      if (lower.contains(key)) return true;
    }
    return false;
  }

  String _descriptionFromBody(String body, String lower, GmailTxType type) {
    if (lower.contains('atm') || lower.contains('withdrawal')) return 'ATM Withdrawal';
    if (lower.contains('pos') || lower.contains('purchase')) return 'POS Purchase';
    if (lower.contains('ibft') || lower.contains('fund transfer') || lower.contains('interbank')) {
      return type == GmailTxType.credit ? 'IBFT Credit' : 'IBFT Transfer';
    }
    if (lower.contains('bill') || lower.contains('utility')) return 'Bill Payment';
    if (lower.contains('salary') || lower.contains('payroll')) return 'Salary Credit';
    if (lower.contains('mobile') && (lower.contains('topup') || lower.contains('top-up') || lower.contains('top up'))) {
      return 'Mobile Top-up';
    }
    if (lower.contains('merchant') || lower.contains('payment at') || lower.contains('paid at')) {
      // Try to extract merchant name
      final re = RegExp(r'(?:at|to)\s+([A-Za-z0-9 &]{3,30})(?:\s+on|\s+dated|\s+Rs|\.|\,|$)', caseSensitive: false);
      final m = re.firstMatch(body);
      if (m != null) return m.group(1)!.trim();
      return 'Merchant Payment';
    }
    if (lower.contains('received') || lower.contains('credited') || lower.contains('credit')) {
      return 'Money Received';
    }
    if (lower.contains('debited') || lower.contains('debit') || lower.contains('sent') || lower.contains('paid')) {
      return 'Payment';
    }
    return type == GmailTxType.credit ? 'Credit' : 'Debit';
  }
}
