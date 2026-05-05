import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/redemption_model.dart';
import '../../data/repositories/points_repository_impl.dart';

final myRedemptionsProvider = AsyncNotifierProvider<MyRedemptionsNotifier, List<RedemptionModel>>(
  MyRedemptionsNotifier.new,
);

class MyRedemptionsNotifier extends AsyncNotifier<List<RedemptionModel>> {
  @override
  Future<List<RedemptionModel>> build() async {
    return ref.watch(pointsRepositoryProvider).getMyRedemptions();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(pointsRepositoryProvider).getMyRedemptions());
  }
}
