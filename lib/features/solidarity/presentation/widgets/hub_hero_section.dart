import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';

class HubHeroSection extends StatelessWidget {
  final AppLocalizations l10n;

  const HubHeroSection({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    const surface = Color(0xFFFBF4E9);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final heroHeight = screenWidth * 235 / 413;

    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/soliderityHeader.png',
          height: heroHeight,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          height: heroHeight,
          width: double.infinity,
          color: Colors.black.withValues(alpha: 0.1),
        ),
        Positioned(
          bottom: 100,
          child: Text(
            l10n.together,
            style: AppTextStyles.display.copyWith(fontSize: 32, color: surface),
          ),
        ),
      ],
    );
  }
}
