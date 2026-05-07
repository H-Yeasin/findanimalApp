import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hesteka_frontend/core/utils/formatters.dart';
import 'package:hesteka_frontend/features/profile/presentation/providers/profile_providers.dart';

import '../../../../core/routing/route_names.dart';
import '../../../home/presentation/widgets/custom_bottom_navigation_bar.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/points_history_item_model.dart';
import '../../data/models/redeemable_item_model.dart';
import '../providers/points_provider.dart';
import '../providers/redeem_points_provider.dart';

class PointsScreen extends ConsumerWidget {
  const PointsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pointsState = ref.watch(pointsProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: pointsState.when(
          data: (state) => _buildContent(context, ref, state),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
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
                _buildHistoricalSection(state.history),
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
        const Text(
          'MY POINTS',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppColors.brandPrimary,
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
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.brandPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoricalSection(List<PointsHistoryItemModel> history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'HISTORICAL',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.brandPrimary,
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
            style: const TextStyle(
              color: AppColors.brandPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            Formatters.compactDate(item.createdAt),
            style: TextStyle(
              color: AppColors.brandPrimary.withValues(alpha: 0.4),
              fontSize: 12,
            ),
          ),
          const Spacer(),
          Text(
            '+${item.points}',
            style: const TextStyle(
              color: AppColors.brandPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRedeemSection(BuildContext context, WidgetRef ref, PointsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                'REDEEM MY POINTS',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.brandPrimary,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.receipt_long, color: AppColors.brandPrimary),
                tooltip: 'My Redemptions',
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
                'Limited edition',
                'limited',
                isSelected: state.currentCategory == 'limited',
              ),
              const SizedBox(width: 10),
              _buildTab(
                ref,
                'Featured',
                'featured',
                isSelected: state.currentCategory == 'featured',
              ),
              const SizedBox(width: 10),
              _buildTab(
                ref,
                'Solidarity shop',
                'solidarity',
                isSelected: state.currentCategory == 'solidarity',
              ),
              const SizedBox(width: 10),
              _buildTab(
                ref,
                'All',
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
                'Product',
                'product',
                isSelected: state.currentType == 'product',
              ),
              const SizedBox(width: 10),
              _buildTypeTab(
                ref,
                'Gift Card',
                'giftcard',
                isSelected: state.currentType == 'giftcard',
              ),
              const SizedBox(width: 10),
              _buildTypeTab(
                ref,
                'All Types',
                null,
                isSelected: state.currentType == null,
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        if (state.redeemableItems.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'No rewards available with these filters.',
                style: TextStyle(color: AppColors.brandPrimary),
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
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.brandPrimary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
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
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.brandPrimary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
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
                        '${item.points} pts',
                        style: const TextStyle(
                          color: AppColors.brandPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
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
                style: const TextStyle(
                  color: AppColors.brandPrimary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
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
        title: const Text(
          'Redeem Reward',
          style: TextStyle(
            color: AppColors.brandPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to redeem "${item.title}" for ${item.points} points?',
            ),
            const SizedBox(height: 10),
            if (item.stock < 5)
              Text(
                'Only ${item.stock} left in stock!',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
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
            child: const Text('Redeem', style: TextStyle(color: Colors.white)),
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
      builder: (dialogContext) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await ref.read(redeemPointsProvider.notifier).redeemReward(item.id);

      // Close loading indicator
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();

      final state = ref.read(redeemPointsProvider);

      if (state.hasError) {
        final error = state.error;
        String errorMessage = 'Something went wrong. Please try again.';

        // Try to extract message from API error if possible
        try {
          // ignore: avoid_dynamic_calls
          final apiMessage = (error as dynamic).response?.data?['message'];
          if (apiMessage != null && apiMessage is String) {
            errorMessage = apiMessage;
          } else if (error.toString().contains('Insufficient points balance')) {
            errorMessage = 'Insufficient points balance';
          }
        } catch (_) {
          if (error.toString().contains('Insufficient points balance')) {
            errorMessage = 'Insufficient points balance';
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
            const SnackBar(
              content: Text('Reward redeemed successfully!'),
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
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
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
