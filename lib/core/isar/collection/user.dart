import 'package:isar/isar.dart';
import 'package:uniplanet/features/auth/domain/entities/user.dart';

part 'user.g.dart';

@Collection()
class UserLocalModel {
  Id isarId = Isar.autoIncrement;
  late String id;
  late String name;
  late String email;
  late String? profileImage;
  late String school;
  late String type;

  UserLocalModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.school,
    required this.type,
  });

  factory UserLocalModel.fromUser(User user) {
    return UserLocalModel(
      id: user.id,
      name: user.name,
      email: user.email,
      profileImage: user.profileImage,
      school: user.school,
      type: user.type,
    );
  }
  User toUser() {
    return User(
      id: id,
      name: name,
      email: email,
      profileImage: profileImage,
      school: school,
      type: type,
    );
  }
}
