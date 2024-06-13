import 'package:isar/isar.dart';
import 'package:uniplanet/models/user.dart';
part 'user.g.dart';

@Collection()
class UserModel {
  Id isarId = Isar.autoIncrement;
  late String id;
  late String name;
  late String email;
  late String? profileImage;
  late String school;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.school,
  });

  factory UserModel.fromUser(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      profileImage: user.profileImage,
      school: user.school,
    );
  }
  User toUser() {
    return User(
      id: id,
      name: name,
      email: email,
      profileImage: profileImage,
      school: school,
    );
  }
}
