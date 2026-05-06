import 'package:flutter/material.dart';

import '../../../../core/widgets/app_top_bar.dart';
import '../../../partner/presentation/widgets/partner_ui_kit.dart';

class LocalMissionHeader extends StatelessWidget {
  const LocalMissionHeader({
    required this.title,
    required this.description,
    super.key,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: CustomBackButton(color: PartnerUiColors.brand),
        ),
        const SizedBox(height: 10),
        PartnerPageTitle(title),
        const SizedBox(height: 10),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: PartnerUiColors.brand,
            fontSize: 13,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}
