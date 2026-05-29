import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:housekeep/core/l10n/generated/app_localizations.dart';
import 'package:housekeep/core/theme/app_theme.dart';
import 'package:housekeep/domain/enums/document_type.dart';
import 'package:housekeep/domain/enums/urgency_level.dart';
import 'package:housekeep/domain/models/upcoming_event.dart';
import 'package:housekeep/features/home/widgets/home_redesign_widgets.dart';

void main() {
  testWidgets('TimelineRow uses the document type icon', (tester) async {
    await tester.pumpWidget(
      _TestApp(
        child: TimelineRow(
          event: UpcomingEvent(
            id: 'document-1',
            title: 'Seguro del hogar',
            subtitle: '',
            dueDate: DateTime.now().add(const Duration(days: 5)),
            urgency: UrgencyLevel.urgent,
            type: UpcomingEventType.document,
            relatedItemId: 'doc-1',
            documentType: DocumentType.insuranceHome,
          ),
          onTap: () {},
        ),
      ),
    );

    expect(find.byIcon(DocumentType.insuranceHome.icon), findsOneWidget);
    expect(find.byIcon(Icons.description_rounded), findsNothing);
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(body: Center(child: child)),
    );
  }
}
