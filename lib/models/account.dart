import 'dart:convert';

import 'package:uniplanet_mobile/models/user_model.dart';

class Account {
  final User user;
  final int unreadNotification;
  final int unreadMessage;
  final List<String> searchHistory;
  final List<String> recentViewHistory;

  Account({
    required this.user,
    required this.unreadNotification,
    required this.unreadMessage,
    required this.searchHistory,
    required this.recentViewHistory,
  });

  static initialAccount() {
    return Account(
      user: User.initialUser(),
      unreadNotification: 0,
      unreadMessage: 0,
      searchHistory: [],
      recentViewHistory: [],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.toMap(),
      'unreadNotification': unreadNotification,
      'unreadMessage': unreadMessage,
      'searchHistory': searchHistory,
      'recentViewHistory': recentViewHistory,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      user: User.fromMap(map),
      unreadNotification: map['unreadNotification'] as int,
      unreadMessage: map['unreadMessage'] as int,
      searchHistory: List<String>.from(
          map['searchHistory'].map((item) => item.toString())),
      recentViewHistory: List<String>.from(
          map['recentViewHistory'].map((item) => item.toString())),
    );
  }

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source) as Map<String, dynamic>);
}
