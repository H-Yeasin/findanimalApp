import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/theme/app_colors.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

import '../../data/models/points_category_summary_model.dart';

/// A single row displaying points earned for one earning category.
/// Always rendered even if [summary.points] is 0.
class PointsCategoryRow extends StatelessWidget {
  const PointsCategoryRow({required this.summary, super.key});

  final PointsCategorySummaryModel summary;

  @override
  Widget build(BuildContext context) {
    final hasPoints = summary.points > 0;
    final icon = _iconForSource(summary.sourceKey);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.brandPrimary.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.brandPrimary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: AppColors.brandPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              summary.label,
              style: AppTextStyles.subtitle.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            hasPoints ? '+${summary.points} pts' : '0 pts',
            style: AppTextStyles.subtitle.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: hasPoints
                  ? AppColors.brandPrimary
                  : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForSource(String source) {
    switch (source) {
      case 'animal_report':
        return Icons.pets;
      case 'local_mission':
        return Icons.handshake_outlined;
      case 'physical_donation':
        return Icons.volunteer_activism_outlined;
      default:
        return Icons.star_outline;
    }
  }
}
