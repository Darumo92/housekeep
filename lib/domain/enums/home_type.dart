import '../../core/l10n/generated/app_localizations.dart';

enum HomeType {
  apartment('apartment'),
  house('house'),
  villa('villa');

  const HomeType(this.dbValue);

  final String dbValue;

  static HomeType fromDb(String value) {
    return HomeType.values.firstWhere(
      (type) => type.dbValue == value,
      orElse: () =>
          throw ArgumentError.value(value, 'value', 'Unknown home type'),
    );
  }

  String label(AppLocalizations l10n) {
    return switch (this) {
      HomeType.apartment => l10n.homeTypeApartment,
      HomeType.house => l10n.homeTypeHouse,
      HomeType.villa => l10n.homeTypeVilla,
    };
  }
}
