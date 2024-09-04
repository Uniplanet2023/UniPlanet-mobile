import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/features/account/domain/entities/account.dart';
import 'package:uniplanet/features/account/presentation/blocs/account/account_bloc.dart';

bool checkBlockedAccount({required String blockType}) {
  AccountEntity? account = getIt<AccountBloc>().state.account;
  if (account.isBlocked) {
    SnackbarGlobal.showSnackBar(
        "Your account is blocked. Please contact support: profile -> Help -> contact us.");
    return true;
  } else if (blockType == "Post" && account.isBlockedPost) {
    SnackbarGlobal.showSnackBar(
        "Your account is blocked from posting. Please contact support: profile -> Help -> contact us.");
    return true;
  } else if (blockType == "Chat" && account.isBlockedChat) {
    SnackbarGlobal.showSnackBar(
        "Your account has been restricted from creating in chats. Advertisers are not permitted to initiate chats. For assistance, please navigate to: Profile -> Help -> Contact Us.");
    return true;
  }
  return false;
}
