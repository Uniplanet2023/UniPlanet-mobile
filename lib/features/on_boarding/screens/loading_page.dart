import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:uniplanet/core/router/index.dart';
import 'package:uniplanet/core/utils/utils.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.purple,
                  Theme.of(context).primaryColor,
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: const AssetImage('assets/images/Logo_nbg.png'),
                    width: 100.w,
                    height: 100.h,
                  ),
                  SizedBox(height: 30.h),
                  DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        WavyAnimatedText('Please wait...'),
                        WavyAnimatedText('Loading...'),
                      ],
                      isRepeatingAnimation: true,
                      onTap: () {
                        log("Tap Event");
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Positioned transparent button at the bottom center
          Positioned(
            bottom:
                40.h, // Position the button 40 logical pixels from the bottom
            left: 0,
            right: 0,
            child: Center(
                child: TextButton(
              onPressed: () {
                // Add your navigation or action logic here
                Navigator.pushNamed(context, AppRoutes.authPage);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent, // Transparent background
                side: BorderSide(
                  // Add border with color and width
                  color: Colors.white.withOpacity(
                      0.8), // Border color with slight transparency
                  width: 2.0, // Border width
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8.0), // Rounded corners if desired
                ),
              ),
              child: Text(
                "Can't Signin?",
                style: TextStyle(
                  color: Colors.white
                      .withOpacity(0.8), // Slight transparency for text
                  fontSize: 16.sp,
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }
}
