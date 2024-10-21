import 'package:uniplanet/features/job/data/data_sources/job_post_remote_data_source.dart';
import 'package:uniplanet/features/job/data/models/job_post_model.dart';
import 'package:uniplanet/features/job/domain/repositories/job_post_repository.dart';

class JobPostRepositoryImpl implements JobPostRepository {
  final JobPostRemoteDataSource remoteDataSource;

  JobPostRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<JobPostModel>> getJobPosts(int page, int limit) async {
    return await remoteDataSource.getJobPosts(page, limit);
  }

  @override
  Future<void> removeJob(String jobId) async {
    return await remoteDataSource.removeJob(jobId);
  }
}
