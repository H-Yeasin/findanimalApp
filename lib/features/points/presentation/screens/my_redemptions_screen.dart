import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/models/redemption_model.dart';
import '../providers/my_redemptions_provider.dart';

class MyRedemptionsScreen extends ConsumerWidget {
  const MyRedemptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final redemptionsState = ref.watch(myRedemptionsProvider);
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
          l10n.pointsMyRedemptionsTitle,
          style: AppTextStyles.heading.copyWith(fontSize: 32),
        ),
        centerTitle: true,
      ),
      body: redemptionsState.when(
        data: (redemptions) => redemptions.isEmpty
            ? Center(
                child: Text(
                  l10n.pointsNoRedemptionsYet,
                  style: AppTextStyles.body,
                ),
              )
            : RefreshIndicator(
                onRefresh: () =>
                    ref.read(myRedemptionsProvider.notifier).refresh(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: redemptions.length,
                  itemBuilder: (context, index) =>
                      _buildRedemptionCard(context, redemptions[index]),
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(l10n.errorLoadingFailed)),
      ),
    );
  }

  Widget _buildRedemptionCard(
    BuildContext context,
    RedemptionModel redemption,
  ) {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.brandPrimary.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFFEF9F3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                redemption.rewardItem.photo.secureUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.shopping_bag,
                  color: AppColors.brandPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  redemption.rewardItem.title,
                  style: AppTextStyles.subtitle.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.pointsRedeemedFor(redemption.pointsAtRedemption),
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 12,
                    color: AppColors.brandPrimary.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  Formatters.dateTime(redemption.createdAt),
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 10,
                    color: AppColors.brandPrimary.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(redemption.status).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _getStatusColor(redemption.status)),
            ),
            child: Text(
              l10n.localizeStatus(redemption.status),
              style: AppTextStyles.caption.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: _getStatusColor(redemption.status),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.brandPrimary;
    }
  }
}
