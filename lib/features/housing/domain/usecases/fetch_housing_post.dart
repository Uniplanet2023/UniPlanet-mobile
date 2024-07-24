import 'package:uniplanet/features/housing/domain/entities/housing_post.dart';
import 'package:uniplanet/features/housing/domain/repositories/housing_repository.dart';

class FetchHousingPost {
  final HousingRepository repository;

  FetchHousingPost(this.repository);

  Future<HousingPost> call(String housingId) async {
    return await repository.fetchHousingPost(housingId);
  }
}
