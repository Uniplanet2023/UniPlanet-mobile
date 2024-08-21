import 'dart:convert';

import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/features/account/domain/entities/account.dart';

class AccountDBModel extends AccountEntity {
  AccountDBModel({
    required super.type,
    required super.isBlocked,
    required super.isBlockedPost,
    required super.isBlockedChat,
    required super.user,
  });

  // Factory method to convert domain model to data model
  factory AccountDBModel.fromDomain(AccountEntity account) {
    return AccountDBModel(
      type: account.type,
      isBlocked: account.isBlocked,
      isBlockedPost: account.isBlockedPost,
      isBlockedChat: account.isBlockedChat,
      user: account.user,
    );
  }

  // Method to convert data model to domain model
  Future<AccountEntity> toDomain() async {
    return AccountEntity(
      user: user,
      type: type,
      isBlocked: isBlocked,
      isBlockedPost: isBlockedPost,
      isBlockedChat: isBlockedChat,
    );
  }

  // Convert to a map for potential serialization
  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'isBlocked': isBlocked,
      'isBlockedPost': isBlockedPost,
      'isBlockedChat': isBlockedChat,
      'user': user.toMap(),
    };
  }

  //from map
  factory AccountDBModel.fromMap(Map<String, dynamic> map) {
    return AccountDBModel(
      type: map['type'] as String,
      isBlocked: map['isBlocked'] as bool,
      isBlockedPost: map['isBlockedPost'] as bool,
      isBlockedChat: map['isBlockedChat'] as bool,
      user: User.fromMap(map),
    );
  }
  //from json
  factory AccountDBModel.fromJson(String source) =>
      AccountDBModel.fromMap(json.decode(source));
}
