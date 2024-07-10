import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

class PhoneOTPVerifyScreen extends StatefulWidget {
  final Future<bool> Function(String) onVerificationComplete;
  final Future<void> Function() onVerification;
  const PhoneOTPVerifyScreen(
      {super.key,
      required this.onVerificationComplete,
      required this.onVerification});

  @override
  PhoneOTPVerifyScreenState createState() => PhoneOTPVerifyScreenState();
}

class PhoneOTPVerifyScreenState extends State<PhoneOTPVerifyScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  int _resendTimer = 30;
  Timer? _timer;
  @override
  void initState() {
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
                onCompleted: (v) async {
                  bool isVerified =
                      await widget.onVerificationComplete(_otpController.text);
                  if (isVerified) {
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text("Fail to verify OTP, Please try again!")),
                      );
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
    widget.onVerification();
    setState(() {
      _resendTimer = 30;
    });
    _startResendTimer();
  }

  void _startResendTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
