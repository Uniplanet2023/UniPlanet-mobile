// lib/features/auth/domain/entities/user.dart

import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final String school;
  final String type;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    required this.school,
    required this.type,
  });

  User.initialUser()
      : id = '',
        name = '',
        email = '',
        profileImage = '',
        school = '',
        type = '';
  //toMap method for potential serialization
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

  //fromMap method for potential deserialization
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      profileImage: map['profileImage'] as String?,
      school: map['school'] as String,
      type: map['type'] as String,
    );
  }
  //to json
  String toJson() => json.encode(toMap());

  //from json
  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
