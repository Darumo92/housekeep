import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'HouseKeep'**
  String get appName;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'HouseKeep'**
  String get appTitle;

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @itemsTab.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get itemsTab;

  /// No description provided for @documentsTab.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documentsTab;

  /// No description provided for @settingsTab.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTab;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your home at a glance'**
  String get homeTitle;

  /// No description provided for @itemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get itemsTitle;

  /// No description provided for @documentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documentsTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @phaseZeroMessage.
  ///
  /// In en, this message translates to:
  /// **'Phase 0 foundation is ready for the next feature phase.'**
  String get phaseZeroMessage;

  /// No description provided for @itemCategoryKitchen.
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get itemCategoryKitchen;

  /// No description provided for @itemCategoryBathroom.
  ///
  /// In en, this message translates to:
  /// **'Bathroom'**
  String get itemCategoryBathroom;

  /// No description provided for @itemCategoryLaundry.
  ///
  /// In en, this message translates to:
  /// **'Laundry'**
  String get itemCategoryLaundry;

  /// No description provided for @itemCategoryLiving.
  ///
  /// In en, this message translates to:
  /// **'Living room'**
  String get itemCategoryLiving;

  /// No description provided for @itemCategoryBedroom.
  ///
  /// In en, this message translates to:
  /// **'Bedroom'**
  String get itemCategoryBedroom;

  /// No description provided for @itemCategoryGarden.
  ///
  /// In en, this message translates to:
  /// **'Garden'**
  String get itemCategoryGarden;

  /// No description provided for @itemCategoryGarage.
  ///
  /// In en, this message translates to:
  /// **'Garage'**
  String get itemCategoryGarage;

  /// No description provided for @itemCategoryPlumbing.
  ///
  /// In en, this message translates to:
  /// **'Plumbing'**
  String get itemCategoryPlumbing;

  /// No description provided for @itemCategoryElectrical.
  ///
  /// In en, this message translates to:
  /// **'Electrical'**
  String get itemCategoryElectrical;

  /// No description provided for @itemCategorySecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get itemCategorySecurity;

  /// No description provided for @itemCategoryGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get itemCategoryGeneral;

  /// No description provided for @documentTypePassport.
  ///
  /// In en, this message translates to:
  /// **'Passport'**
  String get documentTypePassport;

  /// No description provided for @documentTypeIdCard.
  ///
  /// In en, this message translates to:
  /// **'ID card'**
  String get documentTypeIdCard;

  /// No description provided for @documentTypeDriversLicense.
  ///
  /// In en, this message translates to:
  /// **'Driver\'s license'**
  String get documentTypeDriversLicense;

  /// No description provided for @documentTypeVehicleInspection.
  ///
  /// In en, this message translates to:
  /// **'Vehicle inspection'**
  String get documentTypeVehicleInspection;

  /// No description provided for @documentTypeInsuranceHome.
  ///
  /// In en, this message translates to:
  /// **'Home insurance'**
  String get documentTypeInsuranceHome;

  /// No description provided for @documentTypeInsuranceCar.
  ///
  /// In en, this message translates to:
  /// **'Car insurance'**
  String get documentTypeInsuranceCar;

  /// No description provided for @documentTypeInsuranceLife.
  ///
  /// In en, this message translates to:
  /// **'Life insurance'**
  String get documentTypeInsuranceLife;

  /// No description provided for @documentTypeInsuranceHealth.
  ///
  /// In en, this message translates to:
  /// **'Health insurance'**
  String get documentTypeInsuranceHealth;

  /// No description provided for @documentTypeLease.
  ///
  /// In en, this message translates to:
  /// **'Lease'**
  String get documentTypeLease;

  /// No description provided for @documentTypeWarrantyDoc.
  ///
  /// In en, this message translates to:
  /// **'Warranty document'**
  String get documentTypeWarrantyDoc;

  /// No description provided for @documentTypeSubscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get documentTypeSubscription;

  /// No description provided for @documentTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get documentTypeOther;

  /// No description provided for @urgencyOk.
  ///
  /// In en, this message translates to:
  /// **'All good'**
  String get urgencyOk;

  /// No description provided for @urgencyUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Coming up'**
  String get urgencyUpcoming;

  /// No description provided for @urgencyUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get urgencyUrgent;

  /// No description provided for @urgencyOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get urgencyOverdue;

  /// No description provided for @homeTypeApartment.
  ///
  /// In en, this message translates to:
  /// **'Apartment'**
  String get homeTypeApartment;

  /// No description provided for @homeTypeHouse.
  ///
  /// In en, this message translates to:
  /// **'House'**
  String get homeTypeHouse;

  /// No description provided for @homeTypeVilla.
  ///
  /// In en, this message translates to:
  /// **'Villa'**
  String get homeTypeVilla;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
