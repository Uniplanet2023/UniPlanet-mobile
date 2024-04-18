import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uniket/features/on_boarding/widgets/height_spacer.dart';

class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.deepPurple[500],
          child: Column(
            children: [
              const HeightSpacer(size: 65),
              Padding(padding: EdgeInsets.all(8.h)),
              Image.asset("assets/images/page2_Image.jpg"),
              const HeightSpacer(size: 20),
              Column(
                children: [
                  Text(
                    "Contact the seller to buy the item!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const HeightSpacer(size: 10),
                  Text(
                    "You can contact the seller to buy the item you want to buy!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
