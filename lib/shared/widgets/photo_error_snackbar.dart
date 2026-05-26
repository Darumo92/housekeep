import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../data/services/photo_service.dart';

void showPhotoPickerError(
  BuildContext context,
  PhotoPickerException error,
) {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final (message, action) = _resolve(l10n, error);

  messenger.showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 4),
      action: action,
    ),
  );
}

(String, SnackBarAction?) _resolve(
  AppLocalizations l10n,
  PhotoPickerException error,
) {
  switch (error.reason) {
    case PhotoPickerError.permissionDenied:
      return (
        l10n.photoPickerErrorPermission,
        SnackBarAction(
          label: l10n.photoPickerOpenSettings,
          onPressed: () =>
              AppSettings.openAppSettings(type: AppSettingsType.settings),
        ),
      );
    case PhotoPickerError.storageFull:
      return (l10n.photoPickerErrorStorageFull, null);
    case PhotoPickerError.noCamera:
      return (l10n.photoPickerErrorNoCamera, null);
    case PhotoPickerError.unknown:
      return (l10n.photoPickerErrorUnknown, null);
  }
}
