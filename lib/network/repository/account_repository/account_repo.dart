import 'package:dio/dio.dart';
import 'package:uniket/constants/utils.dart';
import 'package:uniket/models/account.dart';
import 'package:uniket/network/api_def/api_server_address.dart';
import 'package:uniket/network/api_def/dio_client.dart';
import 'package:uniket/network/api_def/display_error_messages.dart';
import 'package:uniket/network/repository/account_repository/account_repo_interface.dart';

class AccountRepository implements IAccountRepository {
  final DioClient _dioClient;

  AccountRepository(this._dioClient);

  Future<Account> getAccount() async {
    try {
      Response res = await _dioClient.dio
          .get('$accountURI/myinfo', options: _dioClient.getDioOptions());

      String msg = displayErrorMessages(res.toString());

      if (msg == "success") {
        Account result = Account.fromJson(res.data);
        return result;
      } else {
        throw Exception('Failed to get account info');
      }
    } catch (e) {
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
