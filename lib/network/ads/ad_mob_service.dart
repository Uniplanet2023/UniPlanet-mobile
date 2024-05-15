// import 'dart:io';

// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:uniplanet/constants/utils.dart';

// class AdMobService {
//   static String? get bannerAdUnitId {
//     if (Platform.isAndroid) {
//       return 'ca-app-pub-3940256099942544/2435281174';
//     } else if (Platform.isIOS) {
//       return 'ca-app-pub-3940256099942544/2435281174';
//     }
//     return null;
//   }

//   static String? get interstitialAdUnitId {
//     if (Platform.isAndroid) {
//       return 'ca-app-pub-3940256099942544/1033173712';
//     } else if (Platform.isIOS) {
//       return 'ca-app-pub-3940256099942544/1033173712';
//     }
//     return null;
//   }

//   static String? get rewardedAdUnitId {
//     if (Platform.isAndroid) {
//       return 'ca-app-pub-3940256099942544/5224354917';
//     } else if (Platform.isIOS) {
//       return 'ca-app-pub-3940256099942544/5224354917';
//     }
//     return null;
//   }

//   static final BannerAdListener bannerListener = BannerAdListener(
//     onAdLoaded: (Ad ad) => log('Ad loaded: $ad'),
//     onAdFailedToLoad: (Ad ad, LoadAdError error) {
//       ad.dispose();
//       log('Ad failed to load: $error');
//     },
//     onAdOpened: (Ad ad) => log('Ad opened: $ad'),
//     onAdClosed: (Ad ad) => log('Ad closed: $ad'),
//   );
// }
