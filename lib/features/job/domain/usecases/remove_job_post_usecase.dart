// remove_job_usecase.dart

import 'package:uniplanet/features/job/domain/repositories/job_post_repository.dart';

class RemoveJobUseCase {
  final JobPostRepository jobRepository;

  RemoveJobUseCase(this.jobRepository);

  Future<void> call(String jobId) async {
    return await jobRepository.removeJob(jobId);
  }
}
