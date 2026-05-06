import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../partner/presentation/widgets/partner_ui_kit.dart';

class PartnerMissionCreateCard extends StatelessWidget {
  const PartnerMissionCreateCard({
    required this.titleController,
    required this.descriptionController,
    required this.addressController,
    required this.durationController,
    required this.pointsController,
    required this.latitude,
    required this.longitude,
    required this.hasSelectedImage,
    required this.isSubmitting,
    required this.onPickLocation,
    required this.onPickImage,
    required this.onCreateMission,
    super.key,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController addressController;
  final TextEditingController durationController;
  final TextEditingController pointsController;
  final double? latitude;
  final double? longitude;
  final bool hasSelectedImage;
  final bool isSubmitting;
  final VoidCallback onPickLocation;
  final VoidCallback onPickImage;
  final VoidCallback onCreateMission;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PartnerUiColors.panel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PartnerUiColors.brand),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PartnerFieldLabel(l10n.missionTitle),
          const SizedBox(height: 8),
          PartnerInputField(
            controller: titleController,
            hint: l10n.missionTitleHint,
          ),
          const SizedBox(height: 10),
          PartnerFieldLabel(l10n.message.toUpperCase()),
          const SizedBox(height: 8),
          PartnerInputField(
            controller: descriptionController,
            hint: l10n.missionDescriptionHint,
            maxLines: 3,
          ),
          const SizedBox(height: 10),
          PartnerFieldLabel(l10n.fieldAddress.toUpperCase()),
          const SizedBox(height: 8),
          PartnerInputField(
            controller: addressController,
            hint: l10n.missionAddressHint,
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: onPickLocation,
            child: PartnerOutlinedField(
              _locationLabel(l10n),
              trailing: const Icon(
                Icons.map_outlined,
                color: PartnerUiColors.brand,
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: 10),
          PartnerFieldLabel(l10n.categoryMessaging.toUpperCase()),
          const SizedBox(height: 8),
          PartnerInputField(
            controller: durationController,
            hint: l10n.missionDurationHint,
          ),
          const SizedBox(height: 10),
          PartnerFieldLabel(l10n.myPoints.toUpperCase()),
          const SizedBox(height: 8),
          PartnerInputField(controller: pointsController, hint: 'e.g. 250'),
          const SizedBox(height: 10),
          PartnerFieldLabel(l10n.missionImageOptional),
          const SizedBox(height: 8),
          InkWell(
            onTap: onPickImage,
            child: PartnerOutlinedField(
              hasSelectedImage ? l10n.imageSelected : l10n.uploadMissionImage,
              trailing: const Icon(
                Icons.cloud_upload_outlined,
                color: PartnerUiColors.brand,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: isSubmitting
                ? const CircularProgressIndicator(color: PartnerUiColors.brand)
                : PartnerPublishButton(
                    label: l10n.createLocalMission,
                    onTap: onCreateMission,
                  ),
          ),
        ],
      ),
    );
  }

  String _locationLabel(AppLocalizations l10n) {
    if (latitude == null || longitude == null) {
      return l10n.pickLocationOnMap;
    }

    return '${latitude!.toStringAsFixed(5)}, ${longitude!.toStringAsFixed(5)}';
  }
}
