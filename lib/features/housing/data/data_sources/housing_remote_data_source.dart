import 'package:uniplanet/config/api/server_address.dart';
import 'package:uniplanet/core/error/exceptions.dart';
import 'package:uniplanet/core/helper/dio_helper.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/features/housing/data/models/housing_post_model.dart';

abstract class HousingRemoteDataSource {
  Future<List<HousingPostModel>> getHousingPosts({required int pageNumber});
  Future<List<HousingPostModel>> fetchMyHousingPosts(
      {required int pageNumber, required String status});
  Future<void> deleteHousingPost(String id);
  Future<HousingPostModel> fetchHousingPost(String housingId); // New method
}

class HousingRemoteDataSourceImpl implements HousingRemoteDataSource {
  HousingRemoteDataSourceImpl();

  @override
  Future<List<HousingPostModel>> getHousingPosts(
      {required int pageNumber}) async {
    try {
      final response =
          await DioHelper.instance.dio.get('$productURI/get-recent-housing',
              queryParameters: {
                'limit': 10,
                'pageNumber': pageNumber,
              },
              options: DioHelper.instance.getDioOptions());
      if (response.statusCode == 200) {
        final List data = response.data['posts'];
        final List<HousingPostModel> housingPostList =
            data.map((item) => HousingPostModel.fromJson(item)).toList();
        return housingPostList;
      } else {
        throw Exception('Failed to fetch housing posts');
      }
    } catch (e) {
      log(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<HousingPostModel>> fetchMyHousingPosts(
      {required int pageNumber, required String status}) async {
    try {
      final response =
          await DioHelper.instance.dio.get('$productURI/get-my-housing/$status',
              queryParameters: {
                'limit': 10,
                'pageNumber': pageNumber,
              },
              options: DioHelper.instance.getDioOptions());
      if (response.statusCode == 200) {
        final List data = response.data['posts'];
        final List<HousingPostModel> housingPostList =
            data.map((item) => HousingPostModel.fromJson(item)).toList();
        return housingPostList;
      } else {
        throw Exception('Failed to fetch my housing posts');
      }
    } catch (e) {
      log(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteHousingPost(String id) async {
    try {
      final response = await DioHelper.instance.dio.delete(
          '$productURI/delete-housing/$id',
          options: DioHelper.instance.getDioOptions());
      if (response.statusCode != 200) {
        throw Exception('Failed to delete housing post');
      }
    } catch (e) {
      log(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<HousingPostModel> fetchHousingPost(String housingId) async {
    try {
      final response = await DioHelper.instance.dio.get(
          '$productURI/get-housing/$housingId',
          options: DioHelper.instance.getDioOptions());
      if (response.statusCode == 201) {
        return HousingPostModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch housing post');
      }
    } catch (e) {
      log(e);
      throw ServerException(e.toString());
    }
  }
}
