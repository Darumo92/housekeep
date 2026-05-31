import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../core/constants/app_constants.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_calculations.dart';
import '../../data/repositories/repository_providers.dart' show isProProvider;
import '../../domain/enums/item_category.dart';
import '../../domain/enums/urgency_level.dart';
import '../../domain/models/item.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/hk_button.dart';
import '../../shared/widgets/hk_card.dart';
import '../../shared/widgets/hk_category_tile.dart';
import '../../shared/widgets/hk_chip.dart';
import '../../shared/widgets/hk_fab.dart';
import '../../shared/widgets/hk_status_pill.dart';
import 'items_provider.dart';

class ItemsListScreen extends ConsumerStatefulWidget {
  const ItemsListScreen({super.key});

  @override
  ConsumerState<ItemsListScreen> createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends ConsumerState<ItemsListScreen> {
  bool _navigatingToAdd = false;

  static const _filterCategories = ItemCategory.values;

  Future<void> _navigateToAdd() async {
    if (_navigatingToAdd) return;
    setState(() => _navigatingToAdd = true);
    try {
      final destination = await ref.read(addItemDestinationProvider.future);
      if (!mounted) return;
      context.push(destination);
    } finally {
      if (mounted) setState(() => _navigatingToAdd = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(selectedItemCategoryProvider);
    final itemsAsync = ref.watch(filteredItemsProvider);
    final isPro = ref.watch(isProProvider).valueOrNull ?? false;

    return Scaffold(
      backgroundColor: AppColors.bg,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24, right: 4),
        child: HkFab(
          icon: Symbols.add_rounded,
          onPressed: _navigatingToAdd ? null : _navigateToAdd,
          tooltip: l10n.itemsEmptyCta,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(
            isPro: isPro,
            count: itemsAsync.valueOrNull?.length ?? 0,
          ),
          const SizedBox(height: 14),
          _FilterChips(
            selected: selected,
            categories: _filterCategories,
            onTap: (cat) {
              final notifier = ref.read(selectedItemCategoryProvider.notifier);
              if (cat == null) {
                notifier.clear();
              } else {
                notifier.select(cat);
              }
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: itemsAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  if (selected != null) {
                    return _FilteredEmpty(
                      onClear: () =>
                          ref.read(selectedItemCategoryProvider.notifier).clear(),
                    );
                  }
                  return _EmptyItems(onAdd: _navigateToAdd);
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 100),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final item = items[i];
                    return _ItemCard(
                      key: ValueKey('item-card-${item.id}'),
                      item: item,
                      onTap: () => context.push('/items/${item.id}'),
                    );
                  },
                );
              },
              error: (_, __) => ErrorState(
                onRetry: () => ref.invalidate(filteredItemsProvider),
              ),
              loading: () => const _ItemsSkeleton(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.isPro, required this.count});

  final bool isPro;
  final int count;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final counterText = isPro
        ? l10n.itemsCount(count)
        : l10n.itemsCountFree(count.clamp(0, AppConstants.freeItemsLimit));
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              l10n.itemsTitle,
              style: theme.textTheme.displaySmall?.copyWith(
                color: AppColors.text,
              ),
            ),
          ),
          Text(
            counterText,
            style: isPro
                ? const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  )
                : GoogleFonts.jetBrainsMono(
                    fontSize: 13,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.selected,
    required this.categories,
    required this.onTap,
  });

  final ItemCategory? selected;
  final List<ItemCategory> categories;
  final ValueChanged<ItemCategory?> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        children: [
          HkChip(
            label: l10n.itemsFilterAll,
            active: selected == null,
            onTap: () => onTap(null),
          ),
          for (final cat in categories) ...[
            const SizedBox(width: 7),
            HkChip(
              label: cat.label(l10n),
              active: selected == cat,
              onTap: () => onTap(cat),
            ),
          ],
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    required this.item,
    required this.onTap,
    super.key,
  });

  final Item item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final brandModel = [
      if (item.brand != null && item.brand!.isNotEmpty) item.brand!,
      if (item.model != null && item.model!.isNotEmpty) item.model!,
    ].join(' ');
    final warrantyExpiry = item.warrantyExpiryDate;
    final warrantyActive = item.isWarrantyActive();

    return HkCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Hero(
            tag: 'item-${item.id}',
            child: HkCategoryTile(category: item.category, size: 60),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.name,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (brandModel.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    brandModel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (warrantyExpiry != null) ...[
                  const SizedBox(height: 8),
                  _WarrantyRow(
                    expiry: warrantyExpiry,
                    active: warrantyActive,
                    label: l10n.itemsWarrantyActive,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Symbols.chevron_right_rounded,
            size: 18,
            color: AppColors.textFaint,
          ),
        ],
      ),
    );
  }
}

class _WarrantyRow extends StatelessWidget {
  const _WarrantyRow({
    required this.expiry,
    required this.active,
    required this.label,
  });

  final DateTime expiry;
  final bool active;
  final String label;

  @override
  Widget build(BuildContext context) {
    final days = DateCalculations.calendarDaysUntil(expiry, DateTime.now());
    final urgency = UrgencyLevel.forDocumentExpiryDate(expiry);
    final pillStatus = switch (urgency) {
      UrgencyLevel.overdue => HkStatus.overdue,
      UrgencyLevel.urgent => HkStatus.due,
      UrgencyLevel.upcoming => HkStatus.soon,
      UrgencyLevel.ok => HkStatus.ok,
    };
    final l10n = AppLocalizations.of(context);
    final daysLabel = days >= 0
        ? l10n.itemsWarrantyExpiryInDays(days)
        : l10n.itemsWarrantyExpiryDaysAgo(-days);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        HkStatusPill(status: pillStatus, label: daysLabel),
        const SizedBox(width: 8),
        if (active)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Symbols.lock_outline_rounded,
                size: 11,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _EmptyItems extends StatelessWidget {
  const _EmptyItems({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 100),
      children: [
        HkCard(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.primarySoft,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Symbols.inventory_2_rounded,
                  size: 36,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                l10n.itemsEmptyTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.itemsEmptyBody,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                  height: 1.45,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              HkButton(
                label: l10n.itemsEmptyCta,
                icon: Symbols.add_rounded,
                size: HkButtonSize.md,
                onPressed: onAdd,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FilteredEmpty extends StatelessWidget {
  const _FilteredEmpty({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 100),
      children: [
        HkCard(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            children: [
              Text(
                l10n.itemsFilteredEmptyTitle,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                l10n.itemsFilteredEmptyBody,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              HkButton(
                label: l10n.itemsClearFilter,
                variant: HkButtonVariant.soft,
                size: HkButtonSize.sm,
                onPressed: onClear,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ItemsSkeleton extends StatelessWidget {
  const _ItemsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 100),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) => Container(
        height: 92,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
