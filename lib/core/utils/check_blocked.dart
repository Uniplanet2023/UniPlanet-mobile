import 'package:uniplanet/bloc/index.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/models/account.dart';

bool checkBlockedAccount({required String blockType}) {
  Account? account =
      SnackbarGlobal.key.currentContext?.read<AccountBloc>().state.account;

  if (account == null) {
    SnackbarGlobal.showSnackBar(
        "Can't get account info. Please restart the app. If the problem persists, contact support: profile -> Help -> contact us.");
    return true;
  }
  if (account.isBlocked) {
    SnackbarGlobal.showSnackBar(
        "You're account is blocked. Please contact support: profile -> Help -> contact us.");
    return true;
  } else if (blockType == "Post" && account.isBlockedPost) {
    SnackbarGlobal.showSnackBar(
        "You're account is blocked from posting. Please contact support: profile -> Help -> contact us.");
    return true;
  } else if (blockType == "Chat" && account.isBlockedChat) {
    SnackbarGlobal.showSnackBar(
        "You're account is blocked from chat. Please contact support: profile -> Help -> contact us.");
    return true;
  }
  return false;
}
