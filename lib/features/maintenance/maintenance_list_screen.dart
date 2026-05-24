import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../domain/models/maintenance.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/empty_state.dart';
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

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          itemCount: maintenances.length,
          itemBuilder: (context, index) {
            final maintenance = maintenances[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: MaintenanceCard(
                maintenance: maintenance,
                onTap: () => context.push(
                  '/items/$itemId/maintenance/${maintenance.id}/edit',
                ),
                onMarkDone: () => _markDone(context, ref, maintenance),
                onDelete: () => _delete(context, ref, maintenance),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text(error.toString())),
    );
  }

  Future<void> _markDone(
    BuildContext context,
    WidgetRef ref,
    Maintenance maintenance,
  ) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref
          .read(markMaintenanceDoneProvider.notifier)
          .markDone(maintenance.id);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.maintenanceMarkDoneFailed)),
      );
    }
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
