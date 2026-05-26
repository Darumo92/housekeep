import 'package:flutter/material.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../core/theme/app_dimens.dart';

/// Reusable error placeholder for `AsyncValue.error` branches.
///
/// Replaces the legacy `Center(child: Text(error.toString()))` pattern.
/// Always shows a user-friendly message + optional retry CTA.
class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    this.title,
    this.body,
    this.onRetry,
    this.compact = false,
  });

  final String? title;
  final String? body;
  final VoidCallback? onRetry;

  /// When true, removes the surrounding `Center` so the widget can be
  /// placed inline (e.g. inside a sliver or a small card slot).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final content = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: theme.colorScheme.errorContainer,
            child: Icon(
              Icons.error_outline_rounded,
              color: theme.colorScheme.onErrorContainer,
              size: 28,
            ),
          ),
          const SizedBox(height: Spacing.l),
          Text(
            title ?? l10n.commonErrorTitle,
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.s),
          Text(
            body ?? l10n.commonErrorBody,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: Spacing.l),
            FilledButton.tonalIcon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.commonRetry),
            ),
          ],
        ],
      ),
    );

    if (compact) {
      return Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: content,
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: content,
      ),
    );
  }
}
