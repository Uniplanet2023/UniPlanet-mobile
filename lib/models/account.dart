import 'dart:convert';

import 'package:uniket/models/user_model.dart';

class Account {
  final User user;
  bool isNotificationAllowed;

  Account({
    required this.user,
    this.isNotificationAllowed = false,
  });

  static initialAccount() {
    return Account(
      user: User.initialUser(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.toMap(),
      'isNotificationAllowed': isNotificationAllowed,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      user: User.fromMap(map),
      isNotificationAllowed: map['isNotificationAllowed'] as bool,
    );
  }

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source) as Map<String, dynamic>);
}
