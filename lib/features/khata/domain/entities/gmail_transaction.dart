enum GmailTxSource { jazzCash, easyPaisa, meezanBank, nayaPay, sadaPay, dibPak, generic }

enum GmailTxType { debit, credit }

class GmailTransaction {
  const GmailTransaction({
    required this.messageId,
    required this.date,
    required this.amount,
    required this.currency,
    required this.type,
    required this.source,
    required this.description,
    this.customSourceName,
  });

  final String messageId;
  final DateTime date;
  final double amount;
  final String currency; // 'PKR', 'USD', 'EUR', 'GBP', etc.
  final GmailTxType type;
  final GmailTxSource source;
  final String description;
  final String? customSourceName; // used when source == generic

  String get sourceName => customSourceName ?? switch (source) {
        GmailTxSource.jazzCash => 'JazzCash',
        GmailTxSource.easyPaisa => 'EasyPaisa',
        GmailTxSource.meezanBank => 'Meezan Bank',
        GmailTxSource.nayaPay => 'NayaPay',
        GmailTxSource.sadaPay => 'SadaPay',
        GmailTxSource.dibPak => 'Dubai Islamic Bank',
        GmailTxSource.generic => 'Bank',
      };

  /// Currency prefix for display, e.g. "Rs ", "$ ", "€ "
  String get currencyPrefix => switch (currency) {
        'PKR' => 'Rs ',
        'USD' => '\$ ',
        'EUR' => '€ ',
        'GBP' => '£ ',
        'AED' => 'AED ',
        'SAR' => 'SAR ',
        'CAD' => 'CAD ',
        'AUD' => 'AUD ',
        _ => '$currency ',
      };
}
