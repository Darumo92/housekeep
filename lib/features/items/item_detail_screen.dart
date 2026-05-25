import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../data/repositories/repository_providers.dart';
import '../../data/services/notification_providers.dart';
import '../../data/services/notification_strings.dart';
import '../../domain/models/item.dart';
import '../../domain/models/maintenance.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../maintenance/maintenances_provider.dart';
import '../maintenance/widgets/maintenance_card.dart';
import 'items_provider.dart';

class ItemDetailScreen extends ConsumerWidget {
  const ItemDetailScreen({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final itemAsync = ref.watch(itemByIdProvider(itemId));
    final deleteState = ref.watch(deleteItemProvider);
    final isDeleting = deleteState.isLoading;

    return itemAsync.when(
      data: (item) {
        if (item == null) {
          return Center(child: Text(l10n.itemDetailTitle));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ItemPhoto(photoPath: item.photoPath),
              const SizedBox(height: 16),
              Text(item.name, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [_WarrantyBadge(item: item)],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () => context.push('/items/${item.id}/edit'),
                      child: Text(l10n.itemEdit),
                    ),
                  ),
                  const SizedBox(width: 12),
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
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.itemMaintenanceSectionTitle,
                      style: Theme.of(context).textTheme.titleMedium,
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
              const SizedBox(height: 8),
              _MaintenanceSection(itemId: item.id),
            ],
          ),
        );
      },
      error: (error, stackTrace) => Center(child: Text(error.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
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

    final maintenances = await ref
        .read(maintenancesRepositoryProvider)
        .watchMaintenancesForItem(item.id)
        .first;
    await ref
        .read(notificationSchedulerProvider)
        .cancelAllForItem(
          itemId: item.id,
          maintenanceIds: maintenances.map((m) => m.id),
        );

    try {
      await ref.read(deleteItemProvider.notifier).delete(item.id);
      if (context.mounted) {
        context.pop();
      }
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.itemDeleteFailed)));
    }
  }
}

class _ItemPhoto extends StatelessWidget {
  const _ItemPhoto({required this.photoPath});

  final String? photoPath;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20);
    final image = photoPath == null
        ? const Icon(Icons.photo_outlined, size: 64)
        : Image.file(File(photoPath!), fit: BoxFit.cover);

    return SizedBox(
      height: 220,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Center(child: image),
        ),
      ),
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
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(error.toString()),
      ),
    );
  }

  Future<void> _markDone(
    BuildContext context,
    WidgetRef ref,
    Maintenance maintenance,
  ) async {
    final l10n = AppLocalizations.of(context);
    final texts = NotificationTexts.fromL10n(l10n);
    try {
      await ref
          .read(markMaintenanceDoneProvider.notifier)
          .markDone(maintenance.id);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.maintenanceMarkDoneFailed)),
      );
      return;
    }
    await _rescheduleAfterMarkDone(ref, maintenance.id, texts);
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    Maintenance maintenance,
  ) async {
    final l10n = AppLocalizations.of(context);
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
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
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

class _WarrantyBadge extends StatelessWidget {
  const _WarrantyBadge({required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final label = switch (item.warrantyExpiryDate) {
      null => l10n.itemNoWarranty,
      _ when item.isWarrantyActive() => l10n.itemWarrantyActive,
      _ => l10n.itemWarrantyExpired,
    };

    return Chip(label: Text(label));
  }
}
