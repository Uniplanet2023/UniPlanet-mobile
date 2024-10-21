import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart'; // For getting the basename of the file

class MediaUploadService {
  // Private constructor
  MediaUploadService._privateConstructor();

  // Singleton instance
  static final MediaUploadService _instance =
      MediaUploadService._privateConstructor();

  // Public factory method to provide access to the singleton instance
  factory MediaUploadService() {
    return _instance;
  }

  // Firebase Storage instance
  final FirebaseStorage storage = FirebaseStorage.instance;
  String getImagePathUrl(File imageFile, String path) {
    String originalFileName = basename(imageFile.path);
    String fileName = originalFileName.replaceAllMapped(
      RegExp(r'\.(?=[^.]*\.)'),
      (match) => '_',
    );
    String modifiedFileName = fileName.replaceAll('.', '_900x900.');
    Reference ref = storage.ref().child('$path/$modifiedFileName');

    String encodedFullPath = Uri.encodeComponent(ref.fullPath);

    String url =
        "https://firebasestorage.googleapis.com/v0/b/${ref.bucket}/o/$encodedFullPath?alt=media";

    return url;
  }

  Future<String> uploadImage(File imageFile, String path) async {
    try {
      // Compress the image before uploading
      File compressedImageFile = await _compressImage(imageFile);

      String originalFileName = basename(compressedImageFile.path);

      // Replace all periods except the last one (which indicates the file extension)
      String fileName = originalFileName.replaceAllMapped(
        RegExp(r'\.(?=[^.]*\.)'),
        (match) => '_',
      );

      Reference ref = storage.ref().child('$path/$fileName');

      UploadTask uploadTask = ref.putFile(compressedImageFile);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      String modifiedFileName =
          taskSnapshot.ref.name.replaceAll('.', '_900x900.');
      Reference reference = storage.ref().child('$path/$modifiedFileName');

      String downloadUrl = await getDownloadUrlWithRetry(reference, 50);
      return downloadUrl;
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }

// Method to upload image
  Future<String> uploadAdImage(File imageFile, String path) async {
    try {
      // Compress the image before uploading
      File compressedImageFile = await _compressImage(imageFile);

      String originalFileName = basename(compressedImageFile.path);

      // Replace all periods except the last one (which indicates the file extension)
      String fileName = originalFileName.replaceAllMapped(
        RegExp(r'\.(?=[^.]*\.)'),
        (match) => '_',
      );

      Reference ref = storage.ref().child('$path/$fileName');
      UploadTask uploadTask = ref.putFile(compressedImageFile);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      Reference reference =
          storage.ref().child('$path/${taskSnapshot.ref.name}');

      // String downloadUrl = await getDownloadUrlWithRetry(reference, 10);
      String downloadUrl = await getDownloadUrlWithRetry(reference, 50);
      return downloadUrl;
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }

  // Method to upload multiple images
  Future<List<String>> uploadMultipleAdImages(
      List<File> imageFiles, String path) async {
    try {
      List<String> downloadUrls = [];

      for (File imageFile in imageFiles) {
        // Upload each image and collect the download URL
        String downloadUrl = await uploadAdImage(imageFile, path);
        downloadUrls.add(downloadUrl);
      }

      return downloadUrls;
    } catch (e) {
      throw Exception('Multiple image upload failed: $e');
    }
  }

  Future<File> _compressImage(File imageFile) async {
    final tempDir = await getTemporaryDirectory();

    // Get the original file extension
    String originalExtension = extension(imageFile.path).toLowerCase();

    // Determine the appropriate target extension
    String targetExtension;
    if (originalExtension == '.jpg' ||
        originalExtension == '.jpeg' ||
        originalExtension == '.png') {
      targetExtension = originalExtension;
    } else {
      targetExtension =
          '.jpg'; // Fallback to .jpg if the original format is not supported
    }

    // Ensure the target path has the correct extension
    String fileName = basenameWithoutExtension(
        imageFile.path); // Get file name without extension
    final targetPath =
        '${tempDir.path}/$fileName$targetExtension'; // Append the correct extension

    // Compress the image
    final XFile? compressedXFile =
        await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      targetPath,
      quality: 70, // Adjust quality between 0-100 as needed
      format: targetExtension == '.png'
          ? CompressFormat.png
          : CompressFormat.jpeg, // Handle PNG specifically
    );

    // Ensure a File is always returned
    if (compressedXFile != null) {
      return File(compressedXFile.path);
    } else {
      return imageFile;
    }
  }

  Future<String> uploadVideo(File videoFile, String path) async {
    try {
      String originalFileName = basename(videoFile.path);
      // Replace all periods except the last one (which indicates the file extension)

      String fileName = originalFileName.replaceAllMapped(
        RegExp(r'\.(?=[^.]*\.)'),
        (match) => '_',
      );
      Reference ref = storage.ref().child('$path/$fileName');
      UploadTask uploadTask = ref.putFile(videoFile);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      Reference reference =
          storage.ref().child('$path/${taskSnapshot.ref.name}');

      String downloadUrl = await getDownloadUrlWithRetry(reference, 50);
      return downloadUrl;
    } catch (e) {
      throw Exception('Video upload failed: $e');
    }
  }

  // Function to get download URL with retries
  // Since the system used cloud function to resize the image, it may take some time for the image to be available
  Future<String> getDownloadUrlWithRetry(
      Reference reference, int retries) async {
    for (int attempt = 0; attempt < retries; attempt++) {
      await Future.delayed(
          const Duration(milliseconds: 100)); // Wait before retrying
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
