import 'dart:typed_data';

abstract class StorageRepository {
  Future<String?> uploadProfileImageMobile(String path, String fileName);

  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName);
}
