import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniplanet_mobile/bloc/chatBloc/chat_bloc.dart';
import 'package:uniplanet_mobile/bloc/chatBloc/chat_bloc_event.dart';
import 'package:uniplanet_mobile/bloc/userBloc/user_bloc.dart';
import 'package:uniplanet_mobile/common/widgets/custom_button.dart';
import 'package:uniplanet_mobile/common/widgets/custom_textfield.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/features/auth/screens/signup_screen.dart';
import 'package:uniplanet_mobile/socket/socket_channel.dart';

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

  void signInUser() async {
    context.read<UserBloc>().add(
        SignInEvent(_emailController.text, _passwordController.text, context));
  }

//eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1NDQwZDg2ZWNjMTc3NTFmNGJiZGIzMSIsImlhdCI6MTY5ODk3NDAxM30.wU8DNEsI1oayDiBaiItGBz79RiKa3D9wsZeY2I-fFRo
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
      body: Container(
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
            ],
          ),
        ),
      ),
    );
  }
}
