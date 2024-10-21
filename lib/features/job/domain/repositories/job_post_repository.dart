import 'package:uniplanet/features/job/domain/entities/job_post.dart';

abstract class JobPostRepository {
  Future<List<JobPost>> getJobPosts(int page, int limit);
  Future<void> removeJob(String jobId);
}
