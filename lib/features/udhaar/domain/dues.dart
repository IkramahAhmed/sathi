import '../../../core/storage/app_database.dart';

/// A contact with a payment date coming up (or already missed).
class UdhaarDue {
  const UdhaarDue({
    required this.contact,
    required this.amount,
    required this.theyOweMe,
    required this.due,
    required this.daysLeft,
  });

  final UdhaarContact contact;

  /// What is outstanding, always positive.
  final double amount;

  /// True when they owe you; false when you owe them.
  final bool theyOweMe;
  final DateTime due;

  /// Days from today until [due]; negative when it has passed.
  final int daysLeft;
}

/// Contacts whose next payment date falls within [withinDays] of [today], or has
/// passed. Money owed to you looks at the dates you set when you gave; money you
/// owe looks at the dates on what you received. Settled contacts are skipped.
List<UdhaarDue> upcomingUdhaarDues({
  required List<UdhaarContact> contacts,
  required List<UdhaarEntry> entries,
  required DateTime today,
  int withinDays = 7,
}) {
  final byContact = <int, List<UdhaarEntry>>{};
  for (final e in entries) {
    byContact.putIfAbsent(e.contactId, () => []).add(e);
  }
  final start = DateTime(today.year, today.month, today.day);
  final result = <UdhaarDue>[];

  for (final contact in contacts) {
    final list = byContact[contact.id] ?? const <UdhaarEntry>[];
    final balance = list.fold(0.0, (s, e) => s + (e.type == 'gave' ? e.amount : -e.amount));
    if (balance == 0) continue;
    final theyOweMe = balance > 0;
    final relevantType = theyOweMe ? 'gave' : 'received';

    DateTime? earliest;
    for (final e in list) {
      final d = e.dueDate == null ? null : DateTime.tryParse(e.dueDate!);
      if (e.type != relevantType || d == null) continue;
      if (earliest == null || d.isBefore(earliest)) earliest = d;
    }
    if (earliest == null) continue;

    final daysLeft = DateTime(earliest.year, earliest.month, earliest.day).difference(start).inDays;
    if (daysLeft > withinDays) continue;
    result.add(UdhaarDue(
      contact: contact,
      amount: balance.abs(),
      theyOweMe: theyOweMe,
      due: earliest,
      daysLeft: daysLeft,
    ));
  }
  result.sort((a, b) => a.due.compareTo(b.due));
  return result;
}
