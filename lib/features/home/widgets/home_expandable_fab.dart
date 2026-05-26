import 'package:flutter/material.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/utils/haptics.dart';

class HomeExpandableFab extends StatefulWidget {
  const HomeExpandableFab({
    super.key,
    required this.onAddItem,
    required this.onAddMaintenance,
    required this.onAddDocument,
  });

  final VoidCallback onAddItem;
  final VoidCallback? onAddMaintenance;
  final VoidCallback onAddDocument;

  @override
  State<HomeExpandableFab> createState() => _HomeExpandableFabState();
}

class _HomeExpandableFabState extends State<HomeExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );
  bool _open = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    AppHaptics.tap();
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _runAction(VoidCallback action) {
    _toggle();
    action();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_open) ...[
          _MiniFab(
            label: l10n.homeFabAddDocument,
            icon: Icons.description_outlined,
            onPressed: () => _runAction(widget.onAddDocument),
          ),
          const SizedBox(height: 12),
          _MiniFab(
            label: l10n.homeFabAddMaintenance,
            icon: Icons.build_outlined,
            onPressed: widget.onAddMaintenance == null
                ? null
                : () => _runAction(widget.onAddMaintenance!),
            disabledTooltip: l10n.homeFabAddMaintenanceNoItems,
          ),
          const SizedBox(height: 12),
          _MiniFab(
            label: l10n.homeFabAddItem,
            icon: Icons.kitchen_outlined,
            onPressed: () => _runAction(widget.onAddItem),
          ),
          const SizedBox(height: 12),
        ],
        FloatingActionButton(
          onPressed: _toggle,
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _controller,
          ),
        ),
      ],
    );
  }
}

class _MiniFab extends StatelessWidget {
  const _MiniFab({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.disabledTooltip,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final String? disabledTooltip;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    final fab = FloatingActionButton.extended(
      heroTag: 'home-fab-$label',
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      backgroundColor:
          disabled ? Theme.of(context).disabledColor : null,
    );
    if (!disabled || disabledTooltip == null) return fab;
    return Tooltip(message: disabledTooltip!, child: fab);
  }
}
