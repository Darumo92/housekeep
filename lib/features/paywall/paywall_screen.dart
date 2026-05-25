import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../data/repositories/purchase_repository.dart';
import 'paywall_provider.dart';

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final offeringAsync = ref.watch(currentOfferingProvider);
    final controllerState = ref.watch(purchaseControllerProvider);

    ref.listen<PurchaseControllerState>(purchaseControllerProvider, (
      previous,
      next,
    ) {
      if (next.isCancelled) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.paywallCancelled)));
        ref.read(purchaseControllerProvider.notifier).reset();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.paywallTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
      ),
      body: SafeArea(
        child: offeringAsync.when(
          data: (offering) => _PaywallBody(
            offering: offering,
            controllerState: controllerState,
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _PaywallBody(
            offering: null,
            controllerState: controllerState,
            errorOverride: error.toString(),
          ),
        ),
      ),
    );
  }
}

class _PaywallBody extends ConsumerWidget {
  const _PaywallBody({
    required this.offering,
    required this.controllerState,
    this.errorOverride,
  });

  final PurchaseOffering? offering;
  final PurchaseControllerState controllerState;
  final String? errorOverride;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    if (controllerState.isSuccess) {
      return _SuccessView(
        onContinue: () => context.canPop() ? context.pop() : context.go('/'),
      );
    }

    final package = offering?.primaryPackage;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.paywallTagline,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const _FeatureList(),
          const SizedBox(height: 24),
          const _ComparisonTable(),
          const SizedBox(height: 24),
          if (errorOverride != null || package == null)
            _UnavailableNotice(message: errorOverride),
          if (package != null) ...[
            FilledButton(
              onPressed: controllerState.isLoading
                  ? null
                  : () => ref
                        .read(purchaseControllerProvider.notifier)
                        .buy(package),
              child: controllerState.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.paywallBuyCta(package.priceString)),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: controllerState.isLoading
                  ? null
                  : () =>
                        ref.read(purchaseControllerProvider.notifier).restore(),
              child: Text(l10n.paywallRestore),
            ),
          ],
          if (controllerState.isError) ...[
            const SizedBox(height: 16),
            _ErrorBanner(
              message: controllerState.errorMessage ?? l10n.paywallErrorTitle,
            ),
          ],
        ],
      ),
    );
  }
}

class _FeatureList extends StatelessWidget {
  const _FeatureList();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final features = <(IconData, String)>[
      (Icons.kitchen_outlined, l10n.paywallFeatureUnlimitedItems),
      (Icons.description_outlined, l10n.paywallFeatureUnlimitedDocuments),
      (Icons.auto_awesome_outlined, l10n.paywallFeatureProTemplates),
      (
        Icons.notifications_active_outlined,
        l10n.paywallFeatureMultiNotifications,
      ),
      (Icons.widgets_outlined, l10n.paywallFeatureWidget),
      (Icons.picture_as_pdf_outlined, l10n.paywallFeatureExportPdf),
    ];

    return Column(
      children: [
        for (final (icon, label) in features)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
          ),
      ],
    );
  }
}

class _ComparisonTable extends StatelessWidget {
  const _ComparisonTable();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rows = <(String, String, String)>[
      (l10n.itemsTab, l10n.paywallFreeItemsValue, l10n.paywallProItemsValue),
      (
        l10n.documentsTab,
        l10n.paywallFreeDocumentsValue,
        l10n.paywallProDocumentsValue,
      ),
      (
        l10n.notificationMaintenanceTitle,
        l10n.paywallFreeNotificationsValue,
        l10n.paywallProNotificationsValue,
      ),
    ];

    final headerStyle = Theme.of(context).textTheme.titleSmall;
    final cellStyle = Theme.of(context).textTheme.bodyMedium;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
          },
          children: [
            TableRow(
              children: [
                const SizedBox.shrink(),
                Text(l10n.paywallFreeColumn, style: headerStyle),
                Text(l10n.paywallProColumn, style: headerStyle),
              ],
            ),
            for (final (label, free, pro) in rows)
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(label, style: cellStyle),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(free, style: cellStyle),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(pro, style: cellStyle),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _UnavailableNotice extends StatelessWidget {
  const _UnavailableNotice({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.paywallOfferingUnavailable,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(message!, style: Theme.of(context).textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.errorContainer;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 96,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.paywallSuccessTitle,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.paywallSuccessBody,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: onContinue,
            child: Text(l10n.paywallSuccessContinue),
          ),
        ],
      ),
    );
  }
}
