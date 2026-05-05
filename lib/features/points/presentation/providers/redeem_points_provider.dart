import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/points_repository_impl.dart';

class RedeemPointsNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> submit() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(pointsRepositoryProvider).redeemPoints();
    });
  }

  Future<void> redeemReward(String rewardId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(pointsRepositoryProvider).redeemReward(rewardId);
    });
  }
}

final redeemPointsProvider = AsyncNotifierProvider<RedeemPointsNotifier, void>(
  RedeemPointsNotifier.new,
);
