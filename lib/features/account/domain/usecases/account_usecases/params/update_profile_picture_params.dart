import 'dart:io';

class UpdateProfilePictureParams {
  final File image;
  final String userId;
  final String school;

  UpdateProfilePictureParams({
    required this.image,
    required this.userId,
    required this.school,
  });
}
