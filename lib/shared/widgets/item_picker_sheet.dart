import 'package:flutter/material.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../domain/models/item.dart';

Future<String?> showItemPickerSheet(
  BuildContext context, {
  required List<Item> items,
  required String title,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      final l10n = AppLocalizations.of(sheetContext);
      final theme = Theme.of(sheetContext);
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                alignment: Alignment.center,
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.4,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(title, style: theme.textTheme.titleMedium),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          item.category.icon,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      title: Text(item.name),
                      subtitle: Text(item.category.label(l10n)),
                      onTap: () =>
                          Navigator.of(sheetContext).pop(item.id),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
