import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ReportBaseLayout extends ConsumerWidget {
  final int currentStep;
  final String stepTitle;
  final Widget child;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const ReportBaseLayout({
    super.key,
    required this.currentStep,
    required this.stepTitle,
    required this.child,
    this.buttonText = 'Following',
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF4E9),
      body: Stack(
        children: [
          // Background Grid
          Positioned.fill(child: CustomPaint(painter: GridBackgroundPainter())),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(context, ref),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        _buildStepIndicator(),
                        const SizedBox(height: 30),
                        child,
                        const SizedBox(height: 40),
                        _buildMainButton(),
                        const SizedBox(height: 120), // Bottom nav space
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    return Column(
      children: [
        const AppTopBar(showBackButton: false),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const Text(
                'I REPORT',
                style: TextStyle(
                  color: Color(0xFFBA4A22),
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Impact',
                  letterSpacing: 1.5,
                ),
              ),
              const Text(
                'For each report, you earn 10 points on your Hesteka account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFBA4A22),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepIndicator() {
    const brandColor = Color(0xFFBA4A22);
    const circleSize = 50.0;

    return Column(
      children: [
        // Title row — perfectly aligned above each circle using spaceBetween
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(4, (index) {
            final stepNum = index + 1;
            final isActive = stepNum == currentStep;
            return SizedBox(
              width: circleSize,
              child: isActive
                  ? Text(
                      stepTitle.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: brandColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Impact',
                        height: 1.0,
                      ),
                    )
                  : const SizedBox.shrink(),
            );
          }),
        ),
        const SizedBox(height: 6),
        // Circles with a background line connecting them
        SizedBox(
          height: circleSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background connector line (from center of first to center of last circle)
              Positioned(
                left: circleSize / 2,
                right: circleSize / 2,
                child: Container(height: 2, color: brandColor),
              ),
              // Circles evenly distributed
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) {
                  final stepNum = index + 1;
                  final isActive = stepNum == currentStep;
                  return Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: BoxDecoration(
                      color: isActive ? brandColor : const Color(0xFFFBF4E9),
                      shape: BoxShape.circle,
                      border: Border.all(color: brandColor, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$stepNum',
                      style: TextStyle(
                        color: isActive ? Colors.white : brandColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Impact',
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainButton() {
    return GestureDetector(
      onTap: onButtonPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFBA4A22),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            buttonText.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              fontFamily: 'Impact',
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}

class GridBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFECDB)
      ..strokeWidth = 1.0;
    const double step = 60.0;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
