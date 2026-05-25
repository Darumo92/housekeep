import '../../core/l10n/generated/app_localizations.dart';

class NotificationTexts {
  const NotificationTexts({
    required this.maintenanceTitle,
    required this.maintenanceBody,
    required this.documentTitle,
    required this.documentBody,
    required this.warrantyTitle,
    required this.warrantyBody,
  });

  final String maintenanceTitle;
  final String Function(String itemName, String taskName, int days)
  maintenanceBody;

  final String documentTitle;
  final String Function(String documentName, int days) documentBody;

  final String warrantyTitle;
  final String Function(String itemName, int days) warrantyBody;

  factory NotificationTexts.fromL10n(AppLocalizations l10n) {
    return NotificationTexts(
      maintenanceTitle: l10n.notificationMaintenanceTitle,
      maintenanceBody: (item, task, days) =>
          l10n.notificationMaintenanceBody(item, task, days),
      documentTitle: l10n.notificationDocumentTitle,
      documentBody: (name, days) => l10n.notificationDocumentBody(name, days),
      warrantyTitle: l10n.notificationWarrantyTitle,
      warrantyBody: (name, days) => l10n.notificationWarrantyBody(name, days),
    );
  }
}
