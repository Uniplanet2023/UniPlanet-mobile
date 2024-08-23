// lib/features/auth/domain/entities/user.dart

import 'dart:convert';

class AuthUserEntity {
  final String id;
  final String email;
  final String? profileImage;
  final String school;
  final String type;

  const AuthUserEntity({
    required this.id,
    required this.email,
    this.profileImage,
    required this.school,
    required this.type,
  });

  //toMap method for potential serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'profileImage': profileImage,
      'school': school,
      'type': type,
    };
  }

  //fromMap method for potential deserialization
  factory AuthUserEntity.fromMap(Map<String, dynamic> map) {
    return AuthUserEntity(
      id: map['id'] as String,
      email: map['email'] as String,
      profileImage: map['profileImage'] as String?,
      school: map['school'] as String,
      type: map['type'] as String,
    );
  }
  //to json
  String toJson() => json.encode(toMap());

  //from json
  factory AuthUserEntity.fromJson(String source) =>
      AuthUserEntity.fromMap(json.decode(source));
}
