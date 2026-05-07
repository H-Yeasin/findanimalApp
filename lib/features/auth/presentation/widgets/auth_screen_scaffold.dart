import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/config/app_assets.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../home/presentation/widgets/custom_bottom_navigation_bar.dart';

class AuthScreenScaffold extends StatelessWidget {
  const AuthScreenScaffold({
    required this.child,
    this.onBack,
    this.headerAction,
    this.showBackButton = true,
    this.showBottomNavigation = false,
    this.bottomNavIndex = 2,
    this.onBottomTap,
    this.contentPadding = const EdgeInsets.fromLTRB(34, 18, 34, 24),
    super.key,
  });

  final Widget child;
  final VoidCallback? onBack;
  final Widget? headerAction;
  final bool showBackButton;
  final bool showBottomNavigation;
  final int bottomNavIndex;
  final ValueChanged<int>? onBottomTap;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          _AuthHeroHeader(
            showBackButton: showBackButton,
            onBack: onBack,
            headerAction: headerAction,
          ),
          Expanded(
            child: AppBackground(
              backgroundColor: const Color(0xFFEDEDED),
              lineColor: const Color(0xFFE7DCCB),
              child: SafeArea(
                top: false,
                bottom: false,
                child: SingleChildScrollView(
                  padding: contentPadding,
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: showBottomNavigation
          ? CustomBottomNavigationBar(
              currentIndex: bottomNavIndex,
              onTap: onBottomTap ?? (_) {},
            )
          : null,
    );
  }
}

class _AuthHeroHeader extends StatelessWidget {
  const _AuthHeroHeader({
    required this.showBackButton,
    required this.onBack,
    required this.headerAction,
  });

  final bool showBackButton;
  final VoidCallback? onBack;
  final Widget? headerAction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 243,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssets.cat, fit: BoxFit.cover),
          Container(color: Colors.black.withValues(alpha: 0.03)),
          if (showBackButton)
            Positioned(
              left: 28,
              top: 38,
              child: InkWell(
                onTap: onBack,
                customBorder: const CircleBorder(),
                child: Container(
                  width: 43,
                  height: 43,
                  decoration: const BoxDecoration(
                    color: Color(0xFFB84C24),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.undo, color: Colors.white, size: 24),
                ),
              ),
            ),
          if (headerAction != null)
            Positioned(right: 24, top: 38, child: headerAction!),
          Align(
            alignment: const Alignment(0, 0.52),
            child: Image.asset(
              AppAssets.logo,
              width: 246,
              fit: BoxFit.contain,
              errorBuilder: (_, error, stackTrace) => Text(
                'HESTEKA',
                style: AppTextStyles.heading.copyWith(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
