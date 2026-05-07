import 'package:hesteka_frontend/core/config/app_assets.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class HomeTopHeader extends StatelessWidget {
  const HomeTopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final heroHeight = screenWidth * 271 / 402;
    final logoWidth = (screenWidth - 34).clamp(280.0, 340.0);
    final logoHeight = logoWidth / (1150 / 431);

    return Stack(
      children: [
        SizedBox(
          height: heroHeight,
          width: double.infinity,
          child: const Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(color: Colors.black),
              Image(
                image: AssetImage(AppAssets.homeHero),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
              DecoratedBox(decoration: BoxDecoration()),
            ],
          ),
        ),
        Positioned(
          left: 17,
          bottom: 34,
          child: SizedBox(
            width: logoWidth,
            height: logoHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Image.asset(
                    AppAssets.logo,
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomLeft,
                  ),
                ),
                Positioned(
                  left: logoWidth * 0.41,
                  top: logoHeight * 0.41,
                  child: Text(
                    AppLocalizations.of(context).homeWelcomePrefix,
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white,
                      fontFamily: 'BarlowCondensed',
                      fontSize: (logoWidth * 0.055).clamp(15.0, 19.0),
                      fontWeight: FontWeight.w600,
                      height: 1,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.45),
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class HomeInfoBanner extends StatelessWidget {
  const HomeInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final bannerText = AppLocalizations.of(context).homeInfoBanner;
    const boldPhrases = ['Chaque action compte !', 'Every action counts!'];
    String? boldPhrase;
    for (final phrase in boldPhrases) {
      if (bannerText.contains(phrase)) {
        boldPhrase = phrase;
        break;
      }
    }
    final baseStyle = AppTextStyles.body.copyWith(
      color: Colors.white,
      fontFamily: 'BarlowCondensed',
      fontSize: 18,
      height: 1.16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 36, 16, 34),
      color: const Color(0xFFC64F2A),
      child: boldPhrase == null
          ? Text(bannerText, style: baseStyle)
          : RichText(
              text: TextSpan(
                style: baseStyle,
                children: [
                  TextSpan(
                    text:
                        '${bannerText.split(boldPhrase).first.trimRight()}\n\n',
                  ),
                  TextSpan(
                    text: boldPhrase,
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w800),
                  ),
                  TextSpan(text: bannerText.split(boldPhrase).last),
                ],
              ),
            ),
    );
  }
}
