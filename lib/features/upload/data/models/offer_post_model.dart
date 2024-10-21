import 'package:uniplanet/features/upload/domain/entities/offer.dart';

class OfferModel extends Offer {
  OfferModel({
    required super.companyName,
    required super.companyImage,
    required super.description,
    required super.voucher,
    super.phoneNumber,
    super.link,
    super.stateAddress,
    super.city,
    super.address,
    super.zipCode,
    required super.images,
  });

  // Convert the domain entity into OfferModel
  factory OfferModel.fromDomain(Offer offer) {
    return OfferModel(
      companyName: offer.companyName,
      companyImage: offer.companyImage,
      voucher: offer.voucher,
      description: offer.description,
      link: offer.link,
      stateAddress: offer.stateAddress,
      city: offer.city,
      address: offer.address,
      zipCode: offer.zipCode,
      images: offer.images, // Ensure proper mapping if needed
      phoneNumber: offer.phoneNumber,
    );
  }

  // Convert DTO to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'companyImage': companyImage,
      'voucher': voucher,
      'description': description,
      'link': link,
      'stateAddress': stateAddress,
      'city': city,
      'address': address,
      'zipCode': zipCode,
      'phoneNumber': phoneNumber,
      // Map the File objects to their paths (or URLs if needed)
      'images': images
          .map((image) => image.path)
          .toList(), // Assuming we send image paths
    };
  }
}
