import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hesteka_frontend/features/home/presentation/widgets/custom_bottom_navigation_bar.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/routing/route_names.dart';
import 'package:go_router/go_router.dart';

class ReportBaseLayout extends ConsumerWidget {
  final int currentStep;
  final String stepTitle;
  final Widget child;
  final String? buttonText;
  final VoidCallback onButtonPressed;

  const ReportBaseLayout({
    super.key,
    required this.currentStep,
    required this.stepTitle,
    required this.child,
    this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, ref, l10n),
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
                      _buildMainButton(l10n),
                      const SizedBox(height: 20), // Reduced bottom space
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1, // Active tab for reporting flow
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(RouteNames.reports);
              break;
            case 1:
              context.go(RouteNames.myReports);
              break;
            case 2:
              context.go(RouteNames.mainHome);
              break;
            case 3:
              context.go(RouteNames.mainCommunity);
              break;
            case 4:
              context.go(RouteNames.mainSolidarity);
              break;
          }
        },
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        const AppTopBar(showBackButton: true),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Text(l10n.navReport.toUpperCase(), style: AppTextStyles.display),
              Text(
                l10n.reportPointsInfo,
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
              width: 70,
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
                        fontSize: 32,
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

  Widget _buildMainButton(AppLocalizations l10n) {
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
            (buttonText ?? l10n.following).toUpperCase(),
            style: AppTextStyles.button.copyWith(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
