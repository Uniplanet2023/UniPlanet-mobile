import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class AdsRepository {
  Future<void> createInterstitialAd();
  Future<void> showInterstitialAd();

  void createBannerAd(void Function() setStateCallback);
  void createNativeAd(void Function() setStateCallback);

  String? getInterstitialAdUnitId();
  String? getRewardInterstitialAdUnitId();

  String? getNativeAdUnitId();
  String? getRewardedAdUnitId();
  String? getAdaptiveBannerAdUnitId();
  String? getBannerAdUnitId();

  BannerAdListener createBannerListener(void Function() onAdLoadedCallback);
  NativeAdListener createNativeAdListener(void Function() onAdLoadedCallback);
}
