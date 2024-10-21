// lib/data/repositories/banner_repository_impl.dart
import 'package:uniplanet/features/home/data/data_sources/ad_remote_data_source.dart';
import 'package:uniplanet/features/home/data/models/ad_model.dart';
import 'package:uniplanet/features/home/domain/repository/ad_repository.dart';

class AdRepositoryImpl implements AdRepository {
  final AdRemoteDataSource remoteDataSource;

  AdRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AdModel>> getAds({required String type}) async {
    return await remoteDataSource.getAds(type: type);
  }
}
