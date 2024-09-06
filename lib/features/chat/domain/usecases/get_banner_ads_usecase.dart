// lib/domain/usecases/get_banner_ads_usecase.dart
import 'package:uniplanet/features/chat/domain/repository/banner_repository.dart';
import '../entities/banner_ad.dart';

class GetBannerAdsUseCase {
  final BannerRepository repository;

  GetBannerAdsUseCase(this.repository);

  Future<List<BannerAd>> call() async {
    return await repository.getBannerAds();
  }
}
