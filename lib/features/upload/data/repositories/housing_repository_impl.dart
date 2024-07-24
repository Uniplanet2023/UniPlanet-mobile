import 'package:uniplanet/features/upload/domain/entities/housing_post_form.dart';

import '../../domain/entities/housing_post.dart';
import '../../domain/repositories/housing_repository.dart';
import '../data_sources/housing_remote_data_source.dart';
import '../models/housing_post_model.dart';

class HousingRepositoryImpl implements HousingRepository {
  final HousingRemoteDataSource remoteDataSource;

  HousingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<HousingPostModel?> uploadHousingPost(HousingPostForm postForm) async {
    return await remoteDataSource.uploadHousingPost(postForm);
  }

  @override
  Future<HousingPost?> updateHousingPost(HousingPost post) async {
    final postModel = HousingPostModel(
      id: post.id,
      images: post.images,
      title: post.title,
      category: post.category,
      monthlyPayment: post.monthlyPayment,
      isUtilityIncluded: post.isUtilityIncluded,
      securityDeposit: post.securityDeposit,
      gender: post.gender,
      housingConditions: post.housingConditions,
      location: post.location,
      description: post.description,
      seller: post.seller,
      premiumLevel: post.premiumLevel,
    );

    return await remoteDataSource.updateHousingPost(postModel);
  }
}
