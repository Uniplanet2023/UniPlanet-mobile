import 'package:dio/dio.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/job/data/data_sources/job_post_remote_data_source.dart';
import 'package:uniplanet/features/job/data/repositories/job_post_repository_impl.dart';
import 'package:uniplanet/features/job/domain/repositories/job_post_repository.dart';
import 'package:uniplanet/features/job/domain/usecases/get_job_posts.dart';
import 'package:uniplanet/features/job/domain/usecases/remove_job_post_usecase.dart';
import 'package:uniplanet/features/job/presentation/blocs/job_post/job_post_bloc.dart';

void jobPostSetup() {
  // Register Dio (HTTP client)
  getIt.registerFactory<Dio>(() => Dio());

  // Register Remote Data Source
  getIt.registerFactory<JobPostRemoteDataSource>(
      () => JobPostRemoteDataSource());

  // Register Repository
  getIt.registerFactory<JobPostRepository>(
      () => JobPostRepositoryImpl(getIt<JobPostRemoteDataSource>()));

  // Register Use Case
  getIt.registerFactory<GetJobPosts>(
      () => GetJobPosts(getIt<JobPostRepository>()));
  getIt.registerFactory<RemoveJobUseCase>(
      () => RemoveJobUseCase(getIt<JobPostRepository>()));
  // Register BLoC
  getIt.registerLazySingleton<JobPostBloc>(() => JobPostBloc(
      getJobPosts: getIt<GetJobPosts>(),
      removeJobPost: getIt<RemoveJobUseCase>()));
}
