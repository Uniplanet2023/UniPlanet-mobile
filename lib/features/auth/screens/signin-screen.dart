import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/account/account_bloc.dart';
import 'package:uniplanet_mobile/bloc/auth/auth_bloc_event.dart';
import 'package:uniplanet_mobile/bloc/auth/auth_state/basic_state.dart';
import 'package:uniplanet_mobile/bloc/auth/auth_state/signin_state.dart';
import 'package:uniplanet_mobile/bloc/auth/auth_state/signup_state.dart';
import 'package:uniplanet_mobile/bloc/auth/auth_bloc.dart';
import 'package:uniplanet_mobile/bloc/product/product_bloc.dart';
import 'package:uniplanet_mobile/common/routes/names.dart';
import 'package:uniplanet_mobile/common/widgets/custom_button.dart';
import 'package:uniplanet_mobile/common/widgets/custom_textfield.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/features/auth/functions/forgotten-password.dart';

import 'package:uniplanet_mobile/features/auth/screens/signup-screen.dart';

import 'package:uniplanet_mobile/features/auth/functions/signin.dart';
import 'package:uniplanet_mobile/features/auth/screens/opt_verfiy_screen.dart';
import 'package:uniplanet_mobile/features/auth/widgets/bezierContainer.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _signInFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _resetPasswordController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _resetPasswordController.dispose();
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: const Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UserNotVerifiedState) {
          Navigator.pushNamed(context, AppRoutes.otpVerifyPage,
              arguments: {'email': _emailController.text});
        }
        if (state is Authorized) {
          context.read<ProductBloc>().add(const LoadProductEvent());
          context.read<AccountBloc>().add(const GetAccountInfoEvent());
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.bottomBarPage, (route) => false);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: const BezierContainer(),
            ),
            SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  // color: GlobalVariables.backgroundColor,
                  child: Form(
                    key: _signInFormKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        Image.asset(
                          'assets/images/Logo.png',
                          width: 200,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            'Please sign in to continue',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        CustomTextField(
                          controller: _emailController,
                          hintText: 'Email',
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: _passwordController,
                          hintText: 'Password',
                          obscureText: true,
                        ),
                        const SizedBox(height: 10),
                        CustomButton(
                          text: 'Sign In',
                          onTap: () {
                            if (_signInFormKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(SignInEvent(
                                  _emailController.text,
                                  _passwordController.text));
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Don\'t have an account? '),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignupScreen()),
                                    );
                                  },
                                  child: const Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: GlobalVariables.secondaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Forgot your password? '),
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          scrollable: true,
                                          title: const Text('Reset Password'),
                                          content: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CustomTextField(
                                                controller:
                                                    _resetPasswordController,
                                                hintText:
                                                    'Enter your email (.edu only)'),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge,
                                              ),
                                              child: const Text('Reset'),
                                              onPressed: () {
                                                resetPassword(
                                                    _resetPasswordController
                                                        .text);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Text(
                                    "Reset Password",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: GlobalVariables.secondaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
