import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:uniplanet/constants/utils.dart';
import 'package:uniplanet/isar/isar_service.dart';
import 'package:uniplanet/models/account.dart';
import 'package:uniplanet/api/api_def/api_server_address.dart';
import 'package:uniplanet/api/api_def/dio_client.dart';
import 'package:uniplanet/api/api_def/display_error_messages.dart';
import 'package:uniplanet/api/repository/account_repository/account_repo_interface.dart';
import 'package:uniplanet/models/ad_stat.dart';
import 'package:uniplanet/models/advertiser.dart';
import 'package:uniplanet/models/user_interaction.dart';

class AccountRepository implements IAccountRepository {
  final DioClient _dioClient;

  AccountRepository(this._dioClient);

  Future<Advertiser?> blockControl(
      {required String accountId,
      bool? isPostBlock,
      bool? isChatBlock,
      bool? isBlock}) async {
    try {
      Response res = await _dioClient.dio.post('$accountURI/block-control',
          data: {
            'accountId': accountId,
            'isPostBlock': isPostBlock,
            'isChatBlock': isChatBlock,
            'isBlock': isBlock
          },
          options: _dioClient.getDioOptions());

      String msg = displayErrorMessages(res.toString());

      if (msg == "success") {
        SnackbarGlobal.showSnackBar("Block status updated successfully");
        Advertiser advertiser = Advertiser.fromJson(res.data);
        return advertiser;
      } else {
        return null;
      }
    } catch (e) {
      SnackbarGlobal.showSnackBar("Failed to update block status");
      return null;
    }
  }

  Future<Advertiser?> increaseCredit(
      {required advertiserAccountId,
      required freeCredit,
      required credit}) async {
    try {
      Response res = await _dioClient.dio.post('$accountURI/increase-credit',
          data: {
            'accountId': advertiserAccountId,
            'freeCredit': freeCredit,
            'credit': credit
          },
          options: _dioClient.getDioOptions());

      String msg = displayErrorMessages(res.toString());

      if (msg == "success") {
        SnackbarGlobal.showSnackBar("Credit increased successfully");
        Advertiser advertiser = Advertiser.fromJson(res.data);
        return advertiser;
      } else {
        return null;
      }
    } catch (e) {
      SnackbarGlobal.showSnackBar("Failed to increase credit");
      return null;
    }
  }

  Future<List<Advertiser>> getAdvertiserList({int page = 1}) async {
    List<Advertiser> advertiserList = [];
    try {
      Response res = await _dioClient.dio.get(
          '$accountURI/advertiser-list/$page',
          options: _dioClient.getDioOptions());

      String msg = displayErrorMessages(res.toString());
      if (msg == 'success') {
        var dataList = jsonDecode(res.data);

        if (dataList is List) {
          for (var element in dataList) {
            Advertiser advertiser = Advertiser.fromMap(element);
            advertiserList.add(advertiser);
          }
        } else {
          log('Unexpected data format: $dataList');
        }
        return advertiserList;
      } else {
        log('Error message: $msg');
      }
    } catch (e) {
      log('Exception: $e');
      SnackbarGlobal.showSnackBar("Failed to get account info");
    }
    return advertiserList;
  }

  Future<List<UserInteraction>> getAdInteraction({int page = 1}) async {
    List<UserInteraction> userInteractionList = [];
    try {
      Response res = await _dioClient.dio.get(
          '$accountURI/ad-interaction/$page',
          options: _dioClient.getDioOptions());

      String msg = displayErrorMessages(res.toString());
      if (msg == 'success') {
        var dataList = jsonDecode(res.data);

        if (dataList is List) {
          for (var element in dataList) {
            UserInteraction userInteraction = UserInteraction.fromMap(element);
            userInteractionList.add(userInteraction);
          }
        } else {
          log('Unexpected data format: $dataList');
        }
        return userInteractionList;
      } else {
        log('Error message: $msg');
      }
    } catch (e) {
      log('Exception: $e');
      SnackbarGlobal.showSnackBar("Failed to get account info");
    }
    return userInteractionList;
  }

  Future<AdStat?> getAdStatistic() async {
    try {
      Response res = await _dioClient.dio
          .get('$accountURI/ad-statistic', options: _dioClient.getDioOptions());

      String msg = displayErrorMessages(res.toString());
      if (msg == "success") {
        AdStat adStat = AdStat.fromMap(res.data);
        return adStat;
      }
    } catch (e) {
      SnackbarGlobal.showSnackBar("Failed to get account info");

      return null;
    }
    return null;
  }

  Future<Advertiser?> getAdvertiser() async {
    try {
      Response res = await _dioClient.dio.get('$accountURI/advertiser-info',
          options: _dioClient.getDioOptions());

      String msg = displayErrorMessages(res.toString());

      if (msg == "success") {
        Advertiser advertiser = Advertiser.fromJson(res.data);
        return advertiser;
      } else {
        throw Exception('Failed to get account info');
      }
    } catch (e) {
      SnackbarGlobal.showSnackBar("Failed to get account info");

      return null;
    }
  }

  Future<Account> getAccount() async {
    try {
      Response res = await _dioClient.dio
          .get('$accountURI/myinfo', options: _dioClient.getDioOptions());

      String msg = displayErrorMessages(res.toString());

      if (msg == "success") {
        Account account = Account.fromJson(res.data);
        IsarService.instance.saveAccount(account);
        return account;
      } else {
        throw Exception('Failed to get account info');
      }
    } catch (e) {
      SnackbarGlobal.showSnackBar("Failed to get account info");
      Account? account = await IsarService.instance.getAccount();
      if (account != null) {
        return account;
      }
      rethrow;
    }
  }

  Future<Account?> updateName({required String name}) async {
    try {
      Response res = await _dioClient.dio.put('$accountURI/update-name',
          data: {'name': name}, options: _dioClient.getDioOptions());

      String msg = displayErrorMessages(res.toString());

      if (msg == "success") {
        SnackbarGlobal.showSnackBar(
          "Name updated successfully",
        );
        Account result = Account.fromJson(res.data);
        return result;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<Account?> updateProfileImage({required String profileImage}) async {
    try {
      Response res = await _dioClient.dio.put('$accountURI/update-profile',
          data: {'profileImage': profileImage},
          options: _dioClient.getDioOptions());

      String msg = displayErrorMessages(res.toString());

      if (msg == "success") {
        SnackbarGlobal.showSnackBar(
          "Profile image updated successfully",
        );
        Account result = Account.fromJson(res.data);
        return result;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> reportUser({
    required String reportedUserId,
    required String description,
    required String reportType,
    required String productId,
  }) async {
    try {
      Response res = await _dioClient.dio.post('$accountURI/report-user',
          data: {
            'reportedUserId': reportedUserId,
            'description': description,
            'reportType': reportType,
            'productId': productId,
          },
          options: _dioClient.getDioOptions());

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
      Response res = await _dioClient.dio.get(
          '$accountURI/search-history/$page',
          options: _dioClient.getDioOptions());

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
      Response res = await _dioClient.dio.delete(
          '$accountURI/delete-search-history/$query',
          options: _dioClient.getDioOptions());

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
      Response res = await _dioClient.dio.delete(
          '$accountURI/delete-all-search-history',
          options: _dioClient.getDioOptions());

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
      Response res = await _dioClient.dio.put('$accountURI/update-notification',
          queryParameters: {'isAllow': isAllow},
          options: _dioClient.getDioOptions());

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
