import 'package:uniplanet_mobile/common/widgets/custom_button.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/features/auth/screens/signin_screen.dart';
import 'package:uniplanet_mobile/features/auth/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:uniplanet_mobile/repository/user_repo.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundCOlor,
      appBar: AppBar(
        backgroundColor: GlobalVariables.greyBackgroundCOlor,
        title: const Text(
          'Welcome',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Logo.png',
                width: 300,
              ),
              const Text(
                'Selling Smarter,',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w200,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Buying Better,',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                width: 250.0,
                child: TextLiquidFill(
                  text: 'All on Campus',
                  waveColor: Colors.blueAccent,
                  boxBackgroundColor: GlobalVariables.greyBackgroundCOlor,
                  textStyle: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w800,
                  ),
                  boxHeight: 50.0,
                ),
              ),
              const SizedBox(height: 50),
              CustomButton(
                text: 'Sign Up',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignupScreen()),
                  );
                },
              ),
              const SizedBox(height: 10),
              CustomButton(
                text: 'Sign In',
                color: GlobalVariables.backgroundColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SigninScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
