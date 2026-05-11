import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static const String titleFont = 'EricaOne';
  static const String bodyFont = 'BarlowCondensed';

  static const TextStyle display = TextStyle(
    fontFamily: titleFont,
    fontSize: 42,
    fontWeight: FontWeight.w400,
    height: 0.95,
    color: AppColors.brandPrimary,
  );

  static const TextStyle heading = TextStyle(
    fontFamily: titleFont,
    fontSize: 32,
    fontWeight: FontWeight.w400,
    height: 1,
    color: AppColors.brandPrimary,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: titleFont,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1,
    color: AppColors.brandPrimary,
  );

  //Barlow Condensed

  static const TextStyle condensedSectionTitle = TextStyle(
    fontFamily: bodyFont,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1,
    color: AppColors.brandPrimary,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.brandPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.brandPrimary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.surface,
  );

  static const TextStyle button = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle navLabel = TextStyle(
    fontFamily: bodyFont,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
