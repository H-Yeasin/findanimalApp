import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../partner/presentation/widgets/partner_ui_kit.dart';
import '../../data/models/mission_model.dart';
import '../providers/partner_missions_provider.dart';
import 'partner_mission_item_card.dart';

class PartnerCreatedMissionsList extends ConsumerWidget {
  const PartnerCreatedMissionsList({required this.missionsAsync, super.key});

  final AsyncValue<List<MissionModel>> missionsAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return missionsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.only(top: 30),
        child: Center(
          child: CircularProgressIndicator(color: PartnerUiColors.brand),
        ),
      ),
      error: (error, stack) => Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Text(
              l10n.couldNotLoadMissions,
              style: const TextStyle(
                color: PartnerUiColors.brand,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => ref.invalidate(partnerMissionsProvider),
              child: Text(l10n.retry),
            ),
          ],
        ),
      ),
      data: (missions) {
        if (missions.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              l10n.noMissionsCreated,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: PartnerUiColors.brand,
                fontFamily: 'EricaOne',
                fontSize: 22,
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: missions.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            return PartnerMissionItemCard(mission: missions[index]);
          },
        );
      },
    );
  }
}
