import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/core/utils/result.dart';
import 'package:saathi/core/utils/tz_utils.dart';
import 'package:timezone/data/latest.dart' as tzdata;

void main() {
  setUpAll(tzdata.initializeTimeZones);

  group('localDateAt', () {
    test('rolls over to the next day east of UTC', () {
      // 20:00 UTC on 12 Oct is already 01:00 on 13 Oct in Karachi (UTC+5).
      expect(localDateAt(DateTime.utc(2026, 10, 12, 20), 'Asia/Karachi'), DateTime(2026, 10, 13));
    });

    test('stays on the previous day west of UTC', () {
      // 02:00 UTC on 12 Oct is still 11 Oct evening in New York (UTC-4).
      expect(localDateAt(DateTime.utc(2026, 10, 12, 2), 'America/New_York'), DateTime(2026, 10, 11));
    });

    test('handles daylight saving: London is UTC+1 in summer, UTC+0 in winter', () {
      expect(localDateAt(DateTime.utc(2026, 6, 30, 23, 30), 'Europe/London'), DateTime(2026, 7, 1));
      expect(localDateAt(DateTime.utc(2026, 12, 31, 23, 30), 'Europe/London'), DateTime(2026, 12, 31));
    });
  });

  test('dayOfYear counts from 1 and includes the leap day', () {
    expect(dayOfYear(DateTime(2026, 1, 1)), 1);
    expect(dayOfYear(DateTime(2026, 12, 31)), 365);
    expect(dayOfYear(DateTime(2024, 12, 31)), 366);
  });

  group('Result', () {
    test('success and failure expose their values', () {
      const ok = Result<int>.success(3);
      const bad = Result<int>.failure(AppFailure('nope'));
      expect(ok.valueOrNull, 3);
      expect(ok.failureOrNull, isNull);
      expect(bad.valueOrNull, isNull);
      expect(bad.failureOrNull!.message, 'nope');
      expect(ok.when(success: (v) => v * 2, failure: (_) => -1), 6);
      expect(bad.when(success: (v) => v * 2, failure: (_) => -1), -1);
    });

    test('guard converts exceptions into failures', () async {
      final result = await guard<int>(() async => throw StateError('boom'));
      expect(result.isSuccess, isFalse);
      expect(result.failureOrNull!.cause, isA<StateError>());
      expect((await guard(() async => 7)).valueOrNull, 7);
    });
  });
}
