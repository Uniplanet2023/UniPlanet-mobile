import 'dart:convert';
import 'package:uniplanet/features/auth/data/models/user_model.dart';

class UserInteraction {
  final UserModel user;
  final String advertisement;

  UserInteraction({
    required this.user,
    required this.advertisement,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.toUser(),
      'advertisement': advertisement,
    };
  }

  factory UserInteraction.fromMap(Map<String, dynamic> map) {
    return UserInteraction(
      user: UserModel.fromMap(map['account']),
      advertisement: map['advertisement'] ?? '',
    );
  }

  factory UserInteraction.fromJson(String source) =>
      UserInteraction.fromMap(json.decode(source) as Map<String, dynamic>);
}
