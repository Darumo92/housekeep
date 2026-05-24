import 'package:flutter/material.dart';

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

  IconData get icon {
    return switch (this) {
      DocumentType.passport => Icons.flight_takeoff_rounded,
      DocumentType.idCard => Icons.badge_rounded,
      DocumentType.driversLicense => Icons.directions_car_rounded,
      DocumentType.vehicleInspection => Icons.car_repair_rounded,
      DocumentType.insuranceHome => Icons.home_rounded,
      DocumentType.insuranceCar => Icons.directions_car_filled_rounded,
      DocumentType.insuranceLife => Icons.favorite_rounded,
      DocumentType.insuranceHealth => Icons.health_and_safety_rounded,
      DocumentType.lease => Icons.assignment_rounded,
      DocumentType.warrantyDoc => Icons.verified_rounded,
      DocumentType.subscription => Icons.subscriptions_rounded,
      DocumentType.other => Icons.description_rounded,
    };
  }
}
