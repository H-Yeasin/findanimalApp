import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/theme/app_colors.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';
import 'package:hesteka_frontend/features/profile/presentation/providers/profile_providers.dart';
import '../../data/models/redeemable_item_model.dart';
import '../providers/points_provider.dart';
import '../providers/redeem_points_provider.dart';

class PointsRedeemSection extends StatelessWidget {
  const PointsRedeemSection({required this.state, super.key});

  final PointsState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Align(
              child: Text(
                AppLocalizations.of(context).pointsRedeemMyPoints,
                style: AppTextStyles.heading.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
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
              _PointsFilterChip(
                label: AppLocalizations.of(context).pointsCategoryLimited,
                isSelected: state.currentCategory == 'limited',
                onTap: (ref) =>
                    ref.read(pointsProvider.notifier).setCategory('limited'),
              ),
              const SizedBox(width: 10),
              _PointsFilterChip(
                label: AppLocalizations.of(context).pointsCategoryFeatured,
                isSelected: state.currentCategory == 'featured',
                onTap: (ref) =>
                    ref.read(pointsProvider.notifier).setCategory('featured'),
              ),
              const SizedBox(width: 10),
              _PointsFilterChip(
                label: AppLocalizations.of(context).pointsCategorySolidarity,
                isSelected: state.currentCategory == 'solidarity',
                onTap: (ref) =>
                    ref.read(pointsProvider.notifier).setCategory('solidarity'),
              ),
              const SizedBox(width: 10),
              _PointsFilterChip(
                label: AppLocalizations.of(context).pointsCategoryAll,
                isSelected: state.currentCategory == null,
                onTap: (ref) =>
                    ref.read(pointsProvider.notifier).setCategory(null),
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
              _PointsFilterChip(
                label: AppLocalizations.of(context).pointsTypeProduct,
                isSelected: state.currentType == 'product',
                onTap: (ref) =>
                    ref.read(pointsProvider.notifier).setType('product'),
              ),
              const SizedBox(width: 10),
              _PointsFilterChip(
                label: AppLocalizations.of(context).pointsTypeGiftCard,
                isSelected: state.currentType == 'giftcard',
                onTap: (ref) =>
                    ref.read(pointsProvider.notifier).setType('giftcard'),
              ),
              const SizedBox(width: 10),
              _PointsFilterChip(
                label: AppLocalizations.of(context).pointsTypeAllTypes,
                isSelected: state.currentType == null,
                onTap: (ref) => ref.read(pointsProvider.notifier).setType(null),
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
                PointsRedeemItemCard(item: state.redeemableItems[index]),
          ),
      ],
    );
  }
}

class _PointsFilterChip extends ConsumerWidget {
  const _PointsFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final void Function(WidgetRef ref) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => onTap(ref),
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
}

class PointsRedeemItemCard extends ConsumerWidget {
  const PointsRedeemItemCard({required this.item, super.key});

  final RedeemableItemModel item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _showRedeemConfirmation(context, ref),
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

  void _showRedeemConfirmation(BuildContext parentContext, WidgetRef ref) {
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
              await _processRedemption(parentContext, ref);
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

  Future<void> _processRedemption(BuildContext context, WidgetRef ref) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) =>
          const Center(child: CircularProgressIndicator()),
    );

    try {
      await ref.read(redeemPointsProvider.notifier).redeemReward(item.id);

      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      final state = ref.read(redeemPointsProvider);

      if (state.hasError) {
        final error = state.error;
        var errorMessage = AppLocalizations.of(context).pointsRedeemError;

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
        return;
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).pointsRedeemSuccess),
            backgroundColor: Colors.green,
          ),
        );
        ref.invalidate(pointsProvider);
        ref.invalidate(myProfileProvider);
      }
    } catch (_) {
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
