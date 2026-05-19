import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/theme/app_colors.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class PointsUtilizedSection extends StatelessWidget {
  const PointsUtilizedSection({
    required this.totalUtilized,
    required this.onHistoryTap,
    super.key,
  });

  final int totalUtilized;
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
                  l10n.pointsUtilized,
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppColors.brandPrimary.withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.pointsTotalUtilized,
                style: AppTextStyles.subtitle.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                '$totalUtilized pts',
                style: AppTextStyles.subtitle.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: totalUtilized > 0
                      ? AppColors.brandPrimary
                      : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
