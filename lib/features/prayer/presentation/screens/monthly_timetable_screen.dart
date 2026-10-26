import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/utils/logger.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/prayer_name.dart';
import '../l10n_helpers.dart';
import '../providers/prayer_providers.dart';

/// Scrollable monthly timetable with "share as image".
class MonthlyTimetableScreen extends ConsumerStatefulWidget {
  const MonthlyTimetableScreen({super.key});

  @override
  ConsumerState<MonthlyTimetableScreen> createState() => _MonthlyTimetableScreenState();
}

class _MonthlyTimetableScreenState extends ConsumerState<MonthlyTimetableScreen> {
  final GlobalKey _captureKey = GlobalKey();
  DateTime? _month;

  void _shift(int delta) {
    final DateTime today = ref.read(todayDateProvider);
    final current = _month ?? today;
    setState(() => _month = DateTime(current.year, current.month + delta));
  }

  Future<void> _share(AppLocalizations l10n, DateTime month) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final boundary = _captureKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3);
      final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
      final dir = await getTemporaryDirectory();
      final file = XFile.fromData(
        bytes,
        mimeType: 'image/png',
        name: 'saathi_timetable_${month.year}_${month.month}.png',
        path: '${dir.path}/saathi_timetable_${month.year}_${month.month}.png',
      );
      await SharePlus.instance.share(ShareParams(files: [file]));
    } catch (error, stackTrace) {
      appLog.warning('Sharing the timetable failed', error, stackTrace);
      messenger.showSnackBar(SnackBar(content: Text(l10n.shareFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final settings = ref.watch(currentSettingsProvider);
    final today = ref.watch(todayDateProvider);
    final inRamadan = ref.watch(isRamadanProvider);
    final month = _month ?? DateTime(today.year, today.month);
    final days = ref.watch(monthTimesProvider(month.year, month.month));
    // First day of next month gives us Isha's end for the last day of this month.
    final nextMonth = DateTime(month.year, month.month + 1);
    final nextMonthFirst = ref.watch(monthTimesProvider(nextMonth.year, nextMonth.month)).first;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final monthLabel = DateFormat.yMMMM(dateLocale(locale)).format(month);

    DataColumn col(String label) => DataColumn(label: Text(label, style: text.labelLarge));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.timetableTitle),
        actions: [
          if (inRamadan)
            IconButton(
              tooltip: 'Ramadan Imsakiya',
              icon: const Icon(Icons.nightlight_outlined),
              onPressed: () => context.push(Routes.imsakiya),
            ),
          IconButton(
            tooltip: l10n.shareImage,
            icon: const Icon(Icons.ios_share),
            onPressed: () => _share(l10n, month),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              IconButton(
                tooltip: l10n.previousMonth,
                onPressed: () => _shift(-1),
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(monthLabel, textAlign: TextAlign.center, style: text.titleMedium),
              ),
              IconButton(
                tooltip: l10n.nextMonth,
                onPressed: () => _shift(1),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
                    Text('${settings.cityName} · $monthLabel', style: text.titleMedium),
                    Text(settings.method.displayName, style: text.bodySmall),
                    const SizedBox(height: 8),
                    DataTable(
                      key: const ValueKey('timetable'),
                      columnSpacing: 20,
                      headingRowHeight: 44,
                      dataRowMinHeight: 40,
                      dataRowMaxHeight: 40,
                      columns: [
                        col(l10n.colDate),
                        col(l10n.prayerFajr),
                        col(l10n.prayerSunrise),
                        col('${l10n.prayerDhuhr} / ${l10n.prayerJumma}'),
                        col(l10n.prayerAsr),
                        col(l10n.prayerMaghrib),
                        col(l10n.prayerIsha),
                        col('${l10n.prayerIsha} ends'),
                      ],
                      rows: [
                        for (var i = 0; i < days.length; i++)
                          DataRow(
                            color: days[i].date == today
                                ? WidgetStatePropertyAll(scheme.primaryContainer)
                                : null,
                            cells: [
                              DataCell(Text(
                                '${days[i].date.day} ${DateFormat.E(dateLocale(locale)).format(days[i].date)}',
                                style: TextStyle(
                                  fontWeight: days[i].isFriday ? FontWeight.w700 : FontWeight.w400,
                                ),
                              )),
                              for (final p in PrayerName.values)
                                DataCell(Text(
                                  formatClock(days[i].times[p]!, settings.timezoneId, locale),
                                  style: TextStyle(
                                    fontWeight: days[i].isFriday && p == PrayerName.dhuhr
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                  ),
                                )),
                              DataCell(Text(
                                formatClock(
                                  i + 1 < days.length
                                      ? days[i + 1].times[PrayerName.fajr]!
                                      : nextMonthFirst.times[PrayerName.fajr]!,
                                  settings.timezoneId,
                                  locale,
                                ),
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
        ],
      ),
    );
  }
}
