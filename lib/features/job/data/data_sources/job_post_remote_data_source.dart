import 'package:uniplanet/config/api/server_address.dart';
import 'package:uniplanet/core/helper/dio_helper.dart';
import 'package:uniplanet/features/job/data/models/job_post_model.dart';

class JobPostRemoteDataSource {
  JobPostRemoteDataSource();

  Future<List<JobPostModel>> getJobPosts(int page, int limit) async {
    final response = await DioHelper.instance.dio.get(
      '$productURI/get-job-posts',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
      options: DioHelper.instance.getDioOptions(),
    );

    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => JobPostModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Error fetching job posts');
    }
  }

  Future<void> removeJob(String jobId) async {
    try {
      final response = await DioHelper.instance.dio.delete(
        '$productURI/delete-job/$jobId',
        options: DioHelper.instance.getDioOptions(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to remove job');
      }
    } catch (e) {
      throw Exception('Error removing job: $e');
    }
  }
}
