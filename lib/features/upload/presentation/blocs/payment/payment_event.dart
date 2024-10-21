part of 'payment_bloc.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class CreatePaymentIntentEvent extends PaymentEvent {
  final String tier;
  final String adName;
  final String description;
  final List<File> images;
  final String type;
  final String? link;
  final String? location;
  final String? stateAddress;
  final String? city;
  final String? address;
  final String? zipCode;
  final User advertiser;

  const CreatePaymentIntentEvent({
    required this.tier,
    required this.adName,
    required this.description,
    required this.images,
    required this.type,
    required this.advertiser,
    this.link,
    this.location,
    this.stateAddress,
    this.city,
    this.address,
    this.zipCode,
  });

  @override
  List<Object> get props =>
      [tier, adName, description, images, type, advertiser];
}
