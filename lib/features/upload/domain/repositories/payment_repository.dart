// domain/repositories/payment_repository.dart
import 'dart:io';

import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/features/upload/domain/entities/payment_intent.dart';

abstract class PaymentRepository {
  Future<PaymentIntentEntity> createPaymentIntent({
    required String tier,
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
  });
}
