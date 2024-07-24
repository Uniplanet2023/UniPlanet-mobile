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
  });
  //copy with
  HousingPost copyWith({
    String? id,
    List<String>? images,
    String? title,
    String? category,
    double? monthlyPayment,
    bool? isUtilityIncluded,
    double? securityDeposit,
    String? gender,
    List<String>? housingConditions,
    String? location,
    String? description,
    User? seller,
    String? premiumLevel,
  }) {
    return HousingPost(
      id: id ?? this.id,
      images: images ?? this.images,
      title: title ?? this.title,
      category: category ?? this.category,
      monthlyPayment: monthlyPayment ?? this.monthlyPayment,
      isUtilityIncluded: isUtilityIncluded ?? this.isUtilityIncluded,
      securityDeposit: securityDeposit ?? this.securityDeposit,
      gender: gender ?? this.gender,
      housingConditions: housingConditions ?? this.housingConditions,
      location: location ?? this.location,
      description: description ?? this.description,
      seller: seller ?? this.seller,
      premiumLevel: premiumLevel ?? this.premiumLevel,
    );
  }
}
