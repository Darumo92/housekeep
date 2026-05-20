// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'HouseKeep';

  @override
  String get appTitle => 'HouseKeep';

  @override
  String get homeTab => 'Inicio';

  @override
  String get itemsTab => 'Items';

  @override
  String get documentsTab => 'Documentos';

  @override
  String get settingsTab => 'Ajustes';

  @override
  String get homeTitle => 'Tu casa de un vistazo';

  @override
  String get itemsTitle => 'Items';

  @override
  String get documentsTitle => 'Documentos';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get phaseZeroMessage =>
      'La base de la Fase 0 ya está lista para la siguiente fase.';
}
