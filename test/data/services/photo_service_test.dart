import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:housekeep/data/services/photo_service.dart';
import 'package:path/path.dart' as p;

void main() {
  group('LocalPhotoStorage', () {
    test('copies a picked file into the app photo directory', () async {
      final tempDir = Directory.systemTemp.createTempSync();
      addTearDown(() => tempDir.deleteSync(recursive: true));

      final sourceFile = File(p.join(tempDir.path, 'source.jpg'));
      await sourceFile.writeAsBytes(const [1, 2, 3, 4]);

      final storage = LocalPhotoStorage(appDocumentsPath: tempDir.path);

      final storedPath = await storage.storePickedFile(sourceFile.path);
      final storedFile = File(storedPath);

      expect(storedFile.existsSync(), isTrue);
      expect(p.dirname(storedPath), p.join(tempDir.path, 'photos'));
      expect(await storedFile.readAsBytes(), [1, 2, 3, 4]);
      expect(storedPath, isNot(sourceFile.path));
    });

    test('deletes a stored photo', () async {
      final tempDir = Directory.systemTemp.createTempSync();
      addTearDown(() => tempDir.deleteSync(recursive: true));

      final sourceFile = File(p.join(tempDir.path, 'source.jpg'));
      await sourceFile.writeAsBytes(const [5, 6, 7, 8]);

      final storage = LocalPhotoStorage(appDocumentsPath: tempDir.path);
      final storedPath = await storage.storePickedFile(sourceFile.path);

      await storage.deletePhoto(storedPath);

      expect(File(storedPath).existsSync(), isFalse);
    });

    test('deleting a missing file is a no-op', () async {
      final tempDir = Directory.systemTemp.createTempSync();
      addTearDown(() => tempDir.deleteSync(recursive: true));

      final storage = LocalPhotoStorage(appDocumentsPath: tempDir.path);
      final missingPath = p.join(tempDir.path, 'photos', 'missing.jpg');

      await storage.deletePhoto(missingPath);

      expect(File(missingPath).existsSync(), isFalse);
    });

    test('delete does not remove files outside the managed storage directory', () async {
      final tempDir = Directory.systemTemp.createTempSync();
      addTearDown(() => tempDir.deleteSync(recursive: true));

      final outsideFile = File(p.join(tempDir.path, 'outside.jpg'));
      await outsideFile.writeAsBytes(const [9, 8, 7, 6]);

      final storage = LocalPhotoStorage(appDocumentsPath: tempDir.path);

      await storage.deletePhoto(outsideFile.path);

      expect(outsideFile.existsSync(), isTrue);
    });
  });
}
