// lib/data/datasources/banner_remote_data_source.dart

import 'package:uniplanet/config/api/server_address.dart';
import 'package:uniplanet/core/network/repository/index.dart';

import '../models/banner_ad_model.dart';

abstract class BannerRemoteDataSource {
  Future<List<BannerAdModel>> getBannerAds();
}

class BannerRemoteDataSourceImpl implements BannerRemoteDataSource {
  BannerRemoteDataSourceImpl();

  @override
  Future<List<BannerAdModel>> getBannerAds() async {
    final response = await DioHelper.instance.dio.get(
      '$productURI/get-ads',
      queryParameters: {'type': 'Banner Ads'},
      options: DioHelper.instance.getDioOptions(),
    );

    if (response.statusCode == 200) {
      // Assuming the response data is a list of maps
      final List<dynamic> jsonList = response.data;

      // Convert each map in the list to a BannerAdModel and return the list
      return jsonList.map((data) => BannerAdModel.fromMap(data)).toList();
    } else {
      throw Exception('Failed to load banner ads');
    }
  }
}
