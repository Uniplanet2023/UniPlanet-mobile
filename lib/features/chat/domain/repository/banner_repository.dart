//BannerRepository
import '../entities/banner_ad.dart';

abstract class BannerRepository {
  Future<List<BannerAd>> getBannerAds();
}
