import 'package:flutter/material.dart';

import '../../core/l10n/generated/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.homeTitle, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 12),
                Text(l10n.phaseZeroMessage),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
