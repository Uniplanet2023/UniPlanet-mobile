import 'dart:io';

import 'package:uniplanet/core/entities/user.dart';

class HousingPostForm {
  final List<File> images;
  final String title;
  final String category;
  final double monthlyPayment;
  final bool isUtilityIncluded;
  final double securityDeposit;
  final String gender;
  final List<String> housingConditions;
  final String location;
  final String stateAddress;
  final String city;
  final String address;
  final String zipCode;
  final String description;
  final User seller;

  HousingPostForm({
    required this.images,
    required this.title,
    required this.category,
    required this.monthlyPayment,
    required this.isUtilityIncluded,
    required this.securityDeposit,
    required this.gender,
    required this.housingConditions,
    required this.location,
    required this.stateAddress,
    required this.city,
    required this.address,
    required this.zipCode,
    required this.description,
    required this.seller,
  });
}
