import 'package:flutter/material.dart';

import '../../core/l10n/generated/app_localizations.dart';

enum PhotoPickerAction { camera, gallery, remove }

Future<PhotoPickerAction?> showPhotoPickerSheet(
  BuildContext context, {
  required bool showRemoveAction,
  bool showCameraAction = true,
}) {
  final l10n = AppLocalizations.of(context);

  return showModalBottomSheet<PhotoPickerAction>(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showCameraAction)
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: Text(l10n.itemPhotoCamera),
                onTap: () => Navigator.of(context).pop(PhotoPickerAction.camera),
              ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.itemPhotoGallery),
              onTap: () => Navigator.of(context).pop(PhotoPickerAction.gallery),
            ),
            if (showRemoveAction)
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: Text(l10n.itemPhotoRemove),
                onTap: () => Navigator.of(context).pop(PhotoPickerAction.remove),
              ),
          ],
        ),
      );
    },
  );
}
