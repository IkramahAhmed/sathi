import '../../features/khata/domain/entities/expense_category.dart';
import '../../features/khata/domain/entities/gmail_transaction.dart';
import '../../features/khata/domain/entities/income_source.dart';

// ── Amount extraction ─────────────────────────────────────────────────────────

// Ordered by priority: PKR first so "Rs 500" beats a bare number.
final _amountPatterns = <(RegExp, String)>[
  (RegExp(r'(?:Rs\.?\s*|PKR\s*)([\d,]+(?:\.\d{1,2})?)', caseSensitive: false), 'PKR'),
  (RegExp(r'(?:USD\s*|\$\s*(?![\d,]*(?:\.\d{1,2})?\s*(?:off|%)))([\d,]+(?:\.\d{1,2})?)', caseSensitive: false), 'USD'),
  (RegExp(r'(?:EUR\s*|€\s*)([\d,]+(?:\.\d{1,2})?)', caseSensitive: false), 'EUR'),
  (RegExp(r'(?:GBP\s*|£\s*)([\d,]+(?:\.\d{1,2})?)', caseSensitive: false), 'GBP'),
  (RegExp(r'(?:AED\s*|Dhs?\.?\s*)([\d,]+(?:\.\d{1,2})?)', caseSensitive: false), 'AED'),
  (RegExp(r'SAR\s*([\d,]+(?:\.\d{1,2})?)', caseSensitive: false), 'SAR'),
  (RegExp(r'CAD\s*([\d,]+(?:\.\d{1,2})?)', caseSensitive: false), 'CAD'),
  (RegExp(r'AUD\s*([\d,]+(?:\.\d{1,2})?)', caseSensitive: false), 'AUD'),
];

/// Returns (amount, currency) or null if no amount found.
(double, String)? extractAmount(String text) {
  for (final (re, currency) in _amountPatterns) {
    final m = re.firstMatch(text);
    if (m != null) {
      final v = double.tryParse(m.group(1)!.replaceAll(',', ''));
      if (v != null && v > 0) return (v, currency);
    }
  }
  return null;
}

double? _parseAmount(String text) => extractAmount(text)?.$1;

// ── Debit / Credit detection ──────────────────────────────────────────────────

GmailTxType detectTxType(String lower, {bool defaultCredit = false}) {
  if (lower.contains('credit') ||
      lower.contains('received') ||
      lower.contains('deposited') ||
      lower.contains('added') ||
      lower.contains('incoming') ||
      lower.contains('refund') ||
      lower.contains('cashback') ||
      lower.contains('you got')) {
    return GmailTxType.credit;
  }
  if (lower.contains('debit') ||
      lower.contains('withdraw') ||
      lower.contains('sent') ||
      lower.contains('paid') ||
      lower.contains('payment') ||
      lower.contains('purchase') ||
      lower.contains('charged')) {
    return GmailTxType.debit;
  }
  return defaultCredit ? GmailTxType.credit : GmailTxType.debit;
}

// ── Bank name from sender domain ──────────────────────────────────────────────

const _domainNames = {
  // ── Pakistani commercial banks ───────────────────────────────────────────
  'hbl.com': 'HBL',              // HBL credit-card alerts only (account alerts are SMS)
  'ubl.com.pk': 'UBL',
  'ubl.com': 'UBL',
  'mcb.com.pk': 'MCB',
  'mcb.com': 'MCB',
  'bankalfalah.com': 'Bank Alfalah',
  'faysalbank.com': 'Faysal Bank',
  'sc.com.pk': 'Standard Chartered',
  'sc.com': 'Standard Chartered',
  'standardchartered.com': 'Standard Chartered',
  'askaribank.com.pk': 'Askari Bank',
  'askaribank.com': 'Askari Bank',
  'bankalhabib.com': 'Bank Al Habib',
  'habibmetro.com': 'HabibMetro',
  'jsbl.com': 'JS Bank',
  'bankislami.com.pk': 'BankIslami',
  'bankislami.com': 'BankIslami',
  'silkbank.com.pk': 'Silkbank',
  'silkbank.com': 'Silkbank',
  'soneribank.com': 'Soneri Bank',
  'summitbank.com.pk': 'Summit Bank',
  'abl.com': 'Allied Bank',
  'tmbl.com.pk': 'Telenor Microfinance Bank',
  'ubank.com.pk': 'U Bank',
  'umbl.com.pk': 'U Microfinance Bank',
  // ── Pakistani fintech (specific parsers handle these, but map as fallback) ─
  'jazz.com.pk': 'JazzCash',
  'jazzcash.com.pk': 'JazzCash',
  'easypaisa.com': 'EasyPaisa',
  'telenor.com.pk': 'EasyPaisa',
  'nayapay.com': 'NayaPay',
  'sadapay.pk': 'SadaPay',
  'sadapay.com': 'SadaPay',
  'meezanbank.com': 'Meezan Bank',
  'dibpak.com': 'Dubai Islamic Bank',
  // ── Irish / EU banks ─────────────────────────────────────────────────────
  'boi.com': 'Bank of Ireland',
  'bankofireland.com': 'Bank of Ireland',
  'aib.ie': 'AIB',
  'alliedirish.ie': 'AIB',
  'ulsterbank.ie': 'Ulster Bank',
  'ulsterbank.co.uk': 'Ulster Bank',
  'kbc.ie': 'KBC Ireland',
  'permanenttsb.ie': 'Permanent TSB',
  'bunq.com': 'bunq',
  // ── UK banks ──────────────────────────────────────────────────────────────
  'hsbc.com': 'HSBC',
  'hsbc.co.uk': 'HSBC',
  'barclays.co.uk': 'Barclays',
  'barclays.com': 'Barclays',
  'lloydstb.co.uk': 'Lloyds',
  'lloydsbank.com': 'Lloyds',
  'natwest.com': 'NatWest',
  'rbs.co.uk': 'RBS',
  'santander.co.uk': 'Santander',
  'revolutapp.com': 'Revolut',
  'revolut.com': 'Revolut',
  'monzo.com': 'Monzo',
  'starlingbank.com': 'Starling Bank',
  'n26.com': 'N26',
  'wise.com': 'Wise',
  // ── UAE / Gulf banks ─────────────────────────────────────────────────────
  'emiratesnbd.com': 'Emirates NBD',
  'adcb.com': 'ADCB',
  'mashreq.com': 'Mashreq',
  'fab.ae': 'First Abu Dhabi Bank',
  'dib.ae': 'Dubai Islamic Bank UAE',
  'enbd.com': 'Emirates NBD',
};

String bankNameFromSender(String from) {
  final lower = from.toLowerCase();
  // Exact domain match
  for (final entry in _domainNames.entries) {
    if (lower.contains(entry.key)) return entry.value;
  }
  // Fallback: extract domain part before TLD and capitalise
  final emailRe = RegExp(r'@([\w.-]+)');
  final m = emailRe.firstMatch(lower);
  if (m != null) {
    final parts = m.group(1)!.split('.');
    // Take the last meaningful segment (skip 'com', 'pk', 'ie', etc.)
    final tlds = {'com', 'pk', 'ie', 'uk', 'co', 'net', 'org', 'ae', 'in', 'au'};
    final name = parts.lastWhere((p) => !tlds.contains(p) && p.length > 2, orElse: () => parts.first);
    return name[0].toUpperCase() + name.substring(1);
  }
  return 'Bank';
}

// ── Generic parser (catches any bank, any country) ────────────────────────────

bool isTransactionEmail(String subject) {
  // Quick pre-filter: subject must look like a transaction alert.
  // This prevents importing promotional/newsletter emails.
  final lower = subject.toLowerCase();
  return lower.contains('debit') ||
      lower.contains('credit') ||
      lower.contains('transaction') ||
      lower.contains('alert') ||
      lower.contains('payment') ||
      lower.contains('transfer') ||
      lower.contains('withdrawal') ||
      lower.contains('account') ||
      lower.contains('statement') ||
      lower.contains('fund') ||
      lower.contains('receipt') ||
      lower.contains('invoice');
}

GmailTransaction? parseGeneric({
  required String messageId,
  required DateTime date,
  required String subject,
  required String body,
  required String from,
}) {
  if (!isTransactionEmail(subject)) return null;

  final text = '$subject\n$body';
  final parsed = extractAmount(text);
  if (parsed == null) return null;
  final (amount, currency) = parsed;

  final lower = text.toLowerCase();
  final type = detectTxType(lower);

  // Build a short description from the subject line
  final desc = subject
      .replaceAll(
        RegExp(r'(?:alert|notification|confirmation|transaction|banking|online|update)',
            caseSensitive: false),
        '',
      )
      .replaceAll(RegExp(r'\s{2,}'), ' ')
      .trim();

  return GmailTransaction(
    messageId: messageId,
    date: date,
    amount: amount,
    currency: currency,
    type: type,
    source: GmailTxSource.generic,
    description: desc.isNotEmpty ? desc : (type == GmailTxType.credit ? 'Money Received' : 'Payment'),
    customSourceName: bankNameFromSender(from),
  );
}

// ── Auto-categorisation ───────────────────────────────────────────────────────

/// Returns (categoryName, isIncome) to use when saving an imported transaction.
/// Detects the right expense category or income source from description keywords.
(String category, bool isIncome) suggestCategory(
    String description, GmailTxType type) {
  final lower = description.toLowerCase();

  if (type == GmailTxType.credit) {
    if (lower.contains('salary') || lower.contains('payroll') || lower.contains('wages')) {
      return (IncomeSource.salary.name, true);
    }
    return (IncomeSource.other.name, true);
  }

  // Expenses — check in priority order
  if (lower.contains('food') || lower.contains('restaurant') ||
      lower.contains('kfc') || lower.contains('mcdonalds') ||
      lower.contains('pizza') || lower.contains('cafe') ||
      lower.contains('groceries') || lower.contains('grocery') ||
      lower.contains('bakery') || lower.contains('milk') ||
      lower.contains('dawat') || lower.contains('biryani')) {
    return (ExpenseCategory.food.name, false);
  }
  if (lower.contains('petrol') || lower.contains('fuel') ||
      lower.contains('uber') || lower.contains('careem') ||
      lower.contains('transport') || lower.contains('taxi') ||
      lower.contains('bus') || lower.contains('rickshaw') ||
      lower.contains('toll') || lower.contains('parking') ||
      lower.contains('cng') || lower.contains('pump')) {
    return (ExpenseCategory.transport.name, false);
  }
  if (lower.contains('medical') || lower.contains('pharmacy') ||
      lower.contains('hospital') || lower.contains('doctor') ||
      lower.contains('clinic') || lower.contains('medicine') ||
      lower.contains('health') || lower.contains('lab') ||
      lower.contains('shifa') || lower.contains('agha khan')) {
    return (ExpenseCategory.health.name, false);
  }
  if (lower.contains('bill') || lower.contains('utility') ||
      lower.contains('electric') || lower.contains('wapda') ||
      lower.contains('lesco') || lower.contains('sui gas') ||
      lower.contains('kesc') || lower.contains('internet') ||
      lower.contains('mobile top') || lower.contains('topup') ||
      lower.contains('top-up') || lower.contains('recharge') ||
      lower.contains('ptcl') || lower.contains('stormfiber') ||
      lower.contains('nayatel') || lower.contains('jazz') ||
      lower.contains('zong') || lower.contains('ufone') || lower.contains('telenor')) {
    return (ExpenseCategory.bills.name, false);
  }
  if (lower.contains('rent') || lower.contains('apartment') ||
      lower.contains('flat') || lower.contains('kiraya') ||
      lower.contains('house rent') || lower.contains('makaan')) {
    return (ExpenseCategory.rent.name, false);
  }
  if (lower.contains('pos purchase') || lower.contains('shopping') ||
      lower.contains('mall') || lower.contains('store') ||
      lower.contains('daraz') || lower.contains('amazon') ||
      lower.contains('purchase') || lower.contains('market') ||
      lower.contains('ecommerce') || lower.contains('aliexpress') ||
      lower.contains('merchant payment')) {
    return (ExpenseCategory.shopping.name, false);
  }

  return (ExpenseCategory.other.name, false);
}

// ── JazzCash ─────────────────────────────────────────────────────────────────

const _jazzSenders = {
  'noreply@jazz.com.pk',
  'jazzcash@jazz.com.pk',
  'alerts@jazz.com.pk',
  'noreply@jazzcash.com.pk',
};

bool isJazzCashSender(String from) =>
    _jazzSenders.any((s) => from.toLowerCase().contains(s));

GmailTransaction? parseJazzCash({
  required String messageId,
  required DateTime date,
  required String subject,
  required String body,
}) {
  final text = '$subject\n$body';
  final amount = _parseAmount(text);
  if (amount == null || amount <= 0) return null;

  final lower = text.toLowerCase();
  final type = detectTxType(lower);
  final desc = _jazzDescription(lower, subject);

  return GmailTransaction(
    messageId: messageId,
    date: date,
    amount: amount,
    currency: 'PKR',
    type: type,
    source: GmailTxSource.jazzCash,
    description: desc,
  );
}

String _jazzDescription(String lower, String subject) {
  if (lower.contains('bill') || lower.contains('utility')) return 'Bill Payment';
  if (lower.contains('mobile top') || lower.contains('topup') || lower.contains('top-up')) return 'Mobile Top-up';
  if (lower.contains('send money') || lower.contains('money transfer')) return 'Money Transfer';
  if (lower.contains('merchant') || lower.contains('payment to')) return 'Merchant Payment';
  if (lower.contains('received') || lower.contains('incoming')) return 'Money Received';
  final cleaned = subject.replaceAll(
      RegExp(r'jazzcash|transaction|receipt|alert|confirmation', caseSensitive: false), '').trim();
  return cleaned.isNotEmpty ? cleaned : 'JazzCash Transaction';
}

// ── EasyPaisa ─────────────────────────────────────────────────────────────────

const _easyPaisaSenders = {
  'easypaisa@telenor.com.pk',
  'noreply@easypaisa.com',
  'alerts@easypaisa.com',
  'easypaisa@telenor.com',
  'info@easypaisa.com',
};

bool isEasyPaisaSender(String from) =>
    _easyPaisaSenders.any((s) => from.toLowerCase().contains(s));

GmailTransaction? parseEasyPaisa({
  required String messageId,
  required DateTime date,
  required String subject,
  required String body,
}) {
  final text = '$subject\n$body';
  final amount = _parseAmount(text);
  if (amount == null || amount <= 0) return null;

  final lower = text.toLowerCase();
  final type = detectTxType(lower);
  final desc = _easyPaisaDescription(lower, subject);

  return GmailTransaction(
    messageId: messageId,
    date: date,
    amount: amount,
    currency: 'PKR',
    type: type,
    source: GmailTxSource.easyPaisa,
    description: desc,
  );
}

String _easyPaisaDescription(String lower, String subject) {
  if (lower.contains('bill') || lower.contains('utility')) return 'Bill Payment';
  if (lower.contains('mobile') && (lower.contains('top') || lower.contains('load'))) return 'Mobile Top-up';
  if (lower.contains('send') || lower.contains('transfer')) return 'Money Transfer';
  if (lower.contains('merchant') || lower.contains('retailer')) return 'Merchant Payment';
  if (lower.contains('received') || lower.contains('incoming')) return 'Money Received';
  if (lower.contains('withdrawal') || lower.contains('cash out')) return 'Cash Withdrawal';
  final cleaned = subject
      .replaceAll(RegExp(r'easypaisa|easy paisa|transaction|receipt|alert|confirmation', caseSensitive: false), '')
      .trim();
  return cleaned.isNotEmpty ? cleaned : 'EasyPaisa Transaction';
}

// ── Meezan Bank ───────────────────────────────────────────────────────────────

const _meezanSenders = {
  'no-reply@meezanbank.com',
  'noreply@meezanbank.com',
  'alerts@meezanbank.com',
};

bool isMeezanSender(String from) =>
    _meezanSenders.any((s) => from.toLowerCase().contains(s));

GmailTransaction? parseMeezan({
  required String messageId,
  required DateTime date,
  required String subject,
  required String body,
}) {
  final text = '$subject\n$body';
  final amount = _parseAmount(text);
  if (amount == null || amount <= 0) return null;

  final lower = text.toLowerCase();
  final type = detectTxType(lower);

  // Subject-based description — gives better labels than "Bank Transfer"
  final subjLower = subject.toLowerCase();
  String desc;
  if (subjLower.contains('ibft') || subjLower.contains('fund transfer') || subjLower.contains('interbank')) {
    desc = type == GmailTxType.credit ? 'IBFT Credit' : 'IBFT Transfer';
  } else if (subjLower.contains('atm') || subjLower.contains('withdrawal')) {
    desc = 'ATM Withdrawal';
  } else if (subjLower.contains('pos') || subjLower.contains('purchase') || subjLower.contains('merchant')) {
    desc = 'POS Purchase';
  } else if (subjLower.contains('bill') || subjLower.contains('utility')) {
    desc = 'Bill Payment';
  } else if (subjLower.contains('salary') || subjLower.contains('payroll')) {
    desc = 'Salary Credit';
  } else {
    desc = type == GmailTxType.credit ? 'Credit' : 'Bank Transfer';
  }

  // Try to get beneficiary name from body (outgoing IBFT has this)
  if (lower.contains('beneficiary')) {
    final re = RegExp(r'beneficiary(?:\s+account\s+title)?\s*[:\-]\s*([A-Za-z .]{2,40})', caseSensitive: false);
    final m = re.firstMatch(text);
    if (m != null) desc = m.group(1)!.trim();
  }

  return GmailTransaction(
    messageId: messageId,
    date: date,
    amount: amount,
    currency: 'PKR',
    type: type,
    source: GmailTxSource.meezanBank,
    description: desc,
  );
}

// ── NayaPay ───────────────────────────────────────────────────────────────────

const _nayaPaySenders = {
  'service@nayapay.com',
  'noreply@nayapay.com',
  'no-reply@nayapay.com',
  'alerts@nayapay.com',
};

bool isNayaPaySender(String from) =>
    _nayaPaySenders.any((s) => from.toLowerCase().contains(s));

GmailTransaction? parseNayaPay({
  required String messageId,
  required DateTime date,
  required String subject,
  required String body,
}) {
  final text = '$subject\n$body';
  final amount = _parseAmount(text);
  if (amount == null || amount <= 0) return null;

  final lower = text.toLowerCase();
  final type = detectTxType(lower, defaultCredit: false);

  return GmailTransaction(
    messageId: messageId,
    date: date,
    amount: amount,
    currency: 'PKR',
    type: type,
    source: GmailTxSource.nayaPay,
    description: type == GmailTxType.credit ? 'Money Received' : 'Money Sent',
  );
}

// ── SadaPay ───────────────────────────────────────────────────────────────────

const _sadaPaySenders = {
  'hello@email.sadapay.pk',
  'noreply@sadapay.com',
  'no-reply@sadapay.com',
  'alerts@sadapay.com',
  'hello@sadapay.com',
};

bool isSadaPaySender(String from) =>
    _sadaPaySenders.any((s) => from.toLowerCase().contains(s)) ||
    from.toLowerCase().contains('sadapay');

GmailTransaction? parseSadaPay({
  required String messageId,
  required DateTime date,
  required String subject,
  required String body,
}) {
  final text = '$subject\n$body';
  final amount = _parseAmount(text);
  if (amount == null || amount <= 0) return null;

  final lower = text.toLowerCase();
  final type = detectTxType(lower);

  String desc = type == GmailTxType.credit ? 'Money Received' : 'Payment';
  if (lower.contains('international')) {
    desc = 'International Payment';
  } else if (lower.contains('top') || lower.contains('load')) {
    desc = 'Top-up';
  }

  return GmailTransaction(
    messageId: messageId,
    date: date,
    amount: amount,
    currency: 'PKR',
    type: type,
    source: GmailTxSource.sadaPay,
    description: desc,
  );
}

// ── Dubai Islamic Bank Pakistan ───────────────────────────────────────────────

const _dibSenders = {
  'alerts@dibpak.com',
  'noreply@dibpak.com',
  'no-reply@dibpak.com',
  'ebanking@dibpak.com',
  'info@dibpak.com',
};

bool isDibSender(String from) =>
    _dibSenders.any((s) => from.toLowerCase().contains(s)) ||
    from.toLowerCase().contains('dibpak');

GmailTransaction? parseDib({
  required String messageId,
  required DateTime date,
  required String subject,
  required String body,
}) {
  final text = '$subject\n$body';
  final amount = _parseAmount(text);
  if (amount == null || amount <= 0) return null;

  final lower = text.toLowerCase();
  final type = detectTxType(lower);

  String desc = 'Bank Transaction';
  if (lower.contains('atm')) {
    desc = 'ATM Withdrawal';
  } else if (lower.contains('pos') || lower.contains('purchase')) {
    desc = 'POS Purchase';
  } else if (lower.contains('transfer')) {
    desc = 'Bank Transfer';
  } else if (lower.contains('bill')) {
    desc = 'Bill Payment';
  }

  return GmailTransaction(
    messageId: messageId,
    date: date,
    amount: amount,
    currency: 'PKR',
    type: type,
    source: GmailTxSource.dibPak,
    description: desc,
  );
}
