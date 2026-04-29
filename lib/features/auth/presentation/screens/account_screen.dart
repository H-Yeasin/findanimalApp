import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/route_names.dart';
import '../widgets/auth_screen_scaffold.dart';
import '../widgets/auth_ui_kit.dart';

class AuthAccountScreen extends StatelessWidget {
  const AuthAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AuthScreenScaffold(
      onBack: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(RouteNames.root);
        }
      },
      onBottomTap: (_) => context.go(RouteNames.root),
      child: Column(
        children: [
          const SizedBox(height: 6),
          AuthMainTitle(l10n.accountTitle),
          const SizedBox(height: 70),
          AuthOutlinePillButton(
            label: l10n.login,
            width: 214,
            onPressed: () => context.push(RouteNames.login),
          ),
          const SizedBox(height: 20),
          AuthOrDivider(label: l10n.or),
          const SizedBox(height: 22),
          AuthOutlinePillButton(
            label: l10n.createAccount,
            width: 214,
            onPressed: () => context.push(RouteNames.register),
          ),
          const SizedBox(height: 38),
          AuthFilledPillButton(
            label: l10n.partnerAccess,
            onPressed: () => context.push(RouteNames.partnerAccess),
          ),
        ],
      ),
    );
  }
}
