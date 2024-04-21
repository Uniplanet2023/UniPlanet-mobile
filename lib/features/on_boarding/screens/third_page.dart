import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:uniket/common/widgets/custom_button.dart';
import 'package:uniket/constants/global_variables.dart';
import 'package:uniket/features/auth/screens/auth_screen.dart';
import 'package:uniket/features/on_boarding/widgets/height_spacer.dart';

class PageThree extends StatelessWidget {
  const PageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.secondaryColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 50.0),
                child: SizedBox(
                  height: 300,
                  width: 300,
                  child: Lottie.asset('assets/animations/student.json',
                      fit: BoxFit.cover),
                ),
              ),
              const HeightSpacer(size: 20),
              Text(
                "Elevate Your College Adventure!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const HeightSpacer(size: 20),
              Text(
                "Explore UniKet!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontSize: 18,
                  color: GlobalVariables.greyBackgroundColor,
                ),
              ),
              const HeightSpacer(size: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                    text: "Get Started!",
                    color: GlobalVariables.backgroundColor,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const AuthScreen();
                      }));
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
