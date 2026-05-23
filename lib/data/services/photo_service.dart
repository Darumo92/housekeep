import 'dart:io';
import 'dart:math';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

abstract class PhotoService {
  Future<String?> pickFromCamera();

  Future<String?> pickFromGallery();

  Future<void> deletePhoto(String path);
}

class LocalPhotoStorage {
  const LocalPhotoStorage({required this.appDocumentsPath});

  final String appDocumentsPath;

  Future<String> storePickedFile(String sourcePath) async {
    final photosDirectory = Directory(_photosDirectoryPath);
    await photosDirectory.create(recursive: true);

    final extension = p.extension(sourcePath);
    final entropy = Random().nextInt(1 << 32).toRadixString(16);
    final fileName =
        '${DateTime.now().microsecondsSinceEpoch}_$entropy$extension';
    final destinationPath = p.join(photosDirectory.path, fileName);

    return File(sourcePath).copy(destinationPath).then((file) => file.path);
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
    final pickedFile = await _imagePicker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1600,
    );
    if (pickedFile == null) {
      return null;
    }

    return _storage.storePickedFile(pickedFile.path);
  }
}
