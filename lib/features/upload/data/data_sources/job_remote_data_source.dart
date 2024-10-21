import 'package:uniplanet/config/api/server_address.dart';
import 'package:uniplanet/core/helper/dio_helper.dart';
import 'package:uniplanet/features/upload/data/models/job_post_model.dart';

abstract class JobRemoteDataSource {
  Future<void> createJobPost(JobPostModel jobPostModel);
}

class JobRemoteDataSourceImpl implements JobRemoteDataSource {
  JobRemoteDataSourceImpl();
  @override
  Future<void> createJobPost(JobPostModel jobPostModel) async {
    try {
      final response = await DioHelper.instance.dio.post('$productURI/post-job',
          data: jobPostModel.toJson(),
          options: DioHelper.instance.getDioOptions());

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Failed to create job post');
      }
    } catch (e) {
      throw Exception('Error creating job post: $e');
    }
  }
}
