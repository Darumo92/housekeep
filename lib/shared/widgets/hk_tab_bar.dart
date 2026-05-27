import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';

enum HkTab { home, items, docs, settings }

/// Bottom navigation with a soft pill behind the active icon.
/// See design Phase 2.9.
class HkTabBar extends StatelessWidget {
  const HkTabBar({
    super.key,
    required this.current,
    required this.onChanged,
  });

  final HkTab current;
  final ValueChanged<HkTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = <HkTab, String>{
      HkTab.home: l10n.homeTab,
      HkTab.items: l10n.itemsTab,
      HkTab.docs: l10n.documentsTab,
      HkTab.settings: l10n.settingsTab,
    };
    final icons = <HkTab, IconData>{
      HkTab.home: Symbols.home_rounded,
      HkTab.items: Symbols.inventory_2_rounded,
      HkTab.docs: Symbols.description_rounded,
      HkTab.settings: Symbols.settings_rounded,
    };

    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final tab in HkTab.values)
                Expanded(
                  child: _TabItem(
                    label: labels[tab]!,
                    icon: icons[tab]!,
                    active: tab == current,
                    onTap: () => onChanged(tab),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = active ? AppColors.primary : AppColors.textMuted;
    return Semantics(
      selected: active,
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.btn),
        child: SizedBox(
          height: 64,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: active ? AppColors.primarySoft : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadii.chip),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: fg,
                  weight: active ? 600 : 400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: fg,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
