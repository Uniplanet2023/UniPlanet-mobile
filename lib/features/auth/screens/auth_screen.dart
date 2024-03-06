import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uniplanet_mobile/common/routes/names.dart';
import 'package:uniplanet_mobile/common/widgets/custom_button.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/features/auth/screens/signin-screen.dart';
import 'package:uniplanet_mobile/features/auth/screens/signup-screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Logo.png',
                  width: 300.w,
                ),
                Text(
                  'Selling Smarter,',
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Buying Better,',
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: 250.w,
                  child: TextLiquidFill(
                    text: 'All on Campus',
                    waveColor: Colors.blueAccent,
                    boxBackgroundColor: GlobalVariables.greyBackgroundCOlor,
                    textStyle: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w800,
                    ),
                    boxHeight: 50.h,
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
                SizedBox(height: 10.h),
                CustomButton(
                  text: 'Sign In',
                  color: GlobalVariables.backgroundColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.bottomToTop,
                        child: const SigninScreen(),
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
