// data/models/payment_intent_model.dart
import 'package:uniplanet/features/upload/domain/entities/payment_intent.dart';

class PaymentIntentModel extends PaymentIntentEntity {
  PaymentIntentModel({
    required super.clientSecret,
    required super.token,
  });

  factory PaymentIntentModel.fromJson(Map<String, dynamic> json) {
    return PaymentIntentModel(
      clientSecret: json['clientSecret'],
      token: json['token'],
    );
  }
}
