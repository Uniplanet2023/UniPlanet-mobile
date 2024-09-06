// lib/data/repositories/banner_repository_impl.dart
import 'package:uniplanet/features/chat/domain/repository/banner_repository.dart';

import '../../domain/entities/banner_ad.dart';
import '../datasources/banner_remote_data_source.dart';

class BannerRepositoryImpl implements BannerRepository {
  final BannerRemoteDataSource remoteDataSource;

  BannerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<BannerAd>> getBannerAds() async {
    return await remoteDataSource.getBannerAds();
  }
}
