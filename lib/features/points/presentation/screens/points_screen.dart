import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';

import '../../../../core/routing/route_names.dart';
import '../../../home/presentation/widgets/custom_bottom_navigation_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/points_provider.dart';
import '../widgets/points_header.dart';
import '../widgets/points_history_section.dart';
import '../widgets/points_redeem_section.dart';

class PointsScreen extends ConsumerWidget {
  const PointsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pointsState = ref.watch(pointsProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: pointsState.when(
          data: (state) => _buildContent(context, state),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                l10n.errorLoadingFailed,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.brandPrimary,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(RouteNames.root);
              break;
            case 1:
              context.go(RouteNames.mainReports);
              break;
            case 3:
              context.go(RouteNames.mainCommunity);
              break;
            case 4:
              context.go(RouteNames.mainSolidarity);
              break;
            case 2:
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(RouteNames.mainProfile);
              }
              break;
          }
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, PointsState state) {
    final l10n = AppLocalizations.of(context);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PointsHeader(totalPoints: state.totalPoints),
                const SizedBox(height: 30),
                PointsHistorySection(
                  title: l10n.pointsEarned,
                  history: state.earnedHistory,
                  emptyMessage: l10n.pointsNoEarnedHistory,
                ),
                const SizedBox(height: 24),
                PointsHistorySection(
                  title: l10n.pointsUsed,
                  history: state.usedHistory,
                  emptyMessage: l10n.pointsNoUsedHistory,
                  onTap: () => context.push(RouteNames.profileMyRedemptions),
                ),
                const SizedBox(height: 40),
                PointsRedeemSection(state: state),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
