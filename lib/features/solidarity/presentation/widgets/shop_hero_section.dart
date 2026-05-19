import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';

class ShopHeroSection extends StatelessWidget {
  final AppLocalizations l10n;

  const ShopHeroSection({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          l10n.shopHeroTitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.heading.copyWith(fontSize: 32),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.shopHeroSubtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.shopHeroDescription,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            fontSize: 14,
            height: 1.4,
            color: const Color(0xFFBA4A22),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          l10n.shopHeroCommitment,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            fontSize: 14,
            height: 1.4,
            color: const Color(0xFFBA4A22),
          ),
        ),
      ],
    );
  }
}
