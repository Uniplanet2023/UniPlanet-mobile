// data/repositories/payment_repository_impl.dart
import 'dart:io';

import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/features/upload/data/data_sources/stripe_remote_data_source.dart';
import 'package:uniplanet/features/upload/data/models/payment_intent_model.dart';
import 'package:uniplanet/features/upload/domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final StripeRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaymentIntentModel> createPaymentIntent({
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
  }) async {
    return await remoteDataSource.createPaymentIntent(
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
