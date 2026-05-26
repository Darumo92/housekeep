import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../core/utils/haptics.dart';
import '../../data/repositories/repository_providers.dart';
import '../../data/services/notification_providers.dart';
import '../../data/services/notification_strings.dart';
import '../../domain/models/maintenance.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/responsive_card_list.dart';
import '../../shared/widgets/shimmer.dart';
import '../items/items_provider.dart';
import 'maintenances_provider.dart';
import 'widgets/maintenance_card.dart';

class MaintenanceListScreen extends ConsumerWidget {
  const MaintenanceListScreen({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final itemAsync = ref.watch(itemByIdProvider(itemId));

    return Scaffold(
      appBar: AppBar(
        title: itemAsync.when(
          data: (item) => Text(item?.name ?? l10n.itemMaintenanceSectionTitle),
          loading: () => Text(l10n.itemMaintenanceSectionTitle),
          error: (_, _) => Text(l10n.itemMaintenanceSectionTitle),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/items/$itemId/maintenance/add'),
        icon: const Icon(Icons.add),
        label: Text(l10n.itemMaintenanceAdd),
      ),
      body: MaintenanceListView(itemId: itemId),
    );
  }
}

class MaintenanceListView extends ConsumerWidget {
  const MaintenanceListView({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final maintenancesAsync = ref.watch(maintenancesForItemProvider(itemId));

    return maintenancesAsync.when(
      data: (maintenances) {
        if (maintenances.isEmpty) {
          return EmptyState(
            icon: Icons.handyman_outlined,
            title: l10n.itemMaintenanceSectionEmpty,
            body: l10n.itemMaintenanceAdd,
            actionLabel: l10n.itemMaintenanceAdd,
            onAction: () =>
                context.push('/items/$itemId/maintenance/add'),
          );
        }

        return ResponsiveCardList(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          itemCount: maintenances.length,
          itemBuilder: (context, index) {
            final maintenance = maintenances[index];
            return MaintenanceCard(
              maintenance: maintenance,
              onTap: () => context.push(
                '/items/$itemId/maintenance/${maintenance.id}/edit',
              ),
              onMarkDone: () => _markDone(context, ref, maintenance),
              onDelete: () => _delete(context, ref, maintenance),
            );
          },
        );
      },
      loading: () => const ListSkeleton(),
      error: (error, _) => Center(child: Text(error.toString())),
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
      AppHaptics.error();
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.maintenanceMarkDoneFailed)),
      );
      return;
    }
    AppHaptics.success();
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
    AppHaptics.destructive();

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
  final maintenancesRepo = ref.read(maintenancesRepositoryProvider);
  final itemsRepo = ref.read(itemsRepositoryProvider);
  final updated = await maintenancesRepo.getMaintenance(maintenanceId);
  if (updated == null) return;
  final item = await itemsRepo.getItem(updated.itemId);
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
