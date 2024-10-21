import 'package:uniplanet/features/upload/data/data_sources/job_remote_data_source.dart';
import 'package:uniplanet/features/upload/data/models/job_post_model.dart';
import 'package:uniplanet/features/upload/domain/entities/job.dart';
import 'package:uniplanet/features/upload/domain/repositories/job_repository.dart';

class JobRepositoryImpl implements JobRepository {
  final JobRemoteDataSource remoteDataSource;

  JobRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createJobPost(JobPost post) async {
    // Convert the domain entity `JobPost` to `JobPostModel`
    final jobPostModel = JobPostModel(
      title: post.title,
      applyEmail: post.applyEmail,
      applyLink: post.applyLink,
      companyName: post.companyName,
      qualifications: post.qualifications,
      description: post.description,
      jobType: post.jobType,
      experienceLevel: post.experienceLevel,
      educationLevel: post.educationLevel,
      salary: post.salary,
      jobIndustry: post.jobIndustry,
      companyImage: post.companyImage,
      companyDescription: post.companyDescription,
      stateAddress: post.stateAddress,
      city: post.city,
      address: post.address,
      zipCode: post.zipCode,
    );

    // Call the remote data source to create the job post
    await remoteDataSource.createJobPost(jobPostModel);
  }
}
