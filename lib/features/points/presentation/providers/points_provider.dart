import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/points_category_summary_model.dart';
import '../../data/models/points_history_item_model.dart';
import '../../data/models/redeemable_item_model.dart';
import '../../data/repositories/points_repository_impl.dart';

class PointsState {
  const PointsState({
    required this.totalPoints,
    required this.earnedHistory,
    required this.usedHistory,
    required this.redeemableItems,
    required this.earnedByCategory,
    required this.totalPointsUtilized,
    this.currentCategory,
    this.currentType,
  });

  final int totalPoints;
  final List<PointsHistoryItemModel> earnedHistory;
  final List<PointsHistoryItemModel> usedHistory;
  final List<RedeemableItemModel> redeemableItems;
  final List<PointsCategorySummaryModel> earnedByCategory;
  final int totalPointsUtilized;
  final String? currentCategory;
  final String? currentType;

  PointsState copyWith({
    int? totalPoints,
    List<PointsHistoryItemModel>? earnedHistory,
    List<PointsHistoryItemModel>? usedHistory,
    List<RedeemableItemModel>? redeemableItems,
    List<PointsCategorySummaryModel>? earnedByCategory,
    int? totalPointsUtilized,
    String? currentCategory,
    String? currentType,
  }) {
    return PointsState(
      totalPoints: totalPoints ?? this.totalPoints,
      earnedHistory: earnedHistory ?? this.earnedHistory,
      usedHistory: usedHistory ?? this.usedHistory,
      redeemableItems: redeemableItems ?? this.redeemableItems,
      earnedByCategory: earnedByCategory ?? this.earnedByCategory,
      totalPointsUtilized: totalPointsUtilized ?? this.totalPointsUtilized,
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
      earnedByCategory: _buildCategoryBreakdown(earnedHistory),
      totalPointsUtilized: usedHistory.fold(0, (sum, t) => sum + t.points.abs()),
      currentCategory: state.valueOrNull?.currentCategory,
      currentType: state.valueOrNull?.currentType,
    );
  }

  /// Fixed ordered list of earning categories derived from the `source` field.
  static const List<({String sourceKey, String label})> _categories = [
    (sourceKey: 'animal_report',     label: 'Animal Report'),
    (sourceKey: 'local_mission',     label: 'Local Mission'),
    (sourceKey: 'physical_donation', label: 'Physical Donation'),
  ];

  List<PointsCategorySummaryModel> _buildCategoryBreakdown(
    List<PointsHistoryItemModel> earned,
  ) {
    return _categories.map((cat) {
      final total = earned
          .where((t) => t.source == cat.sourceKey)
          .fold(0, (sum, t) => sum + t.points);
      return PointsCategorySummaryModel(
        sourceKey: cat.sourceKey,
        label: cat.label,
        points: total,
      );
    }).toList();
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

      final earned = overview.transactions.where((t) => t.points > 0).toList();
      final used = overview.transactions.where((t) => t.points < 0).toList();

      return PointsState(
        totalPoints: overview.balance,
        earnedHistory: earned,
        usedHistory: used,
        redeemableItems: rewards,
        earnedByCategory: _buildCategoryBreakdown(earned),
        totalPointsUtilized: used.fold(0, (sum, t) => sum + t.points.abs()),
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

      final earned = overview.transactions.where((t) => t.points > 0).toList();
      final used = overview.transactions.where((t) => t.points < 0).toList();

      return PointsState(
        totalPoints: overview.balance,
        earnedHistory: earned,
        usedHistory: used,
        redeemableItems: rewards,
        earnedByCategory: _buildCategoryBreakdown(earned),
        totalPointsUtilized: used.fold(0, (sum, t) => sum + t.points.abs()),
        currentCategory: previousState?.currentCategory,
        currentType: type,
      );
    });
  }
}

final pointsProvider = AsyncNotifierProvider<PointsNotifier, PointsState>(
  PointsNotifier.new,
);
