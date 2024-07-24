import 'package:get_it/get_it.dart';
import 'package:uniplanet/features/ads/data/repositories/ads_repository_impl.dart';
import 'package:uniplanet/features/ads/domain/repositories/ads_repository.dart';
import 'package:uniplanet/features/ads/domain/use_cases/index.dart';
import 'package:uniplanet/features/ads/presentation/bloc/ads_bloc.dart';

final getIt = GetIt.instance;

void setupAds() {
  // Register services
  getIt
    ..registerFactory<AdsRepository>(() => AdsRepositoryImpl())
    // Register use cases
    ..registerFactory<CreateInterstitialAd>(
        () => CreateInterstitialAd(getIt<AdsRepository>()))
    ..registerFactory<ShowInterstitialAd>(
        () => ShowInterstitialAd(getIt<AdsRepository>()))
    ..registerFactory<CreateBannerAd>(
        () => CreateBannerAd(getIt<AdsRepository>()))
    ..registerFactory<CreateNativeAd>(
        () => CreateNativeAd(getIt<AdsRepository>()))
    // Register Blocs
    ..registerLazySingleton(() => AdsBloc(
          createInterstitialAd: getIt<CreateInterstitialAd>(),
          showInterstitialAd: getIt<ShowInterstitialAd>(),
          createBannerAd: getIt<CreateBannerAd>(),
          createNativeAd: getIt<CreateNativeAd>(),
        ));
}
