import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:uniplanet/constants/global_variables.dart';
import 'package:uniplanet/features/on_boarding/widgets/height_spacer.dart';

class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

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
                SizedBox(
                  height: 350,
                  width: 350,
                  child: Lottie.asset('assets/animations/chat_function.json',
                      fit: BoxFit.cover),
                ),
                const HeightSpacer(size: 20),
                Column(
                  children: [
                    Text(
                      "Seamless Communication",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const HeightSpacer(size: 10),
                    Text(
                      "Use our powerful chat feature to easily connect with buyers and sellers!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        fontSize: 18,
                        color: GlobalVariables.greyBackgroundColor,
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
