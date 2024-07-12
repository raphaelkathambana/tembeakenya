import 'package:flutter/material.dart';

class ColorsUtil {
  static const Color primaryColorLight = Color(0xff84873B);
  static const Color secondaryColorLight = Color(0xFFcfb796);
  static const Color accentColorLight = Color(0xFFc4df81);
  static const Color textColorLight = Color(0xff070901);
  static const Color backgroundColorLight = Color(0xffecf0e5);

  static const Color primaryColorDark = Color(0xffc1c478);
  static const Color secondaryColorDark = Color(0xFF695130);
  static const Color accentColorDark = Color(0xFF637e20);
  static const Color textColorDark = Color(0xfffcfef6);
  static const Color backgroundColorDark = Color(0xff161a0f);
  static const Color cardColorDark = Color(0xff262f14);
  static const Color descriptionColorDark = Color(0xff2d3915);
  // static const Color cardColorDark = ColorsUtil.cardColorDark;
  // static const Color describtionColorDark = ColorsUtil.describtionColorDark;
}

ThemeData darkThemeData = ThemeData(
  fontFamily: 'Montserrat',
  /* dark theme settings */
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: ColorsUtil.accentColorDark,
    primary: ColorsUtil.primaryColorDark,
    secondary: ColorsUtil.secondaryColorDark,
    surface: ColorsUtil.backgroundColorDark,
    background: ColorsUtil.backgroundColorDark,
    // card: ColorsUtil.cardColorDark,
    // describtion: ColorsUtil.describtionColorDark,
    onSecondary: ColorsUtil.textColorDark,
    onSurface: ColorsUtil.textColorDark,
    onBackground: ColorsUtil.textColorDark,
    onError: ColorsUtil.textColorDark,
    surfaceVariant: ColorsUtil.secondaryColorLight,
  ),
  useMaterial3: true,
);
ThemeData lightThemeData = ThemeData(
  fontFamily: 'Montserrat',
  brightness: Brightness.light,
  /* light theme settings */
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: ColorsUtil.accentColorLight,
    primary: ColorsUtil.primaryColorLight,
    secondary: ColorsUtil.secondaryColorLight,
    surface: ColorsUtil.backgroundColorLight,
    background: ColorsUtil.backgroundColorLight,
    onPrimary: ColorsUtil.textColorLight,
    onSecondary: ColorsUtil.textColorLight,
    onSurface: ColorsUtil.textColorLight,
    onBackground: ColorsUtil.textColorLight,
    onError: ColorsUtil.textColorLight,
    surfaceVariant: ColorsUtil.secondaryColorLight,
  ),
  useMaterial3: true,
);
