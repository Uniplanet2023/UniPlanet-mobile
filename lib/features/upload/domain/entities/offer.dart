import 'dart:io';

class Offer {
  final String voucher;
  final String companyName;
  final String companyImage;
  final String? phoneNumber;
  final String? description;
  final String? conditions;
  final String? stateAddress;
  final String? city;
  final String? address;
  final String? zipCode;
  final String? link;
  final List<File> images;

  Offer({
    required this.companyName,
    required this.companyImage,
    required this.voucher,
    this.phoneNumber,
    this.description,
    this.conditions,
    this.link,
    this.stateAddress,
    this.city,
    this.address,
    this.zipCode,
    required this.images,
  });
}
