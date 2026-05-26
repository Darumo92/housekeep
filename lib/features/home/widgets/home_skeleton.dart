import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../shared/widgets/shimmer.dart';

/// Loading placeholder for `HomeScreen`: mimics summary card +
/// stack of upcoming-event cards so the layout doesn't jump
/// when the data resolves.
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.colorScheme.surfaceContainerLow;

    return Shimmer(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          Spacing.l,
          Spacing.l,
          Spacing.l,
          96,
        ),
        children: [
          _SkeletonCard(color: cardColor, height: 180),
          const SizedBox(height: Spacing.xl),
          const ShimmerBox(width: 140, height: 16),
          const SizedBox(height: Spacing.m),
          _SkeletonCard(color: cardColor, height: 96),
          const SizedBox(height: Spacing.m),
          _SkeletonCard(color: cardColor, height: 96),
          const SizedBox(height: Spacing.m),
          _SkeletonCard(color: cardColor, height: 96),
        ],
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({required this.color, required this.height});

  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(Spacing.l),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(Radii.lg),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ShimmerBox(width: 180, height: 14),
          ShimmerBox(width: 240, height: 12),
          ShimmerBox(width: 140, height: 12),
        ],
      ),
    );
  }
}
