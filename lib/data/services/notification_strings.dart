import '../../core/l10n/generated/app_localizations.dart';

class NotificationTexts {
  const NotificationTexts({
    required this.maintenanceTitle,
    required this.maintenanceBody,
    required this.maintenanceOverdueTitle,
    required this.maintenanceOverdueBody,
    required this.documentTitle,
    required this.documentBody,
    required this.documentExpiredTitle,
    required this.documentExpiredBody,
    required this.warrantyTitle,
    required this.warrantyBody,
    required this.warrantyExpiredTitle,
    required this.warrantyExpiredBody,
  });

  final String maintenanceTitle;
  final String Function(String itemName, String taskName, int days)
  maintenanceBody;
  final String maintenanceOverdueTitle;
  final String Function(String itemName, String taskName) maintenanceOverdueBody;

  final String documentTitle;
  final String Function(String documentName, int days) documentBody;
  final String documentExpiredTitle;
  final String Function(String documentName) documentExpiredBody;

  final String warrantyTitle;
  final String Function(String itemName, int days) warrantyBody;
  final String warrantyExpiredTitle;
  final String Function(String itemName) warrantyExpiredBody;

  factory NotificationTexts.fromL10n(AppLocalizations l10n) {
    return NotificationTexts(
      maintenanceTitle: l10n.notificationMaintenanceTitle,
      maintenanceBody: (item, task, days) =>
          l10n.notificationMaintenanceBody(item, task, days),
      maintenanceOverdueTitle: l10n.notificationMaintenanceOverdueTitle,
      maintenanceOverdueBody: (item, task) =>
          l10n.notificationMaintenanceOverdueBody(item, task),
      documentTitle: l10n.notificationDocumentTitle,
      documentBody: (name, days) => l10n.notificationDocumentBody(name, days),
      documentExpiredTitle: l10n.notificationDocumentExpiredTitle,
      documentExpiredBody: (name) => l10n.notificationDocumentExpiredBody(name),
      warrantyTitle: l10n.notificationWarrantyTitle,
      warrantyBody: (name, days) => l10n.notificationWarrantyBody(name, days),
      warrantyExpiredTitle: l10n.notificationWarrantyExpiredTitle,
      warrantyExpiredBody: (name) => l10n.notificationWarrantyExpiredBody(name),
    );
  }
}
