import 'package:uniplanet/features/ads/domain/repositories/ads_repository.dart';

class CreateNativeAd {
  final AdsRepository repository;

  CreateNativeAd(this.repository);

  void call(void Function() setStateCallback) {
    repository.createNativeAd(setStateCallback);
  }
}
