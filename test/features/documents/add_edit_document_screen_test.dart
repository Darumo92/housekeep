import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:housekeep/core/l10n/generated/app_localizations.dart';
import 'package:housekeep/core/theme/app_theme.dart';
import 'package:housekeep/data/repositories/documents_repository.dart';
import 'package:housekeep/data/repositories/repository_providers.dart';
import 'package:housekeep/domain/enums/document_type.dart';
import 'package:housekeep/domain/models/document.dart';
import 'package:housekeep/features/documents/add_edit_document_screen.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('shows the redesigned scan actions and validates name', (
    tester,
  ) async {
    final repository = _FakeDocumentsRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [documentsRepositoryProvider.overrideWithValue(repository)],
        child: const _TestApp(home: AddEditDocumentScreen()),
      ),
    );
    final l10n = _l10n(tester);

    expect(find.text(l10n.documentScan), findsOneWidget);
    expect(find.text(l10n.documentGallery), findsOneWidget);

    await _scrollUntilVisible(tester, find.byKey(_nameFieldKey));
    await tester.tap(find.text(l10n.documentSave));
    await tester.pump();

    expect(find.text(l10n.documentValidationName), findsOneWidget);
    expect(repository.saved, isEmpty);
  });

  testWidgets('loads and updates an existing document through the new form', (
    tester,
  ) async {
    final existing = _document(name: 'Original policy');
    final repository = _FakeDocumentsRepository(seed: [existing]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [documentsRepositoryProvider.overrideWithValue(repository)],
        child: const _PushScreenApp(),
      ),
    );
    await tester.tap(find.text('Open form'));
    await tester.pumpAndSettle();

    await _scrollUntilVisible(tester, find.byKey(_nameFieldKey));
    await tester.enterText(find.byKey(_nameFieldKey), 'Updated policy');
    await tester.tap(find.text(_l10n(tester).documentSave));
    await tester.pumpAndSettle();

    expect(repository.saved, hasLength(1));
    expect(repository.saved.single.id, existing.id);
    expect(repository.saved.single.name, 'Updated policy');
    expect(repository.saved.single.notifyDaysBefore, existing.notifyDaysBefore);
    expect(find.byType(AddEditDocumentScreen), findsNothing);
  });
}

const _nameFieldKey = ValueKey('document-form-name');

AppLocalizations _l10n(WidgetTester tester) {
  return AppLocalizations.of(
    tester.element(find.byType(AddEditDocumentScreen)),
  );
}

Future<void> _scrollUntilVisible(WidgetTester tester, Finder finder) async {
  for (var attempt = 0; attempt < 8; attempt++) {
    if (finder.evaluate().isNotEmpty) {
      await tester.ensureVisible(finder);
      await tester.pumpAndSettle();
      return;
    }
    await tester.drag(find.byType(ListView), const Offset(0, -250));
    await tester.pumpAndSettle();
  }
  expect(finder, findsOneWidget);
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.home});

  final Widget home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: home,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}

class _PushScreenApp extends StatelessWidget {
  const _PushScreenApp();

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: TextButton(
              onPressed: () => context.push('/documents/doc-1/edit'),
              child: const Text('Open form'),
            ),
          ),
        ),
        GoRoute(
          path: '/documents/:id/edit',
          builder: (context, state) =>
              AddEditDocumentScreen(documentId: state.pathParameters['id']),
        ),
      ],
    );
    return MaterialApp.router(
      theme: AppTheme.light(),
      routerConfig: router,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}

Document _document({required String name}) {
  final now = DateTime.now();
  return Document(
    id: 'doc-1',
    name: name,
    type: DocumentType.insuranceHome,
    expiryDate: now.add(const Duration(days: 180)),
    notifyDaysBefore: 15,
    photoPath: null,
    notes: 'Call the agent',
    createdAt: now.subtract(const Duration(days: 4)),
    updatedAt: now,
  );
}

class _FakeDocumentsRepository implements DocumentsRepository {
  _FakeDocumentsRepository({List<Document> seed = const []})
    : _documents = seed;

  final List<Document> _documents;
  final List<Document> saved = [];

  @override
  Future<int> countDocuments() async => _documents.length;

  @override
  Future<int> deleteDocument(String id) async => 1;

  @override
  Future<Document?> getDocument(String id) async {
    for (final document in _documents) {
      if (document.id == id) return document;
    }
    return null;
  }

  @override
  Future<void> saveDocument(Document document) async {
    saved.add(document);
  }

  @override
  Stream<List<Document>> watchDocuments() => Stream.value(_documents);

  @override
  Stream<List<Document>> watchDocumentsByType(DocumentType type) =>
      Stream.value(
        _documents.where((document) => document.type == type).toList(),
      );

  @override
  Stream<List<Document>> watchExpiringDocuments({int limit = 15}) =>
      Stream.value(_documents.take(limit).toList());
}
