import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../data/repositories/repository_providers.dart';
import 'export_pdf_service.dart';

final exportPdfServiceProvider = Provider<ExportPdfService>((_) {
  return const ExportPdfService();
});

class ExportController {
  ExportController(this._ref);

  final Ref _ref;

  Future<ExportPdfPayload> collect() async {
    final items = await _ref.read(itemsRepositoryProvider).watchItems().first;
    final maintenances = await _ref
        .read(maintenancesRepositoryProvider)
        .watchAllMaintenances()
        .first;
    final documents = await _ref
        .read(documentsRepositoryProvider)
        .watchDocuments()
        .first;
    return ExportPdfPayload(
      items: items,
      maintenances: maintenances,
      documents: documents,
    );
  }

  Future<bool> exportAndShare(AppLocalizations l10n, {String? localeTag}) async {
    final payload = await collect();
    if (payload.isEmpty) return false;
    final service = _ref.read(exportPdfServiceProvider);
    final file = await service.buildPdf(payload, l10n, localeTag: localeTag);
    await service.shareFile(file, l10n.exportPdfTitle);
    return true;
  }
}

final exportControllerProvider = Provider<ExportController>((ref) {
  return ExportController(ref);
});
