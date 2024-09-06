import 'dart:io';

import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/features/upload/domain/entities/payment_intent.dart';
import 'package:uniplanet/features/upload/domain/repositories/payment_repository.dart';

class CreatePaymentIntent {
  final PaymentRepository repository;

  CreatePaymentIntent(this.repository);

  Future<PaymentIntentEntity> call({
    required double amount,
    required String adName,
    required String type,
    required List<File> images,
    required User advertiser,
    String? streetAddress,
    String? description,
    String? link,
    String? location,
    String? city,
    String? address,
    String? zipCode,
  }) {
    return repository.createPaymentIntent(
        adName: adName,
        amount: amount,
        type: type,
        images: images,
        advertiser: advertiser,
        streetAddress: streetAddress,
        description: description,
        link: link,
        location: location,
        city: city,
        address: address,
        zipCode: zipCode);
  }
}
