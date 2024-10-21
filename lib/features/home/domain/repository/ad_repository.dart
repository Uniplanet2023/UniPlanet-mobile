//BannerRepository
import '../entities/advertisement.dart';

abstract class AdRepository {
  Future<List<Advertisement>> getAds({required String type});
}
