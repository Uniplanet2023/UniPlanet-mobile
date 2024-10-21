import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/chat/data/datasources/banner_remote_data_source.dart';
import 'package:uniplanet/features/chat/data/repositories/banner_repository_impl.dart';
import 'package:uniplanet/features/chat/domain/repository/banner_repository.dart';
import 'package:uniplanet/features/chat/domain/usecases/get_banner_ads_usecase.dart';
import 'package:uniplanet/features/chat/presentation/blocs/banner/banner_bloc.dart';

void bannerInit() {
  // Use cases
  getIt.registerFactory(() => GetBannerAdsUseCase(getIt()));

  // Repository
  getIt.registerFactory<BannerRepository>(
    () => BannerRepositoryImpl(remoteDataSource: getIt()),
  );

  // Data sources
  getIt.registerFactory<BannerRemoteDataSource>(
    () => BannerRemoteDataSourceImpl(),
  );
  // Bloc
  getIt.registerLazySingleton(() => BannerBloc(
        getBannerAdsUseCase: getIt<GetBannerAdsUseCase>(),
      ));
}
