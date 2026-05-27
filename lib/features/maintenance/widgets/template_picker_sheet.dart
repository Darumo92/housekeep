import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../../data/services/maintenance_templates_providers.dart';
import '../../../domain/enums/item_category.dart';
import '../../../domain/models/maintenance_template.dart';

Future<MaintenanceTemplate?> showMaintenanceTemplatePicker(
  BuildContext context, {
  required ItemCategory category,
}) {
  return showModalBottomSheet<MaintenanceTemplate>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _TemplatePickerSheet(category: category),
  );
}

class _TemplatePickerSheet extends ConsumerStatefulWidget {
  const _TemplatePickerSheet({required this.category});

  final ItemCategory category;

  @override
  ConsumerState<_TemplatePickerSheet> createState() =>
      _TemplatePickerSheetState();
}

class _TemplatePickerSheetState extends ConsumerState<_TemplatePickerSheet> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final templatesAsync = _showAll
        ? ref.watch(maintenanceTemplatesProvider)
        : ref.watch(
            maintenanceTemplatesByCategoryProvider(widget.category),
          );
    final isProAsync = ref.watch(isProProvider);
    final isPro = isProAsync.value ?? false;

    return SafeArea(
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.maintenanceTemplatesTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    FilterChip(
                      selected: !_showAll,
                      label: Text(
                        l10n.maintenanceTemplatesSuggested(
                          widget.category.label(l10n),
                        ),
                      ),
                      onSelected: (_) => setState(() => _showAll = false),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      selected: _showAll,
                      label: Text(l10n.maintenanceTemplatesAll),
                      onSelected: (_) => setState(() => _showAll = true),
                    ),
                  ],
                ),
              ),
              const Divider(height: 0),
              Expanded(
                child: templatesAsync.when(
                  data: (templates) {
                    if (templates.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            l10n.maintenanceTemplatesEmpty,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: templates.length,
                      separatorBuilder: (_, _) => const Divider(height: 0),
                      itemBuilder: (context, index) {
                        final template = templates[index];
                        return _TemplateTile(
                          template: template,
                          isPro: isPro,
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(child: Text(error.toString())),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TemplateTile extends StatelessWidget {
  const _TemplateTile({required this.template, required this.isPro});

  final MaintenanceTemplate template;
  final bool isPro;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isSpanish = Localizations.localeOf(context).languageCode == 'es';
    final name = isSpanish ? template.nameEs : template.nameEn;
    final description = isSpanish
        ? template.descriptionEs
        : template.descriptionEn;
    final locked = template.isPro && !isPro;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(
        template.category.icon,
        color: locked ? colorScheme.outline : colorScheme.primary,
      ),
      title: Row(
        children: [
          Expanded(child: Text(name)),
          if (template.isPro) ...[
            const SizedBox(width: 8),
            Chip(
              label: Text(l10n.maintenanceTemplateProBadge),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(description, maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(
            l10n.maintenanceIntervalMonths(template.intervalMonths),
            style: Theme.of(context).textTheme.labelSmall,
          ),
          if (locked) ...[
            const SizedBox(height: 4),
            Text(
              l10n.maintenanceTemplateProLocked,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.error,
              ),
            ),
          ],
        ],
      ),
      isThreeLine: true,
      onTap: () {
        if (locked) {
          Navigator.of(context).pop();
          context.push('/paywall?gate=true');
          return;
        }
        Navigator.of(context).pop(template);
      },
    );
  }
}
