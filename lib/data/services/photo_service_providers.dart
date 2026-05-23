import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'photo_service.dart';

part 'photo_service_providers.g.dart';

@Riverpod(keepAlive: true)
Future<PhotoService> photoService(PhotoServiceRef ref) async {
  final directory = await getApplicationDocumentsDirectory();

  return LocalPhotoService(
    imagePicker: ImagePicker(),
    storage: LocalPhotoStorage(appDocumentsPath: directory.path),
  );
}
