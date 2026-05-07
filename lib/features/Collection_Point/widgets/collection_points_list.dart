import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/theme/app_colors.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';
import 'package:hesteka_frontend/features/partner_ads/data/models/partner_ad_model.dart';

class CollectionPointsList extends StatelessWidget {
  const CollectionPointsList({
    super.key,
    required this.color,
    required this.cardBg,
    required this.points,
    required this.l10n,
    required this.onSeeOnMap,
    required this.onOpenDetails,
  });

  final Color color;
  final Color cardBg;
  final List<PartnerAdModel> points;
  final AppLocalizations l10n;
  final ValueChanged<PartnerAdModel> onSeeOnMap;
  final ValueChanged<PartnerAdModel> onOpenDetails;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: points.map((point) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: _CollectionPointCard(
              point: point,
              color: color,
              cardBg: cardBg,
              l10n: l10n,
              onSeeOnMap: () => onSeeOnMap(point),
              onOpenDetails: () => onOpenDetails(point),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CollectionPointCard extends StatelessWidget {
  const _CollectionPointCard({
    required this.point,
    required this.color,
    required this.cardBg,
    required this.l10n,
    required this.onSeeOnMap,
    required this.onOpenDetails,
  });

  final PartnerAdModel point;
  final Color color;
  final Color cardBg;
  final AppLocalizations l10n;
  final VoidCallback onSeeOnMap;
  final VoidCallback onOpenDetails;

  @override
  Widget build(BuildContext context) {
    final subtitle = point.partnerCompany ?? point.address;
    final logoUrl = point.photoUrl ?? '';
    final hasLocation = point.latitude != null && point.longitude != null;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: logoUrl.startsWith('http')
                  ? Image.network(
                      logoUrl,
                      fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.store,
                        color: AppColors.brandPrimary,
                        size: 32,
                      ),
                    )
                  : const Icon(
                      Icons.store,
                      color: AppColors.brandPrimary,
                      size: 32,
                    ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  point.title,
                  style: AppTextStyles.condensedSectionTitle.copyWith(
                    color: color,
                    fontSize: 15,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: color.withValues(alpha: 0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: hasLocation ? onSeeOnMap : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: color.withValues(alpha: 0.5),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            l10n.seeOnMap.toUpperCase(),
                            style: AppTextStyles.button.copyWith(
                              color: color,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: onOpenDetails,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            l10n.seeCollectionPoint.toUpperCase(),
                            style: AppTextStyles.button.copyWith(
                              color: Colors.white,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
