import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';

import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/auth_screen_scaffold.dart';
import '../widgets/auth_ui_kit.dart';

/// Shown when a non-authenticated user navigates to the Partner section.
/// Gives them the choice to log in or register as a partner.
class PartnerAuthGatewayScreen extends StatelessWidget {
  const PartnerAuthGatewayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScreenScaffold(
      onBack: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(RouteNames.account);
        }
      },
      onBottomTap: (_) => context.go(RouteNames.root),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 6),
          AuthMainTitle(AppLocalizations.of(context).partner),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).partnerTitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: AuthUiColors.brand,
              fontSize: 15,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 60),
          Center(
            child: AuthOutlinePillButton(
              label: AppLocalizations.of(context).loginAsPartner,
              width: 250,
              onPressed: () => context.push(RouteNames.partnerLogin),
            ),
          ),
          const SizedBox(height: 20),
          AuthOrDivider(label: 'or'),
          const SizedBox(height: 20),
          Center(
            child: AuthFilledPillButton(
              label: AppLocalizations.of(context).registerAsPartner,
              onPressed: () => context.push(RouteNames.partnerRegister),
              isLoading: false,
            ),
          ),
        ],
      ),
    );
  }
}
