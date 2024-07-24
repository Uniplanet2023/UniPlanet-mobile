import 'dart:convert';
import 'package:uniplanet/core/entities/user.dart';

class UserInteraction {
  final User user;
  final String advertisement;

  UserInteraction({
    required this.user,
    required this.advertisement,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.toMap(),
      'advertisement': advertisement,
    };
  }

  factory UserInteraction.fromMap(Map<String, dynamic> map) {
    return UserInteraction(
      user: User.fromMap(map['account']),
      advertisement: map['advertisement'] ?? '',
    );
  }

  factory UserInteraction.fromJson(String source) =>
      UserInteraction.fromMap(json.decode(source) as Map<String, dynamic>);
}
