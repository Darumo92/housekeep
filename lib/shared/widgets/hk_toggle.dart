import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Custom 44x26 animated switch. See design Phase 2.8.
class HkToggle extends StatelessWidget {
  const HkToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  static const double _trackWidth = 44;
  static const double _trackHeight = 26;
  static const double _knobSize = 20;
  static const double _knobInset = 3;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(!value),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: _trackWidth,
              height: _trackHeight,
              decoration: BoxDecoration(
                color: value ? AppColors.primary : AppColors.border,
                borderRadius: BorderRadius.circular(_trackHeight / 2),
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    left: value
                        ? _trackWidth - _knobSize - _knobInset
                        : _knobInset,
                    top: _knobInset,
                    child: Container(
                      width: _knobSize,
                      height: _knobSize,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
