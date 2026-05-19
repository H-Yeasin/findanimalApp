import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/points_provider.dart';
import '../widgets/points_header.dart';
import '../widgets/points_earned_section.dart';
import '../widgets/points_utilized_section.dart';
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
                const SizedBox(height: 10),
                PointsEarnedSection(
                  categories: state.earnedByCategory,
                  onHistoryTap: () =>
                      context.push(RouteNames.pointsEarnedHistory),
                ),
                const SizedBox(height: 24),
                PointsUtilizedSection(
                  totalUtilized: state.totalPointsUtilized,
                  onHistoryTap: () =>
                      context.push(RouteNames.profileMyRedemptions),
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
