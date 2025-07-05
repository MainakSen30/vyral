import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:social_media_app/features/posts/presentation/pages/upload_post_page.dart';
import 'package:social_media_app/features/storage/domain/storage_repo.dart';

class FirebaseStorageRepo implements StorageRepo {
  final FirebaseStorage storage = FirebaseStorage.instance;
  //profile pictures -> upload to storage
  @override
  //mobile platform
  Future<String?> uploadProfileImageOnMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "profile_images");
  }

  @override
  //web platform
  Future<String?> uploadProfileImageOnWeb(
    Uint8List fileBytes,
    String fileName,
  ) {
    return _uploadFileBytes(fileBytes, fileName, "profile_images");
  }

  //post pictures -> upload to storage.
  @override
  Future<String?> uploadPostImageOnMobile(
    String path, 
    String fileName
  ) {
    return _uploadFile(path, fileName, "post_images");
  }

  @override
  Future<String?> uploadPostImageOnWeb(
    Uint8List fileBytes,
    String fileName,
  ) {
    return _uploadFileBytes(fileBytes, fileName, "post_images");
  }

  //helper methods to get profile picture files
  //mobile (file)
  Future<String?> _uploadFile(
    String path,
    String fileName,
    String folder,
  ) async {
    try {
      //get file
      final file = File(path);
      //find place to store
      final storageReference = storage.ref().child('$folder/$fileName');
      //upload the file
      final uploadTask = await storageReference.putFile(file);
      //get image download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      //return the download URL
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  //web (bytes)
  Future<String?> _uploadFileBytes(
    Uint8List fileBytes,
    String fileName,
    String folder,
  ) async {
    try {
      //find place to store
      final storageReference = storage.ref().child('$folder/$fileName');
      //upload the file
      final uploadTask = await storageReference.putData(fileBytes);
      //get image download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      //return the download URL
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }
}
