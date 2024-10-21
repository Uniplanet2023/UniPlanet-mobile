import 'package:uniplanet/features/job/domain/entities/job_post.dart';
import 'package:uniplanet/features/job/domain/repositories/job_post_repository.dart';

class GetJobPosts {
  final JobPostRepository repository;

  GetJobPosts(this.repository);

  Future<List<JobPost>> call(int page, int limit) {
    return repository.getJobPosts(page, limit);
  }
}
