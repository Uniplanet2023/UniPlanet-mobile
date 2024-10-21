import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/upload/data/data_sources/job_remote_data_source.dart';
import 'package:uniplanet/features/upload/data/repositories/job_repository_impl.dart';
import 'package:uniplanet/features/upload/domain/repositories/job_repository.dart';
import 'package:uniplanet/features/upload/domain/usecases/post_job_usecase.dart';
import 'package:uniplanet/features/upload/presentation/blocs/job/job_bloc.dart';

void jobSetup() {
  // Register the data source
  getIt
    ..registerFactory<JobRemoteDataSource>(() => JobRemoteDataSourceImpl())
    ..registerFactory<JobRepository>(
        () => JobRepositoryImpl(remoteDataSource: getIt<JobRemoteDataSource>()))
    ..registerFactory(() => CreateJobPost(getIt<JobRepository>()))
    ..registerLazySingleton(() => JobBloc(
          createJobPost: getIt<CreateJobPost>(),
        ));
}
