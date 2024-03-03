import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:uniplanet_mobile/models/account_model.dart';
import 'package:uniplanet_mobile/network/api_server_address.dart';
import 'package:uniplanet_mobile/network/dio_client.dart';
import 'package:uniplanet_mobile/network/display_error_messages.dart';
import 'package:uniplanet_mobile/repository/account_repository/account_repo_interface.dart';

class AccountRepository implements IAccountRepository {
  DioClient dioClient = DioClient.instance;
  AccountRepository(this.dioClient);

  @override
  Future<Account> getAccount() async {
    try {
      Response res = await DioClient.instance.dio.get('$accountURI/myinfo',
          options: DioClient.instance.getDioOptions());
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
}
