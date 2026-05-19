import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/product_model.dart';
import 'product_card.dart';

class ShopBestSellersSection extends StatelessWidget {
  final AppLocalizations l10n;
  final List<ProductModel> products;

  const ShopBestSellersSection({
    super.key,
    required this.l10n,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          l10n.shopBestSellersLabel,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            height: 0.1,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.shopBestSellersTitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.heading.copyWith(
            fontSize: 36,
            height: 1.4,
            color: const Color(0xFFBA4A22),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.shopBestSellersDescription,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            fontSize: 14,
            height: 1.4,
            color: const Color(0xFFBA4A22),
          ),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: products
                .map(
                  (p) => SizedBox(
                    width: 220,
                    height: 215,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ProductCard(l10n: l10n, product: p),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
