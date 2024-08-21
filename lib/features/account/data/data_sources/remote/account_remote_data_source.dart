import 'dart:io';

import 'package:dio/dio.dart';
import 'package:uniplanet/config/api/server_address.dart';
import 'package:uniplanet/core/helper/dio_helper.dart';
import 'package:uniplanet/features/account/data/models/account_model.dart';

abstract interface class AccountRemoteDataSource {
  Future<Account> getAccountInfo();
  Future<Account?> updateName(String name);
  Future<Account?> updateProfilePicture(File image);
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource{
  @override
  Future<Account> getAccountInfo() async {
     try {
      Response res = await DioHelper.instance.dio.get('$accountURI/myinfo',
          options: DioHelper.instance.getDioOptions());

      String msg = displayErrorMessages(res.toString());

      if (msg == "success") {
        Account account = Account.fromJson(res.data);
        IsarService.instance.saveAccount(account);
        return account;
      } else {
        throw Exception('Failed to get account info');
      }
    } catch (e) {
      Account? account = await IsarService.instance.getAccount();
      if (account != null) {
        return account;
      }
      rethrow;
    }
  }

  @override
  Future<Account?> updateName(String name) {
    // TODO: implement updateName
    throw UnimplementedError();
  }

  @override
  Future<Account?> updateProfilePicture(File image) {
    // TODO: implement updateProfilePicture
    throw UnimplementedError();
  }
  
}
