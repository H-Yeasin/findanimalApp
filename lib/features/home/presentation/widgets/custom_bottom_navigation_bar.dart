import 'package:hesteka_frontend/core/config/app_assets.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
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
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      color: const Color(0xFFBA4A22),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        height: 65,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 65,
                color: const Color(0xFFBA4A22),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                  ), // Adjust this value to bring items closer
                  child: Row(
                    children: [
                      Expanded(
                        child: _item(
                          index: 0,
                          icon: 'search',
                          label: l10n.navSeek,
                        ),
                      ),
                      Expanded(
                        child: _item(
                          index: 1,
                          icon: 'report',
                          label: l10n.navReport,
                        ),
                      ),
                      const SizedBox(width: 50),
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
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
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
                        width: 6,
                      ),
                    ),
                    child: Center(
                      child: Transform.translate(
                        offset: const Offset(
                          -10,
                          -5,
                        ), // Adjust this value to move it more/less
                        child: Image.asset(
                          AppAssets.bottomNavMiddle,
                          width: 60,
                          height: 60,
                          // fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
              AppAssets.bottomNavIcon(icon),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: AppTextStyles.navLabel,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
