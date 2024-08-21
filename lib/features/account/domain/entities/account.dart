import 'package:uniplanet/core/entities/user.dart';

class AccountEntity {
  final int? id;
  final User user;
  final String type;
  final bool isBlocked;
  final bool isBlockedPost;
  final bool isBlockedChat;

  const AccountEntity({
    this.id,
    required this.user,
    required this.type,
    this.isBlocked = false,
    this.isBlockedPost = false,
    this.isBlockedChat = false,
  });

  static AccountEntity initialAccount() {
    return AccountEntity(
      user: User.initialUser(),
      type: 'user',
      isBlocked: false,
      isBlockedPost: false,
      isBlockedChat: false,
    );
  }
}
