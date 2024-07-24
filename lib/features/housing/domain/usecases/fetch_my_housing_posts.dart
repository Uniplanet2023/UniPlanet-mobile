import 'package:uniplanet/features/housing/domain/entities/housing_post.dart';
import 'package:uniplanet/features/housing/domain/repositories/housing_repository.dart';

class FetchMyHousingPosts {
  final HousingRepository repository;

  FetchMyHousingPosts(this.repository);

  Future<List<HousingPost>> call(
      {required int pageNumber, required String status}) {
    return repository.fetchMyHousingPosts(pageNumber, status);
  }
}
