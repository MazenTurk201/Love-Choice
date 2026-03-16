import 'package:flutter/material.dart';
import 'styles.dart';

class AppTheme {
  /// The dark theme for the app, with custom text styles and colors.
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    textTheme: TextTheme(
      headlineMedium: TextStyle(fontFamily: "TurkFont", color: Colors.white),
      labelMedium: TextStyle(fontFamily: "TurkFont", color: Colors.white),
      displayMedium: TextStyle(fontFamily: "TurkFont", color: Colors.white),
      titleMedium: TextStyle(fontFamily: "TurkFont", color: Colors.white),
      bodyLarge: TextStyle(fontFamily: "TurkFont", color: Colors.white),
      bodyMedium: TextStyle(
        fontFamily: "TurkFont",
        fontSize: 24,
        color: Colors.white,
      ),
      bodySmall: TextStyle(fontFamily: "TurkFont", color: Colors.white),
      displayLarge: TextStyle(fontFamily: "TurkFont", color: Colors.white),
      displaySmall: TextStyle(fontFamily: "TurkFont", color: Colors.white),
      headlineLarge: TextStyle(fontFamily: "TurkFont", color: Colors.white),
      headlineSmall: TextStyle(fontFamily: "TurkFont", color: Colors.white),
      labelLarge: TextStyle(fontFamily: "TurkFont", color: Colors.white),
      labelSmall: TextStyle(fontFamily: "TurkFont", color: Colors.white),
      titleLarge: TextStyle(fontFamily: "TurkFont", color: Colors.white),
      titleSmall: TextStyle(fontFamily: "TurkFont", color: Colors.white),
    ),
    tooltipTheme: TurkStyle().themetooltip,
    dialogTheme: DialogThemeData(
      titleTextStyle: TextStyle(
        fontFamily: "TurkFont",
        color: Colors.white,
        fontSize: 24,
      ),
      contentTextStyle: TextStyle(
        fontFamily: "TurkFont",
        color: Colors.white,
        fontSize: 20,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: TurkStyle().mainColor,
      titleTextStyle: TextStyle(
        fontFamily: "TurkFont",
        fontSize: 24,
        color: Colors.white,
      ),
    ),
  );
}
