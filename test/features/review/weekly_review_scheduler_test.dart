import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/features/review/data/weekly_review_scheduler.dart';

void main() {
  // Thursday 26 November 2026, 10:00.
  final now = DateTime(2026, 11, 26, 10);

  group('next weekly occurrence', () {
    test('later this week when the day is still ahead', () {
      expect(nextWeeklyOccurrence(now, DateTime.saturday, 9 * 60), DateTime(2026, 11, 28, 9));
    });

    test('next week when the day is Monday and today is Thursday', () {
      expect(nextWeeklyOccurrence(now, DateTime.monday, 9 * 60), DateTime(2026, 11, 30, 9));
    });

    test('today when the time has not come yet, a week later when it has passed', () {
      expect(nextWeeklyOccurrence(now, DateTime.thursday, 21 * 60), DateTime(2026, 11, 26, 21));
      expect(nextWeeklyOccurrence(now, DateTime.thursday, 9 * 60), DateTime(2026, 12, 3, 9));
      expect(nextWeeklyOccurrence(now, DateTime.thursday, 10 * 60), DateTime(2026, 12, 3, 10),
          reason: 'exactly now counts as passed');
    });

    test('crosses a month and year end', () {
      expect(nextWeeklyOccurrence(DateTime(2026, 12, 30, 12), DateTime.sunday, 8 * 60), DateTime(2027, 1, 3, 8));
    });
  });

  test('recognises only its own payload', () {
    expect(isWeeklyReviewPayload('{"type":"weekly_review"}'), isTrue);
    expect(isWeeklyReviewPayload('{"type":"task","id":3}'), isFalse);
    expect(isWeeklyReviewPayload('not json'), isFalse);
    expect(isWeeklyReviewPayload(null), isFalse);
  });
}
