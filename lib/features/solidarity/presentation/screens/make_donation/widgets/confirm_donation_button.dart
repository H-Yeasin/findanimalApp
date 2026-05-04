import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';

class ConfirmDonationButton extends StatelessWidget {
  const ConfirmDonationButton({
    super.key,
    required this.primaryOrange,
    required this.onTap,
  });

  final Color primaryOrange;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFBF4E9),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: primaryOrange.withValues(alpha: 0.5)),
          ),
          child: Text(
            l10n.validateMySupport.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: primaryOrange,
              fontWeight: FontWeight.w900,
              fontSize: 16,
              height: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}
