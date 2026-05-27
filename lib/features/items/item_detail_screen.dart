import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/utils/date_calculations.dart';
import '../../core/utils/haptics.dart';
import '../../data/repositories/repository_providers.dart';
import '../../data/services/notification_providers.dart';
import '../../data/services/notification_strings.dart';
import '../../domain/models/item.dart';
import '../../domain/models/maintenance.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/hk_button.dart';
import '../../shared/widgets/hk_card.dart';
import '../../shared/widgets/hk_category_tile.dart';
import '../../shared/widgets/hk_photo_slot.dart';
import '../../shared/widgets/hk_status_pill.dart';
import '../maintenance/maintenances_provider.dart';
import 'items_provider.dart';

class ItemDetailScreen extends ConsumerWidget {
  const ItemDetailScreen({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(itemByIdProvider(itemId));

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: itemAsync.when(
        data: (item) {
          if (item == null) {
            return SafeArea(
              child: Column(
                children: [
                  _HeaderBar(onBack: () => context.pop(), onMore: null),
                  const Expanded(child: ErrorState()),
                ],
              ),
            );
          }
          return _ItemDetailBody(item: item);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => SafeArea(
          child: Column(
            children: [
              _HeaderBar(onBack: () => context.pop(), onMore: null),
              Expanded(
                child: ErrorState(
                  onRetry: () => ref.invalidate(itemByIdProvider(itemId)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemDetailBody extends ConsumerWidget {
  const _ItemDetailBody({required this.item});

  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final maintenancesAsync = ref.watch(maintenancesForItemProvider(item.id));
    final deleteState = ref.watch(deleteItemProvider);
    final isDeleting = deleteState.isLoading;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _HeroBlock(item: item)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(22, 32, 22, 100),
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed([
              Text(
                item.name,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontSize: 24,
                  color: AppColors.text,
                ),
              ),
              if (_brandModel(item).isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  _brandModel(item),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              if (item.warrantyExpiryDate != null) ...[
                _WarrantyCard(item: item),
                const SizedBox(height: 24),
              ],
              _SectionHeader(
                title: l10n.itemMaintenanceSectionTitle,
                actionLabel: l10n.itemMaintenanceAdd,
                onAction: () =>
                    context.push('/items/${item.id}/maintenance/add'),
              ),
              const SizedBox(height: 10),
              _MaintenancesList(
                itemId: item.id,
                maintenancesAsync: maintenancesAsync,
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: HkButton(
                      label: l10n.itemEdit,
                      icon: Symbols.edit_rounded,
                      variant: HkButtonVariant.soft,
                      size: HkButtonSize.md,
                      onPressed: () =>
                          context.push('/items/${item.id}/edit'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: HkButton(
                      label: l10n.itemDelete,
                      icon: Symbols.delete_outline_rounded,
                      variant: HkButtonVariant.outline,
                      size: HkButtonSize.md,
                      onPressed: isDeleting
                          ? null
                          : () => _deleteItem(context, ref, item),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ],
    );
  }

  static String _brandModel(Item item) => [
        if (item.brand != null && item.brand!.isNotEmpty) item.brand!,
        if (item.model != null && item.model!.isNotEmpty) item.model!,
      ].join(' ');

  Future<void> _deleteItem(
    BuildContext context,
    WidgetRef ref,
    Item item,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmDialog(
      context: context,
      title: l10n.itemDeleteTitle,
      body: l10n.itemDeleteBody,
      confirmLabel: l10n.itemDeleteConfirm,
    );
    if (!confirmed || ref.read(deleteItemProvider).isLoading) return;
    if (!context.mounted) return;

    AppHaptics.destructive();
    final messenger = ScaffoldMessenger.of(context);
    final maintenancesRepo = ref.read(maintenancesRepositoryProvider);
    final maintenances =
        await maintenancesRepo.watchMaintenancesForItem(item.id).first;
    await ref.read(notificationSchedulerProvider).cancelAllForItem(
          itemId: item.id,
          maintenanceIds: maintenances.map((m) => m.id),
        );

    try {
      await maintenancesRepo.deleteMaintenancesForItem(item.id);
      await ref.read(deleteItemProvider.notifier).delete(item.id);
      if (context.mounted) context.pop();
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.itemDeletedSuccess)),
      );
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.itemDeleteFailed)),
      );
    }
  }
}

class _HeroBlock extends StatelessWidget {
  const _HeroBlock({required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: _HeroPhoto(photoPath: item.photoPath)),
          Positioned(
            top: 14 + MediaQuery.paddingOf(context).top,
            left: 14,
            child: _CircleIconButton(
              icon: Symbols.arrow_back_rounded,
              onTap: () => Navigator.of(context).maybePop(),
            ),
          ),
          Positioned(
            top: 14 + MediaQuery.paddingOf(context).top,
            right: 14,
            child: const _CircleIconButton(
              icon: Symbols.more_horiz_rounded,
              onTap: null,
            ),
          ),
          Positioned(
            left: 18,
            bottom: -22,
            child: Hero(
              tag: 'item-${item.id}',
              child: HkCategoryTile(category: item.category, size: 64),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPhoto extends StatelessWidget {
  const _HeroPhoto({required this.photoPath});

  final String? photoPath;

  @override
  Widget build(BuildContext context) {
    if (photoPath != null) {
      return Image.file(File(photoPath!), fit: BoxFit.cover);
    }
    return const HkPhotoSlot(label: 'appliance photo', height: 220, radius: 0);
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Material(
          color: Colors.white.withValues(alpha: 0.92),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(icon, size: 20, color: AppColors.text),
            ),
          ),
        ),
      ),
    );
  }
}

class _WarrantyCard extends StatelessWidget {
  const _WarrantyCard({required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final purchase = item.purchaseDate;
    final months = item.warrantyMonths;
    final expiry = item.warrantyExpiryDate!;
    final dateFmt = DateFormat('yyyy-MM-dd');
    final active = item.isWarrantyActive();

    double progress = 0;
    if (purchase != null && months != null && months > 0) {
      final total = DateCalculations.addMonths(purchase, months)
          .difference(purchase)
          .inDays;
      final elapsed = DateTime.now().difference(purchase).inDays;
      progress = total == 0 ? 1 : (elapsed / total).clamp(0.0, 1.0);
    }

    return HkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.itemDetailWarranty.toUpperCase(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      months == null
                          ? '—'
                          : l10n.itemDetailMonthsWarranty(months),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (purchase != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        l10n.itemDetailPurchasedOn(dateFmt.format(purchase)),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  HkStatusPill(
                    status: active ? HkStatus.ok : HkStatus.overdue,
                    label: active
                        ? l10n.itemsWarrantyActive.toUpperCase()
                        : 'EXPIRED',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '→ ${dateFmt.format(expiry)}',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11.5,
                      color: AppColors.textFaint,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: Stack(
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(fontSize: 17),
          ),
        ),
        TextButton.icon(
          onPressed: onAction,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            minimumSize: const Size(0, 36),
          ),
          icon: const Icon(Symbols.add_rounded, size: 16),
          label: Text(
            actionLabel,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _MaintenancesList extends ConsumerWidget {
  const _MaintenancesList({
    required this.itemId,
    required this.maintenancesAsync,
  });

  final String itemId;
  final AsyncValue<List<Maintenance>> maintenancesAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return maintenancesAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const ErrorState(compact: true),
      data: (maintenances) {
        if (maintenances.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              l10n.itemMaintenanceSectionEmpty,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
              ),
            ),
          );
        }
        return Column(
          children: [
            for (final m in maintenances)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _MaintenanceRow(
                  maintenance: m,
                  onTap: () => context.push(
                    '/items/$itemId/maintenance/${m.id}/edit',
                  ),
                  onMarkDone: () => _markDone(context, ref, m),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _markDone(
    BuildContext context,
    WidgetRef ref,
    Maintenance maintenance,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final texts = NotificationTexts.fromL10n(l10n);
    try {
      await ref
          .read(maintenancesRepositoryProvider)
          .markAsDone(maintenance.id);
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.maintenanceMarkDoneFailed)),
      );
      return;
    }
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.maintenanceMarkDoneSuccess)),
    );
    final updated = await ref
        .read(maintenancesRepositoryProvider)
        .getMaintenance(maintenance.id);
    if (updated == null) return;
    final item = await ref
        .read(itemsRepositoryProvider)
        .getItem(updated.itemId);
    if (item == null) return;
    final isPro = await ref.read(isProProvider.future);
    await ref.read(notificationSchedulerProvider).rescheduleMaintenance(
          maintenance: updated,
          item: item,
          isPro: isPro,
          texts: texts,
        );
  }
}

class _MaintenanceRow extends StatelessWidget {
  const _MaintenanceRow({
    required this.maintenance,
    required this.onTap,
    required this.onMarkDone,
  });

  final Maintenance maintenance;
  final VoidCallback onTap;
  final VoidCallback onMarkDone;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final days = DateCalculations.calendarDaysUntil(
      maintenance.nextDueAt,
      DateTime.now(),
    );
    final pillStatus = days < 0
        ? HkStatus.overdue
        : days <= 3
            ? HkStatus.due
            : days <= 14
                ? HkStatus.soon
                : HkStatus.ok;
    final daysLabel = days == 0
        ? 'hoy'
        : days == 1
            ? 'mañana'
            : days > 0
                ? 'en ${days}d'
                : days == -1
                    ? 'ayer'
                    : 'hace ${-days}d';

    return HkCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(AppRadii.card * 0.4),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Symbols.calendar_today_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      maintenance.name,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'cada ${maintenance.intervalMonths} meses',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              HkStatusPill(status: pillStatus, label: daysLabel),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: HkButton(
              label: l10n.maintenanceMarkDone,
              icon: Symbols.check_rounded,
              variant: HkButtonVariant.soft,
              size: HkButtonSize.sm,
              onPressed: onMarkDone,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderBar extends StatelessWidget {
  const _HeaderBar({required this.onBack, required this.onMore});

  final VoidCallback? onBack;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
      child: Row(
        children: [
          _CircleIconButton(
            icon: Symbols.arrow_back_rounded,
            onTap: onBack,
          ),
          const Spacer(),
          _CircleIconButton(
            icon: Symbols.more_horiz_rounded,
            onTap: onMore,
          ),
        ],
      ),
    );
  }
}
