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
  String get itemsTab => 'Artículos';

  @override
  String get documentsTab => 'Documentos';

  @override
  String get settingsTab => 'Ajustes';

  @override
  String get homeTitle => 'Tu casa de un vistazo';

  @override
  String get itemsTitle => 'Mis cosas';

  @override
  String get documentsTitle => 'Documentos';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get phaseZeroMessage =>
      'La base de la Fase 0 ya está lista para la siguiente fase.';

  @override
  String get itemCategoryKitchen => 'Cocina';

  @override
  String get itemCategoryBathroom => 'Baño';

  @override
  String get itemCategoryLaundry => 'Lavandería';

  @override
  String get itemCategoryLiving => 'Salón';

  @override
  String get itemCategoryBedroom => 'Dormitorio';

  @override
  String get itemCategoryGarden => 'Jardín';

  @override
  String get itemCategoryGarage => 'Garaje';

  @override
  String get itemCategoryPlumbing => 'Fontanería';

  @override
  String get itemCategoryElectrical => 'Eléctrico';

  @override
  String get itemCategorySecurity => 'Seguridad';

  @override
  String get itemCategoryGeneral => 'General';

  @override
  String get documentTypePassport => 'Pasaporte';

  @override
  String get documentTypeIdCard => 'DNI';

  @override
  String get documentTypeDriversLicense => 'Carnet de conducir';

  @override
  String get documentTypeVehicleInspection => 'ITV';

  @override
  String get documentTypeInsuranceHome => 'Seguro del hogar';

  @override
  String get documentTypeInsuranceCar => 'Seguro del coche';

  @override
  String get documentTypeInsuranceLife => 'Seguro de vida';

  @override
  String get documentTypeInsuranceHealth => 'Seguro de salud';

  @override
  String get documentTypeLease => 'Contrato de alquiler';

  @override
  String get documentTypeWarrantyDoc => 'Documento de garantía';

  @override
  String get documentTypeSubscription => 'Suscripción';

  @override
  String get documentTypeOther => 'Otro';

  @override
  String get itemsEmptyTitle => 'Aún no hay nada por aquí';

  @override
  String get itemsEmptyBody =>
      'Tu caldera, la lavadora, el coche… cualquier cosa con un mantenimiento o garantía.';

  @override
  String get itemsEmptyCta => 'Añadir cosa';

  @override
  String itemsCountFree(int n) {
    return '$n/5';
  }

  @override
  String itemsCount(int n) {
    return '$n elementos';
  }

  @override
  String get itemsWarrantyActive => 'Garantía activa';

  @override
  String get itemsWarrantyExpired => 'Garantía vencida';

  @override
  String itemsWarrantyExpiryInDays(int days) {
    return 'en ${days}d';
  }

  @override
  String itemsWarrantyExpiryDaysAgo(int days) {
    return 'hace ${days}d';
  }

  @override
  String get itemDetailWarranty => 'Garantía';

  @override
  String get itemDetailPhotoPlaceholder => 'Foto del electrodoméstico';

  @override
  String itemDetailMaintenanceInterval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meses',
      one: '$count mes',
    );
    return 'cada $_temp0';
  }

  @override
  String itemDetailPurchasedOn(String date) {
    return 'Comprado el $date';
  }

  @override
  String itemDetailUntil(String date) {
    return 'hasta el $date';
  }

  @override
  String get itemDetailHistory => 'Historial';

  @override
  String itemDetailMonthsWarranty(int n) {
    return '$n meses';
  }

  @override
  String get addFieldPurchased => 'Fecha de compra';

  @override
  String get addSave => 'Guardar';

  @override
  String get addCancel => 'Cancelar';

  @override
  String get addPhotoCamera => 'Cámara';

  @override
  String get addPhotoGallery => 'Galería';

  @override
  String get itemsFilteredEmptyTitle => 'No hay artículos en esta categoría';

  @override
  String get itemsFilteredEmptyBody =>
      'Prueba otra categoría o quita el filtro.';

  @override
  String get itemsClearFilter => 'Quitar filtro';

  @override
  String get itemsFilterAll => 'Todos';

  @override
  String get itemNameLabel => 'Nombre';

  @override
  String get itemBrandLabel => 'Marca';

  @override
  String get itemModelLabel => 'Modelo';

  @override
  String get itemPurchaseDateLabel => 'Fecha de compra';

  @override
  String get itemWarrantyMonthsLabel => 'Meses de garantía';

  @override
  String get itemNotesLabel => 'Notas';

  @override
  String get itemPhotoLabel => 'Foto';

  @override
  String get itemCategoryLabel => 'Categoría';

  @override
  String get itemSave => 'Guardar';

  @override
  String get itemEdit => 'Editar';

  @override
  String get itemDelete => 'Borrar';

  @override
  String get itemDeleteTitle => '¿Borrar artículo?';

  @override
  String get itemDeleteBody =>
      'Esto también borrará el historial de mantenimiento relacionado.';

  @override
  String get itemDeleteConfirm => 'Borrar';

  @override
  String get itemDeleteFailed =>
      'No se pudo borrar el artículo. Inténtalo de nuevo.';

  @override
  String get itemNoWarranty => 'Sin garantía';

  @override
  String get itemWarrantyActive => 'Garantía activa';

  @override
  String get itemWarrantyExpired => 'Garantía vencida';

  @override
  String get itemAddTitle => 'Añadir artículo';

  @override
  String get itemEditTitle => 'Editar artículo';

  @override
  String get itemDetailTitle => 'Detalle del artículo';

  @override
  String get itemPhotoAdd => 'Añadir foto';

  @override
  String get itemPhotoReplace => 'Cambiar foto';

  @override
  String get itemPhotoRemove => 'Quitar foto';

  @override
  String get itemPhotoCamera => 'Hacer foto';

  @override
  String get itemPhotoGallery => 'Elegir de galería';

  @override
  String get photoPickerErrorPermission =>
      'Sin permiso para acceder a la cámara o galería. Concede el permiso en Ajustes.';

  @override
  String get photoPickerErrorStorageFull =>
      'No hay espacio para guardar la foto. Libera almacenamiento e inténtalo de nuevo.';

  @override
  String get photoPickerErrorNoCamera =>
      'No se ha encontrado una cámara disponible.';

  @override
  String get photoPickerErrorUnknown => 'No se ha podido añadir la foto.';

  @override
  String get photoPickerOpenSettings => 'Ajustes';

  @override
  String get homeAddMaintenancePickItemTitle =>
      '¿A qué artículo añades el mantenimiento?';

  @override
  String get itemValidationName => 'Introduce un nombre';

  @override
  String get itemValidationWarrantyMonths =>
      'Introduce un número de meses válido';

  @override
  String get itemMaintenanceSectionTitle => 'Mantenimiento';

  @override
  String get itemMaintenanceSectionEmpty =>
      'Aún no hay mantenimientos para este artículo.';

  @override
  String get itemMaintenanceAdd => 'Añadir mantenimiento';

  @override
  String get maintenanceAddTitle => 'Añadir mantenimiento';

  @override
  String get maintenanceEditTitle => 'Editar mantenimiento';

  @override
  String get maintenanceNameLabel => 'Nombre de la tarea';

  @override
  String get maintenanceDescriptionLabel => 'Descripción';

  @override
  String get maintenanceIntervalLabel => 'Intervalo (meses)';

  @override
  String get maintenanceItemContextLabel => 'Mantenimiento para';

  @override
  String get maintenanceLastDoneLabel => 'Última vez realizado';

  @override
  String get maintenanceLastDoneNever => 'Sin registrar';

  @override
  String get maintenanceNotifyDaysLabel => 'Días de antelación para aviso';

  @override
  String get maintenanceNextDueLabel => 'Próxima vez';

  @override
  String get maintenanceSave => 'Guardar';

  @override
  String get maintenanceMarkDone => 'Marcar como hecho';

  @override
  String get maintenanceMarkDoneSheetTitle => 'Marcar como hecho';

  @override
  String get maintenanceMarkDoneWhenLabel => '¿Cuándo lo hiciste?';

  @override
  String get maintenanceMarkDoneToday => 'Hoy';

  @override
  String get maintenanceMarkDoneYesterday => 'Ayer';

  @override
  String get maintenanceMarkDoneOtherDate => 'Otra fecha';

  @override
  String get maintenanceMarkDoneNextReminder => 'Próximo aviso';

  @override
  String maintenanceMarkDoneNextInMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meses',
      one: '$count mes',
    );
    return 'en $_temp0';
  }

  @override
  String get maintenanceMarkDoneConfirm => 'Confirmar';

  @override
  String get maintenanceMarkDoneCompletedTitle => '¡Hecho!';

  @override
  String maintenanceMarkDoneCompletedSubtitle(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '$days día',
    );
    return 'Próximo aviso en $_temp0';
  }

  @override
  String get maintenanceEdit => 'Editar';

  @override
  String get maintenanceDelete => 'Borrar';

  @override
  String get maintenanceDeleteTitle => '¿Borrar mantenimiento?';

  @override
  String get maintenanceDeleteBody => 'Esta acción no se puede deshacer.';

  @override
  String get maintenanceDeleteConfirm => 'Borrar';

  @override
  String get maintenanceDeleteFailed => 'No se pudo borrar el mantenimiento.';

  @override
  String get maintenanceSaveFailed => 'No se pudo guardar el mantenimiento.';

  @override
  String get maintenanceMarkDoneFailed => 'No se pudo marcar como realizado.';

  @override
  String get maintenanceValidationName => 'Introduce un nombre';

  @override
  String get maintenanceValidationInterval =>
      'Introduce un número de meses válido';

  @override
  String get maintenanceValidationNotifyDays =>
      'Introduce un número de días válido';

  @override
  String get maintenanceUseTemplate => 'Usar plantilla';

  @override
  String get maintenanceTemplatesTitle => 'Plantillas de mantenimiento';

  @override
  String get maintenanceTemplatesEmpty =>
      'No hay plantillas para esta categoría.';

  @override
  String get maintenanceTemplatesAll => 'Todas';

  @override
  String maintenanceTemplatesSuggested(String category) {
    return 'Sugeridas para $category';
  }

  @override
  String get maintenanceTemplateProBadge => 'PRO';

  @override
  String get maintenanceTemplateProLocked =>
      'Esta plantilla requiere HouseKeep Pro.';

  @override
  String maintenanceIntervalMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meses',
      one: '$count mes',
    );
    return '$_temp0';
  }

  @override
  String maintenanceNextDueIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '$days día',
    );
    return 'Vence en $_temp0';
  }

  @override
  String maintenanceOverdueBy(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '$days día',
    );
    return 'Vencido hace $_temp0';
  }

  @override
  String get maintenanceDoneToday => 'Vence hoy';

  @override
  String maintenanceHistoryTitle(String date) {
    return 'Última vez: $date';
  }

  @override
  String get maintenanceLastDoneNeverShort => 'Nunca realizado';

  @override
  String get paywallMaintenanceProTitle => 'Desbloquea plantillas Pro';

  @override
  String get paywallMaintenanceProBody =>
      'Algunas plantillas avanzadas (piscina, riego, placas solares) requieren HouseKeep Pro.';

  @override
  String get paywallItemsLimitTitle => 'Desbloquea artículos ilimitados';

  @override
  String get paywallItemsLimitBody =>
      'El plan gratuito incluye hasta 5 artículos. Mejora a Pro para añadir todos los que necesites.';

  @override
  String get paywallUpgradeCta => 'Mejorar pronto';

  @override
  String get paywallBack => 'Volver';

  @override
  String get urgencyOk => 'Todo bien';

  @override
  String get urgencyUpcoming => 'Próximo';

  @override
  String get urgencyUrgent => 'Urgente';

  @override
  String get urgencyOverdue => 'Vencido';

  @override
  String get homeTypeApartment => 'Piso';

  @override
  String get homeTypeHouse => 'Casa';

  @override
  String get homeTypeVilla => 'Villa';

  @override
  String get documentsEmptyTitle => 'Sin documentos guardados';

  @override
  String get documentsEmptyBody =>
      'DNI, ITV, seguros… te avisamos un mes antes.';

  @override
  String get documentsEmptyCta => 'Añadir documento';

  @override
  String documentsCountFree(int n) {
    return '$n/3';
  }

  @override
  String documentsCount(int n) {
    return '$n documentos';
  }

  @override
  String get documentsSectionExpired => 'Caducados';

  @override
  String get documentsSectionSoon => 'Caducan pronto';

  @override
  String get documentsSectionCurrent => 'En vigor';

  @override
  String get documentsFilteredEmptyTitle => 'No hay documentos de este tipo';

  @override
  String get documentsFilteredEmptyBody =>
      'Prueba otro tipo o quita el filtro.';

  @override
  String get documentsClearFilter => 'Quitar filtro';

  @override
  String get documentsFilterAll => 'Todos';

  @override
  String get documentAddTitle => 'Nuevo documento';

  @override
  String get documentEditTitle => 'Editar documento';

  @override
  String get documentDetailTitle => 'Detalle del documento';

  @override
  String get documentNameLabel => 'Nombre';

  @override
  String get documentNameHint => 'Seguro del coche, DNI…';

  @override
  String get documentTypeLabel => 'Tipo de documento';

  @override
  String get documentExpiryDateLabel => 'Fecha de caducidad';

  @override
  String get documentExpiryDatePick => 'Selecciona una fecha';

  @override
  String get documentNotifyDaysLabel => 'Días de antelación para aviso';

  @override
  String documentReminderDaysBefore(int days) {
    return '$days d. antes';
  }

  @override
  String get documentReminderFreeHint =>
      'Hasta 1 aviso · Pásate a Pro para múltiples';

  @override
  String get documentReminderProHint =>
      'Pro incluye avisos automáticos a 90, 30 y 7 días.';

  @override
  String get documentNotesLabel => 'Notas';

  @override
  String get documentNotesHint => 'Número de póliza, contacto…';

  @override
  String get documentPhotoLabel => 'Foto / escaneo';

  @override
  String get documentScan => 'Escanear';

  @override
  String get documentGallery => 'Galería';

  @override
  String get documentScanPlaceholder => 'escanear';

  @override
  String get documentCancel => 'Cancelar';

  @override
  String get documentSave => 'Guardar';

  @override
  String get documentEdit => 'Editar';

  @override
  String get documentDelete => 'Borrar';

  @override
  String get documentDeleteTitle => '¿Borrar documento?';

  @override
  String get documentDeleteBody => 'Esta acción no se puede deshacer.';

  @override
  String get documentDeleteConfirm => 'Borrar';

  @override
  String get documentDeleteFailed => 'No se pudo borrar el documento.';

  @override
  String get documentSaveFailed => 'No se pudo guardar el documento.';

  @override
  String get documentValidationName => 'Introduce un nombre';

  @override
  String get documentValidationExpiry => 'Selecciona una fecha de caducidad';

  @override
  String get documentValidationNotifyDays =>
      'Introduce un número de días válido';

  @override
  String documentExpiryIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '$days día',
    );
    return 'Caduca en $_temp0';
  }

  @override
  String documentExpiredAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '$days día',
    );
    return 'Caducó hace $_temp0';
  }

  @override
  String get documentExpiresToday => 'Caduca hoy';

  @override
  String get paywallDocumentsLimitTitle => 'Desbloquea documentos ilimitados';

  @override
  String get paywallDocumentsLimitBody =>
      'El plan gratuito incluye hasta 3 documentos. Mejora a Pro para añadir todos los que necesites.';

  @override
  String get homeSummaryTitle => 'Tu casa';

  @override
  String get homeSummarySubtitle => 'Resumen de mantenimientos y documentos';

  @override
  String homeSummaryItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count artículos',
      one: '$count artículo',
      zero: 'Sin artículos',
    );
    return '$_temp0';
  }

  @override
  String homeSummaryPendingMaintenances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mantenimientos pendientes',
      one: '$count mantenimiento pendiente',
      zero: 'Sin mantenimientos pendientes',
    );
    return '$_temp0';
  }

  @override
  String homeSummaryUrgentDocuments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documentos urgentes',
      one: '$count documento urgente',
      zero: 'Sin documentos urgentes',
    );
    return '$_temp0';
  }

  @override
  String get homeAllClearTitle => 'Todo al día';

  @override
  String get homeAllClearBody =>
      'No hay mantenimientos ni documentos urgentes ahora mismo.';

  @override
  String get homeTimelineTitle => 'Próximos eventos';

  @override
  String get homeEmptyTitle => 'Empieza por lo más importante';

  @override
  String get homeEmptyBody =>
      'Añade tu primer electrodoméstico o documento y HouseKeep te avisará antes de que sea tarde.';

  @override
  String get homeEmptyCta => 'Añadir mi primera cosa';

  @override
  String get homeGreetingMorning => 'Buenos días';

  @override
  String get homeGreetingAfternoon => 'Buenas tardes';

  @override
  String get homeGreetingEvening => 'Buenas noches';

  @override
  String get homeSubtitle => 'Esto es lo que pide atención';

  @override
  String get homeSummaryDue => 'Pendientes';

  @override
  String get homeSummarySoon => 'Esta semana';

  @override
  String get homeSummaryOk => 'Al día';

  @override
  String get homeSeeAll => 'Ver todo';

  @override
  String homeProUpsellTitle(String price) {
    return 'Pásate a Pro por $price';
  }

  @override
  String get homeProUpsellTitleGeneric => 'Hazte Pro';

  @override
  String get homeProUpsellSub => 'Sin límites · pago único · para siempre';

  @override
  String get homeProUpsellCta => 'Ver';

  @override
  String get homeShortDayToday => 'hoy';

  @override
  String get homeShortDayTomorrow => 'mañana';

  @override
  String homeShortDayIn(int days) {
    return 'en ${days}d';
  }

  @override
  String get homeShortDayYesterday => 'ayer';

  @override
  String homeShortDayAgo(int days) {
    return 'hace ${days}d';
  }

  @override
  String get homeFallbackName => 'Hola';

  @override
  String get homeEventMaintenance => 'Mantenimiento';

  @override
  String get homeEventDocument => 'Documento';

  @override
  String get homeEventWarranty => 'Garantía';

  @override
  String homeEventDueIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '$days día',
    );
    return 'En $_temp0';
  }

  @override
  String homeEventOverdueBy(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '$days día',
    );
    return 'Vencido hace $_temp0';
  }

  @override
  String get homeEventDueToday => 'Hoy';

  @override
  String get homeFabAddItem => 'Añadir artículo';

  @override
  String get homeFabAddMaintenance => 'Añadir mantenimiento';

  @override
  String get homeFabAddDocument => 'Añadir documento';

  @override
  String get homeFabAddMaintenanceNoItems =>
      'Crea un artículo primero para añadir mantenimientos.';

  @override
  String get notificationMaintenanceTitle => 'Recordatorio de mantenimiento';

  @override
  String notificationMaintenanceBody(String item, String task, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'vence en $days días',
      one: 'vence en 1 día',
      zero: 'vence hoy',
    );
    return '🔧 $item: $task $_temp0';
  }

  @override
  String get notificationMaintenanceOverdueTitle => 'Mantenimiento vencido';

  @override
  String notificationMaintenanceOverdueBody(String item, String task) {
    return '🔧 $item: $task está vencido';
  }

  @override
  String get notificationDocumentTitle => 'Recordatorio de documento';

  @override
  String notificationDocumentBody(String name, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'caduca en $days días',
      one: 'caduca en 1 día',
      zero: 'caduca hoy',
    );
    return '📄 $name $_temp0';
  }

  @override
  String get notificationDocumentExpiredTitle => 'Documento caducado';

  @override
  String notificationDocumentExpiredBody(String name) {
    return '📄 $name ha caducado';
  }

  @override
  String get notificationWarrantyTitle => 'Recordatorio de garantía';

  @override
  String notificationWarrantyBody(String item, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'termina en $days días',
      one: 'termina en 1 día',
      zero: 'termina hoy',
    );
    return '⚠️ La garantía de $item $_temp0';
  }

  @override
  String get notificationWarrantyExpiredTitle => 'Garantía caducada';

  @override
  String notificationWarrantyExpiredBody(String item) {
    return '⚠️ La garantía de $item ha caducado';
  }

  @override
  String get notificationsPermissionDeniedTitle =>
      'Notificaciones desactivadas';

  @override
  String get notificationsPermissionDeniedBody =>
      'HouseKeep necesita permisos de notificación para avisarte de mantenimientos y caducidades.';

  @override
  String get notificationsPermissionOpenSettings => 'Abrir ajustes';

  @override
  String get paywallTitle => 'HouseKeep Pro';

  @override
  String get paywallTagline => 'Cuida tu casa sin límites';

  @override
  String get paywallFeatureUnlimitedItems => 'Artículos ilimitados';

  @override
  String get paywallFeatureUnlimitedDocuments => 'Documentos ilimitados';

  @override
  String get paywallFeatureProTemplates =>
      'Todas las plantillas de mantenimiento';

  @override
  String get paywallFeatureMultiNotifications =>
      'Avisos múltiples (90/30/7 días)';

  @override
  String get paywallFeatureWidget => 'Widget de pantalla de inicio';

  @override
  String get paywallFeatureExportPdf => 'Exportar a PDF';

  @override
  String get paywallFreeColumn => 'Gratis';

  @override
  String get paywallProColumn => 'Pro';

  @override
  String get paywallFreeItemsValue => 'Hasta 5 artículos';

  @override
  String get paywallProItemsValue => 'Ilimitados';

  @override
  String get paywallFreeDocumentsValue => 'Hasta 3 documentos';

  @override
  String get paywallProDocumentsValue => 'Ilimitados';

  @override
  String get paywallFreeNotificationsValue => '1 aviso';

  @override
  String get paywallProNotificationsValue => '3 avisos';

  @override
  String paywallBuyCta(String price) {
    return 'Comprar Pro por $price';
  }

  @override
  String get paywallBuyCtaUnavailable => 'Compra no disponible';

  @override
  String get paywallRestore => 'Restaurar compras';

  @override
  String get paywallSuccessTitle => '¡Bienvenido a Pro!';

  @override
  String get paywallSuccessBody =>
      'Todas las funciones desbloqueadas. Disfruta.';

  @override
  String get paywallSuccessContinue => 'Continuar';

  @override
  String get paywallErrorTitle => 'Algo ha fallado';

  @override
  String get paywallErrorRetry => 'Reintentar';

  @override
  String get paywallCancelled => 'Compra cancelada';

  @override
  String get paywallNothingToRestore => 'No se encontró ninguna compra previa';

  @override
  String get paywallOfferingUnavailable =>
      'Productos no disponibles ahora mismo. Inténtalo más tarde.';

  @override
  String get paywallHeroTitle => 'Pasa a HouseKeep Pro';

  @override
  String get paywallSubtitle => 'Un pago único. Para siempre.';

  @override
  String get paywallOnce => 'pago único';

  @override
  String get paywallUnlockCta => 'Desbloquear Pro';

  @override
  String get paywallSkip => 'Ahora no';

  @override
  String get paywallGateTitle => 'Has llegado al límite gratuito';

  @override
  String get paywallGateSub =>
      'El plan gratuito incluye 5 cosas y 3 documentos. Pasa a Pro para no tener límites.';

  @override
  String get paywallBenefitUnlimited => 'Cosas y documentos ilimitados';

  @override
  String get paywallBenefitMultiReminder => 'Múltiples avisos por elemento';

  @override
  String get paywallBenefitWidget => 'Widget de pantalla de inicio';

  @override
  String get paywallBenefitPdf => 'Exporta a PDF y comparte con tu pareja';

  @override
  String get paywallBenefitTemplates =>
      'Plantillas Pro: piscina, jardín, placas solares';

  @override
  String get paywallPurchaseError =>
      'No se pudo completar la compra. Inténtalo de nuevo.';

  @override
  String get onboardingPage1Title => 'Tu casa tiene memoria.';

  @override
  String get onboardingPage1Body =>
      'Cuándo cambiar el filtro, cuándo caduca el seguro, cuándo toca revisión. Demasiado para recordar.';

  @override
  String get onboardingPage2Title => 'HouseKeep recuerda por ti.';

  @override
  String get onboardingPage2Body =>
      'Avisos a tiempo, plantillas listas y un historial de todo lo que has hecho.';

  @override
  String get onboardingPage3Title => 'Empieza con una sola cosa.';

  @override
  String get onboardingPage3Body =>
      'La caldera, la lavadora, el seguro del coche. Lo que más te preocupe.';

  @override
  String get onboardingNext => 'Siguiente';

  @override
  String get onboardingSkip => 'Saltar';

  @override
  String get onboardingStart => 'Empezar';

  @override
  String get onboardingHomeTypeLabel => 'Tipo de vivienda';

  @override
  String get settingsSectionGeneral => 'General';

  @override
  String get settingsSectionNotifications => 'Notificaciones';

  @override
  String get settingsSectionPremium => 'Premium';

  @override
  String get settingsSectionAbout => 'Sobre';

  @override
  String get settingsSectionWidget => 'Widget de pantalla de inicio';

  @override
  String get settingsWidgetTitle => 'Widget en pantalla de inicio';

  @override
  String get settingsWidgetBodyPro =>
      'Mantén pulsado en tu pantalla de inicio para añadir el widget de HouseKeep.';

  @override
  String get settingsWidgetBodyFree =>
      'Disponible con HouseKeep Pro: añade un widget con tus próximos eventos.';

  @override
  String get settingsWidgetCta => 'Cómo añadirlo';

  @override
  String get settingsWidgetUpgrade => 'Desbloquear con Pro';

  @override
  String get settingsWidgetHowToTitle => 'Cómo añadir el widget';

  @override
  String get settingsWidgetHowToBody =>
      '1. Mantén pulsado un espacio vacío en tu pantalla de inicio.\n2. Pulsa “Widgets” y busca HouseKeep.\n3. Arrastra el widget al lugar que prefieras.';

  @override
  String get settingsWidgetHowToClose => 'Entendido';

  @override
  String get settingsSectionData => 'Datos';

  @override
  String get settingsDataExportTitle => 'Exportar PDF';

  @override
  String get settingsDataExportBodyPro =>
      'Genera un PDF con todos tus electrodomésticos, mantenimientos y documentos.';

  @override
  String get settingsDataExportBodyFree =>
      'Disponible con HouseKeep Pro: exporta un PDF con tu inventario.';

  @override
  String get settingsDataExportCta => 'Generar PDF';

  @override
  String get settingsDataExportUpgrade => 'Desbloquear con Pro';

  @override
  String get settingsDataExportProgress => 'Generando PDF…';

  @override
  String get settingsDataExportSuccess => 'PDF generado';

  @override
  String get settingsDataExportFailed => 'No se pudo generar el PDF';

  @override
  String get settingsDataExportEmpty => 'Aún no tienes datos para exportar';

  @override
  String get exportPdfTitle => 'HouseKeep — Inventario';

  @override
  String exportPdfSubtitle(String date) {
    return 'Generado el $date';
  }

  @override
  String get exportPdfSectionItems => 'Electrodomésticos';

  @override
  String get exportPdfSectionMaintenances => 'Mantenimientos';

  @override
  String get exportPdfSectionDocuments => 'Documentos';

  @override
  String get exportPdfColName => 'Nombre';

  @override
  String get exportPdfColCategory => 'Categoría';

  @override
  String get exportPdfColBrand => 'Marca';

  @override
  String get exportPdfColPurchase => 'Compra';

  @override
  String get exportPdfColWarrantyUntil => 'Garantía';

  @override
  String get exportPdfColItem => 'Artículo';

  @override
  String get exportPdfColIntervalMonths => 'Intervalo (meses)';

  @override
  String get exportPdfColLastDone => 'Última realización';

  @override
  String get exportPdfColNextDue => 'Próximo';

  @override
  String get exportPdfColType => 'Tipo';

  @override
  String get exportPdfColExpiry => 'Caduca';

  @override
  String get exportPdfNone => 'Sin datos';

  @override
  String get exportPdfFileName => 'housekeep-inventario.pdf';

  @override
  String get settingsLanguageLabel => 'Idioma';

  @override
  String get settingsThemeLabel => 'Tema';

  @override
  String get settingsThemeSystem => 'Auto';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsLanguageSystem => 'Sistema';

  @override
  String get settingsLanguageEs => 'Español';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsNotificationsEnabled => 'Activar avisos';

  @override
  String get settingsNotificationsEnabledBody =>
      'Recibe recordatorios de mantenimientos y caducidades.';

  @override
  String get settingsNotificationsOpenSystem => 'Permisos del sistema';

  @override
  String get settingsNotificationsDeniedTitle =>
      'Las notificaciones están bloqueadas';

  @override
  String get settingsNotificationsDeniedBody =>
      'Sin permiso de notificaciones HouseKeep no podrá avisarte de mantenimientos ni caducidades. Vuelve a abrir esta app después de activar el permiso.';

  @override
  String get settingsNotificationsDeniedCta => 'Abrir ajustes';

  @override
  String get settingsPremiumStatusFree => 'Plan gratuito';

  @override
  String get settingsPremiumStatusPro => 'HouseKeep Pro';

  @override
  String get settingsPremiumUpgrade => 'Mejorar a Pro';

  @override
  String get settingsPremiumRestore => 'Restaurar compras';

  @override
  String get settingsPremiumRestoreSuccess => 'Compras restauradas';

  @override
  String get settingsPremiumRestoreNone =>
      'No se encontró ninguna compra previa';

  @override
  String get settingsPremiumRestoreFailed => 'No se pudo restaurar la compra';

  @override
  String settingsAboutVersion(String version) {
    return 'Versión $version';
  }

  @override
  String get settingsAboutContact => 'Contactar con soporte';

  @override
  String get settingsAboutFeedback => 'Enviar feedback';

  @override
  String get settingsAboutPrivacy => 'Política de privacidad';

  @override
  String get settingsAboutTerms => 'Términos de uso';

  @override
  String get settingsAboutRate => 'Valorar la app';

  @override
  String get settingsLinkOpenFailed => 'No se pudo abrir el enlace';

  @override
  String get settingsPlanFreeSub => '5 cosas · 3 documentos';

  @override
  String get settingsPlanProSub => 'Todas las funciones desbloqueadas';

  @override
  String get settingsProActive => 'Activo';

  @override
  String get settingsSectionPreferences => 'Preferencias';

  @override
  String get settingsFooter => 'HOUSEKEEP · MADE WITH CARE';

  @override
  String get itemSavedSuccess => 'Artículo guardado';

  @override
  String get maintenanceSavedSuccess => 'Mantenimiento guardado';

  @override
  String get documentSavedSuccess => 'Documento guardado';

  @override
  String get itemDeletedSuccess => 'Artículo borrado';

  @override
  String get maintenanceDeletedSuccess => 'Mantenimiento borrado';

  @override
  String get documentDeletedSuccess => 'Documento borrado';

  @override
  String get maintenanceMarkDoneSuccess => 'Marcado como realizado';

  @override
  String get commonErrorTitle => 'Algo salió mal';

  @override
  String get commonErrorBody =>
      'No se pudo cargar la información. Comprueba tu conexión e inténtalo de nuevo.';

  @override
  String get commonRetry => 'Reintentar';

  @override
  String get commonGoBack => 'Volver';
}
