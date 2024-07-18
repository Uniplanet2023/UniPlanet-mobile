import 'dart:convert';
import 'package:uniplanet/features/auth/data/models/user_model.dart';
import 'package:uniplanet/features/auth/domain/entities/user.dart';

class Account {
  User user;
  final String type;
  final bool isBlocked;
  final bool isBlockedPost;
  final bool isBlockedChat;
  Account({
    required this.user,
    required this.type,
    this.isBlocked = false,
    this.isBlockedPost = false,
    this.isBlockedChat = false,
  });

  static initialAccount() {
    return Account(
      user: UserModel.initialUser(),
      type: 'user',
      isBlocked: false,
      isBlockedPost: false,
      isBlockedChat: false,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user,
      'type': type,
      'isBlocked': isBlocked,
      'isBlockedPost': isBlockedPost,
      'isBlockedChat': isBlockedChat,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      user: UserModel.fromMap(map),
      type: map['type'] ?? 'student',
      isBlocked: map['isBlocked'] as bool,
      isBlockedPost: map['isBlockedPost'] as bool,
      isBlockedChat: map['isBlockedChat'] as bool,
    );
  }

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source) as Map<String, dynamic>);
}
