import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uniket/features/on_boarding/widgets/height_spacer.dart';

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(Colors.blueAccent.value),
        child: Column(
          children: [
            Image.asset("assets/images/page1_Image.png",
                height: 500, width: 500),
            Column(
              children: [
                Text(
                  "Welcome to University Marketplace!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const HeightSpacer(size: 10),
                Text(
                  "The best place to buy and sell your items in your university!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
