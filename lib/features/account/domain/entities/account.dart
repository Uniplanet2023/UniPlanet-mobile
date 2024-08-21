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

  // to Map

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user.toMap(),
      'type': type,
      'isBlocked': isBlocked,
      'isBlockedPost': isBlockedPost,
      'isBlockedChat': isBlockedChat,
    };
  }
  // from Map

  factory AccountEntity.fromMap(Map<String, dynamic> map) {
    return AccountEntity(
      id: map['id'] as int?,
      user: User.fromMap(map['user'] as Map<String, dynamic>),
      type: map['type'] as String,
      isBlocked: map['isBlocked'] as bool? ?? false,
      isBlockedPost: map['isBlockedPost'] as bool? ?? false,
      isBlockedChat: map['isBlockedChat'] as bool? ?? false,
    );
  }
}
