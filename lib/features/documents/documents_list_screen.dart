import 'package:flutter/material.dart';

import '../../core/l10n/generated/app_localizations.dart';

class DocumentsListScreen extends StatelessWidget {
  const DocumentsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(child: Text(l10n.phaseZeroMessage));
  }
}
