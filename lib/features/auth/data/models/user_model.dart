import 'package:uniplanet/core/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.profileImage,
    required super.school,
    required super.type,
  });
}
