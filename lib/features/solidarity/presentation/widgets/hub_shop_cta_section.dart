import 'package:hesteka_frontend/core/config/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/route_names.dart';

class HubShopCTASection extends StatelessWidget {
  final AppLocalizations l10n;

  const HubShopCTASection({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    const brandPrimary = Color(0xFFBA4A22);

    return Column(
      children: [
        const SizedBox(height: 50),
        Stack(
          alignment: Alignment.topCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.asset(
                AppAssets.solidarityShop,
                height: 200,
                width: MediaQuery.of(context).size.width * 0.9,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            l10n.shopDescription,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: brandPrimary,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            context.push(RouteNames.solidarityShop);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 100),
            padding: const EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: brandPrimary,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              l10n.viewShop.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
