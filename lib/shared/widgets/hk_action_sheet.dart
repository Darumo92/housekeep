import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';

class HkSheetAction {
  const HkSheetAction({
    required this.icon,
    required this.label,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final bool destructive;
}

/// Themed bottom sheet presenting a vertical list of actions in the Cozy
/// style. Returns the index of the tapped action, or null if dismissed.
Future<int?> showHkActionSheet(
  BuildContext context, {
  required List<HkSheetAction> actions,
  String? title,
}) {
  return showModalBottomSheet<int>(
    context: context,
    backgroundColor: context.hkc.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.sheet)),
    ),
    builder: (sheetContext) {
      final theme = Theme.of(sheetContext);
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: context.hkc.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              if (title != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: context.hkc.textMuted,
                    ),
                  ),
                ),
              for (var i = 0; i < actions.length; i++)
                _ActionTile(
                  action: actions[i],
                  onTap: () => Navigator.of(sheetContext).pop(i),
                ),
            ],
          ),
        ),
      );
    },
  );
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.action, required this.onTap});

  final HkSheetAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = action.destructive ? context.hkc.danger : context.hkc.text;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.card * 0.6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: action.destructive
                      ? context.hkc.danger.withValues(alpha: 0.12)
                      : context.hkc.primarySoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(action.icon, size: 19, color: color),
              ),
              const SizedBox(width: 14),
              Text(
                action.label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
