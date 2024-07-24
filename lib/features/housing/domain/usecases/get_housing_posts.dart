// lib/domain/usecases/get_housing_posts.dart
import 'package:uniplanet/features/housing/domain/entities/housing_post.dart';
import 'package:uniplanet/features/housing/domain/repositories/housing_repository.dart';

class GetHousingPosts {
  final HousingRepository repository;

  GetHousingPosts(this.repository);

  Future<List<HousingPost>> call({required int pageNumber}) async {
    return await repository.getHousingPosts(pageNumber: pageNumber);
  }
}
