import 'dart:math';

import 'package:uniplanet/config/api/server_address.dart';
import 'package:uniplanet/core/helper/dio_helper.dart';
import 'package:uniplanet/core/helper/image_upload_helper.dart';
import 'package:uniplanet/features/upload/data/models/offer_post_model.dart';
import 'package:uuid/uuid.dart';

abstract class OfferRemoteDataSource {
  Future<void> postOffer(OfferModel offerModel);
}

class OfferRemoteDataSourceImpl implements OfferRemoteDataSource {
  OfferRemoteDataSourceImpl();

  @override
  Future<void> postOffer(OfferModel offerModel) async {
    try {
      var uuid = Uuid(); // Initialize the UUID generator

      // Generate a unique random ID
      String randomId = uuid.v4(); // v4 generates a random UUID

      List<String> imageList = ImageUploadHelper.instance.getImagesUrl(
        images: offerModel.images,
        path: 'offer-images/${offerModel.companyName}/$randomId',
      );

      // Construct the API endpoint
      final response = await DioHelper.instance.dio.post(
        '$productURI/post-offer', // Update with your API endpoint
        data: offerModel.toJson()
          ..addAll({
            'images': imageList,
          }),
        options: DioHelper.instance
            .getDioOptions(), // Use Dio options from DioHelper
      );

      await ImageUploadHelper.instance.uploadImagesAtFirebase(
        images: offerModel.images,
        path: 'offer-images/${offerModel.companyName}/$randomId',
      );
      // Check if the response is not successful
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Failed to post offer');
      }
    } catch (e) {
      throw Exception('Error posting offer: $e');
    }
  }
}
