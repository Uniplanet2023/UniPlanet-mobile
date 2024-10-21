import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/advertiser/data/data_sources/advertisement_remote_data_source.dart';
import 'package:uniplanet/features/advertiser/data/repository/advertisement_repository_impl.dart';
import 'package:uniplanet/features/advertiser/domain/repository/advertisement_repository.dart';
import 'package:uniplanet/features/advertiser/domain/usecases/cancel_subscription_usecase.dart';
import 'package:uniplanet/features/advertiser/domain/usecases/edit_advertisement.dart';
import 'package:uniplanet/features/advertiser/domain/usecases/get_advertisement.dart';
import 'package:uniplanet/features/advertiser/domain/usecases/remove_advertisement.dart';
import 'package:uniplanet/features/advertiser/presentation/blocs/advertisement/advertisement_bloc.dart';

void advertisementSetup() {
  // Registering Data Sources
  getIt.registerFactory<AdvertisementRemoteDataSource>(
      () => AdvertisementRemoteDataSourceImpl());

  // Registering Repositories
  getIt.registerFactory<AdvertisementRepository>(() =>
      AdvertisementRepositoryImpl(
          remoteDataSource: getIt<AdvertisementRemoteDataSource>()));

  // Registering Use Cases
  getIt.registerFactory(
      () => GetAdvertisement(getIt<AdvertisementRepository>()));
  getIt.registerFactory(
      () => EditAdvertisement(getIt<AdvertisementRepository>()));
  getIt.registerFactory(
      () => RemoveAdvertisement(getIt<AdvertisementRepository>()));
  getIt.registerFactory(
      () => CancelSubscriptionUseCase(getIt<AdvertisementRepository>()));

  // Registering BLoC
  getIt.registerLazySingleton(() => MyAdvertisementBloc(
        getAdvertisement: getIt<GetAdvertisement>(),
        editAdvertisement: getIt<EditAdvertisement>(),
        removeAdvertisement: getIt<RemoveAdvertisement>(),
        cancelSubscription: getIt<CancelSubscriptionUseCase>(),
      ));
}
