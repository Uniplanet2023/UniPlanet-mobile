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
      'image': 'assets/images/icons/air-conditioning.png'
    },
    {'name': 'Furniture', 'image': 'assets/images/icons/chair.png'},
    {'name': 'Home & Garden', 'image': 'assets/images/icons/home.png'},
    {'name': 'Game & Hobbies', 'image': 'assets/images/icons/game.png'},
    {'name': "Books & Music", 'image': 'assets/images/icons/book.png'},
    {'name': "Fashion", 'image': 'assets/images/icons/fashion.png'},
    {
      'name': 'Health & Beauty',
      'image': 'assets/images/icons/health & Beauty.png'
    },
    {'name': 'Sports & Outdoors', 'image': 'assets/images/icons/Sports.png'},
    {'name': 'Vehicles', 'image': 'assets/images/icons/vehicle.png'},
    {'name': 'Other', 'image': 'assets/images/icons/other.png'},
    {'name': 'Rental Housing', 'image': 'assets/images/icons/message.png'},
  ];
  static const List<Map<String, dynamic>> housingCategories = [
    {'name': 'Sublet'},
    {'name': 'Studio'},
    {'name': '1BR'},
    {'name': '2BR'},
    {'name': '3BR⬆'},
    {'name': 'Room mate'},
    {'name': 'Home Stay'},
    {'name': "Other"},
  ];
  static const List<Map<String, dynamic>> housingConditions = [
    {'name': 'Pet Freiendly'},
    {'name': 'Furnished'},
    {'name': 'Kitchen'},
    {'name': 'Parking'},
    {'name': 'Laundry'},
    {'name': 'Dryer'},
    {'name': 'Dish Washer'},
    {'name': 'Air Conditioner'},
    {'name': 'Heater'},
    {'name': 'Balcony'},
    {'name': 'Pool'},
    {'name': 'Gym'},
    {'name': 'Elevator'},
    {'name': 'Wheelchair Accessible'},
    {'name': 'Smoke Free'},
    {'name': 'Internet'},
    {'name': 'Cable TV'},
    {'name': 'Other'},
  ];
  static const List<Map<String, dynamic>> localstore = [
    {'name': 'Coffee Shop', 'image': 'assets/images/icons/fashion.png'},
    {'name': 'Restaurant', 'image': 'assets/images/icons/fashion.png'},
    {'name': 'Hair Shop', 'image': 'assets/images/icons/fashion.png'},
    {'name': "Gym", 'image': 'assets/images/icons/fashion.png'},
  ];
  static const List<String> locations = [
    'On Campus',
    'Off Campus',
    'Custom',
  ];
}
