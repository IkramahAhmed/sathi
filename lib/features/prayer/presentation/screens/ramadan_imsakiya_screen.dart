import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/utils/logger.dart';
import '../../domain/entities/prayer_name.dart';
import '../l10n_helpers.dart';
import '../providers/prayer_providers.dart';

/// 30-day Sehri / Iftar timetable for the current Ramadan.
class RamadanImsakiyaScreen extends ConsumerStatefulWidget {
  const RamadanImsakiyaScreen({super.key});

  @override
  ConsumerState<RamadanImsakiyaScreen> createState() =>
      _RamadanImsakiyaScreenState();
}

class _RamadanImsakiyaScreenState
    extends ConsumerState<RamadanImsakiyaScreen> {
  final GlobalKey _captureKey = GlobalKey();

  Future<void> _share(String city, int hijriYear) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final boundary =
          _captureKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3);
      final bytes =
          (await image.toByteData(format: ui.ImageByteFormat.png))!
              .buffer
              .asUint8List();
      final dir = await getTemporaryDirectory();
      final file = XFile.fromData(
        bytes,
        mimeType: 'image/png',
        name: 'saathi_imsakiya_$hijriYear.png',
        path: '${dir.path}/saathi_imsakiya_$hijriYear.png',
      );
      await SharePlus.instance.share(ShareParams(files: [file]));
    } catch (error, stackTrace) {
      appLog.warning('Sharing the imsakiya failed', error, stackTrace);
      messenger.showSnackBar(
          const SnackBar(content: Text('Could not share the timetable')));
    }
  }

  /// Find the Gregorian date of the 1st of Ramadan in [hijriYear].
  /// Scans ±400 days from today — fast since HijriCalendar is pure Dart math.
  DateTime? _ramadanStart(DateTime today, int hijriYear, int hijriAdjust) {
    for (var offset = -400; offset <= 400; offset++) {
      final candidate = today.add(Duration(days: offset));
      final h = HijriCalendar.fromDate(
          candidate.add(Duration(days: hijriAdjust)));
      if (h.hYear == hijriYear && h.hMonth == 9 && h.hDay == 1) {
        return candidate;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final settings = ref.watch(currentSettingsProvider);
    final today = ref.watch(todayDateProvider);
    final hijri = ref.watch(hijriTodayProvider);

    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    // Find Ramadan start (could be this year or last/next depending on today).
    final targetYear = hijri.hMonth > 9 ? hijri.hYear + 1 : hijri.hYear;
    final ramadanStart =
        _ramadanStart(today, targetYear, settings.hijriAdjustDays);

    if (ramadanStart == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ramadan Timetable')),
        body: const Center(child: Text('Could not compute Ramadan dates')),
      );
    }

    // Flatten into per-day entries with their Hijri day number.
    final rows = <_ImsakiyaRow>[];
    for (var d = 0; d < 30; d++) {
      final gDate = DateTime(
          ramadanStart.year, ramadanStart.month, ramadanStart.day + d);
      // Find the matching day in the month list.
      final monthData = ref.watch(
          monthTimesProvider(gDate.year, gDate.month));
      final dayData = monthData.firstWhere(
        (day) =>
            day.date.year == gDate.year &&
            day.date.month == gDate.month &&
            day.date.day == gDate.day,
        orElse: () => monthData.first,
      );
      final hijriForDay = HijriCalendar.fromDate(
          gDate.add(Duration(days: settings.hijriAdjustDays)));
      // Stop if we've left Ramadan.
      if (hijriForDay.hMonth != 9) break;
      rows.add(_ImsakiyaRow(
        ramadanDay: d + 1,
        date: gDate,
        sehri: dayData.times[PrayerName.fajr],
        iftar: dayData.times[PrayerName.maghrib],
        isToday: gDate.year == today.year &&
            gDate.month == today.month &&
            gDate.day == today.day,
      ));
    }

    final hijriYear = hijri.hYear;
    final cityName = settings.cityName;

    DataColumn col(String label, {bool numeric = false}) =>
        DataColumn(label: Text(label, style: text.labelLarge), numeric: numeric);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ramadan Timetable'),
        actions: [
          IconButton(
            tooltip: 'Share as image',
            icon: const Icon(Icons.ios_share),
            onPressed: () => _share(cityName, hijriYear),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: RepaintBoundary(
              key: _captureKey,
              child: Container(
                color: scheme.surface,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ramadan $hijriYear — $cityName',
                      style: text.titleMedium,
                    ),
                    Text(
                      'Sehri = Fajr time · Iftar = Maghrib time',
                      style: text.bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 8),
                    DataTable(
                      key: const ValueKey('imsakiya-table'),
                      columnSpacing: 16,
                      headingRowHeight: 44,
                      dataRowMinHeight: 38,
                      dataRowMaxHeight: 38,
                      columns: [
                        col('Day', numeric: true),
                        col('Date'),
                        col('Sehri ends'),
                        col('Iftar'),
                      ],
                      rows: [
                        for (final row in rows)
                          DataRow(
                            color: row.isToday
                                ? WidgetStatePropertyAll(
                                    scheme.primaryContainer)
                                : null,
                            cells: [
                              DataCell(Text(
                                '${row.ramadanDay}',
                                style: TextStyle(
                                    fontWeight: row.isToday
                                        ? FontWeight.bold
                                        : FontWeight.w400),
                              )),
                              DataCell(Text(
                                DateFormat('d MMM', dateLocale(locale))
                                    .format(row.date),
                                style: TextStyle(
                                    fontWeight: row.isToday
                                        ? FontWeight.bold
                                        : FontWeight.w400),
                              )),
                              DataCell(Text(
                                row.sehri != null
                                    ? formatClock(row.sehri!,
                                        settings.timezoneId, locale)
                                    : '—',
                              )),
                              DataCell(Text(
                                row.iftar != null
                                    ? formatClock(row.iftar!,
                                        settings.timezoneId, locale)
                                    : '—',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              )),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Times are calculated for $cityName using ${settings.method.displayName}.',
            style:
                text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ImsakiyaRow {
  const _ImsakiyaRow({
    required this.ramadanDay,
    required this.date,
    required this.sehri,
    required this.iftar,
    required this.isToday,
  });

  final int ramadanDay;
  final DateTime date;
  final DateTime? sehri;
  final DateTime? iftar;
  final bool isToday;
}
