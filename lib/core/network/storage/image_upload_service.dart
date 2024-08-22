import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart'; // For getting the basename of the file

class ImageUploadService {
  // Private constructor
  ImageUploadService._privateConstructor();

  // Singleton instance
  static final ImageUploadService _instance =
      ImageUploadService._privateConstructor();

  // Public factory method to provide access to the singleton instance
  factory ImageUploadService() {
    return _instance;
  }

  // Firebase Storage instance
  final FirebaseStorage storage = FirebaseStorage.instance;

  // Method to upload image
  Future<String> uploadImage(File imageFile, String path) async {
    try {
      String fileName = basename(imageFile.path);
      Reference ref = storage.ref().child('$path/$fileName');
      UploadTask uploadTask = ref.putFile(imageFile);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String modifiedFileName =
          taskSnapshot.ref.name.replaceAll('.', '_900x900.');
      Reference reference = storage.ref().child('$path/$modifiedFileName');

      String downloadUrl = await getDownloadUrlWithRetry(reference, 10);
      return downloadUrl;
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }

  // Function to get download URL with retries
  Future<String> getDownloadUrlWithRetry(
      Reference reference, int retries) async {
    for (int attempt = 0; attempt < retries; attempt++) {
      await Future.delayed(const Duration(seconds: 2)); // Wait before retrying
      try {
        String downloadUrl = await reference.getDownloadURL();
        return downloadUrl;
      } catch (e) {
        if (attempt == retries - 1) {
          throw Exception('Image upload failed: $e');
        }
      }
    }
    throw Exception('Image upload failed after $retries retries');
  }
}
