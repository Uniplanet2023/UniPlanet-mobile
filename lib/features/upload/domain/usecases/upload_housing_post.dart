import 'package:uniplanet/features/upload/domain/entities/housing_post.dart';
import 'package:uniplanet/features/upload/domain/entities/housing_post_form.dart';

import '../repositories/housing_repository.dart';

class UploadHousingPost {
  final HousingRepository repository;

  UploadHousingPost(this.repository);

  Future<HousingPost?> call(HousingPostForm post) async {
    return await repository.uploadHousingPost(post);
  }
}
