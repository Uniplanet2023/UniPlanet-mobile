import 'dart:convert';

import 'package:uniplanet_mobile/models/myChatRoom.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String profileImage;
  final String school;
  final bool verified;
  final String type;
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.school,
    required this.verified,
    required this.type,
  });
  static initialUser() {
    return User(
        id: '',
        name: '',
        email: '',
        profileImage: '',
        school: '',
        verified: false,
        type: '');
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'school': school,
      'verified': verified,
      'type': type
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        id: map['id'] as String,
        name: map['name'] as String,
        email: map['email'] as String,
        profileImage: map['profileImage'] as String,
        school: map['school'] as String,
        verified: map['verified'] as bool,
        type: map['type'] as String);
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
    String? school,
    bool? verified,
    String? type,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      school: school ?? this.school,
      verified: verified ?? this.verified,
      type: type ?? this.type,
    );
  }
}
