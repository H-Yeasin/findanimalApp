import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../profile/presentation/providers/profile_providers.dart';
import '../../data/models/points_history_item_model.dart';
import '../../data/models/redeemable_item_model.dart';

class PointsState {
  const PointsState({
    required this.totalPoints,
    required this.history,
    required this.redeemableItems,
  });

  final int totalPoints;
  final List<PointsHistoryItemModel> history;
  final List<RedeemableItemModel> redeemableItems;
}

class PointsNotifier extends AsyncNotifier<PointsState> {
  @override
  Future<PointsState> build() async {
    final profile = await ref.watch(myProfileProvider.future);
    final pointsFromProfile = profile.pointsBalance ?? 0;

    // Keep history/redeem UI data as-is, but use real points balance from profile.
    return PointsState(
      totalPoints: pointsFromProfile,
      history: [
        PointsHistoryItemModel(
          id: '1',
          points: 10,
          reason: 'Reporting',
          createdAt: DateTime(2026, 12, 3),
        ),
        PointsHistoryItemModel(
          id: '2',
          points: 70,
          reason: 'Local mission',
          createdAt: DateTime(2026, 3, 2),
        ),
        PointsHistoryItemModel(
          id: '3',
          points: 10,
          reason: 'Reporting',
          createdAt: DateTime(2026, 3, 1),
        ),
      ],
      redeemableItems: [
        const RedeemableItemModel(
          id: '1',
          name: 'SNACK TRAINING - REAL NATURE',
          pointsCost: 275,
          imageUrl: 'assets/images/snack_training.png',
          category: 'Limited edition',
        ),
        const RedeemableItemModel(
          id: '2',
          name: '5€ GIFT CARD',
          pointsCost: 300,
          imageUrl: 'assets/images/gift_card.png',
          category: 'Limited edition',
        ),
        const RedeemableItemModel(
          id: '3',
          name: 'FISH SNACK - REAL NATURE',
          pointsCost: 200,
          imageUrl: 'assets/images/snack_training.png',
          category: 'Limited edition',
        ),
        const RedeemableItemModel(
          id: '4',
          name: '10€ GIFT CARD',
          pointsCost: 550,
          imageUrl: 'assets/images/gift_card.png',
          category: 'Limited edition',
        ),
        const RedeemableItemModel(
          id: '5',
          name: 'CAT TOY',
          pointsCost: 200,
          imageUrl: 'assets/images/cat_toy.png',
          category: 'Limited edition',
        ),
        const RedeemableItemModel(
          id: '6',
          name: 'KONG TOY - SIZE S',
          pointsCost: 500,
          imageUrl: 'assets/images/kong_toy.png',
          category: 'Limited edition',
        ),
      ],
    );
  }
}

final pointsProvider = AsyncNotifierProvider<PointsNotifier, PointsState>(
  PointsNotifier.new,
);
