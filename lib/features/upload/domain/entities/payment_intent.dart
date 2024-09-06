// domain/entities/payment_intent.dart
class PaymentIntentEntity {
  final String clientSecret;
  final String token;

  PaymentIntentEntity({required this.clientSecret, required this.token});
}
