import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class MakeDonationHeader extends StatelessWidget {
  const MakeDonationHeader({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final heroHeight = screenWidth * 235 / 413;
    const surface = Color(0xFFFBF4E9);

    return Stack(
      children: [
        Container(
          height: heroHeight,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/soliderityHeader.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Text(
              l10n.makeDonation.toUpperCase().replaceAll(' ', '\n'),
              textAlign: TextAlign.center,
              style: AppTextStyles.display.copyWith(
                fontSize: 32,
                color: surface,
                height: 1.1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
