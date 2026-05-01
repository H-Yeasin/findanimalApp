import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final base = ThemeData.light();
    final bodyTheme = base.textTheme.apply(
      fontFamily: AppTextStyles.bodyFont,
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTextStyles.bodyFont,
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.brandPrimary,
        surface: AppColors.surface,
      ),
      textTheme: bodyTheme.copyWith(
        displayLarge: bodyTheme.displayLarge?.copyWith(
          fontFamily: AppTextStyles.titleFont,
          fontWeight: FontWeight.w400,
        ),
        displayMedium: bodyTheme.displayMedium?.copyWith(
          fontFamily: AppTextStyles.titleFont,
          fontWeight: FontWeight.w400,
        ),
        displaySmall: bodyTheme.displaySmall?.copyWith(
          fontFamily: AppTextStyles.titleFont,
          fontWeight: FontWeight.w400,
        ),
        headlineLarge: bodyTheme.headlineLarge?.copyWith(
          fontFamily: AppTextStyles.titleFont,
          fontWeight: FontWeight.w400,
        ),
        headlineMedium: bodyTheme.headlineMedium?.copyWith(
          fontFamily: AppTextStyles.titleFont,
          fontWeight: FontWeight.w400,
        ),
        headlineSmall: bodyTheme.headlineSmall?.copyWith(
          fontFamily: AppTextStyles.titleFont,
          fontWeight: FontWeight.w400,
        ),
      ),
      primaryTextTheme: base.primaryTextTheme.apply(
        fontFamily: AppTextStyles.bodyFont,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.brandPrimary,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(textStyle: AppTextStyles.button),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(textStyle: AppTextStyles.button),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(textStyle: AppTextStyles.button),
      ),
    );
  }
}
