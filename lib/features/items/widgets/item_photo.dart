import 'dart:io';

import 'package:flutter/material.dart';

class ItemPhoto extends StatelessWidget {
  const ItemPhoto({required this.photoPath, required this.icon, super.key});

  final String? photoPath;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 64,
        height: 64,
        child: photoPath == null
            ? DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                ),
                child: Icon(icon, color: theme.colorScheme.primary),
              )
            : Image.file(
                File(photoPath!),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                    ),
                    child: Icon(icon, color: theme.colorScheme.primary),
                  );
                },
              ),
      ),
    );
  }
}
