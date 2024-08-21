// lib/features/auth/domain/entities/user.dart

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
}
