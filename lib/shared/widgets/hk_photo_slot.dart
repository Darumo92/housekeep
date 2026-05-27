import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';

/// Placeholder slot for pending photos.
/// Diagonal stripes + mono uppercase label. See design Phase 2.6.
class HkPhotoSlot extends StatelessWidget {
  const HkPhotoSlot({
    super.key,
    required this.label,
    this.width,
    this.height = 96,
    this.radius,
  });

  final String label;
  final double? width;
  final double height;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final r = radius ?? AppRadii.tile;
    return ClipRRect(
      borderRadius: BorderRadius.circular(r),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(color: AppColors.surfaceAlt),
            ),
            CustomPaint(painter: _StripesPainter()),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(r),
                border: Border.all(color: AppColors.border, width: 1),
              ),
            ),
            Center(
              child: Text(
                label.toUpperCase(),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                  color: AppColors.textFaint,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StripesPainter extends CustomPainter {
  static const _stripeColor = AppColors.placeholderStripe;
  static const _spacing = 10.0;
  static const _strokeWidth = 6.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _stripeColor
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke;

    final diag = size.width + size.height;
    for (double x = -size.height; x < diag; x += _spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
