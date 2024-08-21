import 'package:uniplanet/core/isar/collection/user.dart';
import 'package:uniplanet/features/account/domain/entities/account.dart';
import 'package:isar/isar.dart';

part 'account_isar_model.g.dart';

@Collection()
class AccountIsarModel {
  Id isarId = Isar.autoIncrement;
  late String type;
  late bool isBlocked;
  late bool isBlockedPost;
  late bool isBlockedChat;
  final userLink = IsarLink<UserIsarModel>();

  AccountIsarModel({
    required this.type,
    required this.isBlocked,
    required this.isBlockedPost,
    required this.isBlockedChat,
  });

  // Factory method to convert domain model to data model
  factory AccountIsarModel.fromDomain(AccountEntity account) {
    // Link the user model
    final accountModel = AccountIsarModel(
      type: account.type,
      isBlocked: account.isBlocked,
      isBlockedPost: account.isBlockedPost,
      isBlockedChat: account.isBlockedChat,
    );
    // Set the user link
    accountModel.userLink.value = UserIsarModel.fromUser(account.user);
    return accountModel;
  }

  // Method to convert data model to domain model
  Future<AccountEntity> toDomain() async {
    await userLink.load(); // Load the user link (From Isar)
    return AccountEntity(
      user: userLink.value!.toUser(), // Convert Isar Model to UserEntity
      type: type,
      isBlocked: isBlocked,
      isBlockedPost: isBlockedPost,
      isBlockedChat: isBlockedChat,
    );
  }

  // Convert to a map for potential serialization
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'isBlocked': isBlocked,
      'isBlockedPost': isBlockedPost,
      'isBlockedChat': isBlockedChat,
      // Note: `user` will be handled by Isar, so it's not included in the map
    };
  }
}
