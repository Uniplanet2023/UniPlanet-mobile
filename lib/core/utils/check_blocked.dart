import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/features/account/presentation/blocs/account/account_bloc.dart';
import 'package:uniplanet/models/account.dart';

bool checkBlockedAccount({required String blockType}) {
  Account? account = getIt<AccountBloc>().state.account;
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
