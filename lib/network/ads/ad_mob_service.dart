import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:uniplanet/constants/utils.dart';

class AdMobService {
  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9923099397206192/2555411269';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9923099397206192/8504321060';
    }
    return null;
  }

  static String? get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9923099397206192/2990525534';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9923099397206192/9910237232';
    }
    return null;
  }

  // static String? get rewardedAdUnitId {
  //   if (Platform.isAndroid) {
  //     return '';
  //   } else if (Platform.isIOS) {
  //     return '';
  //   }
  //   return null;
  // }

  static BannerAdListener createBannerListener(
      void Function() onAdLoadedCallback) {
    return BannerAdListener(
      onAdLoaded: (Ad ad) {
        onAdLoadedCallback();
      },
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
        log('Ad failed to load: $error');
      },
      onAdOpened: (Ad ad) => log('Ad opened: $ad'),
      onAdClosed: (Ad ad) => log('Ad closed: $ad'),
    );
  }
}
