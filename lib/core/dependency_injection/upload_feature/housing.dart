import 'package:get_it/get_it.dart';
import 'package:uniplanet/features/upload/data/data_sources/housing_remote_data_source.dart';
import 'package:uniplanet/features/upload/data/repositories/housing_repository_impl.dart';
import 'package:uniplanet/features/upload/domain/repositories/housing_repository.dart';
import 'package:uniplanet/features/upload/domain/usecases/update_housing_post.dart';
import 'package:uniplanet/features/upload/domain/usecases/upload_housing_post.dart';
import 'package:uniplanet/features/upload/presentation/blocs/housing/housing_bloc.dart';

final getIt = GetIt.instance;

void setupHousing() {
  getIt
    // Data sources
    ..registerFactory<HousingRemoteDataSource>(
        () => HousingRemoteDataSourceImpl())
    // Repositories
    ..registerFactory<HousingRepository>(() => HousingRepositoryImpl(
        remoteDataSource: getIt<HousingRemoteDataSource>()))
    // Use cases
    ..registerFactory(() => UploadHousingPost(getIt<HousingRepository>()))
    ..registerFactory(() => UpdateHousingPost(getIt<HousingRepository>()))
    // Register Blocs
    ..registerLazySingleton(() => HousingBloc(
          uploadHousingPost: getIt<UploadHousingPost>(),
          updateHousingPost: getIt<UpdateHousingPost>(),
        ));
}
