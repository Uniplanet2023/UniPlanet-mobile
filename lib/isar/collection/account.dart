import 'package:isar/isar.dart';
import 'package:uniplanet/isar/collection/user.dart';
import 'package:uniplanet/models/account.dart';

part 'account.g.dart';

@Collection()
class AccountModel {
  Id isarId = Isar.autoIncrement;
  late String type;
  late bool isBlocked;
  late bool isBlockedPost;
  late bool isBlockedChat;
  late int? maximumPost; // this is for advertisement account
  late int numberOfPost;
  late int? maximumClick;
  late int numberOfClick; // t
  final user = IsarLink<UserModel>();

  AccountModel({
    required this.type,
    required this.isBlocked,
    required this.isBlockedPost,
    required this.isBlockedChat,
    required this.maximumPost,
    required this.numberOfPost,
    required this.maximumClick,
    required this.numberOfClick,
  });

  factory AccountModel.fromAccount(Account account) {
    return AccountModel(
      type: account.type,
      isBlocked: account.isBlocked,
      isBlockedPost: account.isBlockedPost,
      isBlockedChat: account.isBlockedChat,
      maximumPost: account.maximumPost,
      numberOfPost: account.numberOfPost,
      maximumClick: account.maximumClick,
      numberOfClick: account.numberOfClick,
    );
  }
  Future<Account> toAccount() async {
    await user.load();
    return Account(
      type: type,
      isBlocked: isBlocked,
      isBlockedPost: isBlockedPost,
      isBlockedChat: isBlockedChat,
      maximumPost: maximumPost,
      numberOfPost: numberOfPost,
      maximumClick: maximumClick,
      numberOfClick: numberOfClick,
      user: user.value!.toUser(),
    );
  }
}
