// import 'package:isar/isar.dart';
// import 'package:uniplanet/core/isar/collection/user.dart';
// import 'package:uniplanet/features/account/data/models/account_model.dart';

// part 'account.g.dart';

// @Collection()
// class AccountModel {
//   Id isarId = Isar.autoIncrement;
//   late String type;
//   late bool isBlocked;
//   late bool isBlockedPost;
//   late bool isBlockedChat;
//   final user = IsarLink<UserIsarModel>();

//   AccountModel({
//     required this.type,
//     required this.isBlocked,
//     required this.isBlockedPost,
//     required this.isBlockedChat,
//   });

//   factory AccountModel.fromAccount(Account account) {
//     return AccountModel(
//       type: account.type,
//       isBlocked: account.isBlocked,
//       isBlockedPost: account.isBlockedPost,
//       isBlockedChat: account.isBlockedChat,
//     );
//   }
//   Future<Account> toAccount() async {
//     await user.load();
//     return Account(
//       type: type,
//       isBlocked: isBlocked,
//       isBlockedPost: isBlockedPost,
//       isBlockedChat: isBlockedChat,
//       user: user.value!.toUser(),
//     );
//   }
// }
