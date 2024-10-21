import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/upload/data/data_sources/offer_remote_data_source.dart';
import 'package:uniplanet/features/upload/data/repositories/offer_repository_impl.dart';
import 'package:uniplanet/features/upload/domain/repositories/offer_repository.dart';
import 'package:uniplanet/features/upload/domain/usecases/post_offer_usecase.dart';
import 'package:uniplanet/features/upload/presentation/blocs/offer/offer_bloc.dart';

void setupOffer() {
  // Register Data Sources
  getIt.registerFactory<OfferRemoteDataSource>(
      () => OfferRemoteDataSourceImpl());

  // Register Repositories
  getIt.registerFactory<OfferRepository>(() =>
      OfferRepositoryImpl(remoteDataSource: getIt<OfferRemoteDataSource>()));

  // Register Use Cases
  getIt.registerFactory(() => PostOfferUseCase(getIt<OfferRepository>()));

  // Register Blocs
  getIt.registerLazySingleton(
      () => OfferBloc(postOfferUseCase: getIt<PostOfferUseCase>()));
}
