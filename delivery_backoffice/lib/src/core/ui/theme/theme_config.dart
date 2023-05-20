import 'package:flutter/material.dart';

import '../styles/app_colors.dart';
import '../styles/app_styles.dart';
import '../styles/app_text_styles.dart';

class ThemeConfig {
  ThemeConfig._();

  static final _defaultInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(7),
    borderSide: BorderSide(
      color: Colors.grey[400]!,
    ),
  );
  static final theme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: Colors.black,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.instance.primary,
      primary: AppColors.instance.primary,
      secondary: AppColors.instance.secondary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: AppStyles.instance.primaryButton,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white,
      filled: true,
      isDense: true,
      contentPadding: const EdgeInsets.all(20),
      border: _defaultInputBorder,
      errorBorder: _defaultInputBorder,
      focusedBorder: _defaultInputBorder,
      enabledBorder: _defaultInputBorder,
      labelStyle: AppTextStyles.instance.textRegular.copyWith(
        color: Colors.black,
      ),
      errorStyle: AppTextStyles.instance.textRegular.copyWith(
        color: Colors.redAccent,
      ),
    ),
  );
}
