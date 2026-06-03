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
  /// **'My things'**
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

  /// No description provided for @itemsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get itemsEmptyTitle;

  /// No description provided for @itemsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Your boiler, the washing machine, the car… anything with maintenance or a warranty.'**
  String get itemsEmptyBody;

  /// No description provided for @itemsEmptyCta.
  ///
  /// In en, this message translates to:
  /// **'Add thing'**
  String get itemsEmptyCta;

  /// No description provided for @itemsCountFree.
  ///
  /// In en, this message translates to:
  /// **'{n}/5'**
  String itemsCountFree(int n);

  /// No description provided for @itemsCount.
  ///
  /// In en, this message translates to:
  /// **'{n} items'**
  String itemsCount(int n);

  /// No description provided for @itemsWarrantyActive.
  ///
  /// In en, this message translates to:
  /// **'Active warranty'**
  String get itemsWarrantyActive;

  /// No description provided for @itemsWarrantyExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired warranty'**
  String get itemsWarrantyExpired;

  /// No description provided for @itemsWarrantyExpiryInDays.
  ///
  /// In en, this message translates to:
  /// **'in {days}d'**
  String itemsWarrantyExpiryInDays(int days);

  /// No description provided for @itemsWarrantyExpiryDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String itemsWarrantyExpiryDaysAgo(int days);

  /// No description provided for @itemDetailWarranty.
  ///
  /// In en, this message translates to:
  /// **'Warranty'**
  String get itemDetailWarranty;

  /// No description provided for @itemDetailPhotoPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Appliance photo'**
  String get itemDetailPhotoPlaceholder;

  /// No description provided for @itemDetailMaintenanceInterval.
  ///
  /// In en, this message translates to:
  /// **'every {count, plural, one {{count} month} other {{count} months}}'**
  String itemDetailMaintenanceInterval(int count);

  /// No description provided for @itemDetailPurchasedOn.
  ///
  /// In en, this message translates to:
  /// **'Purchased {date}'**
  String itemDetailPurchasedOn(String date);

  /// No description provided for @itemDetailUntil.
  ///
  /// In en, this message translates to:
  /// **'until {date}'**
  String itemDetailUntil(String date);

  /// No description provided for @itemDetailHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get itemDetailHistory;

  /// No description provided for @itemDetailMonthsWarranty.
  ///
  /// In en, this message translates to:
  /// **'{n} months'**
  String itemDetailMonthsWarranty(int n);

  /// No description provided for @addFieldPurchased.
  ///
  /// In en, this message translates to:
  /// **'Purchase date'**
  String get addFieldPurchased;

  /// No description provided for @addSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get addSave;

  /// No description provided for @addCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get addCancel;

  /// No description provided for @addPhotoCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get addPhotoCamera;

  /// No description provided for @addPhotoGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get addPhotoGallery;

  /// No description provided for @itemsFilteredEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No items in this category'**
  String get itemsFilteredEmptyTitle;

  /// No description provided for @itemsFilteredEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Try another category or clear the filter.'**
  String get itemsFilteredEmptyBody;

  /// No description provided for @itemsClearFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear filter'**
  String get itemsClearFilter;

  /// No description provided for @itemsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get itemsFilterAll;

  /// No description provided for @itemNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get itemNameLabel;

  /// No description provided for @itemBrandLabel.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get itemBrandLabel;

  /// No description provided for @itemModelLabel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get itemModelLabel;

  /// No description provided for @itemPurchaseDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Purchase date'**
  String get itemPurchaseDateLabel;

  /// No description provided for @itemWarrantyMonthsLabel.
  ///
  /// In en, this message translates to:
  /// **'Warranty months'**
  String get itemWarrantyMonthsLabel;

  /// No description provided for @itemNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get itemNotesLabel;

  /// No description provided for @itemPhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get itemPhotoLabel;

  /// No description provided for @itemCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get itemCategoryLabel;

  /// No description provided for @itemSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get itemSave;

  /// No description provided for @itemEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get itemEdit;

  /// No description provided for @itemDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get itemDelete;

  /// No description provided for @itemDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete item?'**
  String get itemDeleteTitle;

  /// No description provided for @itemDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This will also delete related maintenance history.'**
  String get itemDeleteBody;

  /// No description provided for @itemDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get itemDeleteConfirm;

  /// No description provided for @itemDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the item. Please try again.'**
  String get itemDeleteFailed;

  /// No description provided for @itemNoWarranty.
  ///
  /// In en, this message translates to:
  /// **'No warranty'**
  String get itemNoWarranty;

  /// No description provided for @itemWarrantyActive.
  ///
  /// In en, this message translates to:
  /// **'Warranty active'**
  String get itemWarrantyActive;

  /// No description provided for @itemWarrantyExpired.
  ///
  /// In en, this message translates to:
  /// **'Warranty expired'**
  String get itemWarrantyExpired;

  /// No description provided for @itemAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get itemAddTitle;

  /// No description provided for @itemEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get itemEditTitle;

  /// No description provided for @itemDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Item details'**
  String get itemDetailTitle;

  /// No description provided for @itemPhotoAdd.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get itemPhotoAdd;

  /// No description provided for @itemPhotoReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace photo'**
  String get itemPhotoReplace;

  /// No description provided for @itemPhotoRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get itemPhotoRemove;

  /// No description provided for @itemPhotoCamera.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get itemPhotoCamera;

  /// No description provided for @itemPhotoGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get itemPhotoGallery;

  /// No description provided for @photoPickerErrorPermission.
  ///
  /// In en, this message translates to:
  /// **'Camera or gallery permission denied. Grant access in Settings.'**
  String get photoPickerErrorPermission;

  /// No description provided for @photoPickerErrorStorageFull.
  ///
  /// In en, this message translates to:
  /// **'Not enough storage to save the photo. Free up space and try again.'**
  String get photoPickerErrorStorageFull;

  /// No description provided for @photoPickerErrorNoCamera.
  ///
  /// In en, this message translates to:
  /// **'No camera available on this device.'**
  String get photoPickerErrorNoCamera;

  /// No description provided for @photoPickerErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t add the photo.'**
  String get photoPickerErrorUnknown;

  /// No description provided for @photoPickerOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get photoPickerOpenSettings;

  /// No description provided for @homeAddMaintenancePickItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Which item is this maintenance for?'**
  String get homeAddMaintenancePickItemTitle;

  /// No description provided for @itemValidationName.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get itemValidationName;

  /// No description provided for @itemValidationWarrantyMonths.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number of months'**
  String get itemValidationWarrantyMonths;

  /// No description provided for @itemMaintenanceSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get itemMaintenanceSectionTitle;

  /// No description provided for @itemMaintenanceSectionEmpty.
  ///
  /// In en, this message translates to:
  /// **'No maintenance tasks for this item yet.'**
  String get itemMaintenanceSectionEmpty;

  /// No description provided for @itemMaintenanceAdd.
  ///
  /// In en, this message translates to:
  /// **'Add maintenance'**
  String get itemMaintenanceAdd;

  /// No description provided for @maintenanceAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add maintenance'**
  String get maintenanceAddTitle;

  /// No description provided for @maintenanceEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit maintenance'**
  String get maintenanceEditTitle;

  /// No description provided for @maintenanceNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Task name'**
  String get maintenanceNameLabel;

  /// No description provided for @maintenanceDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get maintenanceDescriptionLabel;

  /// No description provided for @maintenanceIntervalLabel.
  ///
  /// In en, this message translates to:
  /// **'Interval (months)'**
  String get maintenanceIntervalLabel;

  /// No description provided for @maintenanceItemContextLabel.
  ///
  /// In en, this message translates to:
  /// **'Maintenance for'**
  String get maintenanceItemContextLabel;

  /// No description provided for @maintenanceLastDoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Last done'**
  String get maintenanceLastDoneLabel;

  /// No description provided for @maintenanceLastDoneNever.
  ///
  /// In en, this message translates to:
  /// **'Not recorded'**
  String get maintenanceLastDoneNever;

  /// No description provided for @maintenanceNotifyDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Notify days before'**
  String get maintenanceNotifyDaysLabel;

  /// No description provided for @maintenanceNextDueLabel.
  ///
  /// In en, this message translates to:
  /// **'Next due'**
  String get maintenanceNextDueLabel;

  /// No description provided for @maintenanceSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get maintenanceSave;

  /// No description provided for @maintenanceMarkDone.
  ///
  /// In en, this message translates to:
  /// **'Mark as done'**
  String get maintenanceMarkDone;

  /// No description provided for @maintenanceMarkDoneSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Mark as done'**
  String get maintenanceMarkDoneSheetTitle;

  /// No description provided for @maintenanceMarkDoneWhenLabel.
  ///
  /// In en, this message translates to:
  /// **'When did you do it?'**
  String get maintenanceMarkDoneWhenLabel;

  /// No description provided for @maintenanceMarkDoneToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get maintenanceMarkDoneToday;

  /// No description provided for @maintenanceMarkDoneYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get maintenanceMarkDoneYesterday;

  /// No description provided for @maintenanceMarkDoneOtherDate.
  ///
  /// In en, this message translates to:
  /// **'Other date'**
  String get maintenanceMarkDoneOtherDate;

  /// No description provided for @maintenanceMarkDoneNextReminder.
  ///
  /// In en, this message translates to:
  /// **'Next reminder'**
  String get maintenanceMarkDoneNextReminder;

  /// No description provided for @maintenanceMarkDoneNextInMonths.
  ///
  /// In en, this message translates to:
  /// **'in {count, plural, one {{count} month} other {{count} months}}'**
  String maintenanceMarkDoneNextInMonths(int count);

  /// No description provided for @maintenanceMarkDoneConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get maintenanceMarkDoneConfirm;

  /// No description provided for @maintenanceMarkDoneCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Done!'**
  String get maintenanceMarkDoneCompletedTitle;

  /// No description provided for @maintenanceMarkDoneCompletedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Next reminder in {days, plural, one {{days} day} other {{days} days}}'**
  String maintenanceMarkDoneCompletedSubtitle(int days);

  /// No description provided for @maintenanceEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get maintenanceEdit;

  /// No description provided for @maintenanceDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get maintenanceDelete;

  /// No description provided for @maintenanceDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete maintenance?'**
  String get maintenanceDeleteTitle;

  /// No description provided for @maintenanceDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get maintenanceDeleteBody;

  /// No description provided for @maintenanceDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get maintenanceDeleteConfirm;

  /// No description provided for @maintenanceDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the maintenance.'**
  String get maintenanceDeleteFailed;

  /// No description provided for @maintenanceSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the maintenance.'**
  String get maintenanceSaveFailed;

  /// No description provided for @maintenanceMarkDoneFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not mark as done.'**
  String get maintenanceMarkDoneFailed;

  /// No description provided for @maintenanceValidationName.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get maintenanceValidationName;

  /// No description provided for @maintenanceValidationInterval.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number of months'**
  String get maintenanceValidationInterval;

  /// No description provided for @maintenanceValidationNotifyDays.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number of days'**
  String get maintenanceValidationNotifyDays;

  /// No description provided for @maintenanceUseTemplate.
  ///
  /// In en, this message translates to:
  /// **'Use template'**
  String get maintenanceUseTemplate;

  /// No description provided for @maintenanceTemplatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Maintenance templates'**
  String get maintenanceTemplatesTitle;

  /// No description provided for @maintenanceTemplatesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No templates for this category.'**
  String get maintenanceTemplatesEmpty;

  /// No description provided for @maintenanceTemplatesAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get maintenanceTemplatesAll;

  /// No description provided for @maintenanceTemplatesSuggested.
  ///
  /// In en, this message translates to:
  /// **'Suggested for {category}'**
  String maintenanceTemplatesSuggested(String category);

  /// No description provided for @maintenanceTemplateProBadge.
  ///
  /// In en, this message translates to:
  /// **'PRO'**
  String get maintenanceTemplateProBadge;

  /// No description provided for @maintenanceTemplateProLocked.
  ///
  /// In en, this message translates to:
  /// **'This template requires HouseKeep Pro.'**
  String get maintenanceTemplateProLocked;

  /// No description provided for @maintenanceIntervalMonths.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} month} other {{count} months}}'**
  String maintenanceIntervalMonths(int count);

  /// No description provided for @maintenanceNextDueIn.
  ///
  /// In en, this message translates to:
  /// **'Due in {days, plural, one {{days} day} other {{days} days}}'**
  String maintenanceNextDueIn(int days);

  /// No description provided for @maintenanceOverdueBy.
  ///
  /// In en, this message translates to:
  /// **'Overdue by {days, plural, one {{days} day} other {{days} days}}'**
  String maintenanceOverdueBy(int days);

  /// No description provided for @maintenanceDoneToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get maintenanceDoneToday;

  /// No description provided for @maintenanceHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Last done: {date}'**
  String maintenanceHistoryTitle(String date);

  /// No description provided for @maintenanceLastDoneNeverShort.
  ///
  /// In en, this message translates to:
  /// **'Never done'**
  String get maintenanceLastDoneNeverShort;

  /// No description provided for @paywallMaintenanceProTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock Pro templates'**
  String get paywallMaintenanceProTitle;

  /// No description provided for @paywallMaintenanceProBody.
  ///
  /// In en, this message translates to:
  /// **'Some advanced templates (pool, irrigation, solar panels) require HouseKeep Pro.'**
  String get paywallMaintenanceProBody;

  /// No description provided for @paywallItemsLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock unlimited items'**
  String get paywallItemsLimitTitle;

  /// No description provided for @paywallItemsLimitBody.
  ///
  /// In en, this message translates to:
  /// **'The free plan includes up to 5 items. Upgrade to Pro to add as many as you need.'**
  String get paywallItemsLimitBody;

  /// No description provided for @paywallUpgradeCta.
  ///
  /// In en, this message translates to:
  /// **'Upgrade soon'**
  String get paywallUpgradeCta;

  /// No description provided for @paywallBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get paywallBack;

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

  /// No description provided for @documentsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No saved documents'**
  String get documentsEmptyTitle;

  /// No description provided for @documentsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'ID, inspection, insurance… we\'ll remind you a month ahead.'**
  String get documentsEmptyBody;

  /// No description provided for @documentsEmptyCta.
  ///
  /// In en, this message translates to:
  /// **'Add document'**
  String get documentsEmptyCta;

  /// No description provided for @documentsCountFree.
  ///
  /// In en, this message translates to:
  /// **'{n}/3'**
  String documentsCountFree(int n);

  /// No description provided for @documentsCount.
  ///
  /// In en, this message translates to:
  /// **'{n} documents'**
  String documentsCount(int n);

  /// No description provided for @documentsSectionExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get documentsSectionExpired;

  /// No description provided for @documentsSectionSoon.
  ///
  /// In en, this message translates to:
  /// **'Expiring soon'**
  String get documentsSectionSoon;

  /// No description provided for @documentsSectionCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get documentsSectionCurrent;

  /// No description provided for @documentsFilteredEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No documents of this type'**
  String get documentsFilteredEmptyTitle;

  /// No description provided for @documentsFilteredEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Try another type or clear the filter.'**
  String get documentsFilteredEmptyBody;

  /// No description provided for @documentsClearFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear filter'**
  String get documentsClearFilter;

  /// No description provided for @documentsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get documentsFilterAll;

  /// No description provided for @documentAddTitle.
  ///
  /// In en, this message translates to:
  /// **'New document'**
  String get documentAddTitle;

  /// No description provided for @documentEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit document'**
  String get documentEditTitle;

  /// No description provided for @documentDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Document details'**
  String get documentDetailTitle;

  /// No description provided for @documentNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get documentNameLabel;

  /// No description provided for @documentNameHint.
  ///
  /// In en, this message translates to:
  /// **'Car insurance, ID…'**
  String get documentNameHint;

  /// No description provided for @documentTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Document type'**
  String get documentTypeLabel;

  /// No description provided for @documentExpiryDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Expiry date'**
  String get documentExpiryDateLabel;

  /// No description provided for @documentExpiryDatePick.
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get documentExpiryDatePick;

  /// No description provided for @documentNotifyDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Notify days before'**
  String get documentNotifyDaysLabel;

  /// No description provided for @documentReminderDaysBefore.
  ///
  /// In en, this message translates to:
  /// **'{days}d before'**
  String documentReminderDaysBefore(int days);

  /// No description provided for @documentReminderFreeHint.
  ///
  /// In en, this message translates to:
  /// **'Up to 1 reminder · Upgrade to Pro for multiple'**
  String get documentReminderFreeHint;

  /// No description provided for @documentReminderProHint.
  ///
  /// In en, this message translates to:
  /// **'Pro includes automatic reminders at 90, 30, and 7 days.'**
  String get documentReminderProHint;

  /// No description provided for @documentNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get documentNotesLabel;

  /// No description provided for @documentNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Policy number, contact…'**
  String get documentNotesHint;

  /// No description provided for @documentPhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Photo / scan'**
  String get documentPhotoLabel;

  /// No description provided for @documentScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get documentScan;

  /// No description provided for @documentGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get documentGallery;

  /// No description provided for @documentScanPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'scan'**
  String get documentScanPlaceholder;

  /// No description provided for @documentCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get documentCancel;

  /// No description provided for @documentSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get documentSave;

  /// No description provided for @documentEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get documentEdit;

  /// No description provided for @documentDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get documentDelete;

  /// No description provided for @documentDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete document?'**
  String get documentDeleteTitle;

  /// No description provided for @documentDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get documentDeleteBody;

  /// No description provided for @documentDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get documentDeleteConfirm;

  /// No description provided for @documentDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the document.'**
  String get documentDeleteFailed;

  /// No description provided for @documentSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the document.'**
  String get documentSaveFailed;

  /// No description provided for @documentValidationName.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get documentValidationName;

  /// No description provided for @documentValidationExpiry.
  ///
  /// In en, this message translates to:
  /// **'Pick an expiry date'**
  String get documentValidationExpiry;

  /// No description provided for @documentValidationNotifyDays.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number of days'**
  String get documentValidationNotifyDays;

  /// No description provided for @documentExpiryIn.
  ///
  /// In en, this message translates to:
  /// **'Expires in {days, plural, one {{days} day} other {{days} days}}'**
  String documentExpiryIn(int days);

  /// No description provided for @documentExpiredAgo.
  ///
  /// In en, this message translates to:
  /// **'Expired {days, plural, one {{days} day} other {{days} days}} ago'**
  String documentExpiredAgo(int days);

  /// No description provided for @documentExpiresToday.
  ///
  /// In en, this message translates to:
  /// **'Expires today'**
  String get documentExpiresToday;

  /// No description provided for @paywallDocumentsLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock unlimited documents'**
  String get paywallDocumentsLimitTitle;

  /// No description provided for @paywallDocumentsLimitBody.
  ///
  /// In en, this message translates to:
  /// **'The free plan includes up to 3 documents. Upgrade to Pro to add as many as you need.'**
  String get paywallDocumentsLimitBody;

  /// No description provided for @homeSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Your home'**
  String get homeSummaryTitle;

  /// No description provided for @homeSummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Maintenance and documents overview'**
  String get homeSummarySubtitle;

  /// No description provided for @homeSummaryItems.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No items} one {{count} item} other {{count} items}}'**
  String homeSummaryItems(int count);

  /// No description provided for @homeSummaryPendingMaintenances.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No pending maintenance} one {{count} pending maintenance} other {{count} pending maintenances}}'**
  String homeSummaryPendingMaintenances(int count);

  /// No description provided for @homeSummaryUrgentDocuments.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No urgent documents} one {{count} urgent document} other {{count} urgent documents}}'**
  String homeSummaryUrgentDocuments(int count);

  /// No description provided for @homeAllClearTitle.
  ///
  /// In en, this message translates to:
  /// **'All clear'**
  String get homeAllClearTitle;

  /// No description provided for @homeAllClearBody.
  ///
  /// In en, this message translates to:
  /// **'No urgent maintenance or documents right now.'**
  String get homeAllClearBody;

  /// No description provided for @homeTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Upcoming events'**
  String get homeTimelineTitle;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Start with what matters most'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add your first appliance or document and HouseKeep will warn you before it\'s too late.'**
  String get homeEmptyBody;

  /// No description provided for @homeEmptyCta.
  ///
  /// In en, this message translates to:
  /// **'Add my first thing'**
  String get homeEmptyCta;

  /// No description provided for @homeGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get homeGreetingMorning;

  /// No description provided for @homeGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get homeGreetingAfternoon;

  /// No description provided for @homeGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get homeGreetingEvening;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Here\'s what needs attention'**
  String get homeSubtitle;

  /// No description provided for @homeSummaryDue.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get homeSummaryDue;

  /// No description provided for @homeSummarySoon.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get homeSummarySoon;

  /// No description provided for @homeSummaryOk.
  ///
  /// In en, this message translates to:
  /// **'On track'**
  String get homeSummaryOk;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get homeSeeAll;

  /// No description provided for @homeProUpsellTitle.
  ///
  /// In en, this message translates to:
  /// **'Go Pro for {price}'**
  String homeProUpsellTitle(String price);

  /// No description provided for @homeProUpsellTitleGeneric.
  ///
  /// In en, this message translates to:
  /// **'Go Pro'**
  String get homeProUpsellTitleGeneric;

  /// No description provided for @homeProUpsellSub.
  ///
  /// In en, this message translates to:
  /// **'No limits · one-time payment · forever'**
  String get homeProUpsellSub;

  /// No description provided for @homeProUpsellCta.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get homeProUpsellCta;

  /// No description provided for @homeShortDayToday.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get homeShortDayToday;

  /// No description provided for @homeShortDayTomorrow.
  ///
  /// In en, this message translates to:
  /// **'tomorrow'**
  String get homeShortDayTomorrow;

  /// No description provided for @homeShortDayIn.
  ///
  /// In en, this message translates to:
  /// **'in {days}d'**
  String homeShortDayIn(int days);

  /// No description provided for @homeShortDayYesterday.
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get homeShortDayYesterday;

  /// No description provided for @homeShortDayAgo.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String homeShortDayAgo(int days);

  /// No description provided for @homeFallbackName.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get homeFallbackName;

  /// No description provided for @homeEventMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get homeEventMaintenance;

  /// No description provided for @homeEventDocument.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get homeEventDocument;

  /// No description provided for @homeEventWarranty.
  ///
  /// In en, this message translates to:
  /// **'Warranty'**
  String get homeEventWarranty;

  /// No description provided for @homeEventDueIn.
  ///
  /// In en, this message translates to:
  /// **'In {days, plural, one {{days} day} other {{days} days}}'**
  String homeEventDueIn(int days);

  /// No description provided for @homeEventOverdueBy.
  ///
  /// In en, this message translates to:
  /// **'Overdue by {days, plural, one {{days} day} other {{days} days}}'**
  String homeEventOverdueBy(int days);

  /// No description provided for @homeEventDueToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get homeEventDueToday;

  /// No description provided for @homeFabAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get homeFabAddItem;

  /// No description provided for @homeFabAddMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Add maintenance'**
  String get homeFabAddMaintenance;

  /// No description provided for @homeFabAddDocument.
  ///
  /// In en, this message translates to:
  /// **'Add document'**
  String get homeFabAddDocument;

  /// No description provided for @homeFabAddMaintenanceNoItems.
  ///
  /// In en, this message translates to:
  /// **'Create an item first to add maintenance.'**
  String get homeFabAddMaintenanceNoItems;

  /// No description provided for @notificationMaintenanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Maintenance reminder'**
  String get notificationMaintenanceTitle;

  /// No description provided for @notificationMaintenanceBody.
  ///
  /// In en, this message translates to:
  /// **'🔧 {item}: {task} {days, plural, =0{is due today} one {is due in 1 day} other {is due in {days} days}}'**
  String notificationMaintenanceBody(String item, String task, int days);

  /// No description provided for @notificationDocumentTitle.
  ///
  /// In en, this message translates to:
  /// **'Document reminder'**
  String get notificationDocumentTitle;

  /// No description provided for @notificationDocumentBody.
  ///
  /// In en, this message translates to:
  /// **'📄 {name} {days, plural, =0{expires today} one {expires in 1 day} other {expires in {days} days}}'**
  String notificationDocumentBody(String name, int days);

  /// No description provided for @notificationWarrantyTitle.
  ///
  /// In en, this message translates to:
  /// **'Warranty reminder'**
  String get notificationWarrantyTitle;

  /// No description provided for @notificationWarrantyBody.
  ///
  /// In en, this message translates to:
  /// **'⚠️ {item} warranty {days, plural, =0{ends today} one {ends in 1 day} other {ends in {days} days}}'**
  String notificationWarrantyBody(String item, int days);

  /// No description provided for @notificationsPermissionDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications disabled'**
  String get notificationsPermissionDeniedTitle;

  /// No description provided for @notificationsPermissionDeniedBody.
  ///
  /// In en, this message translates to:
  /// **'HouseKeep needs notification access to remind you about maintenance and expiries.'**
  String get notificationsPermissionDeniedBody;

  /// No description provided for @notificationsPermissionOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get notificationsPermissionOpenSettings;

  /// No description provided for @paywallTitle.
  ///
  /// In en, this message translates to:
  /// **'HouseKeep Pro'**
  String get paywallTitle;

  /// No description provided for @paywallTagline.
  ///
  /// In en, this message translates to:
  /// **'Take care of your home without limits'**
  String get paywallTagline;

  /// No description provided for @paywallFeatureUnlimitedItems.
  ///
  /// In en, this message translates to:
  /// **'Unlimited items'**
  String get paywallFeatureUnlimitedItems;

  /// No description provided for @paywallFeatureUnlimitedDocuments.
  ///
  /// In en, this message translates to:
  /// **'Unlimited documents'**
  String get paywallFeatureUnlimitedDocuments;

  /// No description provided for @paywallFeatureProTemplates.
  ///
  /// In en, this message translates to:
  /// **'All maintenance templates'**
  String get paywallFeatureProTemplates;

  /// No description provided for @paywallFeatureMultiNotifications.
  ///
  /// In en, this message translates to:
  /// **'Multiple reminders (90/30/7 days)'**
  String get paywallFeatureMultiNotifications;

  /// No description provided for @paywallFeatureWidget.
  ///
  /// In en, this message translates to:
  /// **'Home screen widget'**
  String get paywallFeatureWidget;

  /// No description provided for @paywallFeatureExportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export to PDF'**
  String get paywallFeatureExportPdf;

  /// No description provided for @paywallFreeColumn.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get paywallFreeColumn;

  /// No description provided for @paywallProColumn.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get paywallProColumn;

  /// No description provided for @paywallFreeItemsValue.
  ///
  /// In en, this message translates to:
  /// **'Up to 5 items'**
  String get paywallFreeItemsValue;

  /// No description provided for @paywallProItemsValue.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get paywallProItemsValue;

  /// No description provided for @paywallFreeDocumentsValue.
  ///
  /// In en, this message translates to:
  /// **'Up to 3 documents'**
  String get paywallFreeDocumentsValue;

  /// No description provided for @paywallProDocumentsValue.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get paywallProDocumentsValue;

  /// No description provided for @paywallFreeNotificationsValue.
  ///
  /// In en, this message translates to:
  /// **'1 reminder'**
  String get paywallFreeNotificationsValue;

  /// No description provided for @paywallProNotificationsValue.
  ///
  /// In en, this message translates to:
  /// **'3 reminders'**
  String get paywallProNotificationsValue;

  /// No description provided for @paywallBuyCta.
  ///
  /// In en, this message translates to:
  /// **'Get Pro for {price}'**
  String paywallBuyCta(String price);

  /// No description provided for @paywallBuyCtaUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Upgrade unavailable'**
  String get paywallBuyCtaUnavailable;

  /// No description provided for @paywallRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get paywallRestore;

  /// No description provided for @paywallSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Pro!'**
  String get paywallSuccessTitle;

  /// No description provided for @paywallSuccessBody.
  ///
  /// In en, this message translates to:
  /// **'All features unlocked. Enjoy.'**
  String get paywallSuccessBody;

  /// No description provided for @paywallSuccessContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get paywallSuccessContinue;

  /// No description provided for @paywallErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get paywallErrorTitle;

  /// No description provided for @paywallErrorRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get paywallErrorRetry;

  /// No description provided for @paywallCancelled.
  ///
  /// In en, this message translates to:
  /// **'Purchase cancelled'**
  String get paywallCancelled;

  /// No description provided for @paywallNothingToRestore.
  ///
  /// In en, this message translates to:
  /// **'No previous purchase found'**
  String get paywallNothingToRestore;

  /// No description provided for @paywallOfferingUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Products not available right now. Try again later.'**
  String get paywallOfferingUnavailable;

  /// No description provided for @paywallHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Go HouseKeep Pro'**
  String get paywallHeroTitle;

  /// No description provided for @paywallSubtitle.
  ///
  /// In en, this message translates to:
  /// **'One payment. Forever.'**
  String get paywallSubtitle;

  /// No description provided for @paywallOnce.
  ///
  /// In en, this message translates to:
  /// **'one-time payment'**
  String get paywallOnce;

  /// No description provided for @paywallUnlockCta.
  ///
  /// In en, this message translates to:
  /// **'Unlock Pro'**
  String get paywallUnlockCta;

  /// No description provided for @paywallSkip.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get paywallSkip;

  /// No description provided for @paywallGateTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached the free limit'**
  String get paywallGateTitle;

  /// No description provided for @paywallGateSub.
  ///
  /// In en, this message translates to:
  /// **'The free plan includes 5 things and 3 documents. Upgrade to Pro to remove all limits.'**
  String get paywallGateSub;

  /// No description provided for @paywallBenefitUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited things and documents'**
  String get paywallBenefitUnlimited;

  /// No description provided for @paywallBenefitMultiReminder.
  ///
  /// In en, this message translates to:
  /// **'Multiple reminders per item'**
  String get paywallBenefitMultiReminder;

  /// No description provided for @paywallBenefitWidget.
  ///
  /// In en, this message translates to:
  /// **'Home screen widget'**
  String get paywallBenefitWidget;

  /// No description provided for @paywallBenefitPdf.
  ///
  /// In en, this message translates to:
  /// **'Export to PDF and share with your partner'**
  String get paywallBenefitPdf;

  /// No description provided for @paywallBenefitTemplates.
  ///
  /// In en, this message translates to:
  /// **'Pro templates: pool, garden, solar panels'**
  String get paywallBenefitTemplates;

  /// No description provided for @paywallPurchaseError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t complete the purchase. Try again.'**
  String get paywallPurchaseError;

  /// No description provided for @onboardingPage1Title.
  ///
  /// In en, this message translates to:
  /// **'Your house has memory.'**
  String get onboardingPage1Title;

  /// No description provided for @onboardingPage1Body.
  ///
  /// In en, this message translates to:
  /// **'When to change the filter, when insurance expires, when checkups are due. Too much to remember.'**
  String get onboardingPage1Body;

  /// No description provided for @onboardingPage2Title.
  ///
  /// In en, this message translates to:
  /// **'HouseKeep remembers for you.'**
  String get onboardingPage2Title;

  /// No description provided for @onboardingPage2Body.
  ///
  /// In en, this message translates to:
  /// **'On-time alerts, ready-made templates, and a log of everything you\'ve done.'**
  String get onboardingPage2Body;

  /// No description provided for @onboardingPage3Title.
  ///
  /// In en, this message translates to:
  /// **'Start with one thing.'**
  String get onboardingPage3Title;

  /// No description provided for @onboardingPage3Body.
  ///
  /// In en, this message translates to:
  /// **'The boiler, the washing machine, the car insurance. Whatever worries you most.'**
  String get onboardingPage3Body;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingStart;

  /// No description provided for @onboardingHomeTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Home type'**
  String get onboardingHomeTypeLabel;

  /// No description provided for @settingsSectionGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsSectionGeneral;

  /// No description provided for @settingsSectionNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsSectionNotifications;

  /// No description provided for @settingsSectionPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get settingsSectionPremium;

  /// No description provided for @settingsSectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsSectionAbout;

  /// No description provided for @settingsSectionWidget.
  ///
  /// In en, this message translates to:
  /// **'Home screen widget'**
  String get settingsSectionWidget;

  /// No description provided for @settingsWidgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Home screen widget'**
  String get settingsWidgetTitle;

  /// No description provided for @settingsWidgetBodyPro.
  ///
  /// In en, this message translates to:
  /// **'Long-press on your home screen to add the HouseKeep widget.'**
  String get settingsWidgetBodyPro;

  /// No description provided for @settingsWidgetBodyFree.
  ///
  /// In en, this message translates to:
  /// **'Available with HouseKeep Pro: add a widget showing your next events.'**
  String get settingsWidgetBodyFree;

  /// No description provided for @settingsWidgetCta.
  ///
  /// In en, this message translates to:
  /// **'How to add'**
  String get settingsWidgetCta;

  /// No description provided for @settingsWidgetUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Unlock with Pro'**
  String get settingsWidgetUpgrade;

  /// No description provided for @settingsWidgetHowToTitle.
  ///
  /// In en, this message translates to:
  /// **'How to add the widget'**
  String get settingsWidgetHowToTitle;

  /// No description provided for @settingsWidgetHowToBody.
  ///
  /// In en, this message translates to:
  /// **'1. Long-press an empty space on your home screen.\n2. Tap “Widgets” and find HouseKeep.\n3. Drag the widget where you want.'**
  String get settingsWidgetHowToBody;

  /// No description provided for @settingsWidgetHowToClose.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get settingsWidgetHowToClose;

  /// No description provided for @settingsSectionData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingsSectionData;

  /// No description provided for @settingsDataExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get settingsDataExportTitle;

  /// No description provided for @settingsDataExportBodyPro.
  ///
  /// In en, this message translates to:
  /// **'Generate a PDF with all your appliances, maintenance and documents.'**
  String get settingsDataExportBodyPro;

  /// No description provided for @settingsDataExportBodyFree.
  ///
  /// In en, this message translates to:
  /// **'Available with HouseKeep Pro: export your inventory to PDF.'**
  String get settingsDataExportBodyFree;

  /// No description provided for @settingsDataExportCta.
  ///
  /// In en, this message translates to:
  /// **'Generate PDF'**
  String get settingsDataExportCta;

  /// No description provided for @settingsDataExportUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Unlock with Pro'**
  String get settingsDataExportUpgrade;

  /// No description provided for @settingsDataExportProgress.
  ///
  /// In en, this message translates to:
  /// **'Generating PDF…'**
  String get settingsDataExportProgress;

  /// No description provided for @settingsDataExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'PDF generated'**
  String get settingsDataExportSuccess;

  /// No description provided for @settingsDataExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not generate PDF'**
  String get settingsDataExportFailed;

  /// No description provided for @settingsDataExportEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing to export yet'**
  String get settingsDataExportEmpty;

  /// No description provided for @exportPdfTitle.
  ///
  /// In en, this message translates to:
  /// **'HouseKeep — Inventory'**
  String get exportPdfTitle;

  /// No description provided for @exportPdfSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Generated on {date}'**
  String exportPdfSubtitle(String date);

  /// No description provided for @exportPdfSectionItems.
  ///
  /// In en, this message translates to:
  /// **'Appliances'**
  String get exportPdfSectionItems;

  /// No description provided for @exportPdfSectionMaintenances.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get exportPdfSectionMaintenances;

  /// No description provided for @exportPdfSectionDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get exportPdfSectionDocuments;

  /// No description provided for @exportPdfColName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get exportPdfColName;

  /// No description provided for @exportPdfColCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get exportPdfColCategory;

  /// No description provided for @exportPdfColBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get exportPdfColBrand;

  /// No description provided for @exportPdfColPurchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get exportPdfColPurchase;

  /// No description provided for @exportPdfColWarrantyUntil.
  ///
  /// In en, this message translates to:
  /// **'Warranty'**
  String get exportPdfColWarrantyUntil;

  /// No description provided for @exportPdfColItem.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get exportPdfColItem;

  /// No description provided for @exportPdfColIntervalMonths.
  ///
  /// In en, this message translates to:
  /// **'Interval (months)'**
  String get exportPdfColIntervalMonths;

  /// No description provided for @exportPdfColLastDone.
  ///
  /// In en, this message translates to:
  /// **'Last done'**
  String get exportPdfColLastDone;

  /// No description provided for @exportPdfColNextDue.
  ///
  /// In en, this message translates to:
  /// **'Next due'**
  String get exportPdfColNextDue;

  /// No description provided for @exportPdfColType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get exportPdfColType;

  /// No description provided for @exportPdfColExpiry.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get exportPdfColExpiry;

  /// No description provided for @exportPdfNone.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get exportPdfNone;

  /// No description provided for @exportPdfFileName.
  ///
  /// In en, this message translates to:
  /// **'housekeep-inventory.pdf'**
  String get exportPdfFileName;

  /// No description provided for @settingsLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageLabel;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageEs.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get settingsLanguageEs;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// No description provided for @settingsNotificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enable reminders'**
  String get settingsNotificationsEnabled;

  /// No description provided for @settingsNotificationsEnabledBody.
  ///
  /// In en, this message translates to:
  /// **'Receive maintenance and expiry reminders.'**
  String get settingsNotificationsEnabledBody;

  /// No description provided for @settingsNotificationsOpenSystem.
  ///
  /// In en, this message translates to:
  /// **'System permissions'**
  String get settingsNotificationsOpenSystem;

  /// No description provided for @settingsNotificationsDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications are blocked'**
  String get settingsNotificationsDeniedTitle;

  /// No description provided for @settingsNotificationsDeniedBody.
  ///
  /// In en, this message translates to:
  /// **'Without notification permission HouseKeep cannot remind you about maintenance or document expiry. Reopen this app after enabling the permission.'**
  String get settingsNotificationsDeniedBody;

  /// No description provided for @settingsNotificationsDeniedCta.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get settingsNotificationsDeniedCta;

  /// No description provided for @settingsPremiumStatusFree.
  ///
  /// In en, this message translates to:
  /// **'Free plan'**
  String get settingsPremiumStatusFree;

  /// No description provided for @settingsPremiumStatusPro.
  ///
  /// In en, this message translates to:
  /// **'HouseKeep Pro'**
  String get settingsPremiumStatusPro;

  /// No description provided for @settingsPremiumUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro'**
  String get settingsPremiumUpgrade;

  /// No description provided for @settingsPremiumRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get settingsPremiumRestore;

  /// No description provided for @settingsPremiumRestoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Purchases restored'**
  String get settingsPremiumRestoreSuccess;

  /// No description provided for @settingsPremiumRestoreNone.
  ///
  /// In en, this message translates to:
  /// **'No previous purchase found'**
  String get settingsPremiumRestoreNone;

  /// No description provided for @settingsPremiumRestoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not restore purchase'**
  String get settingsPremiumRestoreFailed;

  /// No description provided for @settingsAboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsAboutVersion(String version);

  /// No description provided for @settingsAboutContact.
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get settingsAboutContact;

  /// No description provided for @settingsAboutFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get settingsAboutFeedback;

  /// No description provided for @settingsAboutPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settingsAboutPrivacy;

  /// No description provided for @settingsAboutTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get settingsAboutTerms;

  /// No description provided for @settingsAboutRate.
  ///
  /// In en, this message translates to:
  /// **'Rate the app'**
  String get settingsAboutRate;

  /// No description provided for @settingsLinkOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open link'**
  String get settingsLinkOpenFailed;

  /// No description provided for @settingsPlanFreeSub.
  ///
  /// In en, this message translates to:
  /// **'5 things · 3 documents'**
  String get settingsPlanFreeSub;

  /// No description provided for @settingsPlanProSub.
  ///
  /// In en, this message translates to:
  /// **'All features unlocked'**
  String get settingsPlanProSub;

  /// No description provided for @settingsProActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get settingsProActive;

  /// No description provided for @settingsSectionPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get settingsSectionPreferences;

  /// No description provided for @settingsFooter.
  ///
  /// In en, this message translates to:
  /// **'HOUSEKEEP · MADE WITH CARE'**
  String get settingsFooter;

  /// No description provided for @itemSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Item saved'**
  String get itemSavedSuccess;

  /// No description provided for @maintenanceSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Maintenance saved'**
  String get maintenanceSavedSuccess;

  /// No description provided for @documentSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Document saved'**
  String get documentSavedSuccess;

  /// No description provided for @itemDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Item deleted'**
  String get itemDeletedSuccess;

  /// No description provided for @maintenanceDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Maintenance deleted'**
  String get maintenanceDeletedSuccess;

  /// No description provided for @documentDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Document deleted'**
  String get documentDeletedSuccess;

  /// No description provided for @maintenanceMarkDoneSuccess.
  ///
  /// In en, this message translates to:
  /// **'Marked as done'**
  String get maintenanceMarkDoneSuccess;

  /// No description provided for @commonErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get commonErrorTitle;

  /// No description provided for @commonErrorBody.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load the information. Check your connection and try again.'**
  String get commonErrorBody;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonGoBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get commonGoBack;
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
