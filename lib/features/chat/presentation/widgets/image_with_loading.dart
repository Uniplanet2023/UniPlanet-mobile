import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uniplanet/config/enums/message_status_enum.dart';

class ImageWithLoadingIndicator extends StatelessWidget {
  final String imagePath;
  final String status;

  const ImageWithLoadingIndicator({
    super.key,
    required this.imagePath,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius:
              BorderRadius.circular(12), // Rounded corners for the image
          child: Image.file(File(imagePath), fit: BoxFit.cover), // Your image
        ),
        if (status == MessageStatusEnum.sending.value)
          const SpinKitFadingCircle(color: Colors.blue, size: 50.0),
        if (status == MessageStatusEnum.error.value)
          const Icon(
            Icons.error_sharp,
            size: 100,
            color: Colors.black54,
          ),
      ],
    );
  }
}
