import 'package:uniplanet/config/api/server_address.dart';
import 'package:uniplanet/core/network/repository/index.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/features/upload/domain/entities/housing_post.dart';
import 'package:uniplanet/features/upload/domain/entities/housing_post_form.dart';
import '../models/housing_post_model.dart';

abstract class HousingRemoteDataSource {
  Future<HousingPostModel?> uploadHousingPost(HousingPostForm post);
  Future<HousingPost?> updateHousingPost(HousingPostModel post);
}

class HousingRemoteDataSourceImpl implements HousingRemoteDataSource {
  HousingRemoteDataSourceImpl();

  @override
  Future<HousingPostModel?> uploadHousingPost(HousingPostForm post) async {
    try {
      final response =
          await DioHelper.instance.dio.post('$productURI/post-housing',
              data: {
                'title': post.title,
                'category': post.category,
                'monthlyPayment': post.monthlyPayment,
                'isUtilityIncluded': post.isUtilityIncluded,
                'securityDeposit': post.securityDeposit,
                'gender': post.gender,
                'housingConditions': post.housingConditions,
                'location': post.location,
                'description': post.description,
                'seller': post.seller,
                'stateAddress': post.stateAddress,
                'city': post.city,
                'address': post.address,
                'zipCode': post.zipCode,
              },
              options: DioHelper.instance.getDioOptions());
      if (response.statusCode == 201) {
        return HousingPostModel.fromJson(response.data);
      } else {
        throw Exception('Failed to upload housing post');
      }
    } catch (e) {
      log(e);
    }
    return null;
  }

  @override
  Future<HousingPost?> updateHousingPost(HousingPostModel post) async {
    try {
      final response = await DioHelper.instance.dio
          .put('$productURI/update-housing/${post.id}',
              data: {
                'images': post.images,
                'title': post.title,
                'category': post.category,
                'monthlyPayment': post.monthlyPayment,
                'isUtilityIncluded': post.isUtilityIncluded,
                'securityDeposit': post.securityDeposit,
                'gender': post.gender,
                'housingConditions': post.housingConditions,
                'location': post.location,
                'description': post.description,
              },
              options: DioHelper.instance.getDioOptions());
      if (response.statusCode == 201) {
        return HousingPostModel.fromJson(response.data);
      }
      if (response.statusCode != 200) {
        throw Exception('Failed to update housing post');
      }
    } catch (e) {
      log(e);
    }
    return null;
  }
}
