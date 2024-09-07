// data/datasources/stripe_remote_data_source.dart
import 'dart:async';
import 'dart:io';

import 'package:uniplanet/config/api/server_address.dart';
import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/core/network/repository/index.dart';
import 'package:uniplanet/core/network/storage/image_upload_service.dart';
import 'package:uniplanet/features/upload/data/models/payment_intent_model.dart';

abstract class StripeRemoteDataSource {
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
  });
}

class StripeRemoteDataSourceImpl implements StripeRemoteDataSource {
  StripeRemoteDataSourceImpl();

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
    var secureUrl = await MediaUploadService()
        .uploadRawImage(
      images[0],
      'ads-images/${advertiser.school}/${advertiser.id}',
    )
        .timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw TimeoutException('Image uploading timed out');
      },
    );

    final response = await DioHelper.instance.dio.get(
      '$productURI/ad-payment',
      data: {
        'amount': (amount * 100).toDouble(), // convert to cents
        'adName': adName,
        'type': type,
        'images': [secureUrl],
        'advertiser': advertiser,
        'streetAddress': streetAddress,
        'description': description,
        'link': link,
        'location': location,
        'city': city,
        'address': address,
        'zipCode': zipCode,
      },
      options: DioHelper.instance.getDioOptions(),
    );
    return PaymentIntentModel.fromJson(response.data);
  }
}
