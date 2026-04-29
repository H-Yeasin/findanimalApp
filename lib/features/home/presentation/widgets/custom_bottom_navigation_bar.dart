import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      height: 104,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 82,
              color: const Color(0xFFBA4A22),
              child: Row(
                children: [
                  Expanded(
                    child: _item(index: 0, icon: 'search', label: l10n.navSeek),
                  ),
                  Expanded(
                    child: _item(index: 1, icon: 'report', label: l10n.navReport),
                  ),
                  const SizedBox(width: 84),
                  Expanded(
                    child: _item(
                      index: 3,
                      icon: 'community',
                      label: l10n.navCommunity,
                    ),
                  ),
                  Expanded(
                    child: _item(
                      index: 4,
                      icon: 'solidarity',
                      label: l10n.navSolidarity,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 42,
            child: Center(
              child: GestureDetector(
                onTap: () => onTap(2),
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBF4E9),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFBA4A22),
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/Bottom_Navigation_icon/bottom_nav_middle.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item({
    required int index,
    required String icon,
    required String label,
  }) {
    final isActive = index == currentIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Opacity(
        opacity: isActive ? 1 : 0.84,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Bottom_Navigation_icon/$icon.png',
              width: 24,
              height: 24,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.circle_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
