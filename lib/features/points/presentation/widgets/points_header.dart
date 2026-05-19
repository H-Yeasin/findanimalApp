import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/theme/app_colors.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class PointsHeader extends StatelessWidget {
  const PointsHeader({required this.totalPoints, super.key});

  final int totalPoints;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.brandPrimary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.undo, color: Colors.white, size: 20),
          ),
        ),
        const SizedBox(width: 15),
        Text(
          AppLocalizations.of(context).pointsMyPoints,
          style: AppTextStyles.heading.copyWith(fontSize: 32),
        ),
        const SizedBox(width: 15),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.brandPrimary,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: AppColors.brandPrimary, width: 2),
          ),
          child: Text(
            '$totalPoints',
            style: AppTextStyles.condensedSectionTitle.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
