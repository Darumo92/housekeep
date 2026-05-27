import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:housekeep/app.dart';
import 'package:housekeep/core/l10n/generated/app_localizations.dart';
import 'package:housekeep/data/repositories/documents_repository.dart';
import 'package:housekeep/data/repositories/repository_providers.dart';
import 'package:housekeep/domain/enums/document_type.dart';
import 'package:housekeep/domain/models/document.dart';
import 'package:housekeep/features/documents/add_edit_document_screen.dart';
import 'package:housekeep/features/paywall/paywall_screen.dart';
import 'package:housekeep/shared/widgets/hk_card.dart';
import 'package:housekeep/shared/widgets/hk_fab.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('groups documents by expiry and preserves chronological order', (
    tester,
  ) async {
    final documents = [
      _document('current', 'Home insurance', 180),
      _document('soon-later', 'Passport', 55),
      _document('expired', 'Old ID', -4),
      _document('soon-first', 'Vehicle inspection', 9),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          documentsRepositoryProvider.overrideWithValue(
            _FakeDocumentsRepository(documents),
          ),
        ],
        child: const HouseKeepApp(initialLocation: '/documents'),
      ),
    );
    await tester.pumpAndSettle();
    final l10n = _l10n(tester);

    expect(find.text(l10n.documentsCountFree(4)), findsOneWidget);
    expect(
      find.text(l10n.documentsSectionExpired.toUpperCase()),
      findsOneWidget,
    );
    expect(find.text(l10n.documentsSectionSoon.toUpperCase()), findsOneWidget);
    expect(
      find.text(l10n.documentsSectionCurrent.toUpperCase()),
      findsOneWidget,
    );
    expect(find.byType(HkCard), findsNWidgets(4));
    expect(
      tester.getTopLeft(find.text('Vehicle inspection')).dy,
      lessThan(tester.getTopLeft(find.text('Passport')).dy),
    );
  });

  testWidgets('opens the edit form when a document card is tapped', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          documentsRepositoryProvider.overrideWithValue(
            _FakeDocumentsRepository([_document('passport', 'Passport', 9)]),
          ),
        ],
        child: const HouseKeepApp(initialLocation: '/documents'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('document-card-passport')));
    await tester.pumpAndSettle();

    expect(find.byType(AddEditDocumentScreen), findsOneWidget);
  });

  testWidgets('routes to paywall when the free document limit is reached', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          documentsRepositoryProvider.overrideWithValue(
            const _FakeDocumentsRepository([]),
          ),
          canAddDocumentProvider.overrideWith((ref) async => false),
        ],
        child: const HouseKeepApp(initialLocation: '/documents'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(HkFab));
    await tester.pumpAndSettle();

    expect(find.byType(PaywallScreen), findsOneWidget);
  });
}

AppLocalizations _l10n(WidgetTester tester) {
  return AppLocalizations.of(tester.element(find.byType(Scaffold).last));
}

Document _document(String id, String name, int expiryDays) {
  final now = DateTime.now();
  return Document(
    id: id,
    name: name,
    type: DocumentType.other,
    expiryDate: DateTime(
      now.year,
      now.month,
      now.day,
    ).add(Duration(days: expiryDays)),
    notifyDaysBefore: 30,
    photoPath: null,
    notes: null,
    createdAt: now,
    updatedAt: now,
  );
}

class _FakeDocumentsRepository implements DocumentsRepository {
  const _FakeDocumentsRepository(this.documents);

  final List<Document> documents;

  @override
  Future<int> countDocuments() async => documents.length;

  @override
  Future<int> deleteDocument(String id) async => 1;

  @override
  Future<Document?> getDocument(String id) async {
    for (final document in documents) {
      if (document.id == id) return document;
    }
    return null;
  }

  @override
  Future<void> saveDocument(Document document) async {}

  @override
  Stream<List<Document>> watchDocuments() => Stream.value(documents);

  @override
  Stream<List<Document>> watchDocumentsByType(DocumentType type) =>
      Stream.value(
        documents.where((document) => document.type == type).toList(),
      );

  @override
  Stream<List<Document>> watchExpiringDocuments({int limit = 15}) =>
      Stream.value(documents.take(limit).toList());
}
