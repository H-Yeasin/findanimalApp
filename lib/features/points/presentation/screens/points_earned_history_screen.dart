import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/points_provider.dart';
import '../widgets/points_history_tile.dart';

class PointsEarnedHistoryScreen extends ConsumerWidget {
  const PointsEarnedHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pointsState = ref.watch(pointsProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: AppColors.brandPrimary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.undo, color: Colors.white, size: 20),
          ),
        ),
        title: Text(
          l10n.pointsEarnedHistoryTitle,
          style: AppTextStyles.heading.copyWith(fontSize: 32),
        ),
        centerTitle: true,
      ),
      body: pointsState.when(
        data: (state) => state.earnedHistory.isEmpty
            ? Center(
                child: Text(
                  l10n.pointsNoEarnedHistory,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.brandPrimary.withValues(alpha: 0.7),
                  ),
                ),
              )
            : RefreshIndicator(
                onRefresh: () => ref.refresh(pointsProvider.future),
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: state.earnedHistory.length,
                  itemBuilder: (context, index) =>
                      PointsHistoryTile(item: state.earnedHistory[index]),
                ),
              ),
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
    );
  }
}
