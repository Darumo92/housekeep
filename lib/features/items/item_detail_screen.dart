import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/utils/haptics.dart';
import '../../data/repositories/repository_providers.dart';
import '../../data/services/notification_providers.dart';
import '../../data/services/notification_strings.dart';
import '../../domain/models/item.dart';
import '../../domain/models/maintenance.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/error_state.dart';
import '../maintenance/maintenances_provider.dart';
import '../maintenance/widgets/maintenance_card.dart';
import 'items_provider.dart';
import 'widgets/warranty_badge.dart';

class ItemDetailScreen extends ConsumerWidget {
  const ItemDetailScreen({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final itemAsync = ref.watch(itemByIdProvider(itemId));
    final deleteState = ref.watch(deleteItemProvider);
    final isDeleting = deleteState.isLoading;

    return itemAsync.when(
      data: (item) {
        if (item == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.itemDetailTitle)),
            body: const ErrorState(),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(item.name),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(Spacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'item-photo-${item.id}',
                  child: _ItemHeroPhoto(photoPath: item.photoPath),
                ),
                const SizedBox(height: Spacing.l),
                Wrap(
                  spacing: Spacing.s,
                  runSpacing: Spacing.s,
                  children: [WarrantyBadge(item: item)],
                ),
                const SizedBox(height: Spacing.l),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () =>
                            context.push('/items/${item.id}/edit'),
                        child: Text(l10n.itemEdit),
                      ),
                    ),
                    const SizedBox(width: Spacing.m),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isDeleting
                            ? null
                            : () => _deleteItem(context, ref, item),
                        child: Text(l10n.itemDelete),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.xl),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.itemMaintenanceSectionTitle,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () =>
                          context.push('/items/${item.id}/maintenance/add'),
                      icon: const Icon(Icons.add),
                      label: Text(l10n.itemMaintenanceAdd),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.s),
                _MaintenanceSection(itemId: item.id),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(title: Text(l10n.itemDetailTitle)),
        body: ErrorState(
          onRetry: () => ref.invalidate(itemByIdProvider(itemId)),
        ),
      ),
      loading: () => Scaffold(
        appBar: AppBar(title: Text(l10n.itemDetailTitle)),
        body: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

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
    final maintenances = await maintenancesRepo
        .watchMaintenancesForItem(item.id)
        .first;
    await ref
        .read(notificationSchedulerProvider)
        .cancelAllForItem(
          itemId: item.id,
          maintenanceIds: maintenances.map((m) => m.id),
        );

    try {
      // Explicit cascade so Drift's stream tracker re-emits maintenance
      // queries instead of relying on SQLite's silent ON DELETE CASCADE.
      await maintenancesRepo.deleteMaintenancesForItem(item.id);
      await ref.read(deleteItemProvider.notifier).delete(item.id);
      if (context.mounted) {
        context.pop();
      }
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.itemDeletedSuccess)),
      );
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.itemDeleteFailed)),
      );
    }
  }
}

class _ItemHeroPhoto extends StatelessWidget {
  const _ItemHeroPhoto({required this.photoPath});

  final String? photoPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final image = photoPath == null
        ? Icon(
            Icons.image_outlined,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant,
          )
        : Image.file(File(photoPath!), fit: BoxFit.cover);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = (width * 9 / 16).clamp(160.0, 240.0);
        return SizedBox(
          width: width,
          height: height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Radii.lg),
            child: ColoredBox(
              color: theme.colorScheme.surfaceContainerHigh,
              child: Center(child: image),
            ),
          ),
        );
      },
    );
  }
}

class _MaintenanceSection extends ConsumerWidget {
  const _MaintenanceSection({required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final maintenancesAsync = ref.watch(maintenancesForItemProvider(itemId));

    return maintenancesAsync.when(
      data: (maintenances) {
        if (maintenances.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(l10n.itemMaintenanceSectionEmpty),
          );
        }
        return Column(
          children: [
            for (final maintenance in maintenances)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: MaintenanceCard(
                  maintenance: maintenance,
                  onTap: () => context.push(
                    '/items/$itemId/maintenance/${maintenance.id}/edit',
                  ),
                  onMarkDone: () => _markDone(context, ref, maintenance),
                  onDelete: () => _delete(context, ref, maintenance),
                ),
              ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: Spacing.m),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => const ErrorState(compact: true),
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
    await _rescheduleAfterMarkDone(ref, maintenance.id, texts);
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    Maintenance maintenance,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showConfirmDialog(
      context: context,
      title: l10n.maintenanceDeleteTitle,
      body: l10n.maintenanceDeleteBody,
      confirmLabel: l10n.maintenanceDeleteConfirm,
    );
    if (!confirmed) return;

    await ref
        .read(notificationSchedulerProvider)
        .cancelMaintenance(maintenance.id);

    try {
      await ref
          .read(deleteMaintenanceProvider.notifier)
          .delete(maintenance.id);
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.maintenanceDeletedSuccess)),
      );
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.maintenanceDeleteFailed)),
      );
    }
  }
}

Future<void> _rescheduleAfterMarkDone(
  WidgetRef ref,
  String maintenanceId,
  NotificationTexts texts,
) async {
  final updated = await ref
      .read(maintenancesRepositoryProvider)
      .getMaintenance(maintenanceId);
  if (updated == null) return;
  final item = await ref
      .read(itemsRepositoryProvider)
      .getItem(updated.itemId);
  if (item == null) return;
  final isPro = await ref.read(isProProvider.future);
  await ref
      .read(notificationSchedulerProvider)
      .rescheduleMaintenance(
        maintenance: updated,
        item: item,
        isPro: isPro,
        texts: texts,
      );
}

