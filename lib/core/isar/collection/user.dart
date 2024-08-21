import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:uniplanet/core/entities/user.dart';

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

  factory UserLocalModel.fromMap(Map<String, dynamic> map) {
    return UserLocalModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      profileImage: map['profileImage'] as String?,
      school: map['school'] as String,
      type: map['type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserLocalModel.fromJson(String source) =>
      UserLocalModel.fromMap(json.decode(source));
}

