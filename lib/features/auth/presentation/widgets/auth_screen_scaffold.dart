import 'package:flutter/material.dart';

import '../../../home/presentation/widgets/custom_bottom_navigation_bar.dart';

class AuthScreenScaffold extends StatelessWidget {
  const AuthScreenScaffold({
    required this.child,
    this.onBack,
    this.showBackButton = true,
    this.bottomNavIndex = 2,
    this.onBottomTap,
    this.contentPadding = const EdgeInsets.fromLTRB(34, 18, 34, 24),
    super.key,
  });

  final Widget child;
  final VoidCallback? onBack;
  final bool showBackButton;
  final int bottomNavIndex;
  final ValueChanged<int>? onBottomTap;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      body: Column(
        children: [
          _AuthHeroHeader(showBackButton: showBackButton, onBack: onBack),
          Expanded(
            child: Stack(
              children: [
                const Positioned.fill(
                  child: CustomPaint(painter: _GridPainter()),
                ),
                SafeArea(
                  top: false,
                  bottom: false,
                  child: SingleChildScrollView(
                    padding: contentPadding,
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: bottomNavIndex,
        onTap: onBottomTap ?? (_) {},
      ),
    );
  }
}

class _AuthHeroHeader extends StatelessWidget {
  const _AuthHeroHeader({required this.showBackButton, required this.onBack});

  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 243,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/cat.png', fit: BoxFit.cover),
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
                  child: const Icon(
                    Icons.undo,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          Align(
            alignment: const Alignment(0, 0.52),
            child: Image.asset(
              'assets/images/Logo/logo.png',
              width: 246,
              fit: BoxFit.contain,
              errorBuilder: (_, error, stackTrace) => const Text(
                'HESTEKA',
                style: TextStyle(
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

class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE7DCCB)
      ..strokeWidth = 1;

    const xStep = 92.0;
    const yStep = 102.0;

    for (double x = 0; x <= size.width; x += xStep) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y <= size.height; y += yStep) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
