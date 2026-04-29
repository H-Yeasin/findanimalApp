import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
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
        const AppTopBar(
          showBackButton: false,
        ),
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
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text(
              stepTitle.toUpperCase(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFFBA4A22),
                fontSize: 16,
                fontWeight: FontWeight.w900,
                fontFamily: 'Impact',
                height: 1.0,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            final stepNum = index + 1;
            final isActive = stepNum == currentStep;
            final isCompleted = stepNum < currentStep;

            return Expanded(
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isActive ? const Color(0xFFBA4A22) : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFBA4A22),
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$stepNum',
                      style: TextStyle(
                        color: isActive ? Colors.white : const Color(0xFFBA4A22),
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Impact',
                      ),
                    ),
                  ),
                  if (index < 3)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: const Color(0xFFBA4A22),
                      ),
                    ),
                ],
              ),
            );
          }),
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
