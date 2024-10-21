import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uniplanet/core/utils/utils.dart';

Future<List<File>> selectImages({
  required BuildContext context,
  required List<File> images,
  required int maxImages,
}) async {
  var pickedImage = await pickImages(context);

  // Check if adding the picked images would exceed the maxImages limit
  if ((images.length + pickedImage.length) <= maxImages) {
    images = [...images, ...pickedImage]; // Merge the lists
    return images; // Return the updated list
  } else {
    // Show an error message and return the original list
    SnackbarGlobal.showSnackBar('You can only add up to $maxImages images.');
    return images; // Return the original list to avoid breaking the function
  }
}

Future<List<File>> selectImageFromCamera({
  required BuildContext context,
  required List<File> images,
  required int maxImages,
}) async {
  File? image = await openCamera(context);
  if (image != null) {
    if (images.length + 1 <= maxImages) {
      images.add(image);
      return images;
    } else {
      SnackbarGlobal.showSnackBar('You can only add up to $maxImages images.');
      return images; // Return the original list to avoid breaking the function
    }
  }
  return [];
}

List<File> removeImage({
  required int selectedIndex,
  required List<File> images,
}) {
  images.removeAt(selectedIndex);
  return images;
}
