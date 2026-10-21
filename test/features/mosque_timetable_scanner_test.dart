// ignore_for_file: avoid_print
import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/features/prayer/data/verification/mosque_timetable_scanner.dart';
import 'package:saathi/features/prayer/domain/entities/prayer_name.dart';

void main() {
  final scanner = MosqueTimetableScanner();

  // Helper: minutes-after-midnight → "H:MM AM/PM"
  String clock(int? m) {
    if (m == null) return 'null';
    final h = m ~/ 60, min = m % 60;
    final h12 = h % 12 == 0 ? 12 : h % 12;
    return '$h12:${min.toString().padLeft(2, '0')} ${h < 12 ? 'AM' : 'PM'}';
  }

  void expectTime(TimetableScan scan, PrayerName prayer, int expectedH, int expectedM) {
    final got = scan[prayer];
    expect(got, isNotNull, reason: '${prayer.name} should be detected');
    expect(got! ~/ 60, expectedH, reason: '${prayer.name} hour');
    expect(got % 60, expectedM, reason: '${prayer.name} minute');
  }

  group('Format A — inline "Name HH:MM AM/PM"', () {
    // Typical UK mosque timetable printed on a board
    const text = '''
Fajr      5:15 AM
Dhuhr     1:20 PM
Asr       4:45 PM
Maghrib   7:10 PM
Isha      9:00 PM
''';

    test('detects all five prayers', () {
      final scan = scanner.parseText(text);
      expectTime(scan, PrayerName.fajr, 5, 15);
      expectTime(scan, PrayerName.dhuhr, 13, 20);
      expectTime(scan, PrayerName.asr, 16, 45);
      expectTime(scan, PrayerName.maghrib, 19, 10);
      expectTime(scan, PrayerName.isha, 21, 0);
    });
  });

  group('Format B — table with azan AND jama\'at columns', () {
    // Most common format: two times per row; jama'at is the last one
    const text = '''
Prayer   Begins   Jama'at
Fajr     5:12     5:30
Zuhr     1:10     1:30
Asr      3:45     4:00
Maghrib  6:22     6:27
Isha     8:30     8:45
''';

    test('picks the jama\'at (last) time from each row', () {
      final scan = scanner.parseText(text);
      expectTime(scan, PrayerName.fajr, 5, 30);
      expectTime(scan, PrayerName.dhuhr, 13, 30);
      expectTime(scan, PrayerName.asr, 16, 0);
      expectTime(scan, PrayerName.maghrib, 18, 27);
      expectTime(scan, PrayerName.isha, 20, 45);
    });
  });

  group('Format C — 24-hour clock', () {
    const text = '''
Fajr    05:20
Dhuhr   13:15
Asr     16:30
Maghrib 19:05
Isha    21:00
''';

    test('parses 24-hour times correctly', () {
      final scan = scanner.parseText(text);
      expectTime(scan, PrayerName.fajr, 5, 20);
      expectTime(scan, PrayerName.dhuhr, 13, 15);
      expectTime(scan, PrayerName.asr, 16, 30);
      expectTime(scan, PrayerName.maghrib, 19, 5);
      expectTime(scan, PrayerName.isha, 21, 0);
    });
  });

  group('Format D — alternate spelling + dot separator', () {
    // "Fajar", "Zuhr", "Magrib", times with dots
    const text = '''
Fajar   5.15
Zuhr    1.20
Asr     4.00
Magrib  6.30
Esha    8.45
''';

    test('handles alternate spellings and dot times', () {
      final scan = scanner.parseText(text);
      expect(scan[PrayerName.fajr], isNotNull, reason: 'Fajar should match Fajr');
      expect(scan[PrayerName.dhuhr], isNotNull, reason: 'Zuhr should match Dhuhr');
      expect(scan[PrayerName.asr], isNotNull, reason: 'Asr detected');
      expect(scan[PrayerName.maghrib], isNotNull, reason: 'Magrib should match Maghrib');
      expect(scan[PrayerName.isha], isNotNull, reason: 'Esha should match Isha');
    });
  });

  group('Format E — OCR noise / messy layout', () {
    // Simulates imperfect OCR: extra spaces, mixed case, stray characters
    const text = '''
FAJR NAMAZ   5 :30 AM  |  Jamaat 5:45 AM
DHUHR        1:15 PM   |  Jamaat 1:30 PM
ASR          3:50 PM   |  Jamaat 4:10 PM
MAGHRIB      6:20 PM   |  Jamaat 6:25 PM
ISHA         8:15 PM   |  Jamaat 8:30 PM
''';

    test('extracts last time (jama\'at) even in noisy rows', () {
      final scan = scanner.parseText(text);
      // Last time in each row is the jama'at time
      expectTime(scan, PrayerName.dhuhr, 13, 30);
      expectTime(scan, PrayerName.asr, 16, 10);
      expectTime(scan, PrayerName.maghrib, 18, 25);
      expectTime(scan, PrayerName.isha, 20, 30);
    });
  });

  group('Edge cases', () {
    test('empty string returns all nulls', () {
      final scan = scanner.parseText('');
      for (final p in PrayerName.obligatory) {
        expect(scan[p], isNull, reason: '${p.name} should be null for empty input');
      }
    });

    test('garbage text returns all nulls', () {
      final scan = scanner.parseText('lorem ipsum dolor sit amet 123 abc');
      for (final p in PrayerName.obligatory) {
        expect(scan[p], isNull);
      }
    });

    test('partial detection — only some prayers found', () {
      const text = 'Fajr 5:30 AM\nMaghrib 6:45 PM';
      final scan = scanner.parseText(text);
      expect(scan[PrayerName.fajr], isNotNull);
      expect(scan[PrayerName.maghrib], isNotNull);
      expect(scan[PrayerName.dhuhr], isNull);
      expect(scan[PrayerName.asr], isNull);
      expect(scan[PrayerName.isha], isNull);
    });
  });

  // Print a nice summary after all tests pass
  tearDownAll(() {
    const testText = '''
Prayer   Begins   Jama'at
Fajr     5:12     5:30
Zuhr     1:10     1:30
Asr      3:45     4:00
Maghrib  6:22     6:27
Isha     8:30     8:45
''';
    final scan = MosqueTimetableScanner().parseText(testText);
    print('\n=== Parser output for sample timetable ===');
    for (final p in PrayerName.obligatory) {
      print('  ${p.name.padRight(8)}: ${clock(scan[p])}');
    }
    print('==========================================\n');
  });
}
