import 'package:flutter/material.dart';
import 'package:uniplanet/common/widgets/full_image_gallery.dart';

void openGallery(BuildContext context, int initialIndex, List<String> images) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => GalleryPhotoViewWrapper(
        galleryItems: images,
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
        initialIndex: initialIndex,
        scrollDirection: Axis.horizontal,
      ),
    ),
  );
}
