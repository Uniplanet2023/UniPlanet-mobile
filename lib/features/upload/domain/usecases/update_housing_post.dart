import '../entities/housing_post.dart';
import '../repositories/housing_repository.dart';

class UpdateHousingPost {
  final HousingRepository repository;

  UpdateHousingPost(this.repository);

  Future<HousingPost?> call(HousingPost post) async {
    return await repository.updateHousingPost(post);
  }
}
