// lib/data/repositories/housing_repository_impl.dart

import 'package:uniplanet/features/housing/data/data_sources/housing_remote_data_source.dart';
import 'package:uniplanet/features/housing/data/models/housing_post_model.dart';
import 'package:uniplanet/features/housing/domain/repositories/housing_repository.dart';

class HousingRepositoryImpl implements HousingRepository {
  final HousingRemoteDataSource remoteDataSource;

  HousingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<HousingPostModel>> getHousingPosts(
      {required int pageNumber}) async {
    return await remoteDataSource.getHousingPosts(pageNumber: pageNumber);
  }

  @override
  Future<List<HousingPostModel>> fetchMyHousingPosts(
      int pageNumber, String status) async {
    final housingPostModels = await remoteDataSource.fetchMyHousingPosts(
        pageNumber: pageNumber, status: status);
    return housingPostModels.map((model) => model).toList();
  }

  @override
  Future<void> deleteHousingPost(String id) async {
    await remoteDataSource.deleteHousingPost(id);
  }

  @override
  Future<HousingPostModel> fetchHousingPost(String housingId) async {
    return await remoteDataSource.fetchHousingPost(housingId);
  }
}
