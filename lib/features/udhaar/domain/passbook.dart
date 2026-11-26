import '../../../core/storage/app_database.dart';

/// Entries oldest first, each with the balance after it (positive: they owe you).
List<({UdhaarEntry entry, double balance})> passbookRows(List<UdhaarEntry> entries) {
  final sorted = [...entries]..sort((a, b) {
      final byDate = a.date.compareTo(b.date);
      return byDate != 0 ? byDate : a.id.compareTo(b.id);
    });
  var running = 0.0;
  return [
    for (final e in sorted)
      (entry: e, balance: running += e.type == 'gave' ? e.amount : -e.amount),
  ];
}
