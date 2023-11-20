import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/userBloc/user_bloc.dart';
import 'package:uniplanet_mobile/common/widgets/custom_button.dart';
import 'package:uniplanet_mobile/common/widgets/custom_textfield.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/features/auth/screens/signup_screen.dart';
import 'package:uniplanet_mobile/repository/user_repo.dart';

class SigninScreen extends StatefulWidget {
  static const String routeName = '/signin-screen';
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

  void signInUser() {
    try {
      context.read<UserBloc>().add(SignInEvent(
          context, _emailController.text, _passwordController.text));
    } catch (e) {
      print(e);
    }
  }

  void resetPassword() {
    try {
      final bool emailValid =
          RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.+-]+\.edu$")
              .hasMatch(_resetPasswordController.text);

      if (!emailValid || _resetPasswordController.text == '') {
        SnackbarGlobal.showSnackBar(
          'Email format not correct, only school accounts accepted(.edu)',
        );
        return;
      }
      UserRepository().forgottenPassword(
          context: context, email: _resetPasswordController.text);
    } catch (e) {
      SnackbarGlobal.showSnackBar(
        'Something went wrong',
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _resetPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign in',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8),
          color: GlobalVariables.backgroundColor,
          child: Form(
            key: _signInFormKey,
            child: Column(
              children: [
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
                      signInUser();
                    }
                  },
                ),
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
                                  builder: (context) => const SignupScreen()),
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
                                        controller: _resetPasswordController,
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
                                        resetPassword();
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
    );
  }
}
