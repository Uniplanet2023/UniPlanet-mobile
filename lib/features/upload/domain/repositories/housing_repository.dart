import 'package:uniplanet/features/upload/domain/entities/housing_post_form.dart';
import '../entities/housing_post.dart';

abstract class HousingRepository {
  Future<HousingPost?> uploadHousingPost(HousingPostForm post);
  Future<HousingPost?> updateHousingPost(HousingPost post);
}
