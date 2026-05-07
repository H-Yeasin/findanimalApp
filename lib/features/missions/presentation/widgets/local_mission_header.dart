import 'package:flutter/material.dart';

import '../../../../core/widgets/app_top_bar.dart';
import '../../../partner/presentation/widgets/partner_ui_kit.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

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
        const SizedBox(height: 30),
        const AppTopBar(showUserAvatar: false),
        const SizedBox(height: 10),
        PartnerPageTitle(title),
        const SizedBox(height: 10),
        Text(
          description,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            color: PartnerUiColors.brand,
            fontSize: 13,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}
