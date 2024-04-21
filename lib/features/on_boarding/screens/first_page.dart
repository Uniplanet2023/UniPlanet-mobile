import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uniket/constants/global_variables.dart';
import 'package:uniket/features/on_boarding/widgets/height_spacer.dart';

class PageOne extends StatelessWidget {
  const PageOne({super.key});

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
                width: 350,
                height: 350,
                child: Image.asset(
                  "assets/images/page1_Image.png",
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                children: [
                  Text(
                    "Welcome to University Marketplace!",
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
                    "Your go-to marketplace for buying and selling items within your university community!",
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
          ),
        ),
      ),
    );
  }
}
