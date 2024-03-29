import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = Color(0xff5BD0E5);
const secondaryColor = Color(0xffFF7171);
// const secondarySplashColor = Color(0xffF5C0C0);
// const splashColor = Color(0xffB8B5FF);

final lightTheme = ThemeData(
    fontFamily: GoogleFonts.poppins().fontFamily,
    primaryColor: primaryColor,);
    // splashColor: splashColor);
final darkTheme = ThemeData(
    fontFamily: GoogleFonts.poppins().fontFamily,
    primaryColor: primaryColor,
    brightness: Brightness.dark,);
    // splashColor: splashColor);
