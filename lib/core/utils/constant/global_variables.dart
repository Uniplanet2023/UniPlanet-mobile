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
    {
      'name': 'Electronics & Appliances',
      'image': 'assets/images/Electronics.png'
    },
    {'name': 'Furniture', 'image': 'assets/images/furniture.png'},
    {'name': 'Home & Garden', 'image': 'assets/images/Home.png'},
    {'name': 'Game & Hobbies', 'image': 'assets/images/Game.png'},
    {'name': "Books & Music", 'image': 'assets/images/books.png'},
    {'name': "Fashion", 'image': 'assets/images/fashion.png'},
    {'name': 'Health & Beauty', 'image': 'assets/images/Beauty.png'},
    {'name': 'Sports & Outdoors', 'image': 'assets/images/sports.png'},
    {'name': 'Vehicles & Parts', 'image': 'assets/images/Vehicles.png'},
    {'name': 'Other', 'image': 'assets/images/box.png'},
  ];
  static const List<Map<String, dynamic>> localstore = [
    {'name': 'Coffee Shop', 'image': 'assets/images/coffee shop.png'},
    {'name': 'Restaurant', 'image': 'assets/images/restaurant.png'},
    {'name': 'Hair Shop', 'image': 'assets/images/hair shop.png'},
    {'name': "Gym", 'image': 'assets/images/gym.png'},
  ];
  static const List<String> locations = [
    'On Campus',
    'Off Campus',
    'Custom',
  ];
}
