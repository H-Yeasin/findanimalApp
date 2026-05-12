import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/theme/app_colors.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';
import 'package:hesteka_frontend/core/utils/formatters.dart';

import '../../data/models/points_history_item_model.dart';

class PointsHistoryTile extends StatelessWidget {
  const PointsHistoryTile({
    required this.item,
    super.key,
  });

  final PointsHistoryItemModel item;

  @override
  Widget build(BuildContext context) {
    final isDebit = item.points < 0;
    final pointsLabel = isDebit ? '${item.points}' : '+${item.points}';
    final reasonLabel = _resolveReason(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.brandPrimary.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Text(
            reasonLabel,
            style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 10),
          Text(
            Formatters.compactDate(item.createdAt),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.brandPrimary.withValues(alpha: 0.4),
            ),
          ),
          const Spacer(),
          Text(
            pointsLabel,
            style: AppTextStyles.subtitle.copyWith(
              fontWeight: FontWeight.w700,
              color: isDebit ? Colors.red : null,
            ),
          ),
        ],
      ),
    );
  }

  String _resolveReason(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final note = item.note?.trim();

    if (note != null && note.isNotEmpty) {
      const redeemedPrefix = 'Redeemed reward:';
      const refundPrefix = 'Refund for cancelled redemption:';

      if (note.startsWith(redeemedPrefix)) {
        final title = note.substring(redeemedPrefix.length).trim();
        return l10n.pointsReasonRedeemedReward(title);
      }

      if (note.startsWith(refundPrefix)) {
        return l10n.pointsReasonRefundCancelled;
      }
    }

    if (item.missionTitle != null && item.missionTitle!.trim().isNotEmpty) {
      return item.missionTitle!.trim();
    }

    switch (item.source) {
      case 'local_mission':
        return l10n.pointsReasonLocalMission;
      case 'physical_donation':
        return l10n.pointsReasonPhysicalDonation;
      case 'animal_report':
        return l10n.pointsReasonAnimalReport;
      case 'reward_item':
        return l10n.pointsReasonRewardRedemption;
      case 'redeem':
        return l10n.pointsReasonUsed;
      default:
        return item.reason.isNotEmpty ? item.reason : l10n.pointsReasonActivity;
    }
  }
}
