import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uniplanet_mobile/common/routes/names.dart';
import 'package:uniplanet_mobile/common/widgets/custom_button.dart';
import 'package:uniplanet_mobile/features/auth/screens/auth_screen.dart';
import 'package:uniplanet_mobile/features/on_boarding/widgets/height_spacer.dart';

class PageThree extends StatelessWidget {
  const PageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(Colors.blueAccent.value),
        child: Column(
          children: [
            const HeightSpacer(size: 65),
            Padding(padding: EdgeInsets.all(8.h)),
            Image.asset("assets/images/page3_Image.jpg"),
            const HeightSpacer(size: 70),
            Column(
              children: [
                Text(
                  "Enjoy your time in UniKet",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const HeightSpacer(size: 80),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomButton(
                      text: "Go Travel",
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const AuthScreen();
                        }));
                      }),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
