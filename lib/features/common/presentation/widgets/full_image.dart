import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImageView extends StatelessWidget {
  final String imagePath;

  const FullScreenImageView({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final ImageProvider imageProvider;
    if (Uri.parse(imagePath).scheme.startsWith('http') ||
        Uri.parse(imagePath).scheme.startsWith('https')) {
      // It's a network URL
      imageProvider = NetworkImage(imagePath);
    } else {
      // It's a file path
      imageProvider = FileImage(File(imagePath));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // White back button
          onPressed: () {
            Navigator.of(context).pop(); // Go back on tap
          },
        ),
      ),
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: PhotoView(
          imageProvider: imageProvider,
          backgroundDecoration: const BoxDecoration(color: Colors.black),
          minScale: PhotoViewComputedScale.contained * 1,
          maxScale: PhotoViewComputedScale.contained * 3,
        ),
      ),
    );
  }
}
