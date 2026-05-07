import 'package:hesteka_frontend/core/config/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';

import 'package:hesteka_frontend/features/partner/presentation/widgets/partner_ui_kit.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PartnerScreenScaffold(
      header: PartnerHeroHeader(
        title: l10n.privacyPolicyTitle,
        imageUrl: AppAssets.privacyPolicy, // Cat peeking image
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 20, 28, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.privacyPolicyIntro,
              style: AppTextStyles.body.copyWith(
                color: PartnerUiColors.brand,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 30),
            _buildSection(
              l10n.privacyDataCollectTitle,
              l10n.privacyDataCollectContent,
            ),
            _buildSection(l10n.privacyUseDataTitle, l10n.privacyUseDataContent),
            _buildSection(l10n.privacySharingTitle, l10n.privacySharingContent),
            _buildSection(
              l10n.privacyRetentionTitle,
              l10n.privacyRetentionContent,
            ),
            _buildSection(
              l10n.privacySecurityTitle,
              l10n.privacySecurityContent,
            ),
            _buildSection(l10n.privacyRightsTitle, l10n.privacyRightsContent),
            _buildSection(l10n.privacyContactTitle, l10n.privacyContactContent),
            Text(
              'contact@hesteka.com',
              style: AppTextStyles.body.copyWith(
                color: PartnerUiColors.brand,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.body.copyWith(
              color: PartnerUiColors.brand,
              fontFamily: 'EricaOne',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: AppTextStyles.body.copyWith(
              color: PartnerUiColors.brand,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
