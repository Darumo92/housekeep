import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

/// Semantic variants for [StatusBanner].
enum StatusBannerVariant { success, info, warning, danger }

/// Reusable inline banner for surfacing status messages
/// (success acknowledgements, warnings, errors).
///
/// Replaces ad-hoc `Container + BoxDecoration` banners scattered
/// across screens.
class StatusBanner extends StatelessWidget {
  const StatusBanner({
    super.key,
    required this.title,
    this.body,
    this.icon,
    this.action,
    this.variant = StatusBannerVariant.info,
    this.margin,
  });

  final String title;
  final String? body;
  final IconData? icon;
  final Widget? action;
  final StatusBannerVariant variant;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = _palette(theme, variant);

    return Container(
      margin: margin,
      padding: const EdgeInsets.all(Spacing.l),
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon ?? _defaultIcon(variant),
                color: palette.foreground,
                size: 20,
              ),
              const SizedBox(width: Spacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: palette.foreground,
                      ),
                    ),
                    if (body != null) ...[
                      const SizedBox(height: Spacing.xs),
                      Text(
                        body!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: palette.foreground,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (action != null) ...[
            const SizedBox(height: Spacing.s),
            Align(alignment: Alignment.centerRight, child: action!),
          ],
        ],
      ),
    );
  }

  IconData _defaultIcon(StatusBannerVariant v) {
    switch (v) {
      case StatusBannerVariant.success:
        return Icons.check_circle_outline_rounded;
      case StatusBannerVariant.info:
        return Icons.info_outline_rounded;
      case StatusBannerVariant.warning:
        return Icons.warning_amber_rounded;
      case StatusBannerVariant.danger:
        return Icons.error_outline_rounded;
    }
  }

  _BannerPalette _palette(ThemeData theme, StatusBannerVariant v) {
    final scheme = theme.colorScheme;
    switch (v) {
      case StatusBannerVariant.success:
        return const _BannerPalette(
          background: AppStatusColors.successContainer,
          foreground: AppStatusColors.onSuccessContainer,
          border: AppStatusColors.successContainer,
        );
      case StatusBannerVariant.info:
        return _BannerPalette(
          background: scheme.primaryContainer,
          foreground: scheme.onPrimaryContainer,
          border: scheme.primaryContainer,
        );
      case StatusBannerVariant.warning:
        return const _BannerPalette(
          background: AppStatusColors.warningContainer,
          foreground: AppStatusColors.onWarningContainer,
          border: AppStatusColors.warningContainer,
        );
      case StatusBannerVariant.danger:
        return _BannerPalette(
          background: scheme.errorContainer,
          foreground: scheme.onErrorContainer,
          border: scheme.error.withValues(alpha: 0.4),
        );
    }
  }
}

class _BannerPalette {
  const _BannerPalette({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;
}
