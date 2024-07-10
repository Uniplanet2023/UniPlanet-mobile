import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet/features/ads/domain/use_cases/create_banner_ad.dart';
import 'package:uniplanet/features/ads/domain/use_cases/create_interstitial_ad.dart';
import 'package:uniplanet/features/ads/domain/use_cases/create_native_ad.dart';
import 'package:uniplanet/features/ads/domain/use_cases/show_interstitial_ad.dart';

part 'ads_event.dart';
part 'ads_state.dart';

class AdsBloc extends Bloc<AdsEvent, AdsState> {
  final CreateInterstitialAd createInterstitialAd;
  final ShowInterstitialAd showInterstitialAd;
  final CreateBannerAd createBannerAd;
  final CreateNativeAd createNativeAd;

  AdsBloc({
    required this.createInterstitialAd,
    required this.showInterstitialAd,
    required this.createBannerAd,
    required this.createNativeAd,
  }) : super(AdsInitial()) {
    on(_onLoadInterstitialAd);
    on(_onShowInterstitialAd);
    on(_onLoadBannerAd);
    on(_onLoadNativeAd);
  }

  Future _onLoadInterstitialAd(
      LoadInterstitialAdEvent event, Emitter emit) async {
    emit(AdsLoading());
    try {
      await createInterstitialAd();
      emit(AdsLoaded());
    } catch (e) {
      emit(AdsError(e.toString()));
    }
  }

  Future _onShowInterstitialAd(
      ShowInterstitialAdEvent event, Emitter emit) async {
    try {
      await showInterstitialAd();
    } catch (e) {
      emit(AdsError(e.toString()));
    }
  }

  void _onLoadBannerAd(LoadBannerAdEvent event, Emitter emit) {
    createBannerAd(event.setStateCallback);
  }

  void _onLoadNativeAd(LoadNativeAdEvent event, Emitter emit) {
    createNativeAd(event.setStateCallback);
  }
}
