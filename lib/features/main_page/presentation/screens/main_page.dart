import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:uniplanet/core/utils/constant/global_variables.dart';
import 'package:uniplanet/core/utils/constant/service.dart';

class RestaurantCategoryScreen extends StatelessWidget {
  final List<String> imgList = [
    'https://firebasestorage.googleapis.com/v0/b/pushnotification-uniplanet.appspot.com/o/ads-images%2FSTONY%20BROOK%20UNIVERSITY%2F67037b730d8200dea645c4f9%2Fbanner1-84CD4CBB-A82D-48E9-9C4B-AC7FCBA332D9-1728364670555.png?alt=media&token=f9811c12-f63f-475d-bf80-c6727cc436f5',
    'https://firebasestorage.googleapis.com/v0/b/pushnotification-uniplanet.appspot.com/o/ads-images%2FSTONY%20BROOK%20UNIVERSITY%2F67037b730d8200dea645c4f9%2FScreenshot%202024-10-08%20at%201_42_21%E2%80%AFAM-A787257F-2372-4BEB-8A49-31BFEB81707C-1728366153626.png?alt=media&token=1be5db98-f200-4954-a3e7-427014fd9d41',
    'https://firebasestorage.googleapis.com/v0/b/pushnotification-uniplanet.appspot.com/o/ads-images%2FSTONY%20BROOK%20UNIVERSITY%2F67037b730d8200dea645c4f9%2FScreenshot%202024-09-13%20at%205_28_56%E2%80%AFPM-7351BD54-8799-4E6F-8A44-A6E255191F16-1728282485125.png?alt=media&token=ac764fb7-f55a-4843-8c5f-45e58097ca59',
  ];

  RestaurantCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sosok'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildImageCarousel(),
              SizedBox(height: 16),
              _buildCategoryGrid(),
            ],
          ),
        ),
      ),
    );
  }

  // Image Carousel Widget
  Widget _buildImageCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 100.0,
        autoPlay: true,
        enlargeCenterPage: false,
        aspectRatio: 2.0,
      ),
      items: imgList
          .map((item) => Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ))
          .toList(),
    );
  }

  // Grid of Categories
  Widget _buildCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Four icons per row
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
      ),
      itemCount: ServiceCategory.serviceCategory.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Image.asset(
              ServiceCategory.serviceCategory[index]["image"]!,
              height: 50,
              width: 50,
            ),
            SizedBox(height: 8),
            Text(
              ServiceCategory.serviceCategory[index]["name"]!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ],
        );
      },
    );
  }
}
