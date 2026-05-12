import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/points_history_item_model.dart';
import '../../data/models/redeemable_item_model.dart';
import '../../data/repositories/points_repository_impl.dart';

class PointsState {
  const PointsState({
    required this.totalPoints,
    required this.earnedHistory,
    required this.usedHistory,
    required this.redeemableItems,
    this.currentCategory,
    this.currentType,
  });

  final int totalPoints;
  final List<PointsHistoryItemModel> earnedHistory;
  final List<PointsHistoryItemModel> usedHistory;
  final List<RedeemableItemModel> redeemableItems;
  final String? currentCategory;
  final String? currentType;

  PointsState copyWith({
    int? totalPoints,
    List<PointsHistoryItemModel>? earnedHistory,
    List<PointsHistoryItemModel>? usedHistory,
    List<RedeemableItemModel>? redeemableItems,
    String? currentCategory,
    String? currentType,
  }) {
    return PointsState(
      totalPoints: totalPoints ?? this.totalPoints,
      earnedHistory: earnedHistory ?? this.earnedHistory,
      usedHistory: usedHistory ?? this.usedHistory,
      redeemableItems: redeemableItems ?? this.redeemableItems,
      currentCategory: currentCategory ?? this.currentCategory,
      currentType: currentType ?? this.currentType,
    );
  }
}

class PointsNotifier extends AsyncNotifier<PointsState> {
  @override
  Future<PointsState> build() async {
    final repository = ref.watch(pointsRepositoryProvider);
    final overview = await repository.getMyPoints();

    final rewards = await repository.getAllRewards(
      category: state.valueOrNull?.currentCategory,
      type: state.valueOrNull?.currentType,
    );

    final earnedHistory = overview.transactions
        .where((item) => item.points > 0)
        .toList();
    final usedHistory = overview.transactions
        .where((item) => item.points < 0)
        .toList();

    return PointsState(
      totalPoints: overview.balance,
      earnedHistory: earnedHistory,
      usedHistory: usedHistory,
      redeemableItems: rewards,
      currentCategory: state.valueOrNull?.currentCategory,
      currentType: state.valueOrNull?.currentType,
    );
  }

  Future<void> setCategory(String? category) async {
    final previousState = state.valueOrNull;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(pointsRepositoryProvider);
      final overview = await repository.getMyPoints();

      final rewards = await repository.getAllRewards(
        category: category,
        type: previousState?.currentType,
      );

      return PointsState(
        totalPoints: overview.balance,
        earnedHistory: previousState?.earnedHistory ??
            overview.transactions.where((item) => item.points > 0).toList(),
        usedHistory: previousState?.usedHistory ??
            overview.transactions.where((item) => item.points < 0).toList(),
        redeemableItems: rewards,
        currentCategory: category,
        currentType: previousState?.currentType,
      );
    });
  }

  Future<void> setType(String? type) async {
    final previousState = state.valueOrNull;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(pointsRepositoryProvider);
      final overview = await repository.getMyPoints();

      final rewards = await repository.getAllRewards(
        category: previousState?.currentCategory,
        type: type,
      );

      return PointsState(
        totalPoints: overview.balance,
        earnedHistory: previousState?.earnedHistory ??
            overview.transactions.where((item) => item.points > 0).toList(),
        usedHistory: previousState?.usedHistory ??
            overview.transactions.where((item) => item.points < 0).toList(),
        redeemableItems: rewards,
        currentCategory: previousState?.currentCategory,
        currentType: type,
      );
    });
  }
}

final pointsProvider = AsyncNotifierProvider<PointsNotifier, PointsState>(
  PointsNotifier.new,
);
