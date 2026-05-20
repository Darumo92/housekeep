import 'package:flutter/material.dart';

import '../../core/l10n/generated/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(child: Text(l10n.phaseZeroMessage));
  }
}
