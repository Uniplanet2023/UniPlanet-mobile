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
    required this.description,
    required this.seller,
  });
}
