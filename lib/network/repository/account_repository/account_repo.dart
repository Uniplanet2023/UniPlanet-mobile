import 'package:dio/dio.dart';
import 'package:uniplanet_mobile/models/account.dart';
import 'package:uniplanet_mobile/network/api_def/api_server_address.dart';
import 'package:uniplanet_mobile/network/api_def/dio_client.dart';
import 'package:uniplanet_mobile/network/api_def/display_error_messages.dart';
import 'package:uniplanet_mobile/network/repository/account_repository/account_repo_interface.dart';

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
}
