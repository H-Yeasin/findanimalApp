import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';

class HomeSupportSection extends StatelessWidget {
  const HomeSupportSection({
    super.key,
    required this.onOpenDonation,
    required this.onOpenShop,
    required this.onOpenMission,
  });

  final VoidCallback onOpenDonation;
  final VoidCallback onOpenShop;
  final VoidCallback onOpenMission;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            l10n.homeSupportTitle,
            style: const TextStyle(
              color: Color(0xFFBA4A22),
              fontSize: 32,
              fontWeight: FontWeight.w900,
              fontFamily: 'EricaOne',
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    _SupportButton(
                      text: l10n.homeMakeDonation,
                      onTap: onOpenDonation,
                    ),
                    const SizedBox(height: 16),
                    _SupportButton(
                      text: l10n.homeSolidarityShop,
                      onTap: onOpenShop,
                    ),
                    const SizedBox(height: 16),
                    _SupportButton(
                      text: l10n.homeSignUpMission,
                      onTap: onOpenMission,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.homeSupportBody,
                      style: const TextStyle(
                        color: Color(0xFFBA4A22),
                        fontSize: 12,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.homeSupportPoints,
                      style: const TextStyle(
                        color: Color(0xFFBA4A22),
                        fontSize: 12,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SupportButton extends StatelessWidget {
  const _SupportButton({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFBA4A22),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
