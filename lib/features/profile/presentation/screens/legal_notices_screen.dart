import 'package:hesteka_frontend/core/config/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';

import 'package:hesteka_frontend/features/partner/presentation/widgets/partner_ui_kit.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class LegalNoticesScreen extends StatelessWidget {
  const LegalNoticesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PartnerScreenScaffold(
      header: PartnerHeroHeader(
        title: l10n.legalNoticesTitle,
        imageUrl: AppAssets.legalNotice,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 20, 28, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.legalNoticesFullTitle,
              style: AppTextStyles.body.copyWith(
                color: PartnerUiColors.brand,
                fontFamily: 'EricaOne',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            _buildSection(l10n.legalEditorTitle, l10n.legalEditorContent),
            _buildSection(l10n.legalHostingTitle, l10n.legalHostingContent),
            _buildSection(l10n.legalIPTitle, l10n.legalIPContent),
            _buildSection(
              l10n.legalPersonalDataTitle,
              l10n.legalPersonalDataContent,
            ),
            _buildSection(
              l10n.legalResponsibilityTitle,
              l10n.legalResponsibilityContent,
            ),
            _buildSection(
              l10n.legalExternalLinksTitle,
              l10n.legalExternalLinksContent,
            ),
            _buildSection(l10n.legalLawTitle, l10n.legalLawContent),
            _buildSection(l10n.legalContactTitle, l10n.legalContactContent),
            Text(
              l10n.legalContactInfo,
              style: AppTextStyles.body.copyWith(
                color: PartnerUiColors.brand,
                fontWeight: FontWeight.bold,
                height: 1.4,
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
