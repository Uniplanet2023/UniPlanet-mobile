import 'package:uniplanet/features/ads/domain/repositories/ads_repository.dart';

class CreateInterstitialAd {
  final AdsRepository repository;

  CreateInterstitialAd(this.repository);

  Future<void> call() async {
    await repository.createInterstitialAd();
  }
}
