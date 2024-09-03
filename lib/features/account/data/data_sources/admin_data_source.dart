import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:uniplanet/config/api/server_address.dart';
import 'package:uniplanet/core/error/exceptions.dart';
import 'package:uniplanet/core/helper/dio_helper.dart';
import 'package:uniplanet/core/utils/display_error_messages.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/features/account/data/models/advertiser_model.dart';

abstract interface class AdminDataSource {
  Future<List<AdvertiserModel>> getAdvertiserList(int page);
  Future<AdvertiserModel> increaseCredit(
    String advertiserAccountId,
    double freeCredit,
    double credit,
  );
  Future<AdvertiserModel> blockControl(
    String accountId,
    bool isPostBlock,
    bool isChatBlock,
    bool isBlock,
  );
}

class AdminDataSourceImpl implements AdminDataSource {
  @override
  Future<AdvertiserModel> blockControl(String accountId, bool isPostBlock,
      bool isChatBlock, bool isBlock) async {
    try {
      Response res =
          await DioHelper.instance.dio.post('$accountURI/block-control',
              data: {
                'accountId': accountId,
                'isPostBlock': isPostBlock,
                'isChatBlock': isChatBlock,
                'isBlock': isBlock
              },
              options: DioHelper.instance.getDioOptions());

      String msg = displayErrorMessages(res.toString());

      if (msg == "success") {
        //TODO: move to presentation layer
        // SnackbarGlobal.showSnackBar("Block status updated successfully");

        AdvertiserModel advertiser = AdvertiserModel.fromJson(res.data);
        return advertiser;
      } else {
        throw ServerException('Error message: $msg');
      }
    } catch (e) {
      //TODO: move to presentation layer
      // SnackbarGlobal.showSnackBar("Failed to update block status");
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<AdvertiserModel>> getAdvertiserList(int page) async {
    List<AdvertiserModel> advertiserList = [];
    try {
      Response res = await DioHelper.instance.dio.get(
          '$accountURI/advertiser-list/$page',
          options: DioHelper.instance.getDioOptions());

      String msg = displayErrorMessages(res.toString());
      if (msg == 'success') {
        var dataList = jsonDecode(res.data);

        if (dataList is List) {
          for (var element in dataList) {
            AdvertiserModel advertiser = AdvertiserModel.fromMap(element);
            advertiserList.add(advertiser);
          }
        } else {
          log('Unexpected data format: $dataList');
          throw ServerException('Unexpected data format: $dataList');
        }
        return advertiserList;
      } else {
        log('Error message: $msg');
        throw ServerException('Unexpected data format: $msg');
      }
    } catch (e) {
      log('Exception: $e');
      throw const ServerException('Failed to get advertiser list');
      //TODO: move to presentation layer
      // SnackbarGlobal.showSnackBar("Failed to get advertiser list");
    }
  }

  @override
  Future<AdvertiserModel> increaseCredit(
      String advertiserAccountId, double freeCredit, double credit) async {
    try {
      Response res = await DioHelper.instance.dio.post(
          '$accountURI/increase-credit',
          data: {
            'accountId': advertiserAccountId,
            'freeCredit': freeCredit,
            'credit': credit
          },
          options: DioHelper.instance.getDioOptions());

      String msg = displayErrorMessages(res.toString());

      if (msg == "success") {
        //TODO: move to presentation layer
        // SnackbarGlobal.showSnackBar("Credit increased successfully");

        AdvertiserModel advertiser = AdvertiserModel.fromJson(res.data);
        return advertiser;
      } else {
        throw const ServerException("Failed to increase credit");
      }
    } catch (e) {
      //TODO: move to presentation layer
      // SnackbarGlobal.showSnackBar("Failed to increase credit");
      throw const ServerException("Failed to increase credit");
    }
  }
}
