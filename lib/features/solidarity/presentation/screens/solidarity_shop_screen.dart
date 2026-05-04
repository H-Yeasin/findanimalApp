import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hesteka_frontend/core/routing/route_names.dart';
import 'package:hesteka_frontend/core/widgets/app_background.dart';
import 'package:hesteka_frontend/features/home/presentation/widgets/custom_bottom_navigation_bar.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../providers/solidarity_providers.dart';
import '../widgets/shop_hero_section.dart';
import '../widgets/shop_best_sellers_section.dart';
import '../widgets/shop_entire_collection_section.dart';
import '../widgets/shop_commitments_section.dart';

class SolidarityShopScreen extends ConsumerWidget {
  const SolidarityShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopState = ref.watch(solidarityShopProvider);
    final shopNotifier = ref.read(solidarityShopProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFBF4E9),
      body: AppBackground(
        child: Column(
          children: [
            const SafeArea(
              bottom: false,
              child: AppTopBar(showBackButton: true),
            ),
            Expanded(
              child: DefaultTextStyle(
                style: const TextStyle(color: Color(0xFFBA4A22)),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      ShopHeroSection(l10n: l10n),
                      const SizedBox(height: 40),
                      ShopBestSellersSection(
                        l10n: l10n,
                        products: shopState.products,
                      ),
                      const SizedBox(height: 40),
                      ShopEntireCollectionSection(
                        l10n: l10n,
                        selectedCategory: shopState.selectedCategory,
                        products: shopNotifier.filteredProducts,
                      ),
                      const SizedBox(height: 40),
                      ShopCommitmentsSection(l10n: l10n),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 4, // Set to 4 for Solidarity
        onTap: (index) {
          // Handle navigation back to main tabs
          switch (index) {
            case 0:
              context.go(
                RouteNames.root,
              ); // Usually switches to the tab via home logic
              break;
            case 1:
              context.go(RouteNames.mainReports);
              break;
            case 2:
              context.go(RouteNames.root);
              break;
            case 3:
              context.go(RouteNames.mainCommunity);
              break;
            case 4:
              context.pop(); // Since we are already in a sub-page of Solidarity
              break;
          }
        },
      ),
    );
  }
}
