import 'package:flutter/material.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../domain/enums/item_category.dart';

class CategoryPicker extends StatefulWidget {
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
  State<CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<CategoryPicker> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          ChoiceChip(
            label: Text(l10n.itemsFilterAll),
            selected: widget.selectedCategory == null,
            onSelected: (_) => widget.onClear(),
          ),
          const SizedBox(width: 8),
          for (final category in ItemCategory.values) ...[
            ChoiceChip(
              avatar: Icon(category.icon, size: 18),
              label: Text(category.label(l10n)),
              selected: widget.selectedCategory == category,
              onSelected: (_) => widget.onCategorySelected(category),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}
