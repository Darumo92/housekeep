abstract class AnalyticsService {
  Future<void> logEvent(String name, [Map<String, Object>? parameters]);

  Future<void> setUserProperty(String name, String value);

  // --- Onboarding ---
  Future<void> onboardingCompleted() => logEvent('onboarding_completed');
  Future<void> onboardingSkipped() => logEvent('onboarding_skipped');

  // --- Items ---
  Future<void> itemSaved({
    required bool isNew,
    required String category,
  }) =>
      logEvent('item_saved', {'is_new': isNew, 'category': category});

  Future<void> itemDeleted() => logEvent('item_deleted');

  // --- Maintenances ---
  Future<void> maintenanceSaved({
    required bool isNew,
    required bool fromTemplate,
    required String? category,
  }) =>
      logEvent('maintenance_saved', {
        'is_new': isNew,
        'from_template': fromTemplate,
        if (category != null) 'category': category,
      });

  Future<void> maintenanceMarkedDone(String when) =>
      logEvent('maintenance_marked_done', {'when': when});

  Future<void> maintenanceDeleted() => logEvent('maintenance_deleted');

  // --- Documents ---
  Future<void> documentSaved({
    required bool isNew,
    required String type,
    required bool hasPhoto,
  }) =>
      logEvent('document_saved', {
        'is_new': isNew,
        'type': type,
        'has_photo': hasPhoto,
      });

  Future<void> documentDeleted() => logEvent('document_deleted');

  // --- Templates ---
  Future<void> templateApplied({required String label, required String? category}) =>
      logEvent('template_applied', {
        'label': label,
        if (category != null) 'category': category,
      });

  Future<void> templatePickerOpened() => logEvent('template_picker_opened');

  // --- Paywall ---
  Future<void> paywallViewed(String source) =>
      logEvent('paywall_viewed', {'source': source});

  Future<void> paywallPurchaseStarted(String source) =>
      logEvent('paywall_purchase_started', {'source': source});

  Future<void> paywallPurchaseSuccess() =>
      logEvent('paywall_purchase_success');

  Future<void> paywallPurchaseCancelled() =>
      logEvent('paywall_purchase_cancelled');

  Future<void> paywallPurchaseError(String? error) =>
      logEvent('paywall_purchase_error', {'error': error ?? 'unknown'});

  Future<void> paywallRestoreStarted() =>
      logEvent('paywall_restore_started');

  Future<void> paywallRestoreSuccess() =>
      logEvent('paywall_restore_success');

  Future<void> paywallRestoreFailed() =>
      logEvent('paywall_restore_failed');

  Future<void> paywallSkipped(String source) =>
      logEvent('paywall_skipped', {'source': source});

  // --- Export ---
  Future<void> exportPdfStarted() => logEvent('export_pdf_started');
  Future<void> exportPdfSuccess() => logEvent('export_pdf_success');
  Future<void> exportPdfEmpty() => logEvent('export_pdf_empty');
  Future<void> exportPdfFailed() => logEvent('export_pdf_failed');

  // --- Settings ---
  Future<void> settingsLanguageChanged(String locale) =>
      logEvent('settings_language_changed', {'locale': locale});

  Future<void> settingsThemeChanged(String theme) =>
      logEvent('settings_theme_changed', {'theme': theme});

  Future<void> settingsNotificationsToggled(bool enabled) =>
      logEvent('settings_notifications_toggled', {'enabled': enabled});

  // --- Limits ---
  Future<void> limitHit(String type) =>
      logEvent('limit_hit', {'type': type});

  // --- Home ---
  Future<void> homeViewed() => logEvent('home_viewed');
}

class NoOpAnalyticsService implements AnalyticsService {
  const NoOpAnalyticsService();

  @override
  Future<void> logEvent(String name, [Map<String, Object>? parameters]) async {}

  @override
  Future<void> setUserProperty(String name, String value) async {}

  @override
  Future<void> onboardingCompleted() async {}

  @override
  Future<void> onboardingSkipped() async {}

  @override
  Future<void> itemSaved({required bool isNew, required String category}) async {}

  @override
  Future<void> itemDeleted() async {}

  @override
  Future<void> maintenanceSaved({required bool isNew, required bool fromTemplate, required String? category}) async {}

  @override
  Future<void> maintenanceMarkedDone(String when) async {}

  @override
  Future<void> maintenanceDeleted() async {}

  @override
  Future<void> documentSaved({required bool isNew, required String type, required bool hasPhoto}) async {}

  @override
  Future<void> documentDeleted() async {}

  @override
  Future<void> templateApplied({required String label, required String? category}) async {}

  @override
  Future<void> templatePickerOpened() async {}

  @override
  Future<void> paywallViewed(String source) async {}

  @override
  Future<void> paywallPurchaseStarted(String source) async {}

  @override
  Future<void> paywallPurchaseSuccess() async {}

  @override
  Future<void> paywallPurchaseCancelled() async {}

  @override
  Future<void> paywallPurchaseError(String? error) async {}

  @override
  Future<void> paywallRestoreStarted() async {}

  @override
  Future<void> paywallRestoreSuccess() async {}

  @override
  Future<void> paywallRestoreFailed() async {}

  @override
  Future<void> paywallSkipped(String source) async {}

  @override
  Future<void> exportPdfStarted() async {}

  @override
  Future<void> exportPdfSuccess() async {}

  @override
  Future<void> exportPdfEmpty() async {}

  @override
  Future<void> exportPdfFailed() async {}

  @override
  Future<void> settingsLanguageChanged(String locale) async {}

  @override
  Future<void> settingsThemeChanged(String theme) async {}

  @override
  Future<void> settingsNotificationsToggled(bool enabled) async {}

  @override
  Future<void> limitHit(String type) async {}

  @override
  Future<void> homeViewed() async {}
}
