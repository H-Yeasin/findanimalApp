import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/theme/app_colors.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

import '../../data/models/points_history_item_model.dart';
import 'points_history_tile.dart';

class PointsHistorySection extends StatelessWidget {
  const PointsHistorySection({
    required this.title,
    required this.history,
    required this.emptyMessage,
    this.onTap,
    super.key,
  });

  final String title;
  final List<PointsHistoryItemModel> history;
  final String emptyMessage;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.subtitle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
              onPressed: onTap,
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.brandPrimary,
                size: 20,
              ),
              visualDensity: VisualDensity.compact,
              splashRadius: 20,
            ),
          ],
        ),
        const SizedBox(height: 15),
        if (history.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(emptyMessage, style: AppTextStyles.body),
          )
        else
          ...history.map((item) => PointsHistoryTile(item: item)),
      ],
    );
  }
}
