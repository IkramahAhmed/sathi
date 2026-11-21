import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/khata/domain/entities/gmail_transaction.dart';
import 'transaction_parser.dart';

const _gmailScope = 'https://www.googleapis.com/auth/gmail.readonly';
const _importedIdsKey = 'gmail_imported_message_ids';

final _googleSignIn = GoogleSignIn(scopes: [_gmailScope]);

class GmailReader {
  // ── Auth ────────────────────────────────────────────────────────────────────

  static Future<GoogleSignInAccount?> signIn() async {
    try {
      return await _googleSignIn.signIn();
    } catch (_) {
      return null;
    }
  }

  static Future<void> signOut() => _googleSignIn.signOut();

  static Future<GoogleSignInAccount?> get currentUser async {
    final account = _googleSignIn.currentUser;
    if (account != null) return account;
    return _googleSignIn.signInSilently();
  }

  static Future<Map<String, String>?> _authHeaders() async {
    final account = await currentUser;
    if (account == null) return null;
    return account.authHeaders;
  }

  // ── Deduplication ───────────────────────────────────────────────────────────

  static Future<Set<String>> _loadImportedIds() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_importedIdsKey) ?? []).toSet();
  }

  static Future<void> markImported(List<String> messageIds) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_importedIdsKey) ?? [];
    await prefs.setStringList(_importedIdsKey, {...existing, ...messageIds}.toList());
  }

  // ── Gmail API ───────────────────────────────────────────────────────────────

  /// Progress callback: (fetched, total) during parallel fetch.
  void Function(int fetched, int total)? onProgress;

  /// Debug info set after fetch: how many messages the Gmail search returned.
  String lastDebugInfo = '';

  Future<List<GmailTransaction>> fetchTransactions({int monthsBack = 1}) async {
    final headers = await _authHeaders();
    if (headers == null) return [];

    final importedIds = await _loadImportedIds();

    final cutoff = DateTime.now().subtract(Duration(days: monthsBack * 31));
    final afterDate =
        '${cutoff.year}/${cutoff.month.toString().padLeft(2, '0')}/${cutoff.day.toString().padLeft(2, '0')}';

    final query = Uri.encodeComponent(
      '(subject:debit OR subject:credit OR subject:"transaction" OR subject:alert '
      'OR subject:payment OR subject:"fund transfer" OR subject:withdrawal '
      'OR subject:"account statement" OR subject:receipt OR subject:statement) '
      'after:$afterDate',
    );

    final listUrl = Uri.parse(
      'https://gmail.googleapis.com/gmail/v1/users/me/messages?q=$query&maxResults=200',
    );
    final listResp = await http.get(listUrl, headers: headers);
    debugPrint('[GmailSync] list status=${listResp.statusCode}');
    if (listResp.statusCode != 200) {
      debugPrint('[GmailSync] list error body=${listResp.body}');
      lastDebugInfo = 'API error ${listResp.statusCode}: ${listResp.body.substring(0, listResp.body.length.clamp(0, 200))}';
      return [];
    }

    final listJson = jsonDecode(listResp.body) as Map<String, dynamic>;
    final allMessages = (listJson['messages'] as List<dynamic>?) ?? [];
    debugPrint('[GmailSync] found ${allMessages.length} messages, query after=$afterDate');

    // Filter out already-imported IDs before fetching
    final toFetch = allMessages
        .map((m) => m['id'] as String)
        .where((id) => !importedIds.contains(id))
        .toList();
    debugPrint('[GmailSync] toFetch=${toFetch.length} (${allMessages.length - toFetch.length} already imported)');
    lastDebugInfo = 'Found ${allMessages.length} emails after $afterDate, ${toFetch.length} to fetch';

    final total = toFetch.length;
    var fetched = 0;
    onProgress?.call(0, total);

    final transactions = <GmailTransaction>[];

    // Fetch in parallel batches of 10 — ~10× faster than sequential
    const batchSize = 10;
    for (var i = 0; i < toFetch.length; i += batchSize) {
      final batch = toFetch.skip(i).take(batchSize).toList();
      final results = await Future.wait(
        batch.map((id) => _fetchAndParse(id, headers)),
      );
      for (final tx in results) {
        if (tx != null) {
          debugPrint('[GmailSync] parsed: ${tx.sourceName} ${tx.type.name} ${tx.amount} ${tx.description}');
          transactions.add(tx);
        }
      }
      fetched += batch.length;
      onProgress?.call(fetched, total);
    }

    debugPrint('[GmailSync] total parsed=${transactions.length}');
    lastDebugInfo += ' → ${transactions.length} parsed';
    return transactions;
  }

  Future<GmailTransaction?> _fetchAndParse(
      String id, Map<String, String> headers) async {
    final msgUrl = Uri.parse(
      'https://gmail.googleapis.com/gmail/v1/users/me/messages/$id?format=full',
    );
    final msgResp = await http.get(msgUrl, headers: headers);
    if (msgResp.statusCode != 200) return null;
    final msgJson = jsonDecode(msgResp.body) as Map<String, dynamic>;
    return _parseMessage(id, msgJson);
  }

  // ── Message parsing ─────────────────────────────────────────────────────────

  GmailTransaction? _parseMessage(String id, Map<String, dynamic> msg) {
    final hdrs = _headers(msg);
    final from = hdrs['from'] ?? '';
    final subject = hdrs['subject'] ?? '';
    final dateStr = hdrs['date'] ?? '';
    final date = _parseDate(dateStr);
    final body = _extractBody(msg);

    // Known Pakistani fintech — specific parsers for best accuracy.
    if (isJazzCashSender(from)) {
      return parseJazzCash(messageId: id, date: date, subject: subject, body: body);
    }
    if (isEasyPaisaSender(from)) {
      return parseEasyPaisa(messageId: id, date: date, subject: subject, body: body);
    }
    if (isMeezanSender(from)) {
      return parseMeezan(messageId: id, date: date, subject: subject, body: body);
    }
    if (isNayaPaySender(from)) {
      return parseNayaPay(messageId: id, date: date, subject: subject, body: body);
    }
    if (isSadaPaySender(from)) {
      return parseSadaPay(messageId: id, date: date, subject: subject, body: body);
    }
    if (isDibSender(from)) {
      return parseDib(messageId: id, date: date, subject: subject, body: body);
    }

    // Generic fallback: handles UBL, MCB, Bank Alfalah, Askari, Bank Al Habib,
    // Faysal Bank, standard chartered, and ANY international bank automatically.
    return parseGeneric(
      messageId: id,
      date: date,
      subject: subject,
      body: body,
      from: from,
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Map<String, String> _headers(Map<String, dynamic> msg) {
    final payload = msg['payload'] as Map<String, dynamic>?;
    final headers = (payload?['headers'] as List<dynamic>?) ?? [];
    final result = <String, String>{};
    for (final h in headers) {
      result[(h['name'] as String).toLowerCase()] = h['value'] as String? ?? '';
    }
    return result;
  }

  String _extractBody(Map<String, dynamic> msg) {
    final payload = msg['payload'] as Map<String, dynamic>?;
    if (payload == null) return '';

    final parts = (payload['parts'] as List<dynamic>?) ?? [];
    for (final mime in ['text/plain', 'text/html']) {
      final raw = _findMimePart(parts, mime);
      if (raw != null) {
        final decoded = _decodeBase64(raw);
        return mime == 'text/html' ? _stripHtml(decoded) : decoded;
      }
    }

    final mimeType = payload['mimeType'] as String? ?? '';
    final body = payload['body'] as Map<String, dynamic>?;
    final data = body?['data'] as String?;
    if (data == null) return '';
    final decoded = _decodeBase64(data);
    return mimeType.contains('html') ? _stripHtml(decoded) : decoded;
  }

  String? _findMimePart(List<dynamic> parts, String mimeType) {
    for (final part in parts) {
      if (part['mimeType'] == mimeType) {
        return (part['body'] as Map<String, dynamic>?)?['data'] as String?;
      }
      final sub = part['parts'] as List<dynamic>?;
      if (sub != null) {
        final found = _findMimePart(sub, mimeType);
        if (found != null) return found;
      }
    }
    return null;
  }

  String _stripHtml(String html) {
    return html
        .replaceAll(RegExp(r'<style[^>]*>.*?</style>', dotAll: true, caseSensitive: false), ' ')
        .replaceAll(RegExp(r'<script[^>]*>.*?</script>', dotAll: true, caseSensitive: false), ' ')
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<p[^>]*>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<[^>]+>'), ' ')
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&nbsp;', ' ')
        .replaceAll(RegExp(r' {2,}'), ' ')
        .trim();
  }

  String _decodeBase64(String data) {
    try {
      final normalized = data.replaceAll('-', '+').replaceAll('_', '/');
      return utf8.decode(base64.decode(normalized));
    } catch (_) {
      return '';
    }
  }

  DateTime _parseDate(String dateStr) {
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      return DateTime.now();
    }
  }
}
