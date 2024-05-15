import 'dart:convert';

import 'package:uniplanet/models/user_model.dart';

class Account {
  final User user;
  final String type;
  final bool isBlocked;
  final bool isBlockedPost;
  final bool isBlockedChat;
  final int? maximumPost; // this is for advertisement account
  final int numberOfPost;
  final int? maximumClick;
  final int numberOfClick; // this is for advertisement account
  Account({
    required this.user,
    required this.type,
    this.isBlocked = false,
    this.isBlockedPost = false,
    this.isBlockedChat = false,
    this.maximumPost,
    required this.numberOfPost,
    this.maximumClick,
    required this.numberOfClick,
  });

  static initialAccount() {
    return Account(
      user: User.initialUser(),
      type: 'user',
      isBlocked: false,
      isBlockedPost: false,
      isBlockedChat: false,
      maximumPost: 0,
      numberOfPost: 0,
      maximumClick: 0,
      numberOfClick: 0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.toMap(),
      'type': type,
      'isBlocked': isBlocked,
      'isBlockedPost': isBlockedPost,
      'isBlockedChat': isBlockedChat,
      'maximumPost': maximumPost,
      'numberOfPost': numberOfPost,
      'maximumClick': maximumClick,
      'numberOfClick': numberOfClick,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      user: User.fromMap(map),
      type: map['type'] ?? 'user',
      isBlocked: map['isBlocked'] as bool,
      isBlockedPost: map['isBlockedPost'] as bool,
      isBlockedChat: map['isBlockedChat'] as bool,
      maximumPost: map['maximumPost'],
      numberOfPost: map['numberOfPost'] as int,
      maximumClick: map['maximumClick'],
      numberOfClick: map['numberOfClick'] as int,
    );
  }

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source) as Map<String, dynamic>);
}
