import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/product_model.dart';
import '../providers/solidarity_providers.dart';
import 'product_card.dart';

class ShopEntireCollectionSection extends ConsumerWidget {
  final AppLocalizations l10n;
  final String selectedCategory;
  final List<ProductModel> products;

  const ShopEntireCollectionSection({
    super.key,
    required this.l10n,
    required this.selectedCategory,
    required this.products,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopState = ref.watch(solidarityShopProvider);

    // Build category keys: "SEE ALL" + titles from collections
    final List<String> categoryKeys = ['SEE ALL'];
    for (var collection in shopState.collections) {
      String title = collection.title.toUpperCase();
      if (title == 'TOUT VOIR' || title == 'SEE ALL') continue;

      String key = title;
      if (title == 'VÊTEMENTS') key = 'CLOTHING';
      if (title == 'ACCESSOIRES') key = 'ACCESSORIES';

      if (!categoryKeys.contains(key)) {
        categoryKeys.add(key);
      }
    }

    return Column(
      children: [
        Text(
          l10n.shopEntireCollectionLabel,
          textAlign: TextAlign.center,
          style: AppTextStyles.heading.copyWith(
            fontSize: 14,
            height: 1.4,
            color: const Color(0xFFBA4A22),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.shopEntireCollectionTitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.heading.copyWith(
            fontSize: 36,
            height: 1.4,
            color: const Color(0xFFBA4A22),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.shopEntireCollectionDescription,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: categoryKeys.map((key) {
                String displayTitle = key;
                if (key == 'SEE ALL') {
                  displayTitle = l10n.shopSeeAll;
                } else if (key == 'CLOTHING') {
                  displayTitle = l10n.shopClothing;
                } else if (key == 'ACCESSORIES') {
                  displayTitle = l10n.shopAccessories;
                }

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () => ref
                        .read(solidarityShopProvider.notifier)
                        .setCategory(key),
                    child: _FilterChip(
                      displayTitle,
                      isSelected: selectedCategory == key,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (shopState.isLoading)
          const Padding(
            padding: EdgeInsets.all(40.0),
            child: CircularProgressIndicator(color: Color(0xFFBA4A22)),
          )
        else if (products.isEmpty)
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Text(l10n.shopNoProducts),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) =>
                ProductCard(l10n: l10n, product: products[index]),
          ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String text;
  final bool isSelected;

  const _FilterChip(this.text, {this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFBA4A22) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBA4A22), width: 1.5),
      ),
      child: Text(
        text,
        style: AppTextStyles.body.copyWith(
          fontFamily: 'EricaOne',
          fontSize: 14,
          color: isSelected ? Colors.white : const Color(0xFFBA4A22),
        ),
      ),
    );
  }
}
