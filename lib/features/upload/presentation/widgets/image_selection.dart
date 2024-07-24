import 'package:flutter/material.dart';
import 'dart:io';

import 'package:uniplanet/core/utils/utils.dart';

class ImageSelection extends StatelessWidget {
  final List<File> images;
  final int maxImages;

  const ImageSelection({
    super.key,
    required this.images,
    required this.maxImages,
  });

  void selectImages(BuildContext context) async {
    // Your logic to pick more images and add to the list, make sure it does not exceed maxImages
    var res =
        await pickImages(context); // Implement pickImages to return List<File>

    if ((images.length + res.length) <= maxImages) {
      // setState is required here in the original widget, not in this stateless widget.
    } else {
      SnackbarGlobal.showSnackBar('You can only add up to $maxImages images.');
    }
  }

  void selectImageFromCamera(BuildContext context) async {
    File? image = await openCamera(context);
    if (image != null) {
      if (images.length + 1 <= maxImages) {
        // setState is required here in the original widget, not in this stateless widget.
      } else {
        SnackbarGlobal.showSnackBar(
            'You can only add up to $maxImages images.');
      }
    }
  }

  Widget imageContainer(File image, BuildContext context) {
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
            // setState is required here in the original widget, not in this stateless widget.
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
          for (File image in images) imageContainer(image, context),
        ],
      ),
    );
  }
}
