import '../../core/l10n/generated/app_localizations.dart';

enum DocumentType {
  passport('passport'),
  idCard('id_card'),
  driversLicense('drivers_license'),
  vehicleInspection('vehicle_inspection'),
  insuranceHome('insurance_home'),
  insuranceCar('insurance_car'),
  insuranceLife('insurance_life'),
  insuranceHealth('insurance_health'),
  lease('lease'),
  warrantyDoc('warranty_doc'),
  subscription('subscription'),
  other('other');

  const DocumentType(this.dbValue);

  final String dbValue;

  static DocumentType fromDb(String value) {
    return DocumentType.values.firstWhere(
      (type) => type.dbValue == value,
      orElse: () =>
          throw ArgumentError.value(value, 'value', 'Unknown document type'),
    );
  }

  String label(AppLocalizations l10n) {
    return switch (this) {
      DocumentType.passport => l10n.documentTypePassport,
      DocumentType.idCard => l10n.documentTypeIdCard,
      DocumentType.driversLicense => l10n.documentTypeDriversLicense,
      DocumentType.vehicleInspection => l10n.documentTypeVehicleInspection,
      DocumentType.insuranceHome => l10n.documentTypeInsuranceHome,
      DocumentType.insuranceCar => l10n.documentTypeInsuranceCar,
      DocumentType.insuranceLife => l10n.documentTypeInsuranceLife,
      DocumentType.insuranceHealth => l10n.documentTypeInsuranceHealth,
      DocumentType.lease => l10n.documentTypeLease,
      DocumentType.warrantyDoc => l10n.documentTypeWarrantyDoc,
      DocumentType.subscription => l10n.documentTypeSubscription,
      DocumentType.other => l10n.documentTypeOther,
    };
  }
}
