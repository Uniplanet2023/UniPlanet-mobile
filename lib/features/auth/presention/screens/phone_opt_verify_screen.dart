import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

import 'package:uniplanet/features/auth/functions/phone_verification.dart';

class PhoneOTPVerifyScreen extends StatefulWidget {
  final String phoneNumber;
  const PhoneOTPVerifyScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  PhoneOTPVerifyScreenState createState() => PhoneOTPVerifyScreenState();
}

class PhoneOTPVerifyScreenState extends State<PhoneOTPVerifyScreen> {
  final TextEditingController _otpController = TextEditingController();
  late String verificationId;
  late bool isOtpSent = false;
  int _resendTimer = 30;
  Timer? _timer;
  bool _isVerificationCompleted =
      false; // Flag to track if verification is completed
  final PhoneVerificationService _phoneVerificationService =
      PhoneVerificationService();

  Future<void> _startPhoneVerification() async {
    await _phoneVerificationService.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      context: context,
      isVerificationCompleted: _isVerificationCompleted,
      onVerificationCompleted: () {
        _isVerificationCompleted = true;
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Verification completed")),
        );
      },
      onVerificationFailed: (String? errorMessage) {
        if (!_isVerificationCompleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage ?? "Verification failed")),
          );
        }
      },
      onCodeSent: (String verificationId) {
        setState(() {
          this.verificationId = verificationId;
          isOtpSent = true;
        });
      },
      onCodeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          this.verificationId = verificationId;
        });
      },
    );
  }

  @override
  void initState() {
    _startPhoneVerification();
    _startResendTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Verification'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Lottie.network(
                'https://assets10.lottiefiles.com/packages/lf20_5tl1xxnz.json',
                height: 200,
                repeat: true,
                reverse: true,
                animate: true,
              ),
              const SizedBox(height: 40),
              const Text(
                'Enter the OTP',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              PinCodeTextField(
                appContext: context,
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.white,
                  inactiveFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                  activeColor: Colors.blue,
                  inactiveColor: Colors.grey,
                  selectedColor: Colors.blue,
                ),
                animationDuration: const Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                enableActiveFill: true,
                controller: _otpController,
                onCompleted: (value) async {
                  if (!_isVerificationCompleted) {
                    // Only verify if not already completed
                    bool isVerified = await _phoneVerificationService.verifyOtp(
                        otpCode: _otpController.text,
                        verificationId: verificationId,
                        context: context);

                    if (isVerified) {
                      if (context.mounted) {
                        _isVerificationCompleted = true;
                        Navigator.pop(context, true);
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "Fail to verify OTP, Please try again!")),
                        );
                      }
                    }
                  }
                },
                onChanged: (value) {},
                beforeTextPaste: (text) {
                  return true;
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _resendTimer == 0 ? _sendOTP : null,
                child: Text(
                  _resendTimer > 0
                      ? 'Resend OTP in $_resendTimer seconds'
                      : 'Resend OTP',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendOTP() {
    _startPhoneVerification();
    setState(() {
      _resendTimer = 30;
    });
    _startResendTimer();
  }

  void _startResendTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        if (mounted) {
          setState(() {
            _resendTimer--;
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
