import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../domain/models/document.dart';
import '../../domain/models/item.dart';
import '../../domain/models/maintenance.dart';

class ExportPdfPayload {
  const ExportPdfPayload({
    required this.items,
    required this.maintenances,
    required this.documents,
  });

  final List<Item> items;
  final List<Maintenance> maintenances;
  final List<Document> documents;

  bool get isEmpty => items.isEmpty && maintenances.isEmpty && documents.isEmpty;
}

class ExportPdfService {
  const ExportPdfService();

  Future<File> buildPdf(
    ExportPdfPayload payload,
    AppLocalizations l10n, {
    String? localeTag,
  }) async {
    final df = DateFormat.yMMMd(localeTag);
    final doc = pw.Document();
    final now = DateTime.now();

    final itemNameById = {for (final it in payload.items) it.id: it.name};

    String fmt(DateTime? d) => d == null ? '—' : df.format(d);

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (_) => pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 16),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                l10n.exportPdfTitle,
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                l10n.exportPdfSubtitle(df.format(now)),
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey700,
                ),
              ),
              pw.Divider(),
            ],
          ),
        ),
        footer: (ctx) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            '${ctx.pageNumber}/${ctx.pagesCount}',
            style: const pw.TextStyle(
              fontSize: 9,
              color: PdfColors.grey600,
            ),
          ),
        ),
        build: (_) => [
          _section(l10n.exportPdfSectionItems),
          if (payload.items.isEmpty)
            pw.Text(
              l10n.exportPdfNone,
              style: const pw.TextStyle(color: PdfColors.grey600),
            )
          else
            pw.TableHelper.fromTextArray(
              headers: [
                l10n.exportPdfColName,
                l10n.exportPdfColCategory,
                l10n.exportPdfColBrand,
                l10n.exportPdfColPurchase,
                l10n.exportPdfColWarrantyUntil,
              ],
              data: payload.items
                  .map(
                    (it) => [
                      it.name,
                      it.category.dbValue,
                      it.brand ?? '—',
                      fmt(it.purchaseDate),
                      fmt(it.warrantyExpiryDate),
                    ],
                  )
                  .toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellStyle: const pw.TextStyle(fontSize: 10),
              cellAlignment: pw.Alignment.centerLeft,
            ),
          pw.SizedBox(height: 16),
          _section(l10n.exportPdfSectionMaintenances),
          if (payload.maintenances.isEmpty)
            pw.Text(
              l10n.exportPdfNone,
              style: const pw.TextStyle(color: PdfColors.grey600),
            )
          else
            pw.TableHelper.fromTextArray(
              headers: [
                l10n.exportPdfColName,
                l10n.exportPdfColItem,
                l10n.exportPdfColIntervalMonths,
                l10n.exportPdfColLastDone,
                l10n.exportPdfColNextDue,
              ],
              data: payload.maintenances
                  .map(
                    (m) => [
                      m.name,
                      itemNameById[m.itemId] ?? '—',
                      m.intervalMonths.toString(),
                      fmt(m.lastDoneAt),
                      fmt(m.nextDueAt),
                    ],
                  )
                  .toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellStyle: const pw.TextStyle(fontSize: 10),
              cellAlignment: pw.Alignment.centerLeft,
            ),
          pw.SizedBox(height: 16),
          _section(l10n.exportPdfSectionDocuments),
          if (payload.documents.isEmpty)
            pw.Text(
              l10n.exportPdfNone,
              style: const pw.TextStyle(color: PdfColors.grey600),
            )
          else
            pw.TableHelper.fromTextArray(
              headers: [
                l10n.exportPdfColName,
                l10n.exportPdfColType,
                l10n.exportPdfColExpiry,
              ],
              data: payload.documents
                  .map(
                    (d) => [d.name, d.type.dbValue, fmt(d.expiryDate)],
                  )
                  .toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellStyle: const pw.TextStyle(fontSize: 10),
              cellAlignment: pw.Alignment.centerLeft,
            ),
        ],
      ),
    );

    final bytes = await doc.save();
    final tmp = await getTemporaryDirectory();
    final file = File(p.join(tmp.path, l10n.exportPdfFileName));
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Future<void> shareFile(File file, String subject) async {
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/pdf')],
      subject: subject,
    );
  }

  pw.Widget _section(String label) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 8),
        child: pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      );
}
