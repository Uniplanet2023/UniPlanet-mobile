import 'package:page_transition/page_transition.dart';
import 'package:uniket/common/widgets/custom_button.dart';
import 'package:uniket/features/auth/screens/signin_screen.dart';
import 'package:uniket/features/auth/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:uniket/features/auth/widgets/bezier_container.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 245, 234, 1),
      body: Stack(
        children: [
          Positioned(
            top: -MediaQuery.of(context).size.height * .15,
            right: -MediaQuery.of(context).size.width * .4,
            child: const BezierContainer(),
          ),
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 100),
                    const Image(
                      image: AssetImage('assets/images/Logo_nbg.png'),
                      width: 200,
                      height: 200,
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
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 250.0,
                      child: TextAnimator(
                        'All on Campus',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 30.0,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w800,
                        ),
                        atRestEffect: WidgetRestingEffects.wave(),
                      ),
                    ),
                    const SizedBox(height: 50),
                    CustomButton(
                      text: 'Sign Up',
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: const SignupScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: const SigninScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          minimumSize: const Size(double.infinity, 60),
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.primary)),
                      child: const Text(
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          'Sign In'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
