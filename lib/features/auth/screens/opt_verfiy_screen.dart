import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/auth/auth_state/basic_state.dart';
import 'package:uniplanet_mobile/bloc/auth/auth_state/signup_state.dart';
import 'package:uniplanet_mobile/bloc/auth/auth_bloc.dart';
import 'package:uniplanet_mobile/common/routes/names.dart';
import 'package:uniplanet_mobile/common/widgets/custom_button.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/features/auth/functions/opt-request.dart';
import 'package:uniplanet_mobile/features/auth/functions/opt-verification.dart';
import 'package:uniplanet_mobile/features/auth/screens/signin-screen.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String email;
  const OtpVerifyScreen({super.key, required this.email});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final _otpFormKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is OTPValidationCompleteState) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.signinPage, (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Verify Email address',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(8),
          color: GlobalVariables.backgroundColor,
          child: Form(
            key: _otpFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Logo.png',
                  width: 200,
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Enter the verification number sent to your Email address to continue:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _otpController,
                      maxLength: 5,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          hintText: 'Verification number',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.black38,
                          )),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.black38,
                          ))),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Enter your verification number';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        optRequest(context, widget.email);
                      },
                      child: const Text('Resend OTP'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Submit',
                  onTap: () {
                    if (_otpFormKey.currentState!.validate()) {
                      optVerification(
                          context, widget.email, _otpController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
