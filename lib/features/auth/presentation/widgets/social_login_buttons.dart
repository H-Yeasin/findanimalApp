import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({this.onApple, this.onGoogle, super.key});

  final VoidCallback? onApple;
  final VoidCallback? onGoogle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: onApple,
          icon: const Icon(Icons.apple),
          label: Text(l10n.continueWithApple),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: onGoogle,
          icon: const Icon(Icons.g_mobiledata),
          label: Text(l10n.continueWithGoogle),
        ),
      ],
    );
  }
}
