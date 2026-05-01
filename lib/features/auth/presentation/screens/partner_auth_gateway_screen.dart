import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/route_names.dart';
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
          const AuthMainTitle('HESTEKA PARTNER'),
          const SizedBox(height: 16),
          const Text(
            'Join the network of professionals\ndedicated to animal welfare.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AuthUiColors.brand,
              fontSize: 15,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 60),
          Center(
            child: AuthOutlinePillButton(
              label: 'LOG IN AS PARTNER',
              width: 250,
              onPressed: () => context.push(RouteNames.partnerLogin),
            ),
          ),
          const SizedBox(height: 20),
          AuthOrDivider(label: 'or'),
          const SizedBox(height: 20),
          Center(
            child: AuthFilledPillButton(
              label: 'REGISTER AS PARTNER',
              onPressed: () => context.push(RouteNames.partnerRegister),
              isLoading: false,
            ),
          ),
        ],
      ),
    );
  }
}
