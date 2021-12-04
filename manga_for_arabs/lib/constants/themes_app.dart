import 'package:arabic_manga_readers/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.grey.shade800,
    backgroundColor: Colors.black,
    scaffoldBackgroundColor: Colors.grey.shade900,
    textTheme: TextTheme(
      headline1: GoogleFonts.tajawal(
          textStyle: TextStyle(
              color: Colors.grey.shade100,
              fontSize: 20.0.sp,
              fontWeight: FontWeight.w600)),
      headline2: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headline3: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headline4: GoogleFonts.openSans(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      headline5: GoogleFonts.openSans(
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      bodyText1: const TextStyle(color: Colors.white),
      bodyText2: const TextStyle(color: Colors.white),
      button: const TextStyle(color: Colors.amber),
    ),
  );

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: lBackgroundColor,
    textTheme: TextTheme(
      headline1: GoogleFonts.tajawal(
          textStyle: TextStyle(
              color: Colors.black,
              fontSize: 20.0.sp,
              fontWeight: FontWeight.w600)),
      headline2: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headline3: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headline4: GoogleFonts.openSans(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      headline5: GoogleFonts.openSans(
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      bodyText1: const TextStyle(color: Colors.white),
      bodyText2: const TextStyle(color: Colors.white),
      button: const TextStyle(color: Colors.amber),
    ),
  );
}
