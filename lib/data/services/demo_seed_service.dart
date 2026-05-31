import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/utils/date_calculations.dart';
import '../../domain/enums/document_type.dart';
import '../../domain/enums/item_category.dart';
import '../../domain/models/document.dart';
import '../../domain/models/item.dart';
import '../../domain/models/maintenance.dart';
import '../repositories/documents_repository.dart';
import '../repositories/items_repository.dart';
import '../repositories/maintenances_repository.dart';

/// Seeds the database with a realistic dataset for store screenshots.
///
/// Debug-only (wired behind `kDebugMode` in Settings). All rows use fixed
/// `demo_` ids so seeding is idempotent and [clear] only removes demo data,
/// never the user's real items/documents.
///
/// Dates are computed relative to [DateTime.now] so the green/amber/red
/// urgency pattern (see [SCREENSHOT_PLAN.md]) holds whenever it is captured.
/// Names are localized via [DemoSeedStrings] so ES and EN screenshots can be
/// taken just by switching the in-app language — no reinstall needed.
class DemoSeedService {
  const DemoSeedService({
    required ItemsRepository items,
    required MaintenancesRepository maintenances,
    required DocumentsRepository documents,
  }) : _items = items,
       _maintenances = maintenances,
       _documents = documents;

  final ItemsRepository _items;
  final MaintenancesRepository _maintenances;
  final DocumentsRepository _documents;

  static const _itemBoiler = 'demo_item_boiler';
  static const _itemDishwasher = 'demo_item_dishwasher';
  static const _itemWasher = 'demo_item_washer';
  static const _itemSmoke = 'demo_item_smoke';
  static const _itemFridge = 'demo_item_fridge';

  static const _itemIds = [
    _itemBoiler,
    _itemDishwasher,
    _itemWasher,
    _itemSmoke,
    _itemFridge,
  ];

  static const _docId = 'demo_doc_id';
  static const _docMot = 'demo_doc_mot';
  static const _docInsurance = 'demo_doc_insurance';

  static const _docIds = [_docId, _docMot, _docInsurance];

  Future<void> seed(DemoSeedStrings s) async {
    final now = DateTime.now();

    // Copy bundled royalty-free demo photos into the app's managed photos
    // directory so they show up exactly like user-picked photos.
    final boilerPhoto = await _copyDemoPhoto('boiler.jpg');
    final dishwasherPhoto = await _copyDemoPhoto('dishwasher.jpg');
    final washerPhoto = await _copyDemoPhoto('washer.jpg');
    final smokePhoto = await _copyDemoPhoto('smoke_detector.jpg');
    final fridgePhoto = await _copyDemoPhoto('fridge.jpg');
    final idPhoto = await _copyDemoPhoto('id_card.jpg');
    final motPhoto = await _copyDemoPhoto('vehicle_inspection.jpg');
    final insurancePhoto = await _copyDemoPhoto('home_insurance.jpg');

    // ----- Items -----
    final items = <Item>[
      _item(
        id: _itemBoiler,
        name: s.boiler,
        category: ItemCategory.plumbing,
        brand: 'Vaillant',
        model: 'ecoTEC plus',
        purchaseMonthsAgo: 20, // warranty 24m → still active
        warrantyMonths: 24,
        photoPath: boilerPhoto,
        now: now,
      ),
      _item(
        id: _itemDishwasher,
        name: s.dishwasher,
        category: ItemCategory.kitchen,
        brand: 'Bosch',
        model: 'SMV4HVX33E',
        purchaseMonthsAgo: 38, // warranty 24m → expired
        warrantyMonths: 24,
        photoPath: dishwasherPhoto,
        now: now,
      ),
      _item(
        id: _itemWasher,
        name: s.washer,
        category: ItemCategory.laundry,
        brand: 'LG',
        model: 'F4WV5012S0W',
        purchaseMonthsAgo: 4, // warranty 24m → active
        warrantyMonths: 24,
        photoPath: washerPhoto,
        now: now,
      ),
      _item(
        id: _itemSmoke,
        name: s.smokeDetector,
        category: ItemCategory.security,
        brand: 'Kidde',
        model: 'i9080',
        purchaseMonthsAgo: 6,
        warrantyMonths: 12,
        photoPath: smokePhoto,
        now: now,
      ),
      _item(
        id: _itemFridge,
        name: s.fridge,
        category: ItemCategory.kitchen,
        brand: 'Balay',
        model: '3HFE743XD',
        purchaseMonthsAgo: 47, // warranty 24m → expired
        warrantyMonths: 24,
        photoPath: fridgePhoto,
        now: now,
      ),
    ];
    for (final item in items) {
      await _items.saveItem(item);
    }

    // ----- Maintenances -----
    final maintenances = <Maintenance>[
      // green: annual boiler service due in ~2 months
      _maintenance(
        id: 'demo_mt_boiler_annual',
        itemId: _itemBoiler,
        name: s.annualService,
        intervalMonths: 12,
        dueInDays: 60,
        now: now,
      ),
      // red: filter change due in a few days
      _maintenance(
        id: 'demo_mt_boiler_filter',
        itemId: _itemBoiler,
        name: s.filterChange,
        intervalMonths: 6,
        dueInDays: 5,
        now: now,
      ),
      // red (overdue): smoke detector monthly test
      _maintenance(
        id: 'demo_mt_smoke_test',
        itemId: _itemSmoke,
        name: s.monthlyTest,
        intervalMonths: 1,
        dueInDays: -2,
        now: now,
      ),
      // amber: washer drum cleaning
      _maintenance(
        id: 'demo_mt_washer_drum',
        itemId: _itemWasher,
        name: s.drumCleaning,
        intervalMonths: 3,
        dueInDays: 20,
        now: now,
      ),
    ];
    for (final maintenance in maintenances) {
      await _maintenances.saveMaintenance(maintenance);
    }

    // ----- Documents -----
    final documents = <Document>[
      // green: ID expires far out
      _document(
        id: _docId,
        name: s.idDocName,
        type: DocumentType.idCard,
        expiresInDays: 1800,
        photoPath: idPhoto,
        now: now,
      ),
      // amber: vehicle inspection in ~2 months
      _document(
        id: _docMot,
        name: s.motDocName,
        type: DocumentType.vehicleInspection,
        expiresInDays: 55,
        photoPath: motPhoto,
        now: now,
      ),
      // red: home insurance renewal in ~2 weeks
      _document(
        id: _docInsurance,
        name: s.insuranceDocName,
        type: DocumentType.insuranceHome,
        expiresInDays: 13,
        photoPath: insurancePhoto,
        now: now,
      ),
    ];
    for (final document in documents) {
      await _documents.saveDocument(document);
    }
  }

  /// Removes only the demo rows and their copied photos. Maintenances cascade
  /// on item delete.
  Future<void> clear() async {
    for (final id in _itemIds) {
      await _items.deleteItem(id);
    }
    for (final id in _docIds) {
      await _documents.deleteDocument(id);
    }
    final photosDir = Directory(await _photosDirPath());
    if (await photosDir.exists()) {
      await for (final entity in photosDir.list()) {
        final name = p.basename(entity.path);
        if (entity is File && name.startsWith(_photoPrefix)) {
          await entity.delete();
        }
      }
    }
  }

  static const _photoPrefix = 'demo_';

  Future<String> _photosDirPath() async {
    final docsDir = await getApplicationDocumentsDirectory();
    return p.join(docsDir.path, 'photos');
  }

  /// Copies `assets/images/demo/<fileName>` into the managed photos dir with a
  /// stable `demo_` name (idempotent) and returns its absolute path.
  Future<String> _copyDemoPhoto(String fileName) async {
    final photosDirPath = await _photosDirPath();
    await Directory(photosDirPath).create(recursive: true);
    final destPath = p.join(photosDirPath, '$_photoPrefix$fileName');
    final data = await rootBundle.load('assets/images/demo/$fileName');
    final bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    await File(destPath).writeAsBytes(bytes, flush: true);
    return destPath;
  }

  Item _item({
    required String id,
    required String name,
    required ItemCategory category,
    required String brand,
    required String model,
    required int purchaseMonthsAgo,
    required int warrantyMonths,
    required String? photoPath,
    required DateTime now,
  }) {
    return Item(
      id: id,
      name: name,
      category: category,
      brand: brand,
      model: model,
      purchaseDate: DateCalculations.addMonths(now, -purchaseMonthsAgo),
      warrantyMonths: warrantyMonths,
      photoPath: photoPath,
      notes: null,
      createdAt: now,
      updatedAt: now,
    );
  }

  Maintenance _maintenance({
    required String id,
    required String itemId,
    required String name,
    required int intervalMonths,
    required int dueInDays,
    required DateTime now,
  }) {
    final nextDueAt = now.add(Duration(days: dueInDays));
    return Maintenance(
      id: id,
      itemId: itemId,
      name: name,
      description: null,
      intervalMonths: intervalMonths,
      lastDoneAt: DateCalculations.addMonths(nextDueAt, -intervalMonths),
      nextDueAt: nextDueAt,
      notifyDaysBefore: 7,
      isFromTemplate: false,
      createdAt: now,
      updatedAt: now,
    );
  }

  Document _document({
    required String id,
    required String name,
    required DocumentType type,
    required int expiresInDays,
    required String? photoPath,
    required DateTime now,
  }) {
    return Document(
      id: id,
      name: name,
      type: type,
      expiryDate: now.add(Duration(days: expiresInDays)),
      notifyDaysBefore: 30,
      photoPath: photoPath,
      notes: null,
      createdAt: now,
      updatedAt: now,
    );
  }
}

/// Localized labels for the demo dataset. Pick [es] or [en] from the active
/// app locale before seeding.
class DemoSeedStrings {
  const DemoSeedStrings({
    required this.boiler,
    required this.dishwasher,
    required this.washer,
    required this.smokeDetector,
    required this.fridge,
    required this.annualService,
    required this.filterChange,
    required this.monthlyTest,
    required this.drumCleaning,
    required this.idDocName,
    required this.motDocName,
    required this.insuranceDocName,
  });

  final String boiler;
  final String dishwasher;
  final String washer;
  final String smokeDetector;
  final String fridge;
  final String annualService;
  final String filterChange;
  final String monthlyTest;
  final String drumCleaning;
  final String idDocName;
  final String motDocName;
  final String insuranceDocName;

  static const es = DemoSeedStrings(
    boiler: 'Caldera salón',
    dishwasher: 'Lavavajillas',
    washer: 'Lavadora',
    smokeDetector: 'Detector humo cocina',
    fridge: 'Frigorífico',
    annualService: 'Revisión anual',
    filterChange: 'Cambio de filtros',
    monthlyTest: 'Test mensual',
    drumCleaning: 'Limpieza del tambor',
    idDocName: 'DNI de Pablo',
    motDocName: 'ITV del coche',
    insuranceDocName: 'Seguro del hogar',
  );

  static const en = DemoSeedStrings(
    boiler: 'Living room boiler',
    dishwasher: 'Dishwasher',
    washer: 'Washing machine',
    smokeDetector: 'Kitchen smoke detector',
    fridge: 'Fridge',
    annualService: 'Annual service',
    filterChange: 'Filter change',
    monthlyTest: 'Monthly test',
    drumCleaning: 'Drum cleaning',
    idDocName: "Pablo's ID card",
    motDocName: 'Car inspection',
    insuranceDocName: 'Home insurance',
  );

  static DemoSeedStrings forLanguageCode(String languageCode) {
    return languageCode == 'es' ? es : en;
  }
}
