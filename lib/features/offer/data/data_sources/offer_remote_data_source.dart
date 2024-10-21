import 'package:uniplanet/config/api/server_address.dart';
import 'package:uniplanet/core/network/repository/index.dart';

import '../models/offer_model.dart';

abstract class OfferRemoteDataSource {
  Future<List<OfferModel>> getOffers(int page, int limit);
  Future<void> deleteOffer(String offerId);
}

class OfferRemoteDataSourceImpl implements OfferRemoteDataSource {
  OfferRemoteDataSourceImpl();
  @override

  // This method is used to delete an offer from the server
  Future<void> deleteOffer(String offerId) async {
    try {
      final response = await DioHelper.instance.dio.delete(
        '$productURI/delete-offer/$offerId', // Your API endpoint
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete offer');
      }
    } catch (e) {
      throw Exception('Error deleting offer: $e');
    }
  }

  @override
  Future<List<OfferModel>> getOffers(int page, int limit) async {
    final response = await DioHelper.instance.dio.get(
      '$productURI/get-offers', // Your API endpoint
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );

    if (response.statusCode == 200) {
      // Cast the response data as a list of dynamic (JSON objects)
      List<dynamic> jsonResponse = response.data;

      // Convert each JSON object into an OfferModel
      return jsonResponse
          .map((offerJson) => OfferModel.fromJson(offerJson))
          .toList();
    } else {
      throw Exception('Failed to load offers');
    }
  }
}
