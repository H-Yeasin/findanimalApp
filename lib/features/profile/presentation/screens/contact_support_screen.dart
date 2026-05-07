import 'package:hesteka_frontend/core/config/app_assets.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import 'package:hesteka_frontend/features/partner/presentation/widgets/partner_ui_kit.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PartnerScreenScaffold(
      header: PartnerHeroHeader(
        title: l10n.contactUs,
        imageUrl: AppAssets.contactUs,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildContactOption(Icons.phone, '06 41 45 83 60'),
                  const SizedBox(width: 8),
                  _buildContactOption(Icons.email, 'contact@hesteka.com'),
                  const SizedBox(width: 8),
                  _buildContactOption(Icons.language, 'www.hesteka.com'),
                  const SizedBox(width: 8),
                  _buildContactOption(Icons.camera_alt, '@_hesteka...'),
                  const SizedBox(width: 8),
                  _buildContactOption(Icons.facebook, 'HESTEKA'),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildFieldLabel(l10n.fieldEmail),
            _buildInputField(l10n.emailHint),
            const SizedBox(height: 20),
            _buildFieldLabel(l10n.nameAndFirstName),
            _buildInputField(l10n.enterMyFirstAndLastName),
            const SizedBox(height: 20),
            _buildFieldLabel(l10n.subject),
            _buildInputField(l10n.contactSubjectHint),
            const SizedBox(height: 20),
            _buildFieldLabel(l10n.message),
            _buildInputField(l10n.tellUsEverything, maxLines: 5),
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: 280,
                height: 40,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: PartnerUiColors.brand),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    l10n.sendMyMessage,
                    style: AppTextStyles.body.copyWith(
                      color: PartnerUiColors.brand,
                      fontFamily: 'EricaOne',
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: PartnerUiColors.brand,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 4),
          Text(text, style: AppTextStyles.body.copyWith(color: Colors.white, fontSize: 8)),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        label,
        style: AppTextStyles.body.copyWith(
          color: PartnerUiColors.brand,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildInputField(String hint, {int maxLines = 1}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: PartnerUiColors.brand,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        hint,
        style: AppTextStyles.body.copyWith(
          color: Colors.white.withValues(alpha: 0.7),
          fontSize: 12,
        ),
      ),
    );
  }
}
