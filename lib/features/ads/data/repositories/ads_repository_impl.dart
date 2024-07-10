import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:uniplanet/features/ads/domain/repositories/ads_repository.dart';
import 'package:uniplanet/core/utils/utils.dart';

class AdsRepositoryImpl implements AdsRepository {
  InterstitialAd? _interstitialAd;
  BannerAd? bannerAd;
  NativeAd? nativeAd;

  @override
  Future<void> createInterstitialAd() async {
    final String? adUnitId = getInterstitialAdUnitId();

    if (adUnitId == null) {
      log('InterstitialAd unit ID is null');
      return;
    }

    await InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          log('InterstitialAd loaded');
          _interstitialAd = ad;
          _interstitialAd?.setImmersiveMode(true);

          _interstitialAd?.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdShowedFullScreenContent: (InterstitialAd ad) =>
                log('Ad showed fullscreen content.'),
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              log('Ad dismissed fullscreen content.');
              ad.dispose();
              _interstitialAd = null;
            },
            onAdFailedToShowFullScreenContent:
                (InterstitialAd ad, AdError error) {
              log('Ad failed to show fullscreen content: $error');
              ad.dispose();
              _interstitialAd = null;
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          log('InterstitialAd failed to load: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  @override
  Future<void> showInterstitialAd() async {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          log('Ad dismissed');
          ad.dispose();
          createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          log('Ad failed to show: $error');
          ad.dispose();
          createInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }

  @override
  void createBannerAd(void Function() setStateCallback) {
    bannerAd = BannerAd(
      size: AdSize.leaderboard,
      adUnitId: getBannerAdUnitId()!,
      listener: createBannerListener(() {
        setStateCallback();
      }),
      request: const AdRequest(),
    )..load();
  }

  @override
  void createNativeAd(void Function() setStateCallback) {
    nativeAd = NativeAd(
      adUnitId: getNativeAdUnitId()!,
      listener: createNativeAdListener(() {
        setStateCallback();
      }),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
        mainBackgroundColor: Colors.white,
      ),
    )..load();
  }

  @override
  String? getBannerAdUnitId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9923099397206192/2555411269';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9923099397206192/8504321060';
    }
    return null;
  }

  @override
  String? getAdaptiveBannerAdUnitId() {
    if (Platform.isAndroid) {
      // return 'ca-app-pub-3940256099942544/9214589741';
      return 'ca-app-pub-3940256099942544/6300978111'; // test
    } else if (Platform.isIOS) {
      // return 'ca-app-pub-9923099397206192/8504321060';
      return 'ca-app-pub-3940256099942544/2435281174'; //test
    }
    return null;
  }

  @override
  String? getInterstitialAdUnitId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9923099397206192/2990525534';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9923099397206192/9910237232';
    }
    return null;
  }

  @override
  String? getNativeAdUnitId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/2247696110';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/3986624511';
    }
    return null;
  }

  @override
  String? getRewardedAdUnitId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9923099397206192/7675257452';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9923099397206192/6804527904';
    }
    return null;
  }

  @override
  String? getRewardInterstitialAdUnitId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9923099397206192/5937388545';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9923099397206192/3449906131';
    }
    return null;
  }

  @override
  BannerAdListener createBannerListener(void Function() onAdLoadedCallback) {
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

  @override
  NativeAdListener createNativeAdListener(void Function() onAdLoadedCallback) {
    return NativeAdListener(
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
