import 'package:uniplanet/features/upload/domain/entities/job.dart';
import 'package:uniplanet/features/upload/domain/repositories/job_repository.dart';

class CreateJobPost {
  final JobRepository repository;

  CreateJobPost(this.repository);

  Future<void> call(JobPost post) async {
    return await repository.createJobPost(post);
  }
}
