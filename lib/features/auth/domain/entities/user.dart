// lib/features/auth/domain/entities/user.dart

class User {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final String school;
  final String type;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    required this.school,
    required this.type,
  });
  //toMap method is used to convert the User object into a map object
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
}
