import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/utils/formatters.dart';
import 'package:hesteka_frontend/features/profile/presentation/providers/profile_providers.dart';

import '../../../../core/routing/route_names.dart';
import '../../../home/presentation/widgets/custom_bottom_navigation_bar.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/points_history_item_model.dart';
import '../../data/models/redeemable_item_model.dart';
import '../providers/points_provider.dart';
import '../providers/redeem_points_provider.dart';

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
          data: (state) => _buildContent(context, ref, state),
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

  Widget _buildContent(BuildContext context, WidgetRef ref, PointsState state) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, state.totalPoints),
                const SizedBox(height: 30),
                _buildHistoricalSection(context, state.history),
                const SizedBox(height: 40),
                _buildRedeemSection(context, ref, state),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, int totalPoints) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.brandPrimary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.undo, color: Colors.white, size: 20),
          ),
        ),
        const SizedBox(width: 15),
        Text(
          AppLocalizations.of(context).pointsMyPoints,
          style: AppTextStyles.heading.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(width: 15),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.brandPrimary, width: 2),
          ),
          child: Text(
            '$totalPoints',
            style: AppTextStyles.subtitle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoricalSection(
    BuildContext context,
    List<PointsHistoryItemModel> history,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).pointsHistorical,
          style: AppTextStyles.subtitle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 15),
        ...history.map((item) => _buildHistoryTile(item)),
      ],
    );
  }

  Widget _buildHistoryTile(PointsHistoryItemModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.brandPrimary.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Text(
            item.reason,
            style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 10),
          Text(
            Formatters.compactDate(item.createdAt),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.brandPrimary.withValues(alpha: 0.4),
            ),
          ),
          const Spacer(),
          Text(
            '+${item.points}',
            style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildRedeemSection(
    BuildContext context,
    WidgetRef ref,
    PointsState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                AppLocalizations.of(context).pointsRedeemMyPoints,
                style: AppTextStyles.heading.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(
                  Icons.receipt_long,
                  color: AppColors.brandPrimary,
                ),
                tooltip: AppLocalizations.of(
                  context,
                ).pointsMyRedemptionsTooltip,
                onPressed: () => context.push(RouteNames.profileMyRedemptions),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTab(
                ref,
                AppLocalizations.of(context).pointsCategoryLimited,
                'limited',
                isSelected: state.currentCategory == 'limited',
              ),
              const SizedBox(width: 10),
              _buildTab(
                ref,
                AppLocalizations.of(context).pointsCategoryFeatured,
                'featured',
                isSelected: state.currentCategory == 'featured',
              ),
              const SizedBox(width: 10),
              _buildTab(
                ref,
                AppLocalizations.of(context).pointsCategorySolidarity,
                'solidarity',
                isSelected: state.currentCategory == 'solidarity',
              ),
              const SizedBox(width: 10),
              _buildTab(
                ref,
                AppLocalizations.of(context).pointsCategoryAll,
                null,
                isSelected: state.currentCategory == null,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTypeTab(
                ref,
                AppLocalizations.of(context).pointsTypeProduct,
                'product',
                isSelected: state.currentType == 'product',
              ),
              const SizedBox(width: 10),
              _buildTypeTab(
                ref,
                AppLocalizations.of(context).pointsTypeGiftCard,
                'giftcard',
                isSelected: state.currentType == 'giftcard',
              ),
              const SizedBox(width: 10),
              _buildTypeTab(
                ref,
                AppLocalizations.of(context).pointsTypeAllTypes,
                null,
                isSelected: state.currentType == null,
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        if (state.redeemableItems.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                AppLocalizations.of(context).pointsNoRewards,
                style: AppTextStyles.body,
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: state.redeemableItems.length,
            itemBuilder: (context, index) =>
                _buildItemCard(context, ref, state.redeemableItems[index]),
          ),
      ],
    );
  }

  Widget _buildTypeTab(
    WidgetRef ref,
    String label,
    String? type, {
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: () => ref.read(pointsProvider.notifier).setType(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.brandPrimary),
        ),
        child: Text(
          label,
          style: AppTextStyles.button.copyWith(
            color: isSelected ? Colors.white : AppColors.brandPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildTab(
    WidgetRef ref,
    String label,
    String? category, {
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: () => ref.read(pointsProvider.notifier).setCategory(category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.brandPrimary),
        ),
        child: Text(
          label,
          style: AppTextStyles.button.copyWith(
            color: isSelected ? Colors.white : AppColors.brandPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(
    BuildContext context,
    WidgetRef ref,
    RedeemableItemModel item,
  ) {
    return GestureDetector(
      onTap: () => _showRedeemConfirmation(context, ref, item),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFEF9F3),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: AppColors.brandPrimary.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.network(
                        item.photo.secureUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholderIcon(item.title),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${item.points} ${AppLocalizations.of(context).pointsPts}',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFDEEE6),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                border: Border(
                  top: BorderSide(
                    color: AppColors.brandPrimary.withValues(alpha: 0.3),
                  ),
                ),
              ),
              child: Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRedeemConfirmation(
    BuildContext parentContext,
    WidgetRef ref,
    RedeemableItemModel item,
  ) {
    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          AppLocalizations.of(parentContext).pointsRedeemRewardTitle,
          style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(
                parentContext,
              ).pointsRedeemConfirmation(item.title, item.points),
            ),
            const SizedBox(height: 10),
            if (item.stock < 5)
              Text(
                AppLocalizations.of(
                  parentContext,
                ).pointsLowStockWarning(item.stock),
                style: AppTextStyles.caption.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              AppLocalizations.of(parentContext).cancel,
              style: AppTextStyles.button.copyWith(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _processRedemption(parentContext, ref, item);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              AppLocalizations.of(parentContext).pointsRedeemMyPoints,
              style: AppTextStyles.button,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processRedemption(
    BuildContext context,
    WidgetRef ref,
    RedeemableItemModel item,
  ) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) =>
          const Center(child: CircularProgressIndicator()),
    );

    try {
      await ref.read(redeemPointsProvider.notifier).redeemReward(item.id);

      // Close loading indicator
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();

      final state = ref.read(redeemPointsProvider);

      if (state.hasError) {
        final error = state.error;
        String errorMessage = AppLocalizations.of(context).pointsRedeemError;

        // Try to extract message from API error if possible
        try {
          // ignore: avoid_dynamic_calls
          final apiMessage = (error as dynamic).response?.data?['message'];
          if (apiMessage != null && apiMessage is String) {
            errorMessage = apiMessage;
          } else if (error.toString().contains('Insufficient points balance')) {
            errorMessage = AppLocalizations.of(
              context,
            ).pointsInsufficientPoints;
          }
        } catch (_) {
          if (error.toString().contains('Insufficient points balance')) {
            errorMessage = AppLocalizations.of(
              context,
            ).pointsInsufficientPoints;
          }
        }

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
          );
        }
      } else {
        // Success
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).pointsRedeemSuccess),
              backgroundColor: Colors.green,
            ),
          );
          // Refresh points and history
          ref.invalidate(pointsProvider);
          ref.invalidate(myProfileProvider);
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).errorLoadingFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildPlaceholderIcon(String name) {
    // Simple logic to show different icons based on item name for now
    IconData icon;
    if (name.contains('GIFT CARD')) {
      icon = Icons.card_giftcard;
    } else if (name.contains('SNACK') || name.contains('FOOD')) {
      icon = Icons.restaurant;
    } else if (name.contains('TOY')) {
      icon = Icons.toys;
    } else {
      icon = Icons.shopping_bag;
    }
    return Icon(
      icon,
      size: 60,
      color: AppColors.brandPrimary.withValues(alpha: 0.5),
    );
  }
}
