import 'package:flutter/material.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../domain/enums/document_type.dart';

class DocumentTypePicker extends StatefulWidget {
  const DocumentTypePicker({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
    required this.onClear,
  });

  final DocumentType? selectedType;
  final ValueChanged<DocumentType> onTypeSelected;
  final VoidCallback onClear;

  @override
  State<DocumentTypePicker> createState() => _DocumentTypePickerState();
}

class _DocumentTypePickerState extends State<DocumentTypePicker> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      height: 44,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: DocumentType.values.length + 1,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            final selected = widget.selectedType == null;
            return FilterChip(
              label: Text(l10n.documentsFilterAll),
              selected: selected,
              onSelected: (_) => widget.onClear(),
            );
          }
          final type = DocumentType.values[index - 1];
          final selected = widget.selectedType == type;
          return FilterChip(
            avatar: Icon(type.icon, size: 18),
            label: Text(type.label(l10n)),
            selected: selected,
            onSelected: (_) =>
                selected ? widget.onClear() : widget.onTypeSelected(type),
          );
        },
      ),
    );
  }
}
