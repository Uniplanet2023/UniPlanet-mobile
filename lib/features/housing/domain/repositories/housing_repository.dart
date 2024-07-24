import 'package:uniplanet/features/housing/domain/entities/housing_post.dart';

abstract class HousingRepository {
  Future<List<HousingPost>> getHousingPosts({required int pageNumber});
  Future<List<HousingPost>> fetchMyHousingPosts(
      int pageNumber, String status); // New method
  Future<void> deleteHousingPost(String id); // New method
  Future<HousingPost> fetchHousingPost(String housingId); // New method
}
