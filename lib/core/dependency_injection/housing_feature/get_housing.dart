// lib/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:uniplanet/features/housing/data/data_sources/housing_remote_data_source.dart';
import 'package:uniplanet/features/housing/data/repositories/housing_repository_impl.dart';
import 'package:uniplanet/features/housing/domain/repositories/housing_repository.dart';
import 'package:uniplanet/features/housing/domain/usecases/delete_housing_post.dart';
import 'package:uniplanet/features/housing/domain/usecases/fetch_housing_post.dart';
import 'package:uniplanet/features/housing/domain/usecases/fetch_my_housing_posts.dart';
import 'package:uniplanet/features/housing/domain/usecases/get_housing_posts.dart';
import 'package:uniplanet/features/housing/presentation/housing/housing_bloc.dart';

final getIt = GetIt.instance;

void initGetHouse() {
  // Bloc
  getIt
    // Data sources
    ..registerFactory<HousingRemoteDataSource>(
        () => HousingRemoteDataSourceImpl())

    // Repository
    ..registerFactory<HousingRepository>(() => HousingRepositoryImpl(
        remoteDataSource: getIt<HousingRemoteDataSource>()))
// Use cases
    ..registerFactory(() => GetHousingPosts(getIt<HousingRepository>()))
    ..registerFactory(() => FetchMyHousingPosts(getIt<HousingRepository>()))
    ..registerFactory(() => DeleteHousingPost(getIt<HousingRepository>()))
    ..registerFactory(() => FetchHousingPost(getIt<HousingRepository>()))
    // Bloc
    ..registerLazySingleton(() => GetHousingBloc(
        getIt<GetHousingPosts>(),
        getIt<FetchMyHousingPosts>(),
        getIt<DeleteHousingPost>(),
        getIt<FetchHousingPost>()));
}
