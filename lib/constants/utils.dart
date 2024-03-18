import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      images.addAll(result.files
          .map((file) => File(file.path!))
          .take(5)); // Limit to 5 files
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return images;
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    SnackbarGlobal.showSnackBar(e.toString());
  }
  return image;
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
  final now = DateTime.now();
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
Future<void> openCamera() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
  if (pickedFile != null) {
    final File imageFile = File(pickedFile.path);
    // Handle the captured image file (e.g., send it or display it)
  }
}
