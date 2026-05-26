import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

enum PhotoPickerError {
  permissionDenied,
  noCamera,
  storageFull,
  unknown,
}

class PhotoPickerException implements Exception {
  const PhotoPickerException(this.reason, [this.cause]);

  final PhotoPickerError reason;
  final Object? cause;

  @override
  String toString() =>
      'PhotoPickerException(reason: $reason${cause == null ? '' : ', cause: $cause'})';
}

abstract class PhotoService {
  Future<String?> pickFromCamera();

  Future<String?> pickFromGallery();

  Future<void> deletePhoto(String path);
}

class LocalPhotoStorage {
  const LocalPhotoStorage({required this.appDocumentsPath});

  final String appDocumentsPath;

  Future<String> storePickedFile(String sourcePath) async {
    try {
      final photosDirectory = Directory(_photosDirectoryPath);
      await photosDirectory.create(recursive: true);

      final extension = p.extension(sourcePath);
      final entropy = Random().nextInt(1 << 32).toRadixString(16);
      final fileName =
          '${DateTime.now().microsecondsSinceEpoch}_$entropy$extension';
      final destinationPath = p.join(photosDirectory.path, fileName);

      final file = await File(sourcePath).copy(destinationPath);
      return file.path;
    } on FileSystemException catch (e) {
      if (_isOutOfSpace(e)) {
        throw PhotoPickerException(PhotoPickerError.storageFull, e);
      }
      throw PhotoPickerException(PhotoPickerError.unknown, e);
    }
  }

  bool _isOutOfSpace(FileSystemException e) {
    final code = e.osError?.errorCode;
    // ENOSPC=28 (linux/macos), ERROR_DISK_FULL=112 (windows).
    if (code == 28 || code == 112) return true;
    final message = '${e.message} ${e.osError?.message ?? ''}'.toLowerCase();
    return message.contains('no space') || message.contains('disk full');
  }

  Future<void> deletePhoto(String path) async {
    if (!_isManagedPhotoPath(path)) {
      return;
    }

    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  String get _photosDirectoryPath => p.join(appDocumentsPath, 'photos');

  bool _isManagedPhotoPath(String path) {
    final photosDirectoryPath = p.normalize(p.absolute(_photosDirectoryPath));
    final targetPath = p.normalize(p.absolute(path));

    return p.isWithin(photosDirectoryPath, targetPath);
  }
}

class LocalPhotoService implements PhotoService {
  const LocalPhotoService({
    required ImagePicker imagePicker,
    required LocalPhotoStorage storage,
  }) : _imagePicker = imagePicker,
       _storage = storage;

  final ImagePicker _imagePicker;
  final LocalPhotoStorage _storage;

  @override
  Future<String?> pickFromCamera() {
    return _pickAndStore(ImageSource.camera);
  }

  @override
  Future<String?> pickFromGallery() {
    return _pickAndStore(ImageSource.gallery);
  }

  @override
  Future<void> deletePhoto(String path) {
    return _storage.deletePhoto(path);
  }

  Future<String?> _pickAndStore(ImageSource source) async {
    final XFile? pickedFile;
    try {
      pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1600,
      );
    } on PlatformException catch (e) {
      throw _mapPickerPlatformException(e);
    }
    if (pickedFile == null) {
      return null;
    }
    return _storage.storePickedFile(pickedFile.path);
  }

  PhotoPickerException _mapPickerPlatformException(PlatformException e) {
    final code = e.code;
    if (code == 'camera_access_denied' || code == 'photo_access_denied') {
      return PhotoPickerException(PhotoPickerError.permissionDenied, e);
    }
    if (code == 'no_available_camera') {
      return PhotoPickerException(PhotoPickerError.noCamera, e);
    }
    return PhotoPickerException(PhotoPickerError.unknown, e);
  }
}
