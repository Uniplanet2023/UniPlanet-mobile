import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uniplanet/constants/global_variables.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    surface: GlobalVariables.backgroundColor,
    surfaceDim: Color.fromARGB(255, 242, 245, 252),
    primary: GlobalVariables.secondaryColor,
    primaryFixedDim: GlobalVariables.selectedNavBarColor,
    secondary: Color.fromARGB(255, 234, 239, 252),
    secondaryFixedDim: Colors.white,
    tertiary: Colors.black,
    tertiaryFixedDim: Colors.black26,
    tertiaryContainer: Colors.black87,
  ),
  fontFamily: GoogleFonts.roboto().fontFamily,
  appBarTheme: const AppBarTheme(
    elevation: 0,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  ),
  useMaterial3: true,
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    surface: GlobalVariables.darkBackgroundColor,
    surfaceDim: GlobalVariables.darkSecondaryBackgroundColor,
    primary: GlobalVariables.secondaryColor,
    primaryFixedDim: GlobalVariables.selectedNavBarColor,
    secondary: GlobalVariables.darkSecondaryBackgroundColor,
    secondaryFixedDim: Color.fromRGBO(66, 66, 66, 1),
    tertiary: Colors.white,
    tertiaryFixedDim: Colors.white30,
    tertiaryContainer: Colors.white70,
  ),
  fontFamily: GoogleFonts.roboto().fontFamily,
  appBarTheme: const AppBarTheme(
    elevation: 0,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
  useMaterial3: true,
);
