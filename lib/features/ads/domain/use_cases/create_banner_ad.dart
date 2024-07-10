//create banner
import 'package:uniplanet/features/ads/domain/repositories/ads_repository.dart';

class CreateBannerAd {
  final AdsRepository adsRepository;

  CreateBannerAd(this.adsRepository);

  void call(void Function() setStateCallback) {
    adsRepository.createBannerAd(setStateCallback);
  }
}
