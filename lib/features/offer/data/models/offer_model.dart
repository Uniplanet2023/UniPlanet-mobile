import '../../domain/entities/offer.dart';

class OfferModel extends Offer {
  OfferModel({
    required super.offerId,
    required super.voucher,
    required super.companyName,
    required super.stateAddress,
    required super.city,
    required super.address,
    required super.zipCode,
    required super.images,
    required super.userId,
    super.phoneNumber,
    super.description,
    super.conditions,
    super.link,
  });

  // Factory method to create OfferModel from JSON
  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      offerId: json['id'],
      voucher: json['voucher'],
      companyName: json['companyName'],
      stateAddress: json['stateAddress'],
      city: json['city'],
      address: json['address'],
      zipCode: json['zipCode'],
      images: List<String>.from(json['images']),
      phoneNumber: json['phoneNumber'],
      description: json['description'],
      conditions: json['conditions'],
      link: json['link'],
      userId: json['user'],
    );
  }

  // Method to convert OfferModel back to JSON if needed
  Map<String, dynamic> toJson() {
    return {
      'id': offerId,
      'voucher': voucher,
      'companyName': companyName,
      'stateAddress': stateAddress,
      'city': city,
      'address': address,
      'zipCode': zipCode,
      'images': images,
      'phoneNumber': phoneNumber,
      'description': description,
      'conditions': conditions,
      'link': link,
      'user': userId,
    };
  }
}
