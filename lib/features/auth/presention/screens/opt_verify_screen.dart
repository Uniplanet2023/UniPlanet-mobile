import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/core/router/names.dart';
import 'package:uniplanet/features/common/presentation/widgets/custom_button.dart';
import 'package:uniplanet/features/auth/presention/blocs/auth/auth_bloc.dart';
import 'package:uniplanet/features/auth/functions/opt_verification.dart';

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
        if (state is Authorized) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.bottomBarPage, (route) => false);
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
          color: Theme.of(context).colorScheme.surface,
          child: Form(
            key: _otpFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Logo_nbg.png',
                  width: 100,
                ),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Enter the verification number sent to your Email address to continue:',
                    style: TextStyle(
                      fontSize: 16,
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
                      decoration: InputDecoration(
                          hintText: 'Verification number',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                            color:
                                Theme.of(context).colorScheme.tertiaryContainer,
                          )),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color:
                                Theme.of(context).colorScheme.tertiaryContainer,
                          ))),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Enter your verification number';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is OtpValidatingState) {
                      return const CircularProgressIndicator();
                    }
                    return CustomButton(
                      text: 'Submit',
                      onTap: () {
                        if (_otpFormKey.currentState!.validate()) {
                          optVerification(
                              context, widget.email, _otpController.text);
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 10),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is OTPValidationRequestState) {
                      return const CircularProgressIndicator();
                    }
                    return TextButton(
                      onPressed: () {
                        context
                            .read<AuthBloc>()
                            .add(RequestOtpEvent(widget.email));
                      },
                      child: Text(
                        "Resend Verification number",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    );
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
