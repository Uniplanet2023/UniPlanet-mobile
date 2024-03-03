import 'dart:convert';

class Account {
  final String id;
  final String name;
  final String email;
  final String school;
  final String profileImage;
  final int unreadNotification;
  final int unreadMessage;
  final List<String> searchHistory;
  final List<String> recentViewHistory;

  Account({
    required this.id,
    required this.name,
    required this.email,
    required this.school,
    required this.profileImage,
    required this.unreadNotification,
    required this.unreadMessage,
    required this.searchHistory,
    required this.recentViewHistory,
  });

  static initialAccount() {
    return Account(
      id: '',
      name: '',
      email: '',
      school: '',
      profileImage: '',
      unreadNotification: 0,
      unreadMessage: 0,
      searchHistory: [],
      recentViewHistory: [],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'school': school,
      'profileImage': profileImage,
      'unreadNotification': unreadNotification,
      'unreadMessage': unreadMessage,
      'searchHistory': searchHistory,
      'recentViewHistory': recentViewHistory,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      name: map['name'] as String,
      email: map['email'] as String,
      school: map['school'] as String,
      profileImage: map['profileImage'] as String,
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
