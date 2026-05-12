import '../../data/models/redeemable_item_model.dart';
import '../../data/models/redemption_model.dart';
import '../../data/models/points_overview_model.dart';

abstract class PointsRepository {
  Future<PointsOverviewModel> getMyPoints();

  Future<void> redeemPoints();

  Future<List<RedeemableItemModel>> getAllRewards({
    String? category,
    String? type,
  });

  Future<void> redeemReward(String rewardId);

  Future<List<RedemptionModel>> getMyRedemptions();
}
