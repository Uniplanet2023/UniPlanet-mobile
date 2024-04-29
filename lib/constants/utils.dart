import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class SnackbarGlobal {
  static GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>();
  static void showSnackBar(String text) {
    key.currentState!.showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}

Future<List<File>> pickImages() async {
  List<File> images = [];

  // Check storage permission status
  var permissionStatus = await Permission.storage.status;

  if (permissionStatus.isGranted) {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        images.addAll(result.files
            .map((file) => File(file.path!))
            .take(10)); // Limit to 10 files
      }
    } catch (e) {
      log('Error picking images: $e');
    }
  } else if (permissionStatus.isDenied) {
    // If permission is denied, request it again
    var requested = await Permission.storage.request();
    if (requested.isGranted) {
      return pickImages(); // Recursive call to try picking images again
    } else {
      // If permission still denied, show a dialog or snackbar
      log('Storage permission is denied.');
    }
  } else if (permissionStatus.isPermanentlyDenied) {
    // Direct the user to the settings if permissions are permanently denied
    log('Storage permission is permanently denied. Please enable from app settings.');
  }

  return images;
}

Future<List<XFile>> pickImagesFromGallery(BuildContext context) async {
  List<XFile> pickedImages = [];

  // Check gallery permission status
  var permissionStatus = await Permission.photos.status;

  if (permissionStatus.isGranted) {
    try {
      pickedImages = await ImagePicker().pickMultiImage();
    } catch (e) {
      log('Error picking images: $e');
    }
  } else if (permissionStatus.isDenied) {
    // If permission is denied, request it again
    var requested = await Permission.photos.request();
    if (requested.isGranted) {
      try {
        pickedImages = await ImagePicker().pickMultiImage();
      } catch (e) {
        log('Error picking images: $e');
      }
    } else {
      // If permission still denied, show a dialog or snackbar
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("Permission needed"),
            content: const Text("This app needs gallery access to pick images"),
            actions: <Widget>[
              TextButton(
                child: const Text("Deny"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text("Settings"),
                onPressed: () => openAppSettings(), // Open app settings
              ),
            ],
          ),
        );
      }
    }
  } else if (permissionStatus.isPermanentlyDenied) {
    // Direct the user to the settings if permissions are permanently denied
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Permission Denied"),
          content: const Text(
              "You have permanently denied access to photos. Please enable access in the system settings."),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Settings"),
              onPressed: () => openAppSettings(), // Open app settings
            ),
          ],
        ),
      );
    }
  }

  return pickedImages;
}

Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? video;
  try {
    final pickedVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      video = File(pickedVideo.path);
    }
  } catch (e) {
    SnackbarGlobal.showSnackBar(e.toString());
  }
  return video;
}

String formatTimestamp(DateTime timestamp) {
  final now = DateTime.now().toUtc();

  final difference = now.difference(timestamp);

  if (difference.inMinutes < 60) {
    return '${difference.inMinutes} min ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if (difference.inHours < 48) {
    return 'Yesterday';
  } else if (difference.inHours <= 8760) {
    return DateFormat('MMMM d').format(timestamp);
  } else {
    return DateFormat('yyyy MMMM d').format(timestamp);
  }
}

// Method to open the camera

Future<File?> openCamera() async {
  // Check camera permission status
  var permissionStatus = await Permission.camera.status;

  if (permissionStatus.isGranted) {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      // Handle the captured image file (e.g., send it or display it)
      return imageFile;
    }
    return null;
  } else if (permissionStatus.isDenied) {
    // If permission is denied, request it again
    var requested = await Permission.camera.request();
    if (requested.isGranted) {
      return openCamera(); // Recursive call to open the camera again
    } else {
      // Permission still denied, handle appropriately
      print('Camera permission is denied.');
    }
  } else if (permissionStatus.isPermanentlyDenied) {
    // Direct the user to the settings if permissions are permanently denied
    print(
        'Camera permission is permanently denied. Please enable from app settings.');
  }

  return null;
}

// Development vs Deployment print()

// During development use log to print() in the Debug Console
// ignore_for_file: avoid_print, uncomment the function below during Development
void log(message) => print(message);
