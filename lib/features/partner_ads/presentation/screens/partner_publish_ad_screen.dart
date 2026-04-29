import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../widgets/partner_ui_kit.dart';

class PartnerPublishAdScreen extends StatelessWidget {
  const PartnerPublishAdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PartnerScreenScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppTopBar(showBackButton: false),
            const SizedBox(height: 6),
            const PartnerPageTitle('PUBLISH\nAN ADVERTISEMENT'),
            const SizedBox(height: 20),
            PartnerSectionHeading(
              'PLACE AN ADVERTISEMENT - LOCAL MISSION',
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
            const PartnerFieldLabel('TITLE OF THE LOCAL MISSION'),
            const SizedBox(height: 10),
            const PartnerMissionTitleField(),
            const SizedBox(height: 14),
            const PartnerFieldLabel('ADDRESS OF THE LOCAL MISSION'),
            const SizedBox(height: 10),
            const PartnerOutlinedField(hint: 'Address of local mission'),
            const SizedBox(height: 14),
            const PartnerFieldLabel('DURATION OF THE LOCAL MISSION'),
            const SizedBox(height: 10),
            const PartnerOutlinedField(hint: 'Duration of local mission'),
            const SizedBox(height: 14),
            const PartnerFieldLabel('PHOTO OF THE LOCAL MISSION'),
            const SizedBox(height: 10),
            const PartnerOutlinedField(
              hint: 'Upload a photo',
              leading: Icon(
                Icons.cloud_upload,
                color: PartnerUiColors.brand,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: PartnerPublishButton(
                label: 'Publish my ad',
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
