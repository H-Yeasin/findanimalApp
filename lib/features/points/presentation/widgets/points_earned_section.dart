import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/theme/app_colors.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

import '../../data/models/points_category_summary_model.dart';
import 'points_category_row.dart';

class PointsEarnedSection extends StatelessWidget {
  const PointsEarnedSection({
    required this.categories,
    required this.onHistoryTap,
    super.key,
  });

  final List<PointsCategorySummaryModel> categories;
  final VoidCallback onHistoryTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onHistoryTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.pointsEarned,
                  style: AppTextStyles.subtitle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.pointsHistory,
                      style: AppTextStyles.subtitle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.brandPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: AppColors.brandPrimary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (categories.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              l10n.pointsNoEarnedHistory,
              style: AppTextStyles.body.copyWith(
                color: AppColors.brandPrimary.withValues(alpha: 0.7),
              ),
            ),
          )
        else
          ...categories.map((summary) => PointsCategoryRow(summary: summary)),
      ],
    );
  }
}
