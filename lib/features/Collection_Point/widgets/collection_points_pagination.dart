import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/theme/app_colors.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';
import 'package:hesteka_frontend/features/partner_ads/presentation/providers/partner_ads_filters_provider.dart';

class CollectionPointsPagination extends StatelessWidget {
  const CollectionPointsPagination({
    super.key,
    required this.color,
    required this.currentPage,
    required this.filterNotifier,
  });

  final Color color;
  final int currentPage;
  final PartnerAdsFiltersNotifier filterNotifier;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: currentPage > 1
              ? () => filterNotifier.setPage(currentPage - 1)
              : null,
          child: Icon(Icons.chevron_left, color: color, size: 24),
        ),
        const SizedBox(width: 10),
        for (int i = 1; i <= 3; i++) ...[
          GestureDetector(
            onTap: () => filterNotifier.setPage(i),
            child: Text(
              '$i',
              style: AppTextStyles.subtitle.copyWith(
                color: AppColors.brandPrimary,
                fontSize: 18,
                decoration: currentPage == i ? TextDecoration.underline : null,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
        GestureDetector(
          onTap: () => filterNotifier.setPage(currentPage + 1),
          child: Icon(Icons.chevron_right, color: color, size: 24),
        ),
      ],
    );
  }
}
