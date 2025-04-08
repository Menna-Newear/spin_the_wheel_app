import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spin_the_wheel_app/theme/theme.dart';

class LightTheme extends BaseTheme {
  @override
  Color get backgroundColor => Color(0xFFF5F5F5);

  @override
  Color get secondaryColor => Color(0xff6F6F6E);

  @override
  Color get primaryColor => Color(0xFFEE3035);

  @override
  Color get textColor => Color(0xFF333333);

  @override
  ThemeData get themeData => ThemeData(
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          secondary: secondaryColor,
        ),
        focusColor: Color(0xff7B7B7B),
        primaryColor: primaryColor,
        hintColor: backgroundColor,
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: secondaryColor,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: secondaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          titleSmall: GoogleFonts.inter(
            fontSize: 16,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: secondaryColor,
          ),
          titleLarge: GoogleFonts.inter(
            fontSize: 26,
            // fontWeight: FontWeight.bold,
            color: secondaryColor,
          ),
          labelMedium: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          labelLarge: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
}
