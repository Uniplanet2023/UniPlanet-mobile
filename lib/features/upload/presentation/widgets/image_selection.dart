import 'package:flutter/material.dart';
import 'dart:io';

class ImageSelection extends StatelessWidget {
  final List<File> images;
  final int maxImages;
  final Function selectImages;
  final Function selectImageFromCamera;
  final Function({required int selectedIndex}) removeImage;

  const ImageSelection({
    super.key,
    required this.images,
    required this.maxImages,
    required this.selectImages,
    required this.selectImageFromCamera,
    required this.removeImage,
  });

  Widget imageContainer(File image, int index, BuildContext context) {
    // Added index parameter
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          width: 70,
          height: 70,
          margin: const EdgeInsets.only(right: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: Theme.of(context).colorScheme.secondaryFixedDim),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(image, fit: BoxFit.cover),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.cancel, color: Colors.red),
          onPressed: () {
            removeImage(selectedIndex: index);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        children: [
          InkWell(
            onTap: () => selectImageFromCamera(context),
            child: Container(
              width: 70,
              height: 70,
              margin: const EdgeInsets.only(right: 8, bottom: 8),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.secondaryFixedDim),
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt,
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      size: 20),
                  Text('${images.length}/$maxImages',
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.tertiaryContainer,
                          fontSize: 12)),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => selectImages(context),
            child: Container(
              width: 70,
              height: 70,
              margin: const EdgeInsets.only(right: 8, bottom: 8),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.secondaryFixedDim),
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo,
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      size: 20),
                  Text('${images.length}/$maxImages',
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.tertiaryContainer,
                          fontSize: 12)),
                ],
              ),
            ),
          ),
          for (int i = 0;
              i < images.length;
              i++) // Use index to iterate over images
            imageContainer(
                images[i], i, context), // Pass the index to imageContainer
        ],
      ),
    );
  }
}
