import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/account/data/data_sources/advertiser_data_source.dart';
import 'package:uniplanet/features/account/data/repository/advertiser_repository_impl.dart';
import 'package:uniplanet/features/account/domain/repository/advertiser_repository.dart';
import 'package:uniplanet/features/account/domain/usecases/advertiser_usecases/get_ad_interaction_usecase.dart';
import 'package:uniplanet/features/account/domain/usecases/advertiser_usecases/get_ad_statistic_usecase.dart';
import 'package:uniplanet/features/account/domain/usecases/advertiser_usecases/get_advertiser_info_usecase.dart';
import 'package:uniplanet/features/account/domain/usecases/advertiser_usecases/get_user_interaction_info_usecase.dart';
import 'package:uniplanet/features/account/presentation/blocs/advertiser/advertiser_bloc.dart';

void advertiserInjectionSetup() {
  // Registering Data Sources
  getIt.registerFactory<AdvertiserDataSource>(() => AdvertiserDataSourceImpl());

  // Registering AdvertiserRepository
  getIt.registerFactory<AdvertiserRepository>(
      () => AdvertiserRepositoryImpl(getIt<AdvertiserDataSource>()));

  // Registering Advertiser Use Cases
  getIt.registerFactory(
      () => GetAdInteractionUsecase(getIt<AdvertiserRepository>()));
  getIt.registerFactory(
      () => GetAdStatisticUsecase(getIt<AdvertiserRepository>()));
  getIt.registerFactory(
      () => GetAdvertiserInfoUsecase(getIt<AdvertiserRepository>()));
  getIt.registerFactory(
      () => GetUserInteractionInfoUsecase(getIt<AdvertiserRepository>()));

  // Registering Advertiser Bloc
  getIt.registerLazySingleton(
    () => AdvertiserBloc(
      getAdInteractionUsecase: getIt<GetAdInteractionUsecase>(),
      getAdStatisticUsecase: getIt<GetAdStatisticUsecase>(),
      getAdvertiserInfoUsecase: getIt<GetAdvertiserInfoUsecase>(),
      getUserInteractionInfoUsecase: getIt<GetUserInteractionInfoUsecase>(),
    ),
  );
}
