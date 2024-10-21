import 'package:get_it/get_it.dart';
import 'package:uniplanet/features/offer/data/data_sources/offer_remote_data_source.dart';
import 'package:uniplanet/features/offer/data/repositories/offer_repository_impl.dart';
import 'package:uniplanet/features/offer/domain/repositories/offer_repository.dart';
import 'package:uniplanet/features/offer/domain/usecases/delete_offer_usecase.dart';
import 'package:uniplanet/features/offer/domain/usecases/get_offers_usecase.dart';
import 'package:uniplanet/features/offer/presentation/blocs/offer/offer_bloc.dart';

final getIt = GetIt.instance;

Future<void> getOfferInit() async {
  // Bloc
  getIt.registerLazySingleton(() =>
      GetOfferBloc(getOffersUseCase: getIt(), deleteOfferUseCase: getIt()));

  // Use cases
  getIt.registerFactory(() => GetOffersUseCase(getIt()));
  getIt.registerFactory(() => DeleteOfferUseCase(getIt()));

  // Repository
  getIt.registerFactory<OfferRepository>(
      () => OfferRepositoryImpl(remoteDataSource: getIt()));

  // Data sources
  getIt.registerFactory<OfferRemoteDataSource>(
      () => OfferRemoteDataSourceImpl());
}
