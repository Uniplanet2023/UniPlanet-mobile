import 'package:uniplanet/features/upload/domain/entities/job.dart';

abstract class JobRepository {
  Future<void> createJobPost(JobPost post);
}
