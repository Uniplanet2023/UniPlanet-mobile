import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/home/data/data_sources/ad_remote_data_source.dart';
import 'package:uniplanet/features/home/data/repository/ad_repository_impl.dart';
import 'package:uniplanet/features/home/domain/repository/ad_repository.dart';
import 'package:uniplanet/features/home/domain/use_cases/get_ads_usecase.dart';
import 'package:uniplanet/features/home/presentation/blocs/advertisement/advertisement_bloc.dart';

void initAdvertisement() {
  // Bloc
  getIt
    // Data sources
    ..registerFactory<AdRemoteDataSource>(() => AdRemoteDataSourceImpl())

    // Repository
    ..registerFactory<AdRepository>(
        () => AdRepositoryImpl(remoteDataSource: getIt<AdRemoteDataSource>()))
// Use cases
    ..registerFactory(() => GetAdsUseCase(getIt<AdRepository>()))
    // Bloc
    ..registerLazySingleton(
        () => AdvertisementBloc(getAdsUseCase: getIt<GetAdsUseCase>()));
}
