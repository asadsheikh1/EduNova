import 'package:flutter/material.dart';

Color kMainColor = const Color(0xffb4560e);
MaterialColor kMainSwatchColor = MaterialColor(
  kMainColor.value,
  <int, Color>{
    50: const Color(0xffdaab87),
    100: const Color(0xffd29a6e),
    200: const Color(0xffcb8956),
    300: const Color(0xffc3783e),
    400: const Color(0xffbc6726),
    500: kMainColor,
    600: const Color(0xffa24d0d),
    700: const Color(0xff90450b),
    800: const Color(0xff7e3c0a),
    900: const Color(0xff6c3408),
  },
);

Color kLightColor = const Color(0xffeee9e6);
Color kDarkColor = const Color(0xff1E1F23);
Color kTransparentColor = Colors.transparent;
Color kTextColor = const Color(0xff6a6c74);
