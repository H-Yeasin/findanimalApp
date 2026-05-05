import '../../data/models/redeemable_item_model.dart';

abstract class PointsRepository {
  Future<void> getMyPoints();

  Future<void> redeemPoints();

  Future<List<RedeemableItemModel>> getAllRewards({
    String? category,
    String? type,
  });
}
