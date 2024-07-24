import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/features/housing/domain/entities/housing_post.dart';

class HousingPostModel extends HousingPost {
  HousingPostModel({
    super.id,
    required super.images,
    required super.title,
    required super.category,
    required super.monthlyPayment,
    required super.isUtilityIncluded,
    required super.securityDeposit,
    required super.gender,
    required super.housingConditions,
    required super.location,
    required super.description,
    required super.seller,
    required super.premiumLevel,
  });

  factory HousingPostModel.fromJson(Map<String, dynamic> json) {
    return HousingPostModel(
      id: json['id'],
      images: List<String>.from(json['images']),
      title: json['title'],
      category: json['category'],
      monthlyPayment: (json['monthlyPayment'] as num?)?.toDouble() ?? 0.0,
      isUtilityIncluded: json['isUtilityIncluded'],
      securityDeposit: (json['securityDeposit'] as num?)?.toDouble() ?? 0.0,
      gender: json['gender'],
      housingConditions: List<String>.from(json['housingConditions']),
      location: json['location'],
      description: json['description'],
      seller: User.fromMap(json['seller']),
      premiumLevel: json['premiumLevel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'images': images,
      'title': title,
      'category': category,
      'monthlyPayment': monthlyPayment,
      'isUtilityIncluded': isUtilityIncluded,
      'securityDeposit': securityDeposit,
      'gender': gender,
      'housingConditions': housingConditions,
      'location': location,
      'description': description,
      'seller': seller.toJson(),
      'premiumLevel': premiumLevel,
    };
  }
}
