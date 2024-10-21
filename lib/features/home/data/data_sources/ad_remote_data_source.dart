// lib/data/datasources/banner_remote_data_source.dart

import 'package:uniplanet/config/api/server_address.dart';
import 'package:uniplanet/core/network/repository/index.dart';

import '../models/ad_model.dart';

abstract class AdRemoteDataSource {
  Future<List<AdModel>> getAds({required String type});
}

class AdRemoteDataSourceImpl implements AdRemoteDataSource {
  AdRemoteDataSourceImpl();

  @override
  Future<List<AdModel>> getAds({required String type}) async {
    final response = await DioHelper.instance.dio.get(
      '$productURI/get-ads',
      queryParameters: {'type': type},
      options: DioHelper.instance.getDioOptions(),
    );

    if (response.statusCode == 200) {
      // Assuming the response data is a list of maps
      final List<dynamic> jsonList = response.data;

      // Convert each map in the list to a AdAdModel and return the list
      return jsonList.map((data) => AdModel.fromMap(data)).toList();
    } else {
      throw Exception('Failed to load banner ads');
    }
  }
}
