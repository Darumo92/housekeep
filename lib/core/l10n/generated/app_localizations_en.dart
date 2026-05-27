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
  String get itemsTitle => 'My things';

  @override
  String get documentsTitle => 'Documents';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get phaseZeroMessage =>
      'Phase 0 foundation is ready for the next feature phase.';

  @override
  String get itemCategoryKitchen => 'Kitchen';

  @override
  String get itemCategoryBathroom => 'Bathroom';

  @override
  String get itemCategoryLaundry => 'Laundry';

  @override
  String get itemCategoryLiving => 'Living room';

  @override
  String get itemCategoryBedroom => 'Bedroom';

  @override
  String get itemCategoryGarden => 'Garden';

  @override
  String get itemCategoryGarage => 'Garage';

  @override
  String get itemCategoryPlumbing => 'Plumbing';

  @override
  String get itemCategoryElectrical => 'Electrical';

  @override
  String get itemCategorySecurity => 'Security';

  @override
  String get itemCategoryGeneral => 'General';

  @override
  String get documentTypePassport => 'Passport';

  @override
  String get documentTypeIdCard => 'ID card';

  @override
  String get documentTypeDriversLicense => 'Driver\'s license';

  @override
  String get documentTypeVehicleInspection => 'Vehicle inspection';

  @override
  String get documentTypeInsuranceHome => 'Home insurance';

  @override
  String get documentTypeInsuranceCar => 'Car insurance';

  @override
  String get documentTypeInsuranceLife => 'Life insurance';

  @override
  String get documentTypeInsuranceHealth => 'Health insurance';

  @override
  String get documentTypeLease => 'Lease';

  @override
  String get documentTypeWarrantyDoc => 'Warranty document';

  @override
  String get documentTypeSubscription => 'Subscription';

  @override
  String get documentTypeOther => 'Other';

  @override
  String get itemsEmptyTitle => 'Nothing here yet';

  @override
  String get itemsEmptyBody =>
      'Your boiler, the washing machine, the car… anything with maintenance or a warranty.';

  @override
  String get itemsEmptyCta => 'Add thing';

  @override
  String itemsCountFree(int n) {
    return '$n/5';
  }

  @override
  String itemsCount(int n) {
    return '$n items';
  }

  @override
  String get itemsWarrantyActive => 'Active warranty';

  @override
  String get itemsWarrantyExpired => 'Expired warranty';

  @override
  String get itemDetailWarranty => 'Warranty';

  @override
  String get itemDetailPhotoPlaceholder => 'Appliance photo';

  @override
  String itemDetailMaintenanceInterval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months',
      one: '$count month',
    );
    return 'every $_temp0';
  }

  @override
  String itemDetailPurchasedOn(String date) {
    return 'Purchased $date';
  }

  @override
  String itemDetailUntil(String date) {
    return 'until $date';
  }

  @override
  String get itemDetailHistory => 'History';

  @override
  String itemDetailMonthsWarranty(int n) {
    return '$n months';
  }

  @override
  String get addFieldPurchased => 'Purchase date';

  @override
  String get addSave => 'Save';

  @override
  String get addCancel => 'Cancel';

  @override
  String get addPhotoCamera => 'Camera';

  @override
  String get addPhotoGallery => 'Gallery';

  @override
  String get itemsFilteredEmptyTitle => 'No items in this category';

  @override
  String get itemsFilteredEmptyBody =>
      'Try another category or clear the filter.';

  @override
  String get itemsClearFilter => 'Clear filter';

  @override
  String get itemsFilterAll => 'All';

  @override
  String get itemNameLabel => 'Name';

  @override
  String get itemBrandLabel => 'Brand';

  @override
  String get itemModelLabel => 'Model';

  @override
  String get itemPurchaseDateLabel => 'Purchase date';

  @override
  String get itemWarrantyMonthsLabel => 'Warranty months';

  @override
  String get itemNotesLabel => 'Notes';

  @override
  String get itemPhotoLabel => 'Photo';

  @override
  String get itemCategoryLabel => 'Category';

  @override
  String get itemSave => 'Save';

  @override
  String get itemEdit => 'Edit';

  @override
  String get itemDelete => 'Delete';

  @override
  String get itemDeleteTitle => 'Delete item?';

  @override
  String get itemDeleteBody =>
      'This will also delete related maintenance history.';

  @override
  String get itemDeleteConfirm => 'Delete';

  @override
  String get itemDeleteFailed => 'Could not delete the item. Please try again.';

  @override
  String get itemNoWarranty => 'No warranty';

  @override
  String get itemWarrantyActive => 'Warranty active';

  @override
  String get itemWarrantyExpired => 'Warranty expired';

  @override
  String get itemAddTitle => 'Add item';

  @override
  String get itemEditTitle => 'Edit item';

  @override
  String get itemDetailTitle => 'Item details';

  @override
  String get itemPhotoAdd => 'Add photo';

  @override
  String get itemPhotoReplace => 'Replace photo';

  @override
  String get itemPhotoRemove => 'Remove photo';

  @override
  String get itemPhotoCamera => 'Take photo';

  @override
  String get itemPhotoGallery => 'Choose from gallery';

  @override
  String get photoPickerErrorPermission =>
      'Camera or gallery permission denied. Grant access in Settings.';

  @override
  String get photoPickerErrorStorageFull =>
      'Not enough storage to save the photo. Free up space and try again.';

  @override
  String get photoPickerErrorNoCamera => 'No camera available on this device.';

  @override
  String get photoPickerErrorUnknown => 'Couldn\'t add the photo.';

  @override
  String get photoPickerOpenSettings => 'Settings';

  @override
  String get homeAddMaintenancePickItemTitle =>
      'Which item is this maintenance for?';

  @override
  String get itemValidationName => 'Enter a name';

  @override
  String get itemValidationWarrantyMonths => 'Enter a valid number of months';

  @override
  String get itemMaintenanceSectionTitle => 'Maintenance';

  @override
  String get itemMaintenanceSectionEmpty =>
      'No maintenance tasks for this item yet.';

  @override
  String get itemMaintenanceAdd => 'Add maintenance';

  @override
  String get maintenanceAddTitle => 'Add maintenance';

  @override
  String get maintenanceEditTitle => 'Edit maintenance';

  @override
  String get maintenanceNameLabel => 'Task name';

  @override
  String get maintenanceDescriptionLabel => 'Description';

  @override
  String get maintenanceIntervalLabel => 'Interval (months)';

  @override
  String get maintenanceLastDoneLabel => 'Last done';

  @override
  String get maintenanceLastDoneNever => 'Not recorded';

  @override
  String get maintenanceNotifyDaysLabel => 'Notify days before';

  @override
  String get maintenanceNextDueLabel => 'Next due';

  @override
  String get maintenanceSave => 'Save';

  @override
  String get maintenanceMarkDone => 'Mark as done';

  @override
  String get maintenanceMarkDoneSheetTitle => 'Mark as done';

  @override
  String get maintenanceMarkDoneWhenLabel => 'When did you do it?';

  @override
  String get maintenanceMarkDoneToday => 'Today';

  @override
  String get maintenanceMarkDoneYesterday => 'Yesterday';

  @override
  String get maintenanceMarkDoneOtherDate => 'Other date';

  @override
  String get maintenanceMarkDoneNextReminder => 'Next reminder';

  @override
  String maintenanceMarkDoneNextInMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months',
      one: '$count month',
    );
    return 'in $_temp0';
  }

  @override
  String get maintenanceMarkDoneConfirm => 'Confirm';

  @override
  String get maintenanceMarkDoneCompletedTitle => 'Done!';

  @override
  String maintenanceMarkDoneCompletedSubtitle(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '$days day',
    );
    return 'Next reminder in $_temp0';
  }

  @override
  String get maintenanceEdit => 'Edit';

  @override
  String get maintenanceDelete => 'Delete';

  @override
  String get maintenanceDeleteTitle => 'Delete maintenance?';

  @override
  String get maintenanceDeleteBody => 'This action cannot be undone.';

  @override
  String get maintenanceDeleteConfirm => 'Delete';

  @override
  String get maintenanceDeleteFailed => 'Could not delete the maintenance.';

  @override
  String get maintenanceSaveFailed => 'Could not save the maintenance.';

  @override
  String get maintenanceMarkDoneFailed => 'Could not mark as done.';

  @override
  String get maintenanceValidationName => 'Enter a name';

  @override
  String get maintenanceValidationInterval => 'Enter a valid number of months';

  @override
  String get maintenanceValidationNotifyDays => 'Enter a valid number of days';

  @override
  String get maintenanceUseTemplate => 'Use template';

  @override
  String get maintenanceTemplatesTitle => 'Maintenance templates';

  @override
  String get maintenanceTemplatesEmpty => 'No templates for this category.';

  @override
  String get maintenanceTemplatesAll => 'All';

  @override
  String maintenanceTemplatesSuggested(String category) {
    return 'Suggested for $category';
  }

  @override
  String get maintenanceTemplateProBadge => 'PRO';

  @override
  String get maintenanceTemplateProLocked =>
      'This template requires HouseKeep Pro.';

  @override
  String maintenanceIntervalMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months',
      one: '$count month',
    );
    return '$_temp0';
  }

  @override
  String maintenanceNextDueIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '$days day',
    );
    return 'Due in $_temp0';
  }

  @override
  String maintenanceOverdueBy(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '$days day',
    );
    return 'Overdue by $_temp0';
  }

  @override
  String get maintenanceDoneToday => 'Due today';

  @override
  String maintenanceHistoryTitle(String date) {
    return 'Last done: $date';
  }

  @override
  String get maintenanceLastDoneNeverShort => 'Never done';

  @override
  String get paywallMaintenanceProTitle => 'Unlock Pro templates';

  @override
  String get paywallMaintenanceProBody =>
      'Some advanced templates (pool, irrigation, solar panels) require HouseKeep Pro.';

  @override
  String get paywallItemsLimitTitle => 'Unlock unlimited items';

  @override
  String get paywallItemsLimitBody =>
      'The free plan includes up to 5 items. Upgrade to Pro to add as many as you need.';

  @override
  String get paywallUpgradeCta => 'Upgrade soon';

  @override
  String get paywallBack => 'Go back';

  @override
  String get urgencyOk => 'All good';

  @override
  String get urgencyUpcoming => 'Coming up';

  @override
  String get urgencyUrgent => 'Urgent';

  @override
  String get urgencyOverdue => 'Overdue';

  @override
  String get homeTypeApartment => 'Apartment';

  @override
  String get homeTypeHouse => 'House';

  @override
  String get homeTypeVilla => 'Villa';

  @override
  String get documentsEmptyTitle => 'No saved documents';

  @override
  String get documentsEmptyBody =>
      'ID, inspection, insurance… we\'ll remind you a month ahead.';

  @override
  String get documentsEmptyCta => 'Add document';

  @override
  String documentsCountFree(int n) {
    return '$n/3';
  }

  @override
  String documentsCount(int n) {
    return '$n documents';
  }

  @override
  String get documentsSectionExpired => 'Expired';

  @override
  String get documentsSectionSoon => 'Expiring soon';

  @override
  String get documentsSectionCurrent => 'Current';

  @override
  String get documentsFilteredEmptyTitle => 'No documents of this type';

  @override
  String get documentsFilteredEmptyBody =>
      'Try another type or clear the filter.';

  @override
  String get documentsClearFilter => 'Clear filter';

  @override
  String get documentsFilterAll => 'All';

  @override
  String get documentAddTitle => 'New document';

  @override
  String get documentEditTitle => 'Edit document';

  @override
  String get documentDetailTitle => 'Document details';

  @override
  String get documentNameLabel => 'Name';

  @override
  String get documentNameHint => 'Car insurance, ID…';

  @override
  String get documentTypeLabel => 'Document type';

  @override
  String get documentExpiryDateLabel => 'Expiry date';

  @override
  String get documentExpiryDatePick => 'Pick a date';

  @override
  String get documentNotifyDaysLabel => 'Notify days before';

  @override
  String documentReminderDaysBefore(int days) {
    return '${days}d before';
  }

  @override
  String get documentReminderFreeHint =>
      'Up to 1 reminder · Upgrade to Pro for multiple';

  @override
  String get documentReminderProHint =>
      'Pro includes automatic reminders at 90, 30, and 7 days.';

  @override
  String get documentNotesLabel => 'Notes';

  @override
  String get documentNotesHint => 'Policy number, contact…';

  @override
  String get documentPhotoLabel => 'Photo / scan';

  @override
  String get documentScan => 'Scan';

  @override
  String get documentGallery => 'Gallery';

  @override
  String get documentScanPlaceholder => 'scan';

  @override
  String get documentCancel => 'Cancel';

  @override
  String get documentSave => 'Save';

  @override
  String get documentEdit => 'Edit';

  @override
  String get documentDelete => 'Delete';

  @override
  String get documentDeleteTitle => 'Delete document?';

  @override
  String get documentDeleteBody => 'This action cannot be undone.';

  @override
  String get documentDeleteConfirm => 'Delete';

  @override
  String get documentDeleteFailed => 'Could not delete the document.';

  @override
  String get documentSaveFailed => 'Could not save the document.';

  @override
  String get documentValidationName => 'Enter a name';

  @override
  String get documentValidationExpiry => 'Pick an expiry date';

  @override
  String get documentValidationNotifyDays => 'Enter a valid number of days';

  @override
  String documentExpiryIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '$days day',
    );
    return 'Expires in $_temp0';
  }

  @override
  String documentExpiredAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '$days day',
    );
    return 'Expired $_temp0 ago';
  }

  @override
  String get documentExpiresToday => 'Expires today';

  @override
  String get paywallDocumentsLimitTitle => 'Unlock unlimited documents';

  @override
  String get paywallDocumentsLimitBody =>
      'The free plan includes up to 3 documents. Upgrade to Pro to add as many as you need.';

  @override
  String get homeSummaryTitle => 'Your home';

  @override
  String get homeSummarySubtitle => 'Maintenance and documents overview';

  @override
  String homeSummaryItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '$count item',
      zero: 'No items',
    );
    return '$_temp0';
  }

  @override
  String homeSummaryPendingMaintenances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pending maintenances',
      one: '$count pending maintenance',
      zero: 'No pending maintenance',
    );
    return '$_temp0';
  }

  @override
  String homeSummaryUrgentDocuments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count urgent documents',
      one: '$count urgent document',
      zero: 'No urgent documents',
    );
    return '$_temp0';
  }

  @override
  String get homeAllClearTitle => 'All clear';

  @override
  String get homeAllClearBody =>
      'No urgent maintenance or documents right now.';

  @override
  String get homeTimelineTitle => 'Upcoming events';

  @override
  String get homeEmptyTitle => 'Start with what matters most';

  @override
  String get homeEmptyBody =>
      'Add your first appliance or document and HouseKeep will warn you before it\'s too late.';

  @override
  String get homeEmptyCta => 'Add my first thing';

  @override
  String get homeGreetingMorning => 'Good morning';

  @override
  String get homeGreetingAfternoon => 'Good afternoon';

  @override
  String get homeGreetingEvening => 'Good evening';

  @override
  String get homeSubtitle => 'Here\'s what needs attention';

  @override
  String get homeSummaryDue => 'Due';

  @override
  String get homeSummarySoon => 'This week';

  @override
  String get homeSummaryOk => 'On track';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get homeProUpsellTitle => 'Go Pro for €5.99';

  @override
  String get homeProUpsellSub => 'No limits · one-time payment · forever';

  @override
  String get homeProUpsellCta => 'View';

  @override
  String get homeShortDayToday => 'today';

  @override
  String get homeShortDayTomorrow => 'tomorrow';

  @override
  String homeShortDayIn(int days) {
    return 'in ${days}d';
  }

  @override
  String get homeShortDayYesterday => 'yesterday';

  @override
  String homeShortDayAgo(int days) {
    return '${days}d ago';
  }

  @override
  String get homeFallbackName => 'Hello';

  @override
  String get homeEventMaintenance => 'Maintenance';

  @override
  String get homeEventDocument => 'Document';

  @override
  String get homeEventWarranty => 'Warranty';

  @override
  String homeEventDueIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '$days day',
    );
    return 'In $_temp0';
  }

  @override
  String homeEventOverdueBy(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '$days day',
    );
    return 'Overdue by $_temp0';
  }

  @override
  String get homeEventDueToday => 'Today';

  @override
  String get homeFabAddItem => 'Add item';

  @override
  String get homeFabAddMaintenance => 'Add maintenance';

  @override
  String get homeFabAddDocument => 'Add document';

  @override
  String get homeFabAddMaintenanceNoItems =>
      'Create an item first to add maintenance.';

  @override
  String get notificationMaintenanceTitle => 'Maintenance reminder';

  @override
  String notificationMaintenanceBody(String item, String task, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'is due in $days days',
      one: 'is due in 1 day',
      zero: 'is due today',
    );
    return '🔧 $item: $task $_temp0';
  }

  @override
  String get notificationDocumentTitle => 'Document reminder';

  @override
  String notificationDocumentBody(String name, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'expires in $days days',
      one: 'expires in 1 day',
      zero: 'expires today',
    );
    return '📄 $name $_temp0';
  }

  @override
  String get notificationWarrantyTitle => 'Warranty reminder';

  @override
  String notificationWarrantyBody(String item, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'ends in $days days',
      one: 'ends in 1 day',
      zero: 'ends today',
    );
    return '⚠️ $item warranty $_temp0';
  }

  @override
  String get notificationsPermissionDeniedTitle => 'Notifications disabled';

  @override
  String get notificationsPermissionDeniedBody =>
      'HouseKeep needs notification access to remind you about maintenance and expiries.';

  @override
  String get notificationsPermissionOpenSettings => 'Open settings';

  @override
  String get paywallTitle => 'HouseKeep Pro';

  @override
  String get paywallTagline => 'Take care of your home without limits';

  @override
  String get paywallFeatureUnlimitedItems => 'Unlimited items';

  @override
  String get paywallFeatureUnlimitedDocuments => 'Unlimited documents';

  @override
  String get paywallFeatureProTemplates => 'All maintenance templates';

  @override
  String get paywallFeatureMultiNotifications =>
      'Multiple reminders (90/30/7 days)';

  @override
  String get paywallFeatureWidget => 'Home screen widget';

  @override
  String get paywallFeatureExportPdf => 'Export to PDF';

  @override
  String get paywallFreeColumn => 'Free';

  @override
  String get paywallProColumn => 'Pro';

  @override
  String get paywallFreeItemsValue => 'Up to 5 items';

  @override
  String get paywallProItemsValue => 'Unlimited';

  @override
  String get paywallFreeDocumentsValue => 'Up to 3 documents';

  @override
  String get paywallProDocumentsValue => 'Unlimited';

  @override
  String get paywallFreeNotificationsValue => '1 reminder';

  @override
  String get paywallProNotificationsValue => '3 reminders';

  @override
  String paywallBuyCta(String price) {
    return 'Get Pro for $price';
  }

  @override
  String get paywallBuyCtaUnavailable => 'Upgrade unavailable';

  @override
  String get paywallRestore => 'Restore purchases';

  @override
  String get paywallSuccessTitle => 'Welcome to Pro!';

  @override
  String get paywallSuccessBody => 'All features unlocked. Enjoy.';

  @override
  String get paywallSuccessContinue => 'Continue';

  @override
  String get paywallErrorTitle => 'Something went wrong';

  @override
  String get paywallErrorRetry => 'Try again';

  @override
  String get paywallCancelled => 'Purchase cancelled';

  @override
  String get paywallNothingToRestore => 'No previous purchase found';

  @override
  String get paywallOfferingUnavailable =>
      'Products not available right now. Try again later.';

  @override
  String get paywallHeroTitle => 'Go HouseKeep Pro';

  @override
  String get paywallSubtitle => 'One payment. Forever.';

  @override
  String get paywallOnce => 'one-time payment';

  @override
  String get paywallUnlockCta => 'Unlock Pro';

  @override
  String get paywallSkip => 'Not now';

  @override
  String get paywallGateTitle => 'You\'ve reached the free limit';

  @override
  String get paywallGateSub =>
      'The free plan includes 5 things and 3 documents. Upgrade to Pro to remove all limits.';

  @override
  String get paywallBenefitUnlimited => 'Unlimited things and documents';

  @override
  String get paywallBenefitMultiReminder => 'Multiple reminders per item';

  @override
  String get paywallBenefitWidget => 'Home screen widget';

  @override
  String get paywallBenefitPdf => 'Export to PDF and share with your partner';

  @override
  String get paywallBenefitTemplates =>
      'Pro templates: pool, garden, solar panels';

  @override
  String get paywallPurchaseError =>
      'Couldn\'t complete the purchase. Try again.';

  @override
  String get onboardingPage1Title => 'Your house has memory.';

  @override
  String get onboardingPage1Body =>
      'When to change the filter, when insurance expires, when checkups are due. Too much to remember.';

  @override
  String get onboardingPage2Title => 'HouseKeep remembers for you.';

  @override
  String get onboardingPage2Body =>
      'On-time alerts, ready-made templates, and a log of everything you\'ve done.';

  @override
  String get onboardingPage3Title => 'Start with one thing.';

  @override
  String get onboardingPage3Body =>
      'The boiler, the washing machine, the car insurance. Whatever worries you most.';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get onboardingHomeTypeLabel => 'Home type';

  @override
  String get settingsSectionGeneral => 'General';

  @override
  String get settingsSectionNotifications => 'Notifications';

  @override
  String get settingsSectionPremium => 'Premium';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String get settingsSectionWidget => 'Home screen widget';

  @override
  String get settingsWidgetTitle => 'Home screen widget';

  @override
  String get settingsWidgetBodyPro =>
      'Long-press on your home screen to add the HouseKeep widget.';

  @override
  String get settingsWidgetBodyFree =>
      'Available with HouseKeep Pro: add a widget showing your next events.';

  @override
  String get settingsWidgetCta => 'How to add';

  @override
  String get settingsWidgetUpgrade => 'Unlock with Pro';

  @override
  String get settingsWidgetHowToTitle => 'How to add the widget';

  @override
  String get settingsWidgetHowToBody =>
      '1. Long-press an empty space on your home screen.\n2. Tap “Widgets” and find HouseKeep.\n3. Drag the widget where you want.';

  @override
  String get settingsWidgetHowToClose => 'Got it';

  @override
  String get settingsSectionData => 'Data';

  @override
  String get settingsDataExportTitle => 'Export PDF';

  @override
  String get settingsDataExportBodyPro =>
      'Generate a PDF with all your appliances, maintenance and documents.';

  @override
  String get settingsDataExportBodyFree =>
      'Available with HouseKeep Pro: export your inventory to PDF.';

  @override
  String get settingsDataExportCta => 'Generate PDF';

  @override
  String get settingsDataExportUpgrade => 'Unlock with Pro';

  @override
  String get settingsDataExportProgress => 'Generating PDF…';

  @override
  String get settingsDataExportSuccess => 'PDF generated';

  @override
  String get settingsDataExportFailed => 'Could not generate PDF';

  @override
  String get settingsDataExportEmpty => 'Nothing to export yet';

  @override
  String get exportPdfTitle => 'HouseKeep — Inventory';

  @override
  String exportPdfSubtitle(String date) {
    return 'Generated on $date';
  }

  @override
  String get exportPdfSectionItems => 'Appliances';

  @override
  String get exportPdfSectionMaintenances => 'Maintenance';

  @override
  String get exportPdfSectionDocuments => 'Documents';

  @override
  String get exportPdfColName => 'Name';

  @override
  String get exportPdfColCategory => 'Category';

  @override
  String get exportPdfColBrand => 'Brand';

  @override
  String get exportPdfColPurchase => 'Purchase';

  @override
  String get exportPdfColWarrantyUntil => 'Warranty';

  @override
  String get exportPdfColItem => 'Item';

  @override
  String get exportPdfColIntervalMonths => 'Interval (months)';

  @override
  String get exportPdfColLastDone => 'Last done';

  @override
  String get exportPdfColNextDue => 'Next due';

  @override
  String get exportPdfColType => 'Type';

  @override
  String get exportPdfColExpiry => 'Expires';

  @override
  String get exportPdfNone => 'No data';

  @override
  String get exportPdfFileName => 'housekeep-inventory.pdf';

  @override
  String get settingsLanguageLabel => 'Language';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsLanguageEs => 'Español';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsNotificationsEnabled => 'Enable reminders';

  @override
  String get settingsNotificationsEnabledBody =>
      'Receive maintenance and expiry reminders.';

  @override
  String get settingsNotificationsOpenSystem => 'System permissions';

  @override
  String get settingsNotificationsDeniedTitle => 'Notifications are blocked';

  @override
  String get settingsNotificationsDeniedBody =>
      'Without notification permission HouseKeep cannot remind you about maintenance or document expiry. Reopen this app after enabling the permission.';

  @override
  String get settingsNotificationsDeniedCta => 'Open settings';

  @override
  String get settingsPremiumStatusFree => 'Free plan';

  @override
  String get settingsPremiumStatusPro => 'HouseKeep Pro';

  @override
  String get settingsPremiumUpgrade => 'Upgrade to Pro';

  @override
  String get settingsPremiumRestore => 'Restore purchases';

  @override
  String get settingsPremiumRestoreSuccess => 'Purchases restored';

  @override
  String get settingsPremiumRestoreNone => 'No previous purchase found';

  @override
  String get settingsPremiumRestoreFailed => 'Could not restore purchase';

  @override
  String settingsAboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get settingsAboutContact => 'Contact support';

  @override
  String get settingsAboutFeedback => 'Send feedback';

  @override
  String get settingsAboutPrivacy => 'Privacy policy';

  @override
  String get settingsAboutTerms => 'Terms of use';

  @override
  String get settingsAboutRate => 'Rate the app';

  @override
  String get settingsLinkOpenFailed => 'Could not open link';

  @override
  String get settingsPlanFreeSub => '5 things · 3 documents';

  @override
  String get settingsPlanProSub => 'All features unlocked';

  @override
  String get settingsProActive => 'Active';

  @override
  String get settingsSectionPreferences => 'Preferences';

  @override
  String get settingsFooter => 'HOUSEKEEP · MADE WITH CARE';

  @override
  String get itemSavedSuccess => 'Item saved';

  @override
  String get maintenanceSavedSuccess => 'Maintenance saved';

  @override
  String get documentSavedSuccess => 'Document saved';

  @override
  String get itemDeletedSuccess => 'Item deleted';

  @override
  String get maintenanceDeletedSuccess => 'Maintenance deleted';

  @override
  String get documentDeletedSuccess => 'Document deleted';

  @override
  String get maintenanceMarkDoneSuccess => 'Marked as done';

  @override
  String get commonErrorTitle => 'Something went wrong';

  @override
  String get commonErrorBody =>
      'We couldn\'t load the information. Check your connection and try again.';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonGoBack => 'Go back';
}
