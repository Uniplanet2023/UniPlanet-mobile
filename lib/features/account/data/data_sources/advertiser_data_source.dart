import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:uniplanet/config/api/server_address.dart';
import 'package:uniplanet/core/error/exceptions.dart';
import 'package:uniplanet/core/helper/dio_helper.dart';
import 'package:uniplanet/core/utils/display_error_messages.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/features/account/data/models/ad_stat_model.dart';
import 'package:uniplanet/features/account/data/models/advertiser_model.dart';
import 'package:uniplanet/features/account/data/models/user_interaction_model.dart';

abstract interface class AdvertiserDataSource {
  Future<List<UserInteractionModel>> getInteraction(int? page);
  Future<AdStatModel> getAdStatistics();
  Future<AdvertiserModel> getAdvertiser();
}

class AdvertiserDataSourceImpl implements AdvertiserDataSource {
  @override
  Future<List<UserInteractionModel>> getInteraction(int? page) async {
    List<UserInteractionModel> userInteractionList = [];
    try {
      Response res = await DioHelper.instance.dio.get(
          '$accountURI/ad-interaction/$page',
          options: DioHelper.instance.getDioOptions());

      String msg = displayErrorMessages(res.toString());
      if (msg == 'success') {
        var dataList = jsonDecode(res.data);

        if (dataList is List) {
          for (var element in dataList) {
            UserInteractionModel userInteraction =
                UserInteractionModel.fromMap(element);
            userInteractionList.add(userInteraction);
          }
        } else {
          log('Unexpected data format: $dataList');
          throw const ServerException('Unexpected data format');
        }
        return userInteractionList;
      } else {
        log('Error message: $msg');
        throw ServerException('Error message: $msg');
      }
    } catch (e) {
      log('Exception: $e');
      throw ServerException(e.toString());
      // TODO: move to presentation layer
      // SnackbarGlobal.showSnackBar("Failed to get account info");
    }
  }

  @override
  Future<AdStatModel> getAdStatistics() async {
    try {
      Response res = await DioHelper.instance.dio.get(
          '$accountURI/ad-statistic',
          options: DioHelper.instance.getDioOptions());

      String msg = displayErrorMessages(res.toString());
      if (msg == "success") {
        AdStatModel adStat = AdStatModel.fromMap(res.data);
        return adStat;
      } else {
        throw ServerException('Error message: $msg');
      }
    } catch (e) {
      // TODO: move to presentation layer
      // SnackbarGlobal.showSnackBar("Failed to get account info");
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AdvertiserModel> getAdvertiser() async {
    try {
      Response res = await DioHelper.instance.dio.get(
          '$accountURI/advertiser-info',
          options: DioHelper.instance.getDioOptions());

      String msg = displayErrorMessages(res.toString());

      if (msg == "success") {
        AdvertiserModel advertiser = AdvertiserModel.fromJson(res.data);
        return advertiser;
      } else {
        throw const ServerException('Failed to get account info');
      }
    } catch (e) {
      // TODO: move to presentation layer
      // SnackbarGlobal.showSnackBar("Failed to get account info");
      throw ServerException(e.toString());
    }
  }
}
