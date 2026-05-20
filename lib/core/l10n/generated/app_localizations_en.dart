// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'HouseKeep';

  @override
  String get appTitle => 'HouseKeep';

  @override
  String get homeTab => 'Home';

  @override
  String get itemsTab => 'Items';

  @override
  String get documentsTab => 'Documents';

  @override
  String get settingsTab => 'Settings';

  @override
  String get homeTitle => 'Your home at a glance';

  @override
  String get itemsTitle => 'Items';

  @override
  String get documentsTitle => 'Documents';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get phaseZeroMessage =>
      'Phase 0 foundation is ready for the next feature phase.';
}
