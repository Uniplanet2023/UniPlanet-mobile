import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uniplanet/common/routes/names.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      snap: false,
      floating: true,
      backgroundColor: Colors.white,
      toolbarHeight: 95.h,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: EdgeInsets.only(
            left: 10, top: Platform.isAndroid ? 35 : 60, bottom: 0),
        title: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 5),
                Image(
                    image: const AssetImage('assets/images/Logo_nbg.png'),
                    width: 30.w,
                    height: 30.h),
                Text(
                  'UniPlanet',
                  style: TextStyle(
                    fontStyle: GoogleFonts.roboto().fontStyle,
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  const SizedBox(width: 10),
                  ChoiceChip(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    side: const BorderSide(
                        color: Colors.black26), // Change border line color
                    selectedColor: Colors.black,
                    label: const Row(
                      children: [
                        FaIcon(FontAwesomeIcons.squareYoutube, size: 15),
                        Text(' Free Items'),
                      ],
                    ),
                    selected: false,
                    onSelected: (selected) {
                      Navigator.pushNamed(context, AppRoutes.category,
                          arguments: 'Free Products');
                    },
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    side: const BorderSide(
                        color: Colors.black26), // Change border line color
                    selectedColor: Colors.black,
                    label: const Row(
                      children: [
                        FaIcon(FontAwesomeIcons.fire, size: 15),
                        Text(' Hot Items'),
                      ],
                    ),
                    selected: false,
                    onSelected: (selected) {
                      Navigator.pushNamed(context, AppRoutes.category,
                          arguments: 'Hot Products');
                    },
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
