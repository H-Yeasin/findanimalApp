import 'package:flutter/material.dart';
import '../../../../core/widgets/app_top_bar.dart';
import 'package:hesteka_frontend/features/partner/presentation/widgets/partner_ui_kit.dart';
import '../../../../core/localization/app_localizations.dart';

class PartnerPublishAdScreen extends StatelessWidget {
  const PartnerPublishAdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PartnerScreenScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppTopBar(showBackButton: false),
            const SizedBox(height: 6),
            PartnerPageTitle(l10n.publishAdTitle),
            const SizedBox(height: 20),
            PartnerSectionHeading(
              l10n.placeAdLocalMission,
              trailing: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: PartnerUiColors.brand,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.home_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(height: 16),
            PartnerFieldLabel(l10n.titleOfLocalMission),
            const SizedBox(height: 10),
            const PartnerMissionTitleField(),
            const SizedBox(height: 14),
            PartnerFieldLabel(l10n.addressOfLocalMission),
            const SizedBox(height: 10),
            PartnerOutlinedField(l10n.missionAddressHint),
            const SizedBox(height: 14),
            PartnerFieldLabel(l10n.durationOfLocalMission),
            const SizedBox(height: 10),
            PartnerOutlinedField(l10n.missionDurationHint),
            const SizedBox(height: 14),
            PartnerFieldLabel(l10n.photoOfLocalMission),
            const SizedBox(height: 10),
            PartnerOutlinedField(
              l10n.uploadPhoto,
              leading: const Icon(
                Icons.cloud_upload,
                color: PartnerUiColors.brand,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: PartnerPublishButton(
                label: l10n.publishMyAd,
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
