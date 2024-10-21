class Offer {
  final String offerId;
  final String voucher;
  final String companyName;
  final String stateAddress;
  final String city;
  final String address;
  final String zipCode;
  final List<String> images;
  final String userId;
  final String? phoneNumber;
  final String? description;
  final String? conditions;
  final String? link;

  Offer({
    required this.offerId,
    required this.companyName,
    required this.voucher,
    required this.userId,
    this.phoneNumber,
    this.description,
    this.conditions,
    this.link,
    required this.stateAddress,
    required this.city,
    required this.address,
    required this.zipCode,
    required this.images,
  });
}
