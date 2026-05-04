import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';

class ShopCommitmentsSection extends StatelessWidget {
  final AppLocalizations l10n;

  const ShopCommitmentsSection({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFBA4A22),
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          Text(
            l10n.shopCommitmentsLabel,
            textAlign: TextAlign.center,
            style: AppTextStyles.condensedSectionTitle.copyWith(
              color: AppColors.surface,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.shopCommitmentsTitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.heading.copyWith(
              color: AppColors.surface,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 220,
                  height: 150,
                  child: _CommitmentCard(
                    title: l10n.shopCommitment1Title,
                    description: l10n.shopCommitment1Description,
                    backgroundColor: const Color(0xFFC65D3B),
                    textColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 200,
                  height: 150,
                  child: _CommitmentCard(
                    title: l10n.shopCommitment2Title,
                    description: l10n.shopCommitment2Description,
                    backgroundColor: const Color(0xFFF9EAD4),
                    textColor: const Color(0xFFBA4A22),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 200,
                  height: 150,
                  child: _CommitmentCard(
                    title: l10n.shopCommitment3Title,
                    description: l10n.shopCommitment3Description,
                    backgroundColor: const Color(0xFFBA4A22),
                    textColor: const Color(0xFFF9EAD4),
                    hasBorder: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommitmentCard extends StatelessWidget {
  final String title;
  final String description;
  final Color backgroundColor;
  final Color textColor;
  final bool hasBorder;

  const _CommitmentCard({
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.textColor,
    this.hasBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: hasBorder
            ? Border.all(color: const Color(0xFFF9EAD4), width: 1.5)
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(
              fontSize: 16,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyles.condensedSectionTitle.copyWith(
              fontSize: 13,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
