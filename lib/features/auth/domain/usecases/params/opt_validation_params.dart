class OtpValidationParams {
  final String email;
  final String hash;
  final String otpCode;

  OtpValidationParams({
    required this.email,
    required this.hash,
    required this.otpCode,
  });
}
