import 'dart:convert';
import 'package:uniplanet/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.profileImage,
    required super.school,
    required super.type,
  });
  UserModel.initialUser()
      : super(
          id: '',
          name: '',
          email: '',
          profileImage: '',
          school: '',
          type: '',
        );

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      profileImage: map['profileImage'],
      school: map['school'] as String,
      type: map['type'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'school': school,
      'type': type,
    };
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

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
