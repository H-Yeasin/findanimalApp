import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/redeemable_item_model.dart';
import '../../data/models/redemption_model.dart';
import '../../domain/repositories/points_repository.dart';
import '../sources/points_remote_source.dart';

final pointsRepositoryProvider = Provider<PointsRepository>((ref) {
  return PointsRepositoryImpl(ref.watch(pointsRemoteSourceProvider));
});

class PointsRepositoryImpl implements PointsRepository {
  const PointsRepositoryImpl(this._remoteSource);

  final PointsRemoteSource _remoteSource;

  @override
  Future<void> getMyPoints() async {
    await _remoteSource.getMyPoints();
  }

  @override
  Future<void> redeemPoints() async {}

  @override
  Future<void> redeemReward(String rewardId) async {
    await _remoteSource.redeemReward(rewardId);
  }

  @override
  Future<List<RedemptionModel>> getMyRedemptions() async {
    final response = await _remoteSource.getMyRedemptions();
    final List<dynamic> data = response['data'];
    return data.map((json) => RedemptionModel.fromJson(json)).toList();
  }

  @override
  Future<List<RedeemableItemModel>> getAllRewards({
    String? category,
    String? type,
  }) async {
    final response = await _remoteSource.getAllRewards(
      category: category,
      type: type,
    );
    final List<dynamic> data = response['data'];
    return data.map((json) => RedeemableItemModel.fromJson(json)).toList();
  }
}
