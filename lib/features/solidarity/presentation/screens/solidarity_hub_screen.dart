import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hesteka_frontend/core/widgets/app_background.dart';
import 'package:hesteka_frontend/core/widgets/app_top_bar.dart';
import '../../../../core/localization/app_localizations.dart';
import '../widgets/hub_hero_section.dart';
import '../widgets/hub_donation_cta_section.dart';
import '../widgets/hub_collection_points_section.dart';
import '../widgets/hub_partners_section.dart';
import '../widgets/hub_shop_cta_section.dart';

class SolidarityHubScreen extends ConsumerWidget {
  const SolidarityHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    const surface = Color(0xFFFBF4E9);

    return Scaffold(
      backgroundColor: surface,
      body: AppBackground(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  HubHeroSection(l10n: l10n),
                  HubDonationCTASection(l10n: l10n),
                  HubCollectionPointsSection(l10n: l10n),
                  HubPartnersSection(l10n: l10n),
                  HubShopCTASection(l10n: l10n),
                ],
              ),
            ),
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(child: AppTopBar(showBackButton: false)),
            ),
          ],
        ),
      ),
    );
  }
}
