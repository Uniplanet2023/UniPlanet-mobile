import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uniplanet/features/common/presentation/widgets/custom_button.dart';
import 'package:uniplanet/features/auth/presention/screens/signin_screen.dart';
import 'package:uniplanet/features/auth/presention/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet/features/auth/presention/widgets/bezier_container.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                    SizedBox(height: 100.h),
                    Image(
                      image: const AssetImage('assets/images/Logo_nbg.png'),
                      width: 200.w,
                      height: 200.h,
                    ),
                    SizedBox(height: 30.h),
                    Text(
                      'Selling Smarter,',
                      style: GoogleFonts.montserrat(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Buying Better,',
                      style: GoogleFonts.montserrat(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    SizedBox(
                      width: 250.0,
                      child: TextAnimator(
                        'All on Campus',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        atRestEffect: WidgetRestingEffects.wave(),
                      ),
                    ),
                    SizedBox(height: 50.h),
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
