import 'dart:io';
import 'dart:ui' as ui;

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/prayer_name.dart';

/// Minutes-after-midnight for each prayer that was detected. Null = not found.
typedef TimetableScan = Map<PrayerName, int?>;

/// Reads a mosque timetable photo and returns the jama'at time for each
/// obligatory prayer (as minutes after midnight), or null when not detected.
///
/// Uses Google ML Kit Text Recognition on-device — nothing is uploaded.
class MosqueTimetableScanner {
  /// Scans [imagePath] and returns prayer→time mappings.
  ///
  /// Two-pass strategy:
  ///   Pass 1 — raw image (handles printed/paper timetables).
  ///   Pass 2 — LED-optimised preprocessing (grayscale → 2× upscale → invert)
  ///            for dot-matrix and 7-segment LED displays where the first pass
  ///            misses prayers because bright-on-dark confuses ML Kit.
  Future<TimetableScan> scan(String imagePath) async {
    final raw1 = await scanRaw(imagePath);
    // Strip "H:MM SS" current-time display (LED clocks show the live clock
    // alongside the timetable; its seconds component distinguishes it from
    // prayer times, which never have a trailing two-digit seconds field).
    final cleaned1 = _stripCurrentTimeDisplay(raw1);
    final result1 = parseText(cleaned1);

    // If all 5 prayers found, no need for the LED pass.
    if (result1.values.whereType<int>().length >= 5) return result1;

    // LED pass: preprocess to help OCR on dot-matrix / 7-segment displays.
    String? ledPath;
    try {
      ledPath = await _preprocessForLed(imagePath);
      final raw2 = await _scanRawPng(ledPath);
      final cleaned2 = _stripCurrentTimeDisplay(raw2);
      final result2 = parseText(cleaned2);
      final found1 = result1.values.whereType<int>().length;
      final found2 = result2.values.whereType<int>().length;
      if (found2 > found1) return result2;
    } catch (_) {
      // Preprocessing failed — fall through and return the first-pass result.
    } finally {
      if (ledPath != null) File(ledPath).delete().ignore();
    }
    return result1;
  }

  /// Removes LED clock "current time with seconds" patterns like "3:58 19"
  /// (H:MM followed by a space and exactly two digits ≤ 59).  These appear
  /// on dot-matrix displays that show both the live time and the timetable.
  static String _stripCurrentTimeDisplay(String text) {
    // Matches "H:MM SS" where SS is a valid seconds field (00-59).
    return text.replaceAll(RegExp(r'\d{1,2}:\d{2}\s+[0-5]\d(?!\d)'), '');
  }

  /// Returns the raw OCR text from the image. Exposed for testing.
  ///
  /// Tries [InputImage.fromFilePath] first (best quality for JPEG/PNG).
  /// Falls back to dart:ui PNG re-encoding when ML Kit throws a
  /// NullPointerException on WebP and some other formats on Android.
  Future<String> scanRaw(String imagePath) async {
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final input = InputImage.fromFilePath(imagePath);
      try {
        final recognised = await recognizer.processImage(input);
        return recognised.text;
      } catch (_) {
        // ML Kit crashed on the file (WebP causes NPE on Android).
        // Decode via Flutter's image codec and retry with a PNG.
        final fallback = await _inputImageFromBytes(imagePath);
        final recognised = await recognizer.processImage(fallback);
        return recognised.text;
      }
    } finally {
      await recognizer.close();
    }
  }

  /// OCR on a file we already know is a valid PNG — skips the dart:ui
  /// re-encoding that [scanRaw] needs for WebP and other formats.
  Future<String> _scanRawPng(String pngPath) async {
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final recognised = await recognizer.processImage(InputImage.fromFilePath(pngPath));
      return recognised.text;
    } finally {
      await recognizer.close();
    }
  }

  // Re-encode the image as PNG via Flutter's codec and save it to a temp file,
  // then hand the PNG path to ML Kit. bgra8888 bytes work on iOS but not
  // Android — PNG is universally supported by InputImage.fromFilePath().
  static Future<InputImage> _inputImageFromBytes(String imagePath) async {
    final bytes = await File(imagePath).readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final uiImg = frame.image;
    try {
      final pngData = await uiImg.toByteData(format: ui.ImageByteFormat.png);
      if (pngData == null) throw Exception('Could not re-encode image: $imagePath');
      final tmpDir = await getTemporaryDirectory();
      final tmpFile = File('${tmpDir.path}/saathi_mlkit_${DateTime.now().millisecondsSinceEpoch}.png');
      await tmpFile.writeAsBytes(pngData.buffer.asUint8List());
      return InputImage.fromFilePath(tmpFile.path);
    } finally {
      uiImg.dispose();
    }
  }

  /// Preprocesses [imagePath] for LED/dot-matrix mosque timetable displays:
  ///   1. Grayscale      — removes colour noise
  ///   2. 2× upscale     — larger characters = more accurate ML Kit recognition
  ///   3. Invert         — LED text is bright-on-dark; ML Kit (trained on
  ///                       ink-on-paper) performs better with dark-on-light
  ///   4. Binary thresh  — snaps every pixel to pure black or white, giving
  ///                       crisp, alias-free digit outlines the OCR can follow
  ///
  /// Returns the path of the preprocessed PNG (caller must delete it).
  /// On any failure returns the original [imagePath] unchanged.
  static Future<String> _preprocessForLed(String imagePath) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      var image = img.decodeImage(bytes);
      if (image == null) return imagePath;

      // 1. Grayscale
      image = img.grayscale(image);

      // 2. Upscale 2× (capped at 3000 px wide to avoid OOM on high-res photos)
      final targetW = (image.width * 2).clamp(image.width, 3000);
      image = img.copyResize(
        image,
        width: targetW,
        interpolation: img.Interpolation.linear,
      );

      // 3. Invert: LED bright-on-dark → dark-on-light
      img.invert(image);

      // 4. Binary threshold at ~47 % luminance: background pixels (now bright)
      //    snap to pure white; LED digit pixels (now dark) snap to pure black.
      //    Writing into a fresh RGB image avoids any format ambiguity with the
      //    single-channel grayscale representation.
      final w = image.width, h = image.height;
      final bw = img.Image(width: w, height: h, numChannels: 3);
      for (final pixel in image) {
        // After grayscale + invert, r == g == b == inverted luminance.
        final val = pixel.r.toInt() > 120 ? 255 : 0;
        bw.setPixelRgb(pixel.x, pixel.y, val, val, val);
      }

      final tmpDir = await getTemporaryDirectory();
      final tmpFile = File(
        '${tmpDir.path}/saathi_led_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await tmpFile.writeAsBytes(img.encodePng(bw));
      return tmpFile.path;
    } catch (_) {
      return imagePath;
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
    final colResult = _parseColumnBased(rawText);
    if (colResult != null && colResult.values.where((v) => v != null).length >= 3) {
      return colResult;
    }

    // Last resort: Arabic-only or LED-display timetables where prayer names
    // can't be OCR'd. Assign times in chronological order with monotonic PM
    // promotion (Fajr→Dhuhr→Asr→Maghrib→Isha). Requires ≥ 4 unambiguous times.
    final orderResult = _parseByTimeOrder(rawText);
    if (orderResult.values.where((v) => v != null).length >= 3) return orderResult;

    // Final fallback: fewer times available than prayers (common for LED
    // displays where OCR only catches some digits). Try assigning each
    // candidate time to its most plausible prayer window, trying both the
    // raw value and its PM counterpart for ambiguous sub-12h times.
    final windowResult = _parseByTimeWindows(rawText);
    if (windowResult != null && windowResult.values.where((v) => v != null).length >= 2) {
      return windowResult;
    }

    return colResult ?? result;
  }

  /// Order-based fallback: read times in document order and promote ambiguous
  /// 12-hour times to PM using the monotonic-increase property of prayer times.
  /// Used for Arabic LED timetables where ML Kit (Latin recogniser) cannot read
  /// prayer names, and times lack AM/PM markers.
  TimetableScan _parseByTimeOrder(String rawText) {
    final empty = <PrayerName, int?>{for (final p in PrayerName.obligatory) p: null};

    // Collect times in document order (top-to-bottom as OCR reads them).
    final seen = <int>{};
    final ordered = <int>[];
    for (final line in rawText.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty)) {
      for (final t in _timesInLine(line)) {
        if (seen.add(t)) ordered.add(t);
      }
    }

    // Prayer times increase monotonically through the day. When a time is ≤ the
    // previous prayer time, try adding 12 h — this handles 12-hour LED displays
    // that show "1 30" for Dhuhr (1:30 PM) without an explicit PM marker.
    final promoted = <int>[];
    var prev = 0;
    for (var t in ordered) {
      if (t <= prev) {
        final pm = t + 12 * 60;
        if (pm > prev && pm <= 24 * 60) t = pm;
      }
      // Fajr ≥ 2:30 AM; Isha ≤ 11:59 PM; strictly after the previous prayer.
      if (t > prev && t >= 150 && t <= 1439) {
        promoted.add(t);
        prev = t;
        if (promoted.length == 5) break;
      }
    }

    // Require at least 4 unambiguous times — fewer than that is too uncertain
    // for in-order assignment (monotonic promotion could mismatch prayers).
    if (promoted.length < 4) return empty;

    final result = <PrayerName, int?>{for (final p in PrayerName.obligatory) p: null};
    final prayers = PrayerName.obligatory.toList();
    for (var i = 0; i < promoted.length && i < prayers.length; i++) {
      result[prayers[i]] = promoted[i];
    }
    return result;
  }

  /// Window-based fallback for partial LED data: assigns candidate times to
  /// prayers by time-of-day window rather than strictly sequential order.
  /// For each raw time < 12 h, both the AM and PM variants are tried.
  /// Returns null when fewer than 3 prayers can be assigned.
  TimetableScan? _parseByTimeWindows(String rawText) {
    // (lo, hi) in minutes-after-midnight — intentionally generous.
    const windows = <PrayerName, (int, int)>{
      PrayerName.fajr:    (150,  450),  // 02:30–07:30
      PrayerName.dhuhr:   (660,  840),  // 11:00–14:00
      PrayerName.asr:     (840, 1050),  // 14:00–17:30
      PrayerName.maghrib: (1020, 1170), // 17:00–19:30
      PrayerName.isha:    (1140, 1380), // 19:00–23:00
    };

    // Build candidate set: each raw time + its PM twin when < 12 h.
    final seen = <int>{};
    final candidates = <int>[];
    for (final line in rawText.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty)) {
      for (final t in _timesInLine(line)) {
        if (seen.add(t)) candidates.add(t);
        if (t < 720) {
          final pm = t + 720;
          if (seen.add(pm)) candidates.add(pm);
        }
      }
    }

    // Track which source times (< 720) have been used, so that a single OCR
    // reading cannot be assigned to two prayers (once as AM, once as PM twin).
    // Example: "4 42" on an LED counter → 4:42 AM → Fajr, but 4:42 PM must NOT
    // also be assigned to Asr since it came from the same digit group.
    final usedSources = <int>{};
    final result = <PrayerName, int?>{for (final p in PrayerName.obligatory) p: null};
    for (final entry in windows.entries) {
      final (lo, hi) = entry.value;
      for (final t in candidates) {
        if (t < lo || t > hi || result[entry.key] != null) continue;
        final source = t >= 720 ? t - 720 : t;
        if (usedSources.contains(source)) continue;
        result[entry.key] = t;
        usedSources.add(source);
        break;
      }
    }

    // Second pass: partial-time recovery for LED displays where ML Kit drops
    // individual digits. Applied only to windows still empty after the main pass.
    //   • Bare single digit H (1–9) → candidate H:00  (e.g. "5 00" read as "5")
    //   • Bare two-digit MM (01–59) → candidate 1:MM  (e.g. "1 15" read as "15";
    //     the LED "1" is a single thin bar that ML Kit consistently drops)
    if (result.values.any((v) => v == null)) {
      final partSeen = <int>{};
      final partCandidates = <int>[];
      for (final line in rawText.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty)) {
        // Strip full time matches first so partial patterns don't double-count.
        final stripped = line.replaceAll(_timePattern, ' ');
        // Bare single digit 1–9 (not adjacent to another digit) → H:00.
        for (final m in RegExp(r'(?<!\d)([1-9])(?!\d)').allMatches(stripped)) {
          final t = int.parse(m.group(1)!) * 60;
          if (partSeen.add(t)) partCandidates.add(t);
          if (partSeen.add(t + 720)) partCandidates.add(t + 720);
        }
        // Bare two-digit MM (01–59, not adjacent to another digit) → 1:MM.
        for (final m in RegExp(r'(?<!\d)([0-5]\d)(?!\d)').allMatches(stripped)) {
          final mm = int.parse(m.group(1)!);
          if (mm == 0) continue; // bare "00" is pure noise
          final t = 60 + mm; // 1:MM AM
          if (partSeen.add(t)) partCandidates.add(t);
          if (partSeen.add(t + 720)) partCandidates.add(t + 720); // 1:MM PM
        }
      }
      for (final entry in windows.entries) {
        if (result[entry.key] != null) continue;
        final (lo, hi) = entry.value;
        for (final t in partCandidates) {
          if (t < lo || t > hi) continue;
          final source = t >= 720 ? t - 720 : t;
          if (usedSources.contains(source)) continue;
          result[entry.key] = t;
          usedSources.add(source);
          break;
        }
      }
    }

    final found = result.values.where((v) => v != null).length;
    return found >= 3 ? result : null;
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

  // Matches "5:30 AM", "05:30", "5.30 pm", space-separated "5 30" (LED displays),
  // and 4-digit 24-hour "1730".
  static final _timePattern = RegExp(
    r'(\d{1,2})[:. ]([0-5]\d)\s*(am|pm)?|(?<!\d)([01]\d|2[0-3])([0-5]\d)(?!\d)',
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
