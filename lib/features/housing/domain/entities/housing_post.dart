import 'package:uniplanet/core/entities/user.dart';

class HousingPost {
  final String? id;
  final List<String> images;
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
  final String premiumLevel;
  final String stateAddress;
  final String city;
  final String address;
  final String zipCode;

  HousingPost({
    this.id,
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
    required this.premiumLevel,
    required this.stateAddress,
    required this.city,
    required this.address,
    required this.zipCode,
  });

  // Add a fromJson constructor if necessary
  factory HousingPost.fromJson(Map<String, dynamic> json) {
    return HousingPost(
      id: json['id'],
      images: List<String>.from(json['images']),
      title: json['title'],
      category: json['category'],
      monthlyPayment: json['monthlyPayment'],
      isUtilityIncluded: json['isUtilityIncluded'],
      securityDeposit: json['securityDeposit'],
      gender: json['gender'],
      housingConditions: List<String>.from(json['housingConditions']),
      location: json['location'],
      description: json['description'],
      seller: User.fromJson(
          json['seller']), // Assuming User has a fromJson constructor
      premiumLevel: json['premiumLevel'],
      stateAddress: json['stateAddress'],
      city: json['city'],
      address: json['address'],
      zipCode: json['zipCode'],
    );
  }
}
