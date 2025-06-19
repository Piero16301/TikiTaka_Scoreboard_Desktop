import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static final darkTheme = ThemeData(
    fontFamily: GoogleFonts.montserrat().fontFamily,
    useMaterial3: true,
    visualDensity: VisualDensity.compact,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    cardTheme: CardThemeData(
      color: const Color.fromRGBO(50, 49, 47, 1),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        foregroundColor: WidgetStateProperty.all(Colors.black),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    ),
    dividerColor: Colors.transparent,
    colorScheme: const ColorScheme.dark(primary: Colors.white),
  );

  static final lightTheme = ThemeData(
    fontFamily: GoogleFonts.montserrat().fontFamily,
    useMaterial3: true,
    visualDensity: VisualDensity.compact,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    cardTheme: CardThemeData(
      color: const Color.fromARGB(255, 207, 207, 207),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.black),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    ),
    dividerColor: Colors.transparent,
    colorScheme: const ColorScheme.light(primary: Colors.black),
  );
}
