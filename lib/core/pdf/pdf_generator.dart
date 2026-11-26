import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../features/udhaar/domain/passbook.dart';
import '../storage/app_database.dart';
import '../../features/khata/domain/entities/income_source.dart';

final _fmt = NumberFormat('#,##0', 'en');
String _rs(double v) => 'Rs ${_fmt.format(v.abs())}';

// ── Khata monthly report ──────────────────────────────────────────────────────

/// Returns raw PDF bytes — used by the background task to email the report.
Future<List<int>> buildKhataPdfBytes(
  List<Expense> entries,
  DateTime month,
) async {
  final doc = pw.Document();
  doc.addPage(_khataPdfPage(entries, month));
  return doc.save();
}

Future<void> shareKhataPdf(
  List<Expense> entries,
  DateTime month, {
  String Function(String key)? categoryName,
}) async {
  final fileLabel = DateFormat('yyyy-MM').format(month);
  final doc = pw.Document();
  doc.addPage(_khataPdfPage(entries, month, categoryName));
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/khata_$fileLabel.pdf');
  await file.writeAsBytes(await doc.save());
  await Share.shareXFiles([
    XFile(file.path, mimeType: 'application/pdf'),
  ], subject: 'Khata – ${DateFormat.yMMMM().format(month)}');
}

pw.MultiPage _khataPdfPage(
  List<Expense> entries,
  DateTime month, [
  String Function(String key)? categoryName,
]) {
  final monthLabel = DateFormat('MMMM yyyy').format(month);
  final totalIncome = entries
      .where((e) => e.type == 'income')
      .fold(0.0, (s, e) => s + e.amount);
  final totalExpense = entries
      .where((e) => e.type != 'income')
      .fold(0.0, (s, e) => s + e.amount);
  final net = totalIncome - totalExpense;

  return pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(32),
    build: (_) => [
      pw.Text(
        'Saathi — Khata Report',
        style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
      ),
      pw.Text(
        monthLabel,
        style: const pw.TextStyle(fontSize: 13, color: PdfColors.grey700),
      ),
      pw.SizedBox(height: 16),
      _summaryRow('Total income', totalIncome, PdfColors.green700),
      _summaryRow('Total expense', totalExpense, PdfColors.red700),
      _summaryRow('Net', net, net >= 0 ? PdfColors.green800 : PdfColors.red800),
      pw.SizedBox(height: 20),
      pw.Text(
        'Entries',
        style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),
      pw.Table(
        border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
        columnWidths: const {
          0: pw.FlexColumnWidth(1.5),
          1: pw.FlexColumnWidth(2),
          2: pw.FlexColumnWidth(1.5),
          3: pw.FlexColumnWidth(2),
        },
        children: [
          _tableHeader(['Date', 'Type / Category', 'Amount', 'Note']),
          for (final e in entries)
            _tableRow([
              e.date,
              e.type == 'income'
                  ? 'Income · ${IncomeSource.fromString(e.category).name}'
                  : (categoryName ?? (k) => k)(e.category),
              (e.type == 'income' ? '+' : '-') + _rs(e.amount),
              e.note,
            ], e.type == 'income'),
        ],
      ),
    ],
  );
}

// ── Udhaar passbook ───────────────────────────────────────────────────────────

Future<void> shareUdhaarPassbookPdf(
  UdhaarContact contact,
  List<UdhaarEntry> entries,
  double balance,
) async {
  final doc = pw.Document();
  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (_) => [
        pw.Text(
          'Saathi — Udhaar Passbook',
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(
          contact.name,
          style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          balance > 0
              ? 'Outstanding: ${_rs(balance)} (they owe you)'
              : balance < 0
              ? 'Outstanding: ${_rs(balance.abs())} (you owe them)'
              : 'All settled',
          style: pw.TextStyle(
            fontSize: 13,
            fontWeight: pw.FontWeight.bold,
            color: balance > 0
                ? PdfColors.green700
                : balance < 0
                ? PdfColors.red700
                : PdfColors.grey600,
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          columnWidths: const {
            0: pw.FlexColumnWidth(1.5),
            1: pw.FlexColumnWidth(1.2),
            2: pw.FlexColumnWidth(1.5),
            3: pw.FlexColumnWidth(1.6),
            4: pw.FlexColumnWidth(2),
            5: pw.FlexColumnWidth(1.5),
          },
          children: [
            _tableHeader(['Date', 'Type', 'Amount', 'Balance', 'Note', 'Due date']),
            for (final row in passbookRows(entries))
              _tableRow(
                [
                  row.entry.date,
                  row.entry.type == 'gave' ? 'Gave' : 'Received',
                  _rs(row.entry.amount),
                  '${_rs(row.balance)}${row.balance == 0 ? '' : row.balance > 0 ? ' Dr' : ' Cr'}',
                  row.entry.note,
                  row.entry.dueDate ?? '—',
                ],
                row.entry.type == 'gave',
                debitColor: PdfColors.red700,
              ),
          ],
        ),
      ],
    ),
  );

  final dir = await getTemporaryDirectory();
  final safe = contact.name.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
  final file = File('${dir.path}/udhaar_$safe.pdf');
  await file.writeAsBytes(await doc.save());
  await Share.shareXFiles([
    XFile(file.path, mimeType: 'application/pdf'),
  ], subject: 'Udhaar Passbook — ${contact.name}');
}

// ── Helpers ───────────────────────────────────────────────────────────────────

pw.TableRow _tableHeader(List<String> cols) => pw.TableRow(
  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
  children: [
    for (final c in cols)
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: pw.Text(
          c,
          style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
        ),
      ),
  ],
);

pw.TableRow _tableRow(
  List<String> cols,
  bool isCredit, {
  PdfColor debitColor = PdfColors.black,
}) => pw.TableRow(
  children: [
    for (final c in cols)
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: pw.Text(
          c,
          style: pw.TextStyle(
            fontSize: 9,
            color: isCredit ? PdfColors.green700 : debitColor,
          ),
        ),
      ),
  ],
);

pw.Widget _summaryRow(String label, double amount, PdfColor color) =>
    pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Text(label, style: const pw.TextStyle(fontSize: 12)),
          ),
          pw.Text(
            _rs(amount),
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
