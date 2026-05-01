import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';

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
                image: AssetImage('assets/homeHero.png'),
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
                    'assets/images/Logo/logo.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomLeft,
                  ),
                ),
                Positioned(
                  left: logoWidth * 0.41,
                  top: logoHeight * 0.41,
                  child: Text(
                    AppLocalizations.of(context).homeWelcomePrefix,
                    style: TextStyle(
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      color: const Color(0xFFC65D3B),
      child: Text(
        AppLocalizations.of(context).homeInfoBanner,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          height: 1.5,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
