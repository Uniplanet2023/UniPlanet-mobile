import 'package:uniplanet/features/ads/domain/repositories/ads_repository.dart';

class ShowInterstitialAd {
  final AdsRepository repository;

  ShowInterstitialAd(this.repository);

  Future<void> call() async {
    await repository.showInterstitialAd();
  }
}
