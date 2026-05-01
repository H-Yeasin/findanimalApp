import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/app_top_bar.dart';

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
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
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
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const AppTopBar(showBackButton: false),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const Text('I REPORT', style: AppTextStyles.display),
              const Text(
                'For each report, you earn 10 points on your Hesteka account',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption,
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
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
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
                        fontFamily: 'EricaOne',
                        fontWeight: FontWeight.w400,
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
            style: AppTextStyles.button.copyWith(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
