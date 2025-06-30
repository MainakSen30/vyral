import 'dart:typed_data';

abstract class StorageRepo {
  //upload profile pics on mobile platforms.
  Future<String?> uploadProfileImageOnMobile(String path, String fileName);
  //upload profile pics on the web.
  Future<String?> uploadProfileImageOnWeb(Uint8List fileBytes, String fileName);
}
