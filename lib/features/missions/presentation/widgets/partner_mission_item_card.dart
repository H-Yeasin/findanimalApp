import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../partner/presentation/widgets/partner_ui_kit.dart';
import '../../data/models/mission_model.dart';
import 'mission_participants_bottom_sheet.dart';

class PartnerMissionItemCard extends StatelessWidget {
  const PartnerMissionItemCard({required this.mission, super.key});

  final MissionModel mission;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return InkWell(
      onTap: () => _showParticipants(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: PartnerUiColors.panel,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: PartnerUiColors.brand),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: mission.photo != null
                  ? Image.network(
                      mission.photo!.secureUrl,
                      width: 74,
                      height: 74,
                      fit: BoxFit.cover,
                      errorBuilder: (_, error, stackTrace) => _placeholder(),
                    )
                  : _placeholder(),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mission.title,
                    style: const TextStyle(
                      color: PartnerUiColors.brand,
                      fontFamily: 'EricaOne',
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mission.address,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: PartnerUiColors.brand,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    l10n.durationPoints
                        .replaceAll('{duration}', mission.duration)
                        .replaceAll(
                          '{points}',
                          (mission.points ?? 0).toString(),
                        ),
                    style: const TextStyle(
                      color: PartnerUiColors.brand,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showParticipants(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: PartnerUiColors.panel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return MissionParticipantsBottomSheet(missionId: mission.id);
      },
    );
  }

  Widget _placeholder() {
    return Container(
      width: 74,
      height: 74,
      color: const Color(0xFFE4D5B6),
      child: const Icon(Icons.flag_outlined, color: PartnerUiColors.brand),
    );
  }
}
