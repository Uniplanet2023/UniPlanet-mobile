import 'dart:convert';

import 'package:uniplanet_mobile/models/user_model.dart';

class Account {
  final User user;
  final List<String> searchHistory;
  final List<String> recentViewHistory;

  Account({
    required this.user,
    required this.searchHistory,
    required this.recentViewHistory,
  });

  static initialAccount() {
    return Account(
      user: User.initialUser(),
      searchHistory: [],
      recentViewHistory: [],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.toMap(),
      'searchHistory': searchHistory,
      'recentViewHistory': recentViewHistory,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      user: User.fromMap(map),
      searchHistory: List<String>.from(
          map['searchHistory'].map((item) => item.toString())),
      recentViewHistory: List<String>.from(
          map['recentViewHistory'].map((item) => item.toString())),
    );
  }

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source) as Map<String, dynamic>);
}
