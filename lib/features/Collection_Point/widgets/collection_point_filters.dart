import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';
import 'package:hesteka_frontend/features/partner_ads/presentation/providers/partner_ads_filters_provider.dart';

class CollectionPointFilters extends StatelessWidget {
  const CollectionPointFilters({
    super.key,
    required this.color,
    required this.filterNotifier,
    required this.l10n,
    required this.onRadiusSelected,
  });

  final Color color;
  final PartnerAdsFiltersNotifier filterNotifier;
  final AppLocalizations l10n;
  final ValueChanged<double> onRadiusSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'name') {
                  filterNotifier.setSort('title', 'ascending');
                } else if (value == 'newest') {
                  filterNotifier.setSort('date', 'descending');
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 'name', child: Text(l10n.sortByName)),
                PopupMenuItem(value: 'newest', child: Text(l10n.sortByNewest)),
              ],
              child: _FilterButton(text: l10n.sortBy, color: color),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: PopupMenuButton<double>(
              onSelected: onRadiusSelected,
              itemBuilder: (context) => [
                PopupMenuItem(value: 1, child: Text(l10n.radiusValue(1))),
                PopupMenuItem(value: 5, child: Text(l10n.radiusValue(5))),
                PopupMenuItem(value: 10, child: Text(l10n.radiusValue(10))),
                PopupMenuItem(value: 50, child: Text(l10n.radiusValue(50))),
                PopupMenuItem(value: 0, child: Text(l10n.statusAll)),
              ],
              child: _FilterButton(text: l10n.nearbyKm(5), color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.button.copyWith(
                color: Colors.white,
                fontSize: 9,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 14),
        ],
      ),
    );
  }
}
