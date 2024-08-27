import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneVerificationService {
  // Private constructor for Singleton pattern
  PhoneVerificationService._privateConstructor();

  // Single instance (Singleton)
  static final PhoneVerificationService _instance =
      PhoneVerificationService._privateConstructor();

  // Factory constructor to return the same instance
  factory PhoneVerificationService() {
    return _instance;
  }

  // Static FirebaseAuth instance
  static final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required BuildContext
        context, // It's better to pass necessary callbacks instead of context
    required Function onVerificationCompleted,
    required Function onVerificationFailed,
    required Function onCodeSent,
    required Function onCodeAutoRetrievalTimeout,
    required bool isVerificationCompleted,
  }) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        if (!isVerificationCompleted) {
          await auth.signInWithCredential(credential);
          onVerificationCompleted();
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        onVerificationFailed(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        onCodeAutoRetrievalTimeout(verificationId);
      },
    );
  }

  Future<bool> verifyOtp({
    required String otpCode,
    required String verificationId,
    required BuildContext context, // You might need this for showing errors
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpCode,
      );

      await auth.signInWithCredential(credential);

      return true;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
      return false;
    }
  }
}
