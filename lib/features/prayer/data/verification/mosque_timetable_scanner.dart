import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/prayer_name.dart';

/// Minutes-after-midnight for each prayer that was detected. Null = not found.
typedef TimetableScan = Map<PrayerName, int?>;

/// Reads a mosque timetable photo and returns the jama'at time for each
/// obligatory prayer (as minutes after midnight), or null when not detected.
///
/// Uses Google ML Kit Text Recognition on-device — nothing is uploaded.
class MosqueTimetableScanner {
  Future<TimetableScan> scan(String imagePath) async {
    final raw = await scanRaw(imagePath);
    return parseText(raw);
  }

  /// Returns the raw OCR text from the image. Exposed for testing.
  Future<String> scanRaw(String imagePath) async {
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final input = InputImage.fromFilePath(imagePath);
      final recognised = await recognizer.processImage(input);
      return recognised.text;
    } finally {
      await recognizer.close();
    }
  }

  /// Parses raw OCR text to extract prayer→jama'at time mappings.
  /// Public so it can be unit-tested without a real image.
  TimetableScan parseText(String rawText) {
    // Try row-based first (prayer name + times on same/adjacent line).
    final result = _parseRowBased(rawText);
    if (result.values.where((v) => v != null).length >= 3) return result;

    // Fallback: ML Kit sometimes reads tables column-by-column.
    // Detect that pattern and zip prayer names with jamaat times.
    return _parseColumnBased(rawText) ?? result;
  }

  TimetableScan _parseRowBased(String rawText) {
    final result = <PrayerName, int?>{for (final p in PrayerName.obligatory) p: null};

    final lines = rawText
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    for (var i = 0; i < lines.length; i++) {
      final prayer = _prayerInLine(lines[i]);
      if (prayer == null) continue;

      // Try current line first; only fall back to next line if no times here.
      var candidates = _timesInLine(lines[i]);
      if (candidates.isEmpty && i + 1 < lines.length) {
        candidates = _timesInLine(lines[i + 1]);
      }

      if (candidates.isEmpty) continue;

      // When a row has two times (azan + jama'at), take the LAST one.
      final raw = candidates.last;
      result[prayer] = _applyPrayerContext(raw, prayer);
    }

    return result;
  }

  // Matches "Jamaat", "Jama'at", "Jamat" etc.
  static final _jamaatPattern =
      RegExp(r"jama[a']?[a']?t|jamat", caseSensitive: false);

  /// Column-based fallback: prayer names appear in one column, times in another.
  /// Finds the ordered prayer sequence and the jamaat time column, then zips them.
  TimetableScan? _parseColumnBased(String rawText) {
    final lines = rawText
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    // Collect prayer names in the order they appear (skip duplicates).
    final prayerOrder = <PrayerName>[];
    for (final line in lines) {
      final p = _prayerInLine(line);
      if (p != null && !prayerOrder.contains(p)) prayerOrder.add(p);
    }
    if (prayerOrder.length < 3) return null;

    // Find the last "Jamaat" header, then take single-time lines after it.
    var jamaatIdx = -1;
    for (var i = 0; i < lines.length; i++) {
      if (_jamaatPattern.hasMatch(lines[i])) jamaatIdx = i;
    }

    final timeLines = <int>[];
    final start = jamaatIdx >= 0 ? jamaatIdx + 1 : 0;
    for (var i = start; i < lines.length; i++) {
      final ts = _timesInLine(lines[i]);
      if (ts.length == 1) timeLines.add(ts.first);
    }

    if (timeLines.length < prayerOrder.length) return null;

    // If more times than prayers, take the last N (most likely to be jamaat col).
    final matched = timeLines.sublist(timeLines.length - prayerOrder.length);

    final result = <PrayerName, int?>{for (final p in PrayerName.obligatory) p: null};
    for (var i = 0; i < prayerOrder.length; i++) {
      result[prayerOrder[i]] = _applyPrayerContext(matched[i], prayerOrder[i]);
    }
    return result;
  }

  // ── Prayer name detection ──────────────────────────────────────────────────

  static final _prayerKeywords = <PrayerName, List<RegExp>>{
    PrayerName.fajr: [
      RegExp(r'\b(fajr|fajar|fajer|subh|subuh|fair|faijr)\b', caseSensitive: false),
    ],
    PrayerName.dhuhr: [
      RegExp(r'\b(dhuhr?|zuhr?|zohr?|zohur?|duhr|dhur|dhuhor)\b', caseSensitive: false),
    ],
    PrayerName.asr: [
      RegExp(r'\basr?\b', caseSensitive: false),
    ],
    PrayerName.maghrib: [
      RegExp(r'\b(maghrib|magrib|maghreb)\b', caseSensitive: false),
    ],
    PrayerName.isha: [
      RegExp(r"\b(isha['a]?|esha['a]?|ishaa?)\b", caseSensitive: false),
    ],
  };

  PrayerName? _prayerInLine(String line) {
    for (final entry in _prayerKeywords.entries) {
      if (entry.value.any((re) => re.hasMatch(line))) return entry.key;
    }
    return null;
  }

  // ── Time extraction ────────────────────────────────────────────────────────

  // Matches "5:30 AM", "05:30", "5.30 pm", and 4-digit "1730"
  static final _timePattern = RegExp(
    r'(\d{1,2})[:.](\d{2})\s*(am|pm)?|(?<!\d)([01]\d|2[0-3])([0-5]\d)(?!\d)',
    caseSensitive: false,
  );

  List<int> _timesInLine(String line) {
    final times = <int>[];
    for (final m in _timePattern.allMatches(line)) {
      final t = _parseMatch(m);
      if (t != null) times.add(t);
    }
    return times;
  }

  int? _parseMatch(RegExpMatch m) {
    if (m.group(1) != null) {
      final h = int.parse(m.group(1)!);
      final min = int.parse(m.group(2)!);
      final suffix = m.group(3)?.toLowerCase();
      return _toMinutes(h, min, suffix);
    }
    // 4-digit 24-hour, e.g. "1730"
    if (m.group(4) != null) {
      final h = int.parse(m.group(4)!);
      final min = int.parse(m.group(5)!);
      if (h > 23 || min >= 60) return null;
      return h * 60 + min;
    }
    return null;
  }

  int? _toMinutes(int h, int min, String? suffix) {
    if (h < 0 || min >= 60) return null;
    if (suffix == null) {
      // No AM/PM: accept as-is for 24-hour (h up to 23), or leave ambiguous
      // for h<=12 — _applyPrayerContext will add 12h if needed.
      if (h > 23) return null;
      return h * 60 + min;
    }
    // 12-hour with explicit AM/PM
    if (h < 1 || h > 12) return null;
    int hour = h;
    if (suffix == 'pm' && h != 12) hour += 12;
    if (suffix == 'am' && h == 12) hour = 0;
    return hour * 60 + min;
  }

  // ── Prayer context inference ───────────────────────────────────────────────

  /// When a time has no AM/PM suffix and hour < 12, infer PM for every prayer
  /// except Fajr (which is always before sunrise).
  int _applyPrayerContext(int minutes, PrayerName prayer) {
    final h = minutes ~/ 60;
    if (h >= 12) return minutes; // Already unambiguously PM (or noon)
    if (prayer == PrayerName.fajr) return minutes; // Fajr is always AM
    // Dhuhr / Asr / Maghrib / Isha are always afternoon/evening
    return minutes + 12 * 60;
  }
}

/// Camera/gallery helper for timetable scanning.
class TimetableCameraSource {
  TimetableCameraSource([ImagePicker? picker]) : _picker = picker ?? ImagePicker();
  final ImagePicker _picker;

  Future<String?> takePhoto() async {
    final shot = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      imageQuality: 90,
    );
    return shot?.path;
  }

  Future<String?> pickFromGallery() async {
    final shot = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      imageQuality: 90,
    );
    return shot?.path;
  }

  Future<void> discard(String path) async {
    try {
      await File(path).delete();
    } catch (_) {}
  }
}
