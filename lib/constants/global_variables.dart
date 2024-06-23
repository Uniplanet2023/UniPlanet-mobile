import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class GlobalVariables {
  // COLORS
  static const appBarGradient = LinearGradient(
    colors: [
      Color.fromRGBO(76, 151, 228, 1),
      Color.fromRGBO(60, 203, 228, 1),
    ],
    stops: [0.5, 1.0],
  );
  static const primaryColor = Color.fromARGB(255, 125, 221, 216);
  static const secondaryColor = Color.fromRGBO(78, 132, 233, 1);
  static const backgroundColor = Colors.white;
  static const Color greyBackgroundColor = Color(0xffebecee);
  static const selectedNavBarColor = Color.fromRGBO(60, 220, 228, 1);
  static const unselectedNavBarColor = Colors.black87;
  static const bezierContainerColor = [
    Color.fromRGBO(78, 132, 233, 1),
    Color.fromRGBO(68, 108, 244, 1)
  ];

  static const darkBackgroundColor = Colors.black;
  static const darkSecondaryBackgroundColor = Colors.black54;

  // STATIC IMAGES
  static final customCacheManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: const Duration(days: 2),
    maxNrOfCacheObjects: 100,
  ));

  static const List<Map<String, dynamic>> categories = [
    {'name': 'Electronics & Appliances', 'image': 'assets/images/macbook.jpg'},
    {'name': 'Furniture', 'image': 'assets/images/chair.jpg'},
    {'name': 'Home & Garden', 'image': 'assets/images/fry pan.png'},
    {'name': 'Game & Hobbies', 'image': 'assets/images/game.jpg'},
    {'name': "Books & Music", 'image': 'assets/images/books.jpg'},
    {'name': "Fashion", 'image': 'assets/images/clothes.jpg'},
    {'name': 'Health & Beauty', 'image': 'assets/images/toner.jpg'},
    {'name': 'Sports & Outdoors', 'image': 'assets/images/gloves.jpg'},
    {'name': 'Vehicles & Parts', 'image': 'assets/images/car.jpg'},
    {'name': 'Other', 'image': 'assets/images/box.jpg'},
  ];
  static const List<String> locations = [
    'On Campus',
    'Off Campus',
    'Custom',
  ];
}
