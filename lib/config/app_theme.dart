import 'package:flutter/material.dart';

import 'app_color.dart';

ThemeData getLightTheme() {
  return ThemeData.light().copyWith(
      sliderTheme: const SliderThemeData(
        showValueIndicator: ShowValueIndicator.always,
      ),
      appBarTheme: const AppBarTheme(elevation: 0, color: Colors.white),
      primaryColor: AppColor.primary,
      scaffoldBackgroundColor: Colors.white,
      highlightColor: Colors.transparent,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 0, foregroundColor: Colors.white),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColor.primary),
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColor.primary,
        secondary: AppColor.primary,
      ));
}
