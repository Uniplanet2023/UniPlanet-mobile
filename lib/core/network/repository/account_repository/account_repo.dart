import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/config/api/server_address.dart';
import 'package:uniplanet/core/helper/dio_helper.dart';
import 'package:uniplanet/core/utils/display_error_messages.dart';
import 'package:uniplanet/core/network/repository/account_repository/account_repo_interface.dart';
import 'package:uniplanet/features/account/domain/entities/advertiser_entity.dart';
import 'package:uniplanet/features/account/data/models/ad_stat_model.dart';
import 'package:uniplanet/features/account/data/models/advertiser_model.dart';
import 'package:uniplanet/features/account/data/models/user_interaction_model.dart';

class AccountRepository implements IAccountRepository {
  AccountRepository();

  // Future<AdvertiserEntity?> blockControl(
  //     {required String accountId,
  //     bool? isPostBlock,
  //     bool? isChatBlock,
  //     bool? isBlock}) async {
  //   try {
  //     Response res =
  //         await DioHelper.instance.dio.post('$accountURI/block-control',
  //             data: {
  //               'accountId': accountId,
  //               'isPostBlock': isPostBlock,
  //               'isChatBlock': isChatBlock,
  //               'isBlock': isBlock
  //             },
  //             options: DioHelper.instance.getDioOptions());

  //     String msg = displayErrorMessages(res.toString());

  //     if (msg == "success") {
  //       SnackbarGlobal.showSnackBar("Block status updated successfully");
  //       Advertiser advertiser = Advertiser.fromJson(res.data);
  //       return advertiser;
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     SnackbarGlobal.showSnackBar("Failed to update block status");
  //     return null;
  //   }
  // }

  // Future<AdvertiserEntity?> increaseCredit(
  //     {required advertiserAccountId,
  //     required freeCredit,
  //     required credit}) async {
  //   try {
  //     Response res = await DioHelper.instance.dio.post(
  //         '$accountURI/increase-credit',
  //         data: {
  //           'accountId': advertiserAccountId,
  //           'freeCredit': freeCredit,
  //           'credit': credit
  //         },
  //         options: DioHelper.instance.getDioOptions());

  //     String msg = displayErrorMessages(res.toString());

  //     if (msg == "success") {
  //       SnackbarGlobal.showSnackBar("Credit increased successfully");
  //       Advertiser advertiser = Advertiser.fromJson(res.data);
  //       return advertiser;
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     SnackbarGlobal.showSnackBar("Failed to increase credit");
  //     return null;
  //   }
  // }

  // Future<List<AdvertiserEntity>> getAdvertiserList({int page = 1}) async {
  //   List<AdvertiserEntity> advertiserList = [];
  //   try {
  //     Response res = await DioHelper.instance.dio.get(
  //         '$accountURI/advertiser-list/$page',
  //         options: DioHelper.instance.getDioOptions());

  //     String msg = displayErrorMessages(res.toString());
  //     if (msg == 'success') {
  //       var dataList = jsonDecode(res.data);

  //       if (dataList is List) {
  //         for (var element in dataList) {
  //           Advertiser advertiser = Advertiser.fromMap(element);
  //           advertiserList.add(advertiser);
  //         }
  //       } else {
  //         log('Unexpected data format: $dataList');
  //       }
  //       return advertiserList;
  //     } else {
  //       log('Error message: $msg');
  //     }
  //   } catch (e) {
  //     log('Exception: $e');
  //     SnackbarGlobal.showSnackBar("Failed to get advertiser list");
  //   }
  //   return advertiserList;
  // }

  // Future<List<UserInteraction>> getAdInteraction({int page = 1}) async {
  //   List<UserInteraction> userInteractionList = [];
  //   try {
  //     Response res = await DioHelper.instance.dio.get(
  //         '$accountURI/ad-interaction/$page',
  //         options: DioHelper.instance.getDioOptions());

  //     String msg = displayErrorMessages(res.toString());
  //     if (msg == 'success') {
  //       var dataList = jsonDecode(res.data);

  //       if (dataList is List) {
  //         for (var element in dataList) {
  //           UserInteraction userInteraction = UserInteraction.fromMap(element);
  //           userInteractionList.add(userInteraction);
  //         }
  //       } else {
  //         log('Unexpected data format: $dataList');
  //       }
  //       return userInteractionList;
  //     } else {
  //       log('Error message: $msg');
  //     }
  //   } catch (e) {
  //     log('Exception: $e');
  //     SnackbarGlobal.showSnackBar("Failed to get account info");
  //   }
  //   return userInteractionList;
  // }

  // Future<AdStat?> getAdStatistic() async {
  //   try {
  //     Response res = await DioHelper.instance.dio.get(
  //         '$accountURI/ad-statistic',
  //         options: DioHelper.instance.getDioOptions());

  //     String msg = displayErrorMessages(res.toString());
  //     if (msg == "success") {
  //       AdStat adStat = AdStat.fromMap(res.data);
  //       return adStat;
  //     }
  //   } catch (e) {
  //     SnackbarGlobal.showSnackBar("Failed to get account info");

  //     return null;
  //   }
  //   return null;
  // }

  // Future<AdvertiserEntity?> getAdvertiser() async {
  //   try {
  //     Response res = await DioHelper.instance.dio.get(
  //         '$accountURI/advertiser-info',
  //         options: DioHelper.instance.getDioOptions());

  //     String msg = displayErrorMessages(res.toString());

  //     if (msg == "success") {
  //       Advertiser advertiser = Advertiser.fromJson(res.data);
  //       return advertiser;
  //     } else {
  //       throw Exception('Failed to get account info');
  //     }
  //   } catch (e) {
  //     SnackbarGlobal.showSnackBar("Failed to get account info");

  //     return null;
  //   }
  // }

  Future<bool> reportUser({
    required String reportedUserId,
    required String description,
    required String reportType,
    required String productId,
  }) async {
    try {
      Response res =
          await DioHelper.instance.dio.post('$accountURI/report-user',
              data: {
                'reportedUserId': reportedUserId,
                'description': description,
                'reportType': reportType,
                'productId': productId,
              },
              options: DioHelper.instance.getDioOptions());

      String msg = displayErrorMessages(res.toString());

      if (msg == "success") {
        SnackbarGlobal.showSnackBar("User reported successfully");

        return true;
      } else {
        return false;
      }
    } catch (e) {
      SnackbarGlobal.showSnackBar("Somehitng went wrong. Please try again.");
      return false;
    }
  }

  Future<List<String>?> getSearchHistory({required page}) async {
    try {
      Response res = await DioHelper.instance.dio.get(
          '$accountURI/search-history/$page',
          options: DioHelper.instance.getDioOptions());

      String msg = displayErrorMessages(res.toString());

      if (msg == "success") {
        List<String> result = List<String>.from(res.data['data']);
        return result;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> removeSearchHistory({required String query}) async {
    try {
      Response res = await DioHelper.instance.dio.delete(
          '$accountURI/delete-search-history/$query',
          options: DioHelper.instance.getDioOptions());

      String msg = displayErrorMessages(res.toString());

      if (msg == "success") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> clearSearchHistory() async {
    try {
      Response res = await DioHelper.instance.dio.delete(
          '$accountURI/delete-all-search-history',
          options: DioHelper.instance.getDioOptions());

      String msg = displayErrorMessages(res.toString());

      if (msg == "success") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateNotification({required bool isAllow}) async {
    try {
      Response res = await DioHelper.instance.dio.put(
          '$accountURI/update-notification',
          queryParameters: {'isAllow': isAllow},
          options: DioHelper.instance.getDioOptions());

      String msg = displayErrorMessages(res.toString());

      if (msg == "success") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
