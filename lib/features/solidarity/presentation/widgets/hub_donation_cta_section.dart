import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../screens/make_donation_screen.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class HubDonationCTASection extends StatelessWidget {
  final AppLocalizations l10n;

  const HubDonationCTASection({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    const brandPrimary = Color(0xFFBA4A22);

    return Column(
      children: [
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            l10n.solidarityDescription,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              color: brandPrimary,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 15),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const MakeDonationScreen(),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 45,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: brandPrimary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              l10n.makeDonation.toUpperCase(),
              style: AppTextStyles.body.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                height: 1.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
