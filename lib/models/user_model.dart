import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final String school;
  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    required this.school,
  });
  static initialUser() {
    return User(
      id: '',
      name: '',
      email: '',
      profileImage: '',
      school: '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'school': school,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      profileImage: map['profileImage'],
      school: map['school'] as String,
    );
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
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      school: school ?? this.school,
    );
  }
}
