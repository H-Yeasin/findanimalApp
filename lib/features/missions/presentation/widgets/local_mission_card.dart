import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/models/mission_model.dart';
import '../../data/repositories/missions_repository_impl.dart';
import '../../../partner/presentation/widgets/partner_ui_kit.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class LocalMissionCard extends ConsumerWidget {
  const LocalMissionCard(this.mission, {this.onSeeOnMap, super.key});

  final MissionModel mission;
  final VoidCallback? onSeeOnMap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentUser = ref.watch(currentUserProvider);
    final organization = mission.partner?.company ?? l10n.organization;
    final timeAgo = mission.createdAt != null
        ? _formatTimeAgo(mission.createdAt!, l10n)
        : l10n.recently;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
            borderRadius: BorderRadius.circular(12),
            child: mission.photo != null
                ? Image.network(
                    mission.photo!.secureUrl,
                    width: 82,
                    height: 82,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _placeholder(),
                  )
                : _placeholder(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        mission.title.toUpperCase(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: PartnerUiColors.brand,
                          fontFamily: 'EricaOne',
                          fontSize: 16,
                          height: 1.05,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        color: PartnerUiColors.brand.withValues(alpha: 0.6),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '$organization | ${l10n.missionDuration.replaceAll('{duration}', mission.duration)}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: PartnerUiColors.brand,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onSeeOnMap,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: PartnerUiColors.brand,
                          side: const BorderSide(color: PartnerUiColors.brand),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(l10n.seeOnMap),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: currentUser?.role == 'partners'
                            ? null
                            : () => _joinMission(context, ref, l10n),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PartnerUiColors.brand,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(l10n.seeMission),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _joinMission(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    try {
      await ref.read(missionsRepositoryProvider).joinMission(mission.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.interestSubmitted),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      var errorMessage = '${l10n.error}: $e';
      if (e is DioException) {
        final responseData = e.response?.data;
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'].toString();
        }
      }

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }

  Widget _placeholder() {
    return Container(
      width: 82,
      height: 82,
      color: PartnerUiColors.grid,
      child: const Icon(Icons.flag_outlined, color: PartnerUiColors.brand),
    );
  }

  String _formatTimeAgo(DateTime dateTime, AppLocalizations l10n) {
    return Formatters.recentOrDateTime(
      dateTime,
      locale: l10n.locale.languageCode,
    );
  }
}
