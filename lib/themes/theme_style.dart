import 'package:flutter/material.dart';
import 'package:edu_nova/themes/colors.dart';

class ThemeStyle {
  static ThemeData lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: kLightColor,
      iconTheme: IconThemeData(color: kMainSwatchColor),
      foregroundColor: kMainSwatchColor,
    ),
    primarySwatch: kMainSwatchColor,
    scaffoldBackgroundColor: kLightColor,
    dialogBackgroundColor: kLightColor,
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: kLightColor),
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontFamily: 'Lato', color: kMainSwatchColor),
      bodyMedium: TextStyle(fontFamily: 'Lato', color: kMainSwatchColor),
      bodySmall: TextStyle(fontFamily: 'Lato', color: kMainSwatchColor),
      displayLarge: TextStyle(fontFamily: 'Lato', color: kMainSwatchColor),
      displayMedium: TextStyle(fontFamily: 'Lato', color: kMainSwatchColor),
      displaySmall: TextStyle(fontFamily: 'Lato', color: kMainSwatchColor),
      headlineLarge: TextStyle(fontFamily: 'Lato', color: kMainSwatchColor),
      headlineMedium: TextStyle(fontFamily: 'Lato', color: kMainSwatchColor),
      headlineSmall: TextStyle(fontFamily: 'Lato', color: kMainSwatchColor),
      labelLarge: TextStyle(fontFamily: 'Lato', color: kMainSwatchColor),
      labelMedium: TextStyle(fontFamily: 'Lato', color: kMainSwatchColor),
      labelSmall: TextStyle(fontFamily: 'Lato', color: kMainSwatchColor),
      titleLarge: TextStyle(fontFamily: 'Lato', color: kMainSwatchColor),
      titleMedium: TextStyle(fontFamily: 'Lato', color: kMainSwatchColor),
      titleSmall: TextStyle(fontFamily: 'Lato', color: kMainSwatchColor),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: kDarkColor,
      iconTheme: IconThemeData(color: kMainSwatchColor),
      foregroundColor: kMainSwatchColor,
    ),
    primarySwatch: kMainSwatchColor,
    scaffoldBackgroundColor: kDarkColor,
    dialogBackgroundColor: kDarkColor,
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: kDarkColor),
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontFamily: 'Lato', color: kLightColor),
      bodyMedium: TextStyle(fontFamily: 'Lato', color: kLightColor),
      bodySmall: TextStyle(fontFamily: 'Lato', color: kLightColor),
      displayLarge: TextStyle(fontFamily: 'Lato', color: kLightColor),
      displayMedium: TextStyle(fontFamily: 'Lato', color: kLightColor),
      displaySmall: TextStyle(fontFamily: 'Lato', color: kLightColor),
      headlineLarge: TextStyle(fontFamily: 'Lato', color: kLightColor),
      headlineMedium: TextStyle(fontFamily: 'Lato', color: kLightColor),
      headlineSmall: TextStyle(fontFamily: 'Lato', color: kLightColor),
      labelLarge: TextStyle(fontFamily: 'Lato', color: kLightColor),
      labelMedium: TextStyle(fontFamily: 'Lato', color: kLightColor),
      labelSmall: TextStyle(fontFamily: 'Lato', color: kLightColor),
      titleLarge: TextStyle(fontFamily: 'Lato', color: kLightColor),
      titleMedium: TextStyle(fontFamily: 'Lato', color: kLightColor),
      titleSmall: TextStyle(fontFamily: 'Lato', color: kLightColor),
    ),
  );
}
