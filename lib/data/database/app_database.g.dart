// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ItemsTableTable extends ItemsTable
    with TableInfo<$ItemsTableTable, ItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
      'brand', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
      'model', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _purchaseDateMeta =
      const VerificationMeta('purchaseDate');
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> purchaseDate =
      GeneratedColumn<int>('purchase_date', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<DateTime?>($ItemsTableTable.$converterpurchaseDaten);
  static const VerificationMeta _warrantyMonthsMeta =
      const VerificationMeta('warrantyMonths');
  @override
  late final GeneratedColumn<int> warrantyMonths = GeneratedColumn<int>(
      'warranty_months', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>('created_at', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<DateTime>($ItemsTableTable.$convertercreatedAt);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> updatedAt =
      GeneratedColumn<int>('updated_at', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<DateTime>($ItemsTableTable.$converterupdatedAt);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        category,
        brand,
        model,
        purchaseDate,
        warrantyMonths,
        photoPath,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'items';
  @override
  VerificationContext validateIntegrity(Insertable<ItemRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
          _brandMeta, brand.isAcceptableOrUnknown(data['brand']!, _brandMeta));
    }
    if (data.containsKey('model')) {
      context.handle(
          _modelMeta, model.isAcceptableOrUnknown(data['model']!, _modelMeta));
    }
    context.handle(_purchaseDateMeta, const VerificationResult.success());
    if (data.containsKey('warranty_months')) {
      context.handle(
          _warrantyMonthsMeta,
          warrantyMonths.isAcceptableOrUnknown(
              data['warranty_months']!, _warrantyMonthsMeta));
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    context.handle(_createdAtMeta, const VerificationResult.success());
    context.handle(_updatedAtMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      brand: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}brand']),
      model: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model']),
      purchaseDate: $ItemsTableTable.$converterpurchaseDaten.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}purchase_date'])),
      warrantyMonths: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}warranty_months']),
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: $ItemsTableTable.$convertercreatedAt.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!),
      updatedAt: $ItemsTableTable.$converterupdatedAt.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!),
    );
  }

  @override
  $ItemsTableTable createAlias(String alias) {
    return $ItemsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $converterpurchaseDate =
      const DateTimeMillisecondsConverter();
  static TypeConverter<DateTime?, int?> $converterpurchaseDaten =
      NullAwareTypeConverter.wrap($converterpurchaseDate);
  static TypeConverter<DateTime, int> $convertercreatedAt =
      const DateTimeMillisecondsConverter();
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const DateTimeMillisecondsConverter();
}

class ItemRow extends DataClass implements Insertable<ItemRow> {
  final String id;
  final String name;
  final String category;
  final String? brand;
  final String? model;
  final DateTime? purchaseDate;
  final int? warrantyMonths;
  final String? photoPath;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ItemRow(
      {required this.id,
      required this.name,
      required this.category,
      this.brand,
      this.model,
      this.purchaseDate,
      this.warrantyMonths,
      this.photoPath,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    if (!nullToAbsent || purchaseDate != null) {
      map['purchase_date'] = Variable<int>(
          $ItemsTableTable.$converterpurchaseDaten.toSql(purchaseDate));
    }
    if (!nullToAbsent || warrantyMonths != null) {
      map['warranty_months'] = Variable<int>(warrantyMonths);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    {
      map['created_at'] =
          Variable<int>($ItemsTableTable.$convertercreatedAt.toSql(createdAt));
    }
    {
      map['updated_at'] =
          Variable<int>($ItemsTableTable.$converterupdatedAt.toSql(updatedAt));
    }
    return map;
  }

  ItemsTableCompanion toCompanion(bool nullToAbsent) {
    return ItemsTableCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      brand:
          brand == null && nullToAbsent ? const Value.absent() : Value(brand),
      model:
          model == null && nullToAbsent ? const Value.absent() : Value(model),
      purchaseDate: purchaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseDate),
      warrantyMonths: warrantyMonths == null && nullToAbsent
          ? const Value.absent()
          : Value(warrantyMonths),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ItemRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      brand: serializer.fromJson<String?>(json['brand']),
      model: serializer.fromJson<String?>(json['model']),
      purchaseDate: serializer.fromJson<DateTime?>(json['purchaseDate']),
      warrantyMonths: serializer.fromJson<int?>(json['warrantyMonths']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'brand': serializer.toJson<String?>(brand),
      'model': serializer.toJson<String?>(model),
      'purchaseDate': serializer.toJson<DateTime?>(purchaseDate),
      'warrantyMonths': serializer.toJson<int?>(warrantyMonths),
      'photoPath': serializer.toJson<String?>(photoPath),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ItemRow copyWith(
          {String? id,
          String? name,
          String? category,
          Value<String?> brand = const Value.absent(),
          Value<String?> model = const Value.absent(),
          Value<DateTime?> purchaseDate = const Value.absent(),
          Value<int?> warrantyMonths = const Value.absent(),
          Value<String?> photoPath = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ItemRow(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        brand: brand.present ? brand.value : this.brand,
        model: model.present ? model.value : this.model,
        purchaseDate:
            purchaseDate.present ? purchaseDate.value : this.purchaseDate,
        warrantyMonths:
            warrantyMonths.present ? warrantyMonths.value : this.warrantyMonths,
        photoPath: photoPath.present ? photoPath.value : this.photoPath,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ItemRow copyWithCompanion(ItemsTableCompanion data) {
    return ItemRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      brand: data.brand.present ? data.brand.value : this.brand,
      model: data.model.present ? data.model.value : this.model,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      warrantyMonths: data.warrantyMonths.present
          ? data.warrantyMonths.value
          : this.warrantyMonths,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('warrantyMonths: $warrantyMonths, ')
          ..write('photoPath: $photoPath, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, category, brand, model,
      purchaseDate, warrantyMonths, photoPath, notes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.brand == this.brand &&
          other.model == this.model &&
          other.purchaseDate == this.purchaseDate &&
          other.warrantyMonths == this.warrantyMonths &&
          other.photoPath == this.photoPath &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ItemsTableCompanion extends UpdateCompanion<ItemRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> category;
  final Value<String?> brand;
  final Value<String?> model;
  final Value<DateTime?> purchaseDate;
  final Value<int?> warrantyMonths;
  final Value<String?> photoPath;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ItemsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.brand = const Value.absent(),
    this.model = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.warrantyMonths = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemsTableCompanion.insert({
    required String id,
    required String name,
    required String category,
    this.brand = const Value.absent(),
    this.model = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.warrantyMonths = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        category = Value(category),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ItemRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? brand,
    Expression<String>? model,
    Expression<int>? purchaseDate,
    Expression<int>? warrantyMonths,
    Expression<String>? photoPath,
    Expression<String>? notes,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (brand != null) 'brand': brand,
      if (model != null) 'model': model,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (warrantyMonths != null) 'warranty_months': warrantyMonths,
      if (photoPath != null) 'photo_path': photoPath,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? category,
      Value<String?>? brand,
      Value<String?>? model,
      Value<DateTime?>? purchaseDate,
      Value<int?>? warrantyMonths,
      Value<String?>? photoPath,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ItemsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      warrantyMonths: warrantyMonths ?? this.warrantyMonths,
      photoPath: photoPath ?? this.photoPath,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<int>(
          $ItemsTableTable.$converterpurchaseDaten.toSql(purchaseDate.value));
    }
    if (warrantyMonths.present) {
      map['warranty_months'] = Variable<int>(warrantyMonths.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
          $ItemsTableTable.$convertercreatedAt.toSql(createdAt.value));
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
          $ItemsTableTable.$converterupdatedAt.toSql(updatedAt.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('warrantyMonths: $warrantyMonths, ')
          ..write('photoPath: $photoPath, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MaintenancesTableTable extends MaintenancesTable
    with TableInfo<$MaintenancesTableTable, MaintenanceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenancesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES items (id) ON DELETE CASCADE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _intervalMonthsMeta =
      const VerificationMeta('intervalMonths');
  @override
  late final GeneratedColumn<int> intervalMonths = GeneratedColumn<int>(
      'interval_months', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastDoneAtMeta =
      const VerificationMeta('lastDoneAt');
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> lastDoneAt =
      GeneratedColumn<int>('last_done_at', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<DateTime?>(
              $MaintenancesTableTable.$converterlastDoneAtn);
  static const VerificationMeta _nextDueAtMeta =
      const VerificationMeta('nextDueAt');
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> nextDueAt =
      GeneratedColumn<int>('next_due_at', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<DateTime>($MaintenancesTableTable.$converternextDueAt);
  static const VerificationMeta _notifyDaysBeforeMeta =
      const VerificationMeta('notifyDaysBefore');
  @override
  late final GeneratedColumn<int> notifyDaysBefore = GeneratedColumn<int>(
      'notify_days_before', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(7));
  static const VerificationMeta _isFromTemplateMeta =
      const VerificationMeta('isFromTemplate');
  @override
  late final GeneratedColumn<bool> isFromTemplate = GeneratedColumn<bool>(
      'is_from_template', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_from_template" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>('created_at', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<DateTime>($MaintenancesTableTable.$convertercreatedAt);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> updatedAt =
      GeneratedColumn<int>('updated_at', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<DateTime>($MaintenancesTableTable.$converterupdatedAt);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        itemId,
        name,
        description,
        intervalMonths,
        lastDoneAt,
        nextDueAt,
        notifyDaysBefore,
        isFromTemplate,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenances';
  @override
  VerificationContext validateIntegrity(Insertable<MaintenanceRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('interval_months')) {
      context.handle(
          _intervalMonthsMeta,
          intervalMonths.isAcceptableOrUnknown(
              data['interval_months']!, _intervalMonthsMeta));
    } else if (isInserting) {
      context.missing(_intervalMonthsMeta);
    }
    context.handle(_lastDoneAtMeta, const VerificationResult.success());
    context.handle(_nextDueAtMeta, const VerificationResult.success());
    if (data.containsKey('notify_days_before')) {
      context.handle(
          _notifyDaysBeforeMeta,
          notifyDaysBefore.isAcceptableOrUnknown(
              data['notify_days_before']!, _notifyDaysBeforeMeta));
    }
    if (data.containsKey('is_from_template')) {
      context.handle(
          _isFromTemplateMeta,
          isFromTemplate.isAcceptableOrUnknown(
              data['is_from_template']!, _isFromTemplateMeta));
    }
    context.handle(_createdAtMeta, const VerificationResult.success());
    context.handle(_updatedAtMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaintenanceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaintenanceRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      intervalMonths: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval_months'])!,
      lastDoneAt: $MaintenancesTableTable.$converterlastDoneAtn.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}last_done_at'])),
      nextDueAt: $MaintenancesTableTable.$converternextDueAt.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}next_due_at'])!),
      notifyDaysBefore: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}notify_days_before'])!,
      isFromTemplate: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_from_template'])!,
      createdAt: $MaintenancesTableTable.$convertercreatedAt.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!),
      updatedAt: $MaintenancesTableTable.$converterupdatedAt.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!),
    );
  }

  @override
  $MaintenancesTableTable createAlias(String alias) {
    return $MaintenancesTableTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $converterlastDoneAt =
      const DateTimeMillisecondsConverter();
  static TypeConverter<DateTime?, int?> $converterlastDoneAtn =
      NullAwareTypeConverter.wrap($converterlastDoneAt);
  static TypeConverter<DateTime, int> $converternextDueAt =
      const DateTimeMillisecondsConverter();
  static TypeConverter<DateTime, int> $convertercreatedAt =
      const DateTimeMillisecondsConverter();
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const DateTimeMillisecondsConverter();
}

class MaintenanceRow extends DataClass implements Insertable<MaintenanceRow> {
  final String id;
  final String itemId;
  final String name;
  final String? description;
  final int intervalMonths;
  final DateTime? lastDoneAt;
  final DateTime nextDueAt;
  final int notifyDaysBefore;
  final bool isFromTemplate;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MaintenanceRow(
      {required this.id,
      required this.itemId,
      required this.name,
      this.description,
      required this.intervalMonths,
      this.lastDoneAt,
      required this.nextDueAt,
      required this.notifyDaysBefore,
      required this.isFromTemplate,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['item_id'] = Variable<String>(itemId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['interval_months'] = Variable<int>(intervalMonths);
    if (!nullToAbsent || lastDoneAt != null) {
      map['last_done_at'] = Variable<int>(
          $MaintenancesTableTable.$converterlastDoneAtn.toSql(lastDoneAt));
    }
    {
      map['next_due_at'] = Variable<int>(
          $MaintenancesTableTable.$converternextDueAt.toSql(nextDueAt));
    }
    map['notify_days_before'] = Variable<int>(notifyDaysBefore);
    map['is_from_template'] = Variable<bool>(isFromTemplate);
    {
      map['created_at'] = Variable<int>(
          $MaintenancesTableTable.$convertercreatedAt.toSql(createdAt));
    }
    {
      map['updated_at'] = Variable<int>(
          $MaintenancesTableTable.$converterupdatedAt.toSql(updatedAt));
    }
    return map;
  }

  MaintenancesTableCompanion toCompanion(bool nullToAbsent) {
    return MaintenancesTableCompanion(
      id: Value(id),
      itemId: Value(itemId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      intervalMonths: Value(intervalMonths),
      lastDoneAt: lastDoneAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastDoneAt),
      nextDueAt: Value(nextDueAt),
      notifyDaysBefore: Value(notifyDaysBefore),
      isFromTemplate: Value(isFromTemplate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MaintenanceRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaintenanceRow(
      id: serializer.fromJson<String>(json['id']),
      itemId: serializer.fromJson<String>(json['itemId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      intervalMonths: serializer.fromJson<int>(json['intervalMonths']),
      lastDoneAt: serializer.fromJson<DateTime?>(json['lastDoneAt']),
      nextDueAt: serializer.fromJson<DateTime>(json['nextDueAt']),
      notifyDaysBefore: serializer.fromJson<int>(json['notifyDaysBefore']),
      isFromTemplate: serializer.fromJson<bool>(json['isFromTemplate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'itemId': serializer.toJson<String>(itemId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'intervalMonths': serializer.toJson<int>(intervalMonths),
      'lastDoneAt': serializer.toJson<DateTime?>(lastDoneAt),
      'nextDueAt': serializer.toJson<DateTime>(nextDueAt),
      'notifyDaysBefore': serializer.toJson<int>(notifyDaysBefore),
      'isFromTemplate': serializer.toJson<bool>(isFromTemplate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MaintenanceRow copyWith(
          {String? id,
          String? itemId,
          String? name,
          Value<String?> description = const Value.absent(),
          int? intervalMonths,
          Value<DateTime?> lastDoneAt = const Value.absent(),
          DateTime? nextDueAt,
          int? notifyDaysBefore,
          bool? isFromTemplate,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      MaintenanceRow(
        id: id ?? this.id,
        itemId: itemId ?? this.itemId,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        intervalMonths: intervalMonths ?? this.intervalMonths,
        lastDoneAt: lastDoneAt.present ? lastDoneAt.value : this.lastDoneAt,
        nextDueAt: nextDueAt ?? this.nextDueAt,
        notifyDaysBefore: notifyDaysBefore ?? this.notifyDaysBefore,
        isFromTemplate: isFromTemplate ?? this.isFromTemplate,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  MaintenanceRow copyWithCompanion(MaintenancesTableCompanion data) {
    return MaintenanceRow(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      intervalMonths: data.intervalMonths.present
          ? data.intervalMonths.value
          : this.intervalMonths,
      lastDoneAt:
          data.lastDoneAt.present ? data.lastDoneAt.value : this.lastDoneAt,
      nextDueAt: data.nextDueAt.present ? data.nextDueAt.value : this.nextDueAt,
      notifyDaysBefore: data.notifyDaysBefore.present
          ? data.notifyDaysBefore.value
          : this.notifyDaysBefore,
      isFromTemplate: data.isFromTemplate.present
          ? data.isFromTemplate.value
          : this.isFromTemplate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceRow(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('intervalMonths: $intervalMonths, ')
          ..write('lastDoneAt: $lastDoneAt, ')
          ..write('nextDueAt: $nextDueAt, ')
          ..write('notifyDaysBefore: $notifyDaysBefore, ')
          ..write('isFromTemplate: $isFromTemplate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      itemId,
      name,
      description,
      intervalMonths,
      lastDoneAt,
      nextDueAt,
      notifyDaysBefore,
      isFromTemplate,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenanceRow &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.name == this.name &&
          other.description == this.description &&
          other.intervalMonths == this.intervalMonths &&
          other.lastDoneAt == this.lastDoneAt &&
          other.nextDueAt == this.nextDueAt &&
          other.notifyDaysBefore == this.notifyDaysBefore &&
          other.isFromTemplate == this.isFromTemplate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MaintenancesTableCompanion extends UpdateCompanion<MaintenanceRow> {
  final Value<String> id;
  final Value<String> itemId;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> intervalMonths;
  final Value<DateTime?> lastDoneAt;
  final Value<DateTime> nextDueAt;
  final Value<int> notifyDaysBefore;
  final Value<bool> isFromTemplate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MaintenancesTableCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.intervalMonths = const Value.absent(),
    this.lastDoneAt = const Value.absent(),
    this.nextDueAt = const Value.absent(),
    this.notifyDaysBefore = const Value.absent(),
    this.isFromTemplate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MaintenancesTableCompanion.insert({
    required String id,
    required String itemId,
    required String name,
    this.description = const Value.absent(),
    required int intervalMonths,
    this.lastDoneAt = const Value.absent(),
    required DateTime nextDueAt,
    this.notifyDaysBefore = const Value.absent(),
    this.isFromTemplate = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        itemId = Value(itemId),
        name = Value(name),
        intervalMonths = Value(intervalMonths),
        nextDueAt = Value(nextDueAt),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<MaintenanceRow> custom({
    Expression<String>? id,
    Expression<String>? itemId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? intervalMonths,
    Expression<int>? lastDoneAt,
    Expression<int>? nextDueAt,
    Expression<int>? notifyDaysBefore,
    Expression<bool>? isFromTemplate,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (intervalMonths != null) 'interval_months': intervalMonths,
      if (lastDoneAt != null) 'last_done_at': lastDoneAt,
      if (nextDueAt != null) 'next_due_at': nextDueAt,
      if (notifyDaysBefore != null) 'notify_days_before': notifyDaysBefore,
      if (isFromTemplate != null) 'is_from_template': isFromTemplate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MaintenancesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? itemId,
      Value<String>? name,
      Value<String?>? description,
      Value<int>? intervalMonths,
      Value<DateTime?>? lastDoneAt,
      Value<DateTime>? nextDueAt,
      Value<int>? notifyDaysBefore,
      Value<bool>? isFromTemplate,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return MaintenancesTableCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      name: name ?? this.name,
      description: description ?? this.description,
      intervalMonths: intervalMonths ?? this.intervalMonths,
      lastDoneAt: lastDoneAt ?? this.lastDoneAt,
      nextDueAt: nextDueAt ?? this.nextDueAt,
      notifyDaysBefore: notifyDaysBefore ?? this.notifyDaysBefore,
      isFromTemplate: isFromTemplate ?? this.isFromTemplate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (intervalMonths.present) {
      map['interval_months'] = Variable<int>(intervalMonths.value);
    }
    if (lastDoneAt.present) {
      map['last_done_at'] = Variable<int>($MaintenancesTableTable
          .$converterlastDoneAtn
          .toSql(lastDoneAt.value));
    }
    if (nextDueAt.present) {
      map['next_due_at'] = Variable<int>(
          $MaintenancesTableTable.$converternextDueAt.toSql(nextDueAt.value));
    }
    if (notifyDaysBefore.present) {
      map['notify_days_before'] = Variable<int>(notifyDaysBefore.value);
    }
    if (isFromTemplate.present) {
      map['is_from_template'] = Variable<bool>(isFromTemplate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
          $MaintenancesTableTable.$convertercreatedAt.toSql(createdAt.value));
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
          $MaintenancesTableTable.$converterupdatedAt.toSql(updatedAt.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenancesTableCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('intervalMonths: $intervalMonths, ')
          ..write('lastDoneAt: $lastDoneAt, ')
          ..write('nextDueAt: $nextDueAt, ')
          ..write('notifyDaysBefore: $notifyDaysBefore, ')
          ..write('isFromTemplate: $isFromTemplate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DocumentsTableTable extends DocumentsTable
    with TableInfo<$DocumentsTableTable, DocumentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _expiryDateMeta =
      const VerificationMeta('expiryDate');
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> expiryDate =
      GeneratedColumn<int>('expiry_date', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<DateTime>($DocumentsTableTable.$converterexpiryDate);
  static const VerificationMeta _notifyDaysBeforeMeta =
      const VerificationMeta('notifyDaysBefore');
  @override
  late final GeneratedColumn<int> notifyDaysBefore = GeneratedColumn<int>(
      'notify_days_before', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(30));
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>('created_at', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<DateTime>($DocumentsTableTable.$convertercreatedAt);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> updatedAt =
      GeneratedColumn<int>('updated_at', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<DateTime>($DocumentsTableTable.$converterupdatedAt);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        type,
        expiryDate,
        notifyDaysBefore,
        photoPath,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documents';
  @override
  VerificationContext validateIntegrity(Insertable<DocumentRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    context.handle(_expiryDateMeta, const VerificationResult.success());
    if (data.containsKey('notify_days_before')) {
      context.handle(
          _notifyDaysBeforeMeta,
          notifyDaysBefore.isAcceptableOrUnknown(
              data['notify_days_before']!, _notifyDaysBeforeMeta));
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    context.handle(_createdAtMeta, const VerificationResult.success());
    context.handle(_updatedAtMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DocumentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      expiryDate: $DocumentsTableTable.$converterexpiryDate.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}expiry_date'])!),
      notifyDaysBefore: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}notify_days_before'])!,
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: $DocumentsTableTable.$convertercreatedAt.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!),
      updatedAt: $DocumentsTableTable.$converterupdatedAt.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!),
    );
  }

  @override
  $DocumentsTableTable createAlias(String alias) {
    return $DocumentsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $converterexpiryDate =
      const DateTimeMillisecondsConverter();
  static TypeConverter<DateTime, int> $convertercreatedAt =
      const DateTimeMillisecondsConverter();
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const DateTimeMillisecondsConverter();
}

class DocumentRow extends DataClass implements Insertable<DocumentRow> {
  final String id;
  final String name;
  final String type;
  final DateTime expiryDate;
  final int notifyDaysBefore;
  final String? photoPath;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DocumentRow(
      {required this.id,
      required this.name,
      required this.type,
      required this.expiryDate,
      required this.notifyDaysBefore,
      this.photoPath,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    {
      map['expiry_date'] = Variable<int>(
          $DocumentsTableTable.$converterexpiryDate.toSql(expiryDate));
    }
    map['notify_days_before'] = Variable<int>(notifyDaysBefore);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    {
      map['created_at'] = Variable<int>(
          $DocumentsTableTable.$convertercreatedAt.toSql(createdAt));
    }
    {
      map['updated_at'] = Variable<int>(
          $DocumentsTableTable.$converterupdatedAt.toSql(updatedAt));
    }
    return map;
  }

  DocumentsTableCompanion toCompanion(bool nullToAbsent) {
    return DocumentsTableCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      expiryDate: Value(expiryDate),
      notifyDaysBefore: Value(notifyDaysBefore),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DocumentRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      expiryDate: serializer.fromJson<DateTime>(json['expiryDate']),
      notifyDaysBefore: serializer.fromJson<int>(json['notifyDaysBefore']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'expiryDate': serializer.toJson<DateTime>(expiryDate),
      'notifyDaysBefore': serializer.toJson<int>(notifyDaysBefore),
      'photoPath': serializer.toJson<String?>(photoPath),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DocumentRow copyWith(
          {String? id,
          String? name,
          String? type,
          DateTime? expiryDate,
          int? notifyDaysBefore,
          Value<String?> photoPath = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      DocumentRow(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        expiryDate: expiryDate ?? this.expiryDate,
        notifyDaysBefore: notifyDaysBefore ?? this.notifyDaysBefore,
        photoPath: photoPath.present ? photoPath.value : this.photoPath,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DocumentRow copyWithCompanion(DocumentsTableCompanion data) {
    return DocumentRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      expiryDate:
          data.expiryDate.present ? data.expiryDate.value : this.expiryDate,
      notifyDaysBefore: data.notifyDaysBefore.present
          ? data.notifyDaysBefore.value
          : this.notifyDaysBefore,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('notifyDaysBefore: $notifyDaysBefore, ')
          ..write('photoPath: $photoPath, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, expiryDate, notifyDaysBefore,
      photoPath, notes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.expiryDate == this.expiryDate &&
          other.notifyDaysBefore == this.notifyDaysBefore &&
          other.photoPath == this.photoPath &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DocumentsTableCompanion extends UpdateCompanion<DocumentRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<DateTime> expiryDate;
  final Value<int> notifyDaysBefore;
  final Value<String?> photoPath;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DocumentsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.notifyDaysBefore = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentsTableCompanion.insert({
    required String id,
    required String name,
    required String type,
    required DateTime expiryDate,
    this.notifyDaysBefore = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        type = Value(type),
        expiryDate = Value(expiryDate),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<DocumentRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? expiryDate,
    Expression<int>? notifyDaysBefore,
    Expression<String>? photoPath,
    Expression<String>? notes,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (notifyDaysBefore != null) 'notify_days_before': notifyDaysBefore,
      if (photoPath != null) 'photo_path': photoPath,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? type,
      Value<DateTime>? expiryDate,
      Value<int>? notifyDaysBefore,
      Value<String?>? photoPath,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return DocumentsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      expiryDate: expiryDate ?? this.expiryDate,
      notifyDaysBefore: notifyDaysBefore ?? this.notifyDaysBefore,
      photoPath: photoPath ?? this.photoPath,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<int>(
          $DocumentsTableTable.$converterexpiryDate.toSql(expiryDate.value));
    }
    if (notifyDaysBefore.present) {
      map['notify_days_before'] = Variable<int>(notifyDaysBefore.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
          $DocumentsTableTable.$convertercreatedAt.toSql(createdAt.value));
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
          $DocumentsTableTable.$converterupdatedAt.toSql(updatedAt.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('notifyDaysBefore: $notifyDaysBefore, ')
          ..write('photoPath: $photoPath, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ItemsTableTable itemsTable = $ItemsTableTable(this);
  late final $MaintenancesTableTable maintenancesTable =
      $MaintenancesTableTable(this);
  late final $DocumentsTableTable documentsTable = $DocumentsTableTable(this);
  late final Index itemsCategoryIdx = Index('items_category_idx',
      'CREATE INDEX items_category_idx ON items (category)');
  late final Index itemsCreatedAtIdx = Index('items_created_at_idx',
      'CREATE INDEX items_created_at_idx ON items (created_at)');
  late final Index maintenancesItemIdIdx = Index('maintenances_item_id_idx',
      'CREATE INDEX maintenances_item_id_idx ON maintenances (item_id)');
  late final Index maintenancesNextDueAtIdx = Index(
      'maintenances_next_due_at_idx',
      'CREATE INDEX maintenances_next_due_at_idx ON maintenances (next_due_at)');
  late final Index documentsExpiryDateIdx = Index('documents_expiry_date_idx',
      'CREATE INDEX documents_expiry_date_idx ON documents (expiry_date)');
  late final Index documentsTypeIdx = Index('documents_type_idx',
      'CREATE INDEX documents_type_idx ON documents (type)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        itemsTable,
        maintenancesTable,
        documentsTable,
        itemsCategoryIdx,
        itemsCreatedAtIdx,
        maintenancesItemIdIdx,
        maintenancesNextDueAtIdx,
        documentsExpiryDateIdx,
        documentsTypeIdx
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('items',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('maintenances', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$ItemsTableTableCreateCompanionBuilder = ItemsTableCompanion Function({
  required String id,
  required String name,
  required String category,
  Value<String?> brand,
  Value<String?> model,
  Value<DateTime?> purchaseDate,
  Value<int?> warrantyMonths,
  Value<String?> photoPath,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ItemsTableTableUpdateCompanionBuilder = ItemsTableCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> category,
  Value<String?> brand,
  Value<String?> model,
  Value<DateTime?> purchaseDate,
  Value<int?> warrantyMonths,
  Value<String?> photoPath,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$ItemsTableTableReferences
    extends BaseReferences<_$AppDatabase, $ItemsTableTable, ItemRow> {
  $$ItemsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MaintenancesTableTable, List<MaintenanceRow>>
      _maintenancesTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.maintenancesTable,
              aliasName: $_aliasNameGenerator(
                  db.itemsTable.id, db.maintenancesTable.itemId));

  $$MaintenancesTableTableProcessedTableManager get maintenancesTableRefs {
    final manager =
        $$MaintenancesTableTableTableManager($_db, $_db.maintenancesTable)
            .filter((f) => f.itemId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_maintenancesTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ItemsTableTable> {
  $$ItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get purchaseDate =>
      $composableBuilder(
          column: $table.purchaseDate,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get warrantyMonths => $composableBuilder(
      column: $table.warrantyMonths,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
          column: $table.createdAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get updatedAt =>
      $composableBuilder(
          column: $table.updatedAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  Expression<bool> maintenancesTableRefs(
      Expression<bool> Function($$MaintenancesTableTableFilterComposer f) f) {
    final $$MaintenancesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.maintenancesTable,
        getReferencedColumn: (t) => t.itemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenancesTableTableFilterComposer(
              $db: $db,
              $table: $db.maintenancesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemsTableTable> {
  $$ItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get warrantyMonths => $composableBuilder(
      column: $table.warrantyMonths,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemsTableTable> {
  $$ItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get purchaseDate =>
      $composableBuilder(
          column: $table.purchaseDate, builder: (column) => column);

  GeneratedColumn<int> get warrantyMonths => $composableBuilder(
      column: $table.warrantyMonths, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> maintenancesTableRefs<T extends Object>(
      Expression<T> Function($$MaintenancesTableTableAnnotationComposer a) f) {
    final $$MaintenancesTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.maintenancesTable,
            getReferencedColumn: (t) => t.itemId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenancesTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.maintenancesTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ItemsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ItemsTableTable,
    ItemRow,
    $$ItemsTableTableFilterComposer,
    $$ItemsTableTableOrderingComposer,
    $$ItemsTableTableAnnotationComposer,
    $$ItemsTableTableCreateCompanionBuilder,
    $$ItemsTableTableUpdateCompanionBuilder,
    (ItemRow, $$ItemsTableTableReferences),
    ItemRow,
    PrefetchHooks Function({bool maintenancesTableRefs})> {
  $$ItemsTableTableTableManager(_$AppDatabase db, $ItemsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String?> brand = const Value.absent(),
            Value<String?> model = const Value.absent(),
            Value<DateTime?> purchaseDate = const Value.absent(),
            Value<int?> warrantyMonths = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ItemsTableCompanion(
            id: id,
            name: name,
            category: category,
            brand: brand,
            model: model,
            purchaseDate: purchaseDate,
            warrantyMonths: warrantyMonths,
            photoPath: photoPath,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String category,
            Value<String?> brand = const Value.absent(),
            Value<String?> model = const Value.absent(),
            Value<DateTime?> purchaseDate = const Value.absent(),
            Value<int?> warrantyMonths = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ItemsTableCompanion.insert(
            id: id,
            name: name,
            category: category,
            brand: brand,
            model: model,
            purchaseDate: purchaseDate,
            warrantyMonths: warrantyMonths,
            photoPath: photoPath,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ItemsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({maintenancesTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (maintenancesTableRefs) db.maintenancesTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (maintenancesTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$ItemsTableTableReferences
                            ._maintenancesTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ItemsTableTableReferences(db, table, p0)
                                .maintenancesTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.itemId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ItemsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ItemsTableTable,
    ItemRow,
    $$ItemsTableTableFilterComposer,
    $$ItemsTableTableOrderingComposer,
    $$ItemsTableTableAnnotationComposer,
    $$ItemsTableTableCreateCompanionBuilder,
    $$ItemsTableTableUpdateCompanionBuilder,
    (ItemRow, $$ItemsTableTableReferences),
    ItemRow,
    PrefetchHooks Function({bool maintenancesTableRefs})>;
typedef $$MaintenancesTableTableCreateCompanionBuilder
    = MaintenancesTableCompanion Function({
  required String id,
  required String itemId,
  required String name,
  Value<String?> description,
  required int intervalMonths,
  Value<DateTime?> lastDoneAt,
  required DateTime nextDueAt,
  Value<int> notifyDaysBefore,
  Value<bool> isFromTemplate,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$MaintenancesTableTableUpdateCompanionBuilder
    = MaintenancesTableCompanion Function({
  Value<String> id,
  Value<String> itemId,
  Value<String> name,
  Value<String?> description,
  Value<int> intervalMonths,
  Value<DateTime?> lastDoneAt,
  Value<DateTime> nextDueAt,
  Value<int> notifyDaysBefore,
  Value<bool> isFromTemplate,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$MaintenancesTableTableReferences extends BaseReferences<
    _$AppDatabase, $MaintenancesTableTable, MaintenanceRow> {
  $$MaintenancesTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ItemsTableTable _itemIdTable(_$AppDatabase db) =>
      db.itemsTable.createAlias(
          $_aliasNameGenerator(db.maintenancesTable.itemId, db.itemsTable.id));

  $$ItemsTableTableProcessedTableManager? get itemId {
    if ($_item.itemId == null) return null;
    final manager = $$ItemsTableTableTableManager($_db, $_db.itemsTable)
        .filter((f) => f.id($_item.itemId!));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MaintenancesTableTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenancesTableTable> {
  $$MaintenancesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get intervalMonths => $composableBuilder(
      column: $table.intervalMonths,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get lastDoneAt =>
      $composableBuilder(
          column: $table.lastDoneAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get nextDueAt =>
      $composableBuilder(
          column: $table.nextDueAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get notifyDaysBefore => $composableBuilder(
      column: $table.notifyDaysBefore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFromTemplate => $composableBuilder(
      column: $table.isFromTemplate,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
          column: $table.createdAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get updatedAt =>
      $composableBuilder(
          column: $table.updatedAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  $$ItemsTableTableFilterComposer get itemId {
    final $$ItemsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.itemsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableTableFilterComposer(
              $db: $db,
              $table: $db.itemsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MaintenancesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenancesTableTable> {
  $$MaintenancesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get intervalMonths => $composableBuilder(
      column: $table.intervalMonths,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastDoneAt => $composableBuilder(
      column: $table.lastDoneAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get nextDueAt => $composableBuilder(
      column: $table.nextDueAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get notifyDaysBefore => $composableBuilder(
      column: $table.notifyDaysBefore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFromTemplate => $composableBuilder(
      column: $table.isFromTemplate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$ItemsTableTableOrderingComposer get itemId {
    final $$ItemsTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.itemsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableTableOrderingComposer(
              $db: $db,
              $table: $db.itemsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MaintenancesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenancesTableTable> {
  $$MaintenancesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get intervalMonths => $composableBuilder(
      column: $table.intervalMonths, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get lastDoneAt =>
      $composableBuilder(
          column: $table.lastDoneAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get nextDueAt =>
      $composableBuilder(column: $table.nextDueAt, builder: (column) => column);

  GeneratedColumn<int> get notifyDaysBefore => $composableBuilder(
      column: $table.notifyDaysBefore, builder: (column) => column);

  GeneratedColumn<bool> get isFromTemplate => $composableBuilder(
      column: $table.isFromTemplate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ItemsTableTableAnnotationComposer get itemId {
    final $$ItemsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.itemsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.itemsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MaintenancesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MaintenancesTableTable,
    MaintenanceRow,
    $$MaintenancesTableTableFilterComposer,
    $$MaintenancesTableTableOrderingComposer,
    $$MaintenancesTableTableAnnotationComposer,
    $$MaintenancesTableTableCreateCompanionBuilder,
    $$MaintenancesTableTableUpdateCompanionBuilder,
    (MaintenanceRow, $$MaintenancesTableTableReferences),
    MaintenanceRow,
    PrefetchHooks Function({bool itemId})> {
  $$MaintenancesTableTableTableManager(
      _$AppDatabase db, $MaintenancesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenancesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaintenancesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaintenancesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> itemId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> intervalMonths = const Value.absent(),
            Value<DateTime?> lastDoneAt = const Value.absent(),
            Value<DateTime> nextDueAt = const Value.absent(),
            Value<int> notifyDaysBefore = const Value.absent(),
            Value<bool> isFromTemplate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MaintenancesTableCompanion(
            id: id,
            itemId: itemId,
            name: name,
            description: description,
            intervalMonths: intervalMonths,
            lastDoneAt: lastDoneAt,
            nextDueAt: nextDueAt,
            notifyDaysBefore: notifyDaysBefore,
            isFromTemplate: isFromTemplate,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String itemId,
            required String name,
            Value<String?> description = const Value.absent(),
            required int intervalMonths,
            Value<DateTime?> lastDoneAt = const Value.absent(),
            required DateTime nextDueAt,
            Value<int> notifyDaysBefore = const Value.absent(),
            Value<bool> isFromTemplate = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              MaintenancesTableCompanion.insert(
            id: id,
            itemId: itemId,
            name: name,
            description: description,
            intervalMonths: intervalMonths,
            lastDoneAt: lastDoneAt,
            nextDueAt: nextDueAt,
            notifyDaysBefore: notifyDaysBefore,
            isFromTemplate: isFromTemplate,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MaintenancesTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (itemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.itemId,
                    referencedTable:
                        $$MaintenancesTableTableReferences._itemIdTable(db),
                    referencedColumn:
                        $$MaintenancesTableTableReferences._itemIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MaintenancesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MaintenancesTableTable,
    MaintenanceRow,
    $$MaintenancesTableTableFilterComposer,
    $$MaintenancesTableTableOrderingComposer,
    $$MaintenancesTableTableAnnotationComposer,
    $$MaintenancesTableTableCreateCompanionBuilder,
    $$MaintenancesTableTableUpdateCompanionBuilder,
    (MaintenanceRow, $$MaintenancesTableTableReferences),
    MaintenanceRow,
    PrefetchHooks Function({bool itemId})>;
typedef $$DocumentsTableTableCreateCompanionBuilder = DocumentsTableCompanion
    Function({
  required String id,
  required String name,
  required String type,
  required DateTime expiryDate,
  Value<int> notifyDaysBefore,
  Value<String?> photoPath,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$DocumentsTableTableUpdateCompanionBuilder = DocumentsTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> type,
  Value<DateTime> expiryDate,
  Value<int> notifyDaysBefore,
  Value<String?> photoPath,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$DocumentsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentsTableTable> {
  $$DocumentsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get expiryDate =>
      $composableBuilder(
          column: $table.expiryDate,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get notifyDaysBefore => $composableBuilder(
      column: $table.notifyDaysBefore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
          column: $table.createdAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get updatedAt =>
      $composableBuilder(
          column: $table.updatedAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$DocumentsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentsTableTable> {
  $$DocumentsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get notifyDaysBefore => $composableBuilder(
      column: $table.notifyDaysBefore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$DocumentsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentsTableTable> {
  $$DocumentsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get expiryDate =>
      $composableBuilder(
          column: $table.expiryDate, builder: (column) => column);

  GeneratedColumn<int> get notifyDaysBefore => $composableBuilder(
      column: $table.notifyDaysBefore, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DocumentsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DocumentsTableTable,
    DocumentRow,
    $$DocumentsTableTableFilterComposer,
    $$DocumentsTableTableOrderingComposer,
    $$DocumentsTableTableAnnotationComposer,
    $$DocumentsTableTableCreateCompanionBuilder,
    $$DocumentsTableTableUpdateCompanionBuilder,
    (
      DocumentRow,
      BaseReferences<_$AppDatabase, $DocumentsTableTable, DocumentRow>
    ),
    DocumentRow,
    PrefetchHooks Function()> {
  $$DocumentsTableTableTableManager(
      _$AppDatabase db, $DocumentsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<DateTime> expiryDate = const Value.absent(),
            Value<int> notifyDaysBefore = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DocumentsTableCompanion(
            id: id,
            name: name,
            type: type,
            expiryDate: expiryDate,
            notifyDaysBefore: notifyDaysBefore,
            photoPath: photoPath,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String type,
            required DateTime expiryDate,
            Value<int> notifyDaysBefore = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              DocumentsTableCompanion.insert(
            id: id,
            name: name,
            type: type,
            expiryDate: expiryDate,
            notifyDaysBefore: notifyDaysBefore,
            photoPath: photoPath,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DocumentsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DocumentsTableTable,
    DocumentRow,
    $$DocumentsTableTableFilterComposer,
    $$DocumentsTableTableOrderingComposer,
    $$DocumentsTableTableAnnotationComposer,
    $$DocumentsTableTableCreateCompanionBuilder,
    $$DocumentsTableTableUpdateCompanionBuilder,
    (
      DocumentRow,
      BaseReferences<_$AppDatabase, $DocumentsTableTable, DocumentRow>
    ),
    DocumentRow,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ItemsTableTableTableManager get itemsTable =>
      $$ItemsTableTableTableManager(_db, _db.itemsTable);
  $$MaintenancesTableTableTableManager get maintenancesTable =>
      $$MaintenancesTableTableTableManager(_db, _db.maintenancesTable);
  $$DocumentsTableTableTableManager get documentsTable =>
      $$DocumentsTableTableTableManager(_db, _db.documentsTable);
}
