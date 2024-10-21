import 'package:flutter/material.dart';
import 'dart:io';

import 'package:uniplanet/features/upload/presentation/functions/image_functions.dart';

class ImageSelection extends StatelessWidget {
  final List<File> images;
  final int maxImages;
  final Function(void Function()) updateState;

  const ImageSelection(
      {super.key,
      required this.images,
      required this.maxImages,
      required this.updateState});

  Widget imageContainer(File image, int index, BuildContext context) {
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

        // Display "Main" text if the index is 0
        if (index == 0)
          Positioned(
            top: 5,
            left: 5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.1), // Optional shadow for depth
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                'Main',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),

        // Cancel button
        IconButton(
          icon: const Icon(Icons.cancel, color: Colors.red),
          onPressed: () {
            updateState(() {
              images.removeAt(index);
            });
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
            onTap: () async {
              var newImages = await selectImageFromCamera(
                context: context,
                images: images,
                maxImages: maxImages,
              );
              updateState(() {
                images.addAll(newImages.where((img) => !images.contains(img)));
              });
            },
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
            onTap: () async {
              var selectedImages = await selectImages(
                context: context,
                images: images,
                maxImages: maxImages,
              );

              updateState(() {
                images.addAll(
                    selectedImages.where((img) => !images.contains(img)));
              });
            },
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
