abstract class IAuthRepository {
  Future<String?> signUpUser({
    required String email,
    required String password,
    required String name,
    required String school,
    required bool isStudent,
  });

  Future<bool> tokenValidation();

  Future<String> signInUser({
    required String email,
    required String password,
  });

  Future<String> requestOtp({
    required String email,
  });

  Future<bool> resetPassword({
    required String email,
  });

  Future<bool> otpValidation(String email, String hash, String otpCode);

  Future<String> logOut();

  Future<String> updatePassword(
      {required String password, required String newPassword});
}
