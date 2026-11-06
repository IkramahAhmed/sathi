import '../../../core/storage/app_database.dart';

String _todayStr() {
  final now = DateTime.now();
  return '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
}

/// True when a `yyyy-MM-dd` due date is before today. Dates compare correctly as strings.
bool isPastDue(String dueDate) => dueDate.compareTo(_todayStr()) < 0;

/// Contacts who are late: they still owe money and at least one of their `gave`
/// entries has a due date that has passed. Maps contact id to the earliest such due date.
Map<int, String> overdueByContact(List<UdhaarEntry> entries) {
  final balance = <int, double>{};
  final earliestDue = <int, String>{};
  for (final e in entries) {
    balance[e.contactId] = (balance[e.contactId] ?? 0) + (e.type == 'gave' ? e.amount : -e.amount);
    final due = e.dueDate;
    if (e.type == 'gave' && due != null && isPastDue(due)) {
      final current = earliestDue[e.contactId];
      if (current == null || due.compareTo(current) < 0) earliestDue[e.contactId] = due;
    }
  }
  return {
    for (final entry in earliestDue.entries)
      if ((balance[entry.key] ?? 0) > 0) entry.key: entry.value,
  };
}
