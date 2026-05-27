import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Uppercase eyebrow label + child input. See design Phase 2.7.
class HkFormField extends StatelessWidget {
  const HkFormField({
    super.key,
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
            letterSpacing: 0.2,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 7),
        child,
      ],
    );
  }
}
