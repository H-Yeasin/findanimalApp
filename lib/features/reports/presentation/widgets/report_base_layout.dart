import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hesteka_frontend/features/home/presentation/widgets/custom_bottom_navigation_bar.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/app_top_bar.dart';

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
              _buildHeader(context, l10n),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      _buildStepIndicator(context),
                      const SizedBox(height: 30),
                      child,
                      const SizedBox(height: 40),
                      _buildMainButton(context, l10n),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
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

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
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
                softWrap: true,
                style: AppTextStyles.caption.copyWith(
                  fontSize: _responsiveFont(context, 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepIndicator(BuildContext context) {
    const brandColor = Color(0xFFBA4A22);

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth / 4).clamp(52.0, 82.0);
        final circleSize = (constraints.maxWidth / 4).clamp(44.0, 50.0);

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(4, (index) {
                final stepNum = index + 1;
                final isActive = stepNum == currentStep;
                return SizedBox(
                  width: itemWidth,
                  child:
                      isActive
                          ? Text(
                            stepTitle.toUpperCase(),
                            textAlign: TextAlign.center,
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: _responsiveFont(context, 12),
                              height: 1,
                            ),
                          )
                          : const SizedBox.shrink(),
                );
              }),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: circleSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: circleSize / 2,
                    right: circleSize / 2,
                    child: Container(height: 2, color: brandColor),
                  ),
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
                          style: AppTextStyles.body.copyWith(
                            color: isActive ? Colors.white : brandColor,
                            fontSize: _responsiveFont(context, 32),
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
      },
    );
  }

  Widget _buildMainButton(BuildContext context, AppLocalizations l10n) {
    final textScaler = MediaQuery.textScalerOf(context);

    return GestureDetector(
      onTap: onButtonPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFBA4A22),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child:
              textScaler.scale(1) > 1.15
                  ? Text(
                    (buttonText ?? l10n.following).toUpperCase(),
                    textAlign: TextAlign.center,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.button.copyWith(
                      fontSize: _responsiveFont(context, 18),
                      height: 1.1,
                    ),
                  )
                  : FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      (buttonText ?? l10n.following).toUpperCase(),
                      maxLines: 1,
                      style: AppTextStyles.button.copyWith(
                        fontSize: _responsiveFont(context, 18),
                      ),
                    ),
                  ),
        ),
      ),
    );
  }

  double _responsiveFont(BuildContext context, double size) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 360) return size * 0.85;
    if (width < 400) return size * 0.92;
    return size;
  }
}
