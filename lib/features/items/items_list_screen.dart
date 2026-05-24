import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../domain/enums/item_category.dart';
import '../../shared/widgets/empty_state.dart';
import 'items_provider.dart';
import 'widgets/category_picker.dart';
import 'widgets/item_card.dart';

class ItemsListScreen extends ConsumerStatefulWidget {
  const ItemsListScreen({super.key});

  @override
  ConsumerState<ItemsListScreen> createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends ConsumerState<ItemsListScreen> {
  bool _isNavigatingToAdd = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selectedCategory = ref.watch(selectedItemCategoryProvider);
    final itemsAsync = ref.watch(filteredItemsProvider);

    Future<void> navigateToAdd() async {
      if (_isNavigatingToAdd) return;

      setState(() {
        _isNavigatingToAdd = true;
      });

      try {
        final destination = await ref.read(addItemDestinationProvider.future);
        if (!context.mounted) return;

        context.push(destination);
      } finally {
        if (mounted) {
          setState(() {
            _isNavigatingToAdd = false;
          });
        }
      }
    }

    void selectCategory(ItemCategory category) {
      ref.read(selectedItemCategoryProvider.notifier).select(category);
    }

    void clearCategory() {
      ref.read(selectedItemCategoryProvider.notifier).clear();
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isNavigatingToAdd ? null : navigateToAdd,
        icon: const Icon(Icons.add),
        label: Text(l10n.itemsEmptyCta),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          CategoryPicker(
            selectedCategory: selectedCategory,
            onCategorySelected: selectCategory,
            onClear: clearCategory,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: itemsAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  if (selectedCategory != null) {
                    return EmptyState(
                      icon: selectedCategory.icon,
                      title: l10n.itemsFilteredEmptyTitle,
                      body: l10n.itemsFilteredEmptyBody,
                      actionLabel: l10n.itemsClearFilter,
                      onAction: clearCategory,
                    );
                  }

                  return EmptyState(
                    icon: Icons.kitchen_rounded,
                    title: l10n.itemsEmptyTitle,
                    body: l10n.itemsEmptyBody,
                    actionLabel: l10n.itemsEmptyCta,
                    onAction: navigateToAdd,
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) => ItemCard(
                    item: items[index],
                    onTap: () =>
                        context.push('/items/${items[index].id}'),
                  ),
                );
              },
              error: (error, stackTrace) =>
                  Center(child: Text(error.toString())),
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
