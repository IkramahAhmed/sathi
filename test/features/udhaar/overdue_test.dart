import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/core/storage/app_database.dart';
import 'package:saathi/features/udhaar/domain/overdue.dart';

String _ymd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

final _past = _ymd(DateTime.now().subtract(const Duration(days: 2)));
final _earlier = _ymd(DateTime.now().subtract(const Duration(days: 5)));
final _future = _ymd(DateTime.now().add(const Duration(days: 7)));

UdhaarEntry _e(int id, int contact, double amount, String type, {String? due}) => UdhaarEntry(
      id: id,
      contactId: contact,
      amount: amount,
      type: type,
      note: '',
      date: _ymd(DateTime.now()),
      dueDate: due,
      createdAt: DateTime.now().toUtc(),
    );

void main() {
  test('contact with a passed due date and money still owed is overdue', () {
    final result = overdueByContact([_e(1, 1, 500, 'gave', due: _past)]);
    expect(result, {1: _past});
  });

  test('future due date is not overdue', () {
    expect(overdueByContact([_e(1, 1, 500, 'gave', due: _future)]), isEmpty);
  });

  test('no due date is not overdue', () {
    expect(overdueByContact([_e(1, 1, 500, 'gave')]), isEmpty);
  });

  test('passed due date but fully paid back is not overdue', () {
    final result = overdueByContact([
      _e(1, 1, 500, 'gave', due: _past),
      _e(2, 1, 500, 'received'),
    ]);
    expect(result, isEmpty);
  });

  test('reports the earliest passed due date when there are several', () {
    final result = overdueByContact([
      _e(1, 1, 300, 'gave', due: _past),
      _e(2, 1, 300, 'gave', due: _earlier),
    ]);
    expect(result, {1: _earlier});
  });

  test('only the late contact is flagged', () {
    final result = overdueByContact([
      _e(1, 1, 500, 'gave', due: _past),
      _e(2, 2, 500, 'gave', due: _future),
    ]);
    expect(result.keys, [1]);
  });
}
