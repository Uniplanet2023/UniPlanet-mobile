import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uniplanet/core/utils/constant/global_variables.dart';

class CategoryHeader extends StatelessWidget {
  final String category;
  const CategoryHeader({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      snap: false,
      floating: true,
      backgroundColor: Colors.white,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(
              bottom: 16,
            ),
            centerTitle: true,
            title: Text(
              category,
              style: TextStyle(
                fontStyle: GoogleFonts.roboto().fontStyle,
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ), // Show category if it's not null otherwise 'uniplanet'
            background: Container(
              decoration: const BoxDecoration(
                gradient: GlobalVariables.appBarGradient,
              ),
            ),
          );
        },
      ),
    );
  }
}
