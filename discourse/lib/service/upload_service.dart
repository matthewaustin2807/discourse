import 'dart:io';
import 'package:discourse/service/service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

/// Service class to handle File Uploads
class FileUploadService extends Service {
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(bucket: "gs://cs5520-final-projec.firebasestorage.app");

  /// Uploads an image to Cloud Storage
  Future<String> uploadImage(XFile image) async {
    try {
      String fileExtension = image.name.split('.').last;
      Reference storageReference = _storage
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.$fileExtension');  

      UploadTask uploadTask = storageReference.putFile(File(image.path));

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl; 
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  /// Uploads a file to Cloud Storage
  Future<String> uploadFile(File file) async {
    try {
      String fileExtension = file.path.split('.').last;

      String filePath = 'uploads/${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      Reference storageReference = _storage.ref().child(filePath);
      UploadTask uploadTask = storageReference.putFile(file);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Error uploading file: $e');
    }
  }

  /// Uploads profile pictures to Cloud Storage
  Future<String> uploadProfilePicture(XFile file) async {
    try {
      String fileExtension = file.name.split('.').last;
      Reference storageReference = _storage
          .ref()
          .child('profilePicture/${DateTime.now().millisecondsSinceEpoch}.$fileExtension');  

      UploadTask uploadTask = storageReference.putFile(File(file.path));

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl; 
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
}
