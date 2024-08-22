import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullScreenImagePage extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullScreenImagePage({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
  });

  @override
  FullScreenImagePageState createState() => FullScreenImagePageState();
}

class FullScreenImagePageState extends State<FullScreenImagePage> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    print(widget.imageUrls[0]);
    _pageController = PageController(initialPage: widget.initialIndex);
    _currentIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            pageController: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider:
                    CachedNetworkImageProvider(widget.imageUrls[index]),
                minScale: PhotoViewComputedScale.contained,
                maxScale:
                    PhotoViewComputedScale.contained * 2, // Adjusted maxScale
                initialScale: PhotoViewComputedScale
                    .contained, // Ensures the image fits within the screen initially
                heroAttributes:
                    PhotoViewHeroAttributes(tag: widget.imageUrls[index]),
              );
            },
            scrollPhysics: const BouncingScrollPhysics(),
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
          ),
          Positioned(
            top: 40.0,
            left: 16.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          Positioned(
            top: 40.0,
            right: 16.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Text(
                '${_currentIndex + 1} / ${widget.imageUrls.length}',
                style: const TextStyle(color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
