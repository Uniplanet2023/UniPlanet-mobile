import 'dart:io';

class UpdateProfilePictureParams {
  final File image;
  final String userId;

  UpdateProfilePictureParams({
    required this.image,
    required this.userId,
  });
}
