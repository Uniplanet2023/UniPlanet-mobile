import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:uniplanet/config/api/server_address.dart';
import 'package:uniplanet/core/helper/dio_helper.dart';
import 'package:uniplanet/core/isar/isar_service.dart';
import 'package:uniplanet/core/network/storage/image_upload_service.dart';
import 'package:uniplanet/core/utils/display_error_messages.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/features/account/data/models/account_db_model.dart';
import 'package:uniplanet/features/account/domain/entities/account.dart';
import 'package:uniplanet/features/account/domain/usecases/account_usecases/params/update_profile_picture_params.dart';
import 'package:uniplanet/features/auth/domain/repository/user_repository.dart';

abstract interface class AccountRemoteDataSource {
  Future<AccountDBModel> getAccountInfo();
  Future<AccountDBModel> updateName(String name);
  Future<AccountDBModel> updateProfilePicture(
      UpdateProfilePictureParams params);
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  @override
  Future<AccountDBModel> getAccountInfo() async {
    try {
      Response res = await DioHelper.instance.dio.get('$accountURI/myinfo',
          options: DioHelper.instance.getDioOptions());

      String msg = displayErrorMessages(res.toString());

      if (msg == "success") {
        AccountDBModel account = AccountDBModel.fromJson(res.data);
        IsarService.instance.saveAccount(account);
        return account;
      } else {
        throw Exception('Failed to get account info');
      }
    } catch (e) {
      AccountEntity? account = await IsarService.instance.getAccount();
      if (account != null) {
        return AccountDBModel.fromDomain(account);
      }
      rethrow;
    }
  }

  @override
  Future<AccountDBModel> updateName(String name) async {
    try {
      Response res = await DioHelper.instance.dio.put('$accountURI/update-name',
          data: {'name': name}, options: DioHelper.instance.getDioOptions());

      String msg = displayErrorMessages(res.toString());

      if (msg == "success") {
        SnackbarGlobal.showSnackBar(
          "Name updated successfully",
        );
        AccountDBModel result = AccountDBModel.fromJson(res.data);
        return result;
      }
      throw Exception('Failed to update name');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AccountDBModel> updateProfilePicture(
      UpdateProfilePictureParams params) async {
    try {
      // Upload image to firebase storage
      File imageFile = File(params.image.path);
      String profileImage = await ImageUploadService()
          .uploadImage(imageFile,
              'profile-image/${AuthRepository.school}/${params.userId}')
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Image uploading timed out');
        },
      );
      // Update profile image in the server
      Response res = await DioHelper.instance.dio.put(
          '$accountURI/update-profile',
          data: {'profileImage': profileImage},
          options: DioHelper.instance.getDioOptions());

      String msg = displayErrorMessages(res.toString());

      if (msg == "success") {
        SnackbarGlobal.showSnackBar(
          "Profile image updated successfully",
        );
        AccountDBModel result = AccountDBModel.fromJson(res.data);
        return result;
      } else {
        throw Exception('Failed to update profile image');
      }
    } catch (e) {
      rethrow;
    }
  }
}
