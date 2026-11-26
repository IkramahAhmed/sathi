import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/core/storage/app_database.dart';
import 'package:saathi/features/udhaar/domain/dues.dart';
import 'package:saathi/features/udhaar/domain/passbook.dart';

UdhaarContact contact(int id, String name) =>
    UdhaarContact(id: id, name: name, phone: '', createdAt: DateTime.utc(2026, 1, 1), source: 'normal');

UdhaarEntry entry(int contact, String type, double amount, {String? due}) => UdhaarEntry(
      id: contact * 100 + amount.toInt(),
      contactId: contact,
      type: type,
      amount: amount,
      note: '',
      date: '2026-11-01',
      dueDate: due,
      createdAt: DateTime.utc(2026, 11, 1),
    );

void main() {
  final today = DateTime(2026, 11, 26);

  test('money owed to me due within a week is listed, later dates are not', () {
    final dues = upcomingUdhaarDues(
      contacts: [contact(1, 'Ali'), contact(2, 'Sara')],
      entries: [
        entry(1, 'gave', 5000, due: '2026-11-29'),
        entry(2, 'gave', 9000, due: '2026-12-20'),
      ],
      today: today,
    );
    expect(dues.map((d) => d.contact.name), ['Ali']);
    expect(dues.single.theyOweMe, isTrue);
    expect(dues.single.amount, 5000);
    expect(dues.single.daysLeft, 3);
  });

  test('money I owe uses the dates on what I received', () {
    final dues = upcomingUdhaarDues(
      contacts: [contact(1, 'Bilal')],
      entries: [entry(1, 'received', 20000, due: '2026-11-28')],
      today: today,
    );
    expect(dues.single.theyOweMe, isFalse);
    expect(dues.single.amount, 20000);
  });

  test('overdue dates are included with negative days, settled contacts are not', () {
    final dues = upcomingUdhaarDues(
      contacts: [contact(1, 'Ali'), contact(2, 'Sara')],
      entries: [
        entry(1, 'gave', 5000, due: '2026-11-20'),
        entry(2, 'gave', 3000, due: '2026-11-27'),
        entry(2, 'received', 3000),
      ],
      today: today,
    );
    expect(dues.map((d) => d.contact.name), ['Ali']);
    expect(dues.single.daysLeft, -6);
  });

  test('earliest date wins and the list is ordered by date', () {
    final dues = upcomingUdhaarDues(
      contacts: [contact(1, 'Ali'), contact(2, 'Sara')],
      entries: [
        entry(1, 'gave', 100, due: '2026-12-01'),
        entry(1, 'gave', 200, due: '2026-11-30'),
        entry(2, 'gave', 50, due: '2026-11-27'),
      ],
      today: today,
    );
    expect(dues.map((d) => d.contact.name), ['Sara', 'Ali']);
    expect(dues.last.due, DateTime(2026, 11, 30));
  });

  test('passbook shows a running balance, oldest entry first', () {
    final rows = passbookRows([
      entry(1, 'received', 2000),
      entry(1, 'gave', 5000),
    ]);
    // Same date: ordered by id (smaller amount id here), so check balances add up.
    expect(rows.length, 2);
    expect(rows.last.balance, 3000);
  });
}
