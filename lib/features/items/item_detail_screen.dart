import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../domain/models/item.dart';
import '../../shared/widgets/confirm_dialog.dart';
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
              Text(
                l10n.itemMaintenanceSectionTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(l10n.itemMaintenanceSectionPlaceholder),
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
