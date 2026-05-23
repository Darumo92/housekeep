import 'package:flutter/material.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../domain/enums/item_category.dart';

class CategoryPicker extends StatelessWidget {
  const CategoryPicker({
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onClear,
    super.key,
  });

  final ItemCategory? selectedCategory;
  final ValueChanged<ItemCategory> onCategorySelected;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          ChoiceChip(
            label: Text(l10n.itemsFilterAll),
            selected: selectedCategory == null,
            onSelected: (_) => onClear(),
          ),
          const SizedBox(width: 8),
          for (final category in ItemCategory.values) ...[
            ChoiceChip(
              avatar: Icon(category.icon, size: 18),
              label: Text(category.label(l10n)),
              selected: selectedCategory == category,
              onSelected: (_) => onCategorySelected(category),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}
