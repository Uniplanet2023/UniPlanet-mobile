import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
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

Future<List<File>> pickImages(BuildContext context) async {
  List<File> images = [];

  // Check storage permission status
  var permissionStatus = await Permission.storage.status;

  if (permissionStatus.isGranted ||
      permissionStatus.isLimited ||
      Platform.isAndroid) {
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
      if (context.mounted) {
        return pickImages(
            context); // Recursive call to try picking images again
      }
    } else {
      // If permission still denied, show a dialog or snackbar
      log('Storage permission is denied.');
    }
  } else {
    // Direct the user to the settings if permissions are permanently denied
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

  return images;
}

Future<List<XFile>> pickMultipleMedia(BuildContext context) async {
  List<XFile> pickedFiles = [];

  // Check gallery permission status
  bool hasImagePermission = await _checkAndRequestPermission(Permission.photos);

  if (hasImagePermission || Platform.isAndroid) {
    try {
      pickedFiles = await ImagePicker().pickMultipleMedia(
        imageQuality: 100,
        maxWidth: 1920,
        maxHeight: 1080,
      );
      // Limit the selection to 5 files
      if (pickedFiles.length > 5) {
        pickedFiles = pickedFiles.sublist(0, 5);

        // Show a message to the user
        if (context.mounted) _showMaxLimitExceededDialog(context);
      }
    } catch (e) {
      log('Error picking media: $e');
    }
  } else {
    // Handle permission denial
    if (context.mounted) _showPermissionDeniedDialog(context);
  }

  return pickedFiles;
}

void _showMaxLimitExceededDialog(BuildContext context) {
  if (context.mounted) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Selection Limit Exceeded"),
        content: const Text("You can only select up to 5 images."),
        actions: <Widget>[
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

bool isVideo(XFile file) {
  final mimeType = lookupMimeType(file.path);

  if (mimeType != null && mimeType.startsWith('video/')) {
    return true;
  }

  return false;
}

bool isImage(XFile file) {
  final mimeType = lookupMimeType(file.path);

  if (mimeType != null && mimeType.startsWith('image/')) {
    return true;
  }

  return false;
}

Future<bool> _checkAndRequestPermission(Permission permission) async {
  if (await permission.isGranted) {
    return true;
  } else {
    var result = await permission.request();
    return result.isGranted;
  }
}

void _showPermissionDeniedDialog(BuildContext context) {
  if (context.mounted) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Permission needed"),
        content: const Text(
            "This app needs gallery access to pick images and videos."),
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

Future<File?> openCamera(BuildContext context) async {
  if (Platform.isAndroid) {
    // Request camera permission for Android
    await Permission.camera.request();
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      // Handle the captured image file (e.g., send it or display it)
      return imageFile;
    }
    return null;
  }
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
      if (context.mounted) {
        return openCamera(context); // Recursive call to open the camera again
      }
    } else {
      // Permission still denied, handle appropriately
      log('Camera permission is denied.');
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
  return null;
}

// Development vs Deployment print()

// During development use log to print() in the Debug Console
// ignore_for_file: avoid_print, uncomment the function below during Development
void log(message) => print(message);
