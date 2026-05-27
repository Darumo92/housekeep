import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../core/theme/app_category_palette.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../domain/enums/item_category.dart';
import '../../../shared/widgets/hk_category_tile.dart';
import '../../../shared/widgets/hk_photo_slot.dart';
import '../../../shared/widgets/hk_status_pill.dart';

/// Three abstract compositions for the onboarding pages.
/// All artworks render inside a 280×280 box. See phase 3 §Arte.
class OnboardingArt {
  const OnboardingArt._();

  static const double canvas = 280;
}

class OnboardingArtHomeCluster extends StatelessWidget {
  const OnboardingArtHomeCluster({super.key});

  static const _miniSize = 60.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: OnboardingArt.canvas,
      height: OnboardingArt.canvas,
      child: Stack(
        children: [
          Positioned(
            left: 50,
            top: 60,
            child: Container(
              width: 180,
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(AppRadii.card * 1.4),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Symbols.home_rounded,
                size: 92,
                color: AppColors.primary,
              ),
            ),
          ),
          Positioned(
            left: 8,
            top: 20,
            child: _miniTile(ItemCategory.kitchen, 6),
          ),
          Positioned(
            right: 4,
            top: 8,
            child: _miniTile(ItemCategory.laundry, -8),
          ),
          Positioned(
            left: 18,
            bottom: 10,
            child: _miniTile(ItemCategory.garden, -6),
          ),
          Positioned(
            right: 10,
            bottom: 20,
            child: _miniTile(ItemCategory.bathroom, 8),
          ),
        ],
      ),
    );
  }

  Widget _miniTile(ItemCategory category, double rotationDeg) {
    final palette = AppCategoryPalette.of(category);
    return Transform.rotate(
      angle: rotationDeg * math.pi / 180,
      child: Container(
        width: _miniSize,
        height: _miniSize,
        decoration: BoxDecoration(
          color: palette.bg,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          boxShadow: AppShadows.card,
        ),
        alignment: Alignment.center,
        child: Icon(category.icon, size: 28, color: palette.fg),
      ),
    );
  }
}

class OnboardingArtBellStack extends StatelessWidget {
  const OnboardingArtBellStack({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _fakeNotification(AppColors.dangerSoft, AppColors.danger, 1.0),
      _fakeNotification(AppColors.warnSoft, AppColors.warn, 0.82),
      _fakeNotification(AppColors.okSoft, AppColors.ok, 0.64),
    ];

    return SizedBox(
      width: OnboardingArt.canvas,
      height: OnboardingArt.canvas,
      child: Stack(
        children: [
          for (var i = 0; i < cards.length; i++)
            Positioned(
              left: 10.0 + i * 8,
              top: 18.0 + i * 18,
              child: cards[i],
            ),
          Positioned(
            right: 14,
            bottom: 14,
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
                boxShadow: AppShadows.fab,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Symbols.notifications_rounded,
                size: 48,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fakeNotification(Color iconBg, Color iconFg, double opacity) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 220,
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.card * 0.7),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(AppRadii.tile),
              ),
              alignment: Alignment.center,
              child: Icon(
                Symbols.notifications_rounded,
                size: 22,
                color: iconFg,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAlt,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 6,
                    width: 110,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAlt,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingArtSparkleItem extends StatelessWidget {
  const OnboardingArtSparkleItem({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: OnboardingArt.canvas,
      height: OnboardingArt.canvas,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: 220,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadii.card),
              boxShadow: AppShadows.card,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const HkCategoryTile(
                      category: ItemCategory.bathroom,
                      size: 48,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 10,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceAlt,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 7,
                            width: 90,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceAlt,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const HkPhotoSlot(label: 'appliance photo', height: 70),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const HkStatusPill(status: HkStatus.soon, label: 'SOON'),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 7,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceAlt,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: AppColors.accentSoft,
                shape: BoxShape.circle,
                boxShadow: AppShadows.fab,
              ),
              child: const Icon(
                Symbols.auto_awesome_rounded,
                size: 44,
                color: AppColors.accent,
                fill: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
